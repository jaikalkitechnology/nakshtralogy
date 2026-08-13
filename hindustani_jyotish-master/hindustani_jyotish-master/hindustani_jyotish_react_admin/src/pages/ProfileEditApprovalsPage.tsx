import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { ProfileEditFields, ProfileEditRequest, ProfileEditStatus } from '../api/types'
import { StatusBadge } from '../components/Badge'
import { BANK_PROOF_LABELS } from '../components/KycDocs'
import { LightboxImage } from '../components/Lightbox'
import { PageHeader, Card } from '../components/ui/PageShell'

const FILTERS: { label:string; value:ProfileEditStatus|'all' }[]=[{label:'Pending',value:'pending'},{label:'Approved',value:'approved'},{label:'Rejected',value:'rejected'},{label:'All',value:'all'}]

/** Flat (non-nested) diff fields — the nested `kyc` object renders as its own subsection. */
type ScalarEditField = Exclude<keyof ProfileEditFields, 'kyc'>

const FIELD_LABELS: Record<ScalarEditField, string> = {
  display_name: 'Display name',
  bio: 'Bio',
  photo_url: 'Profile photo',
  mobile: 'Mobile number',
  country_code: 'Country code',
  skills: 'Skills',
  languages: 'Languages',
  rate_chat_per_msg: 'Chat rate / msg',
  rate_call_per_min: 'Call rate / min',
  rate_video_per_min: 'Video rate / min',
  super_chat_presets: 'Super chat presets',
}

/** Friendly labels for the nested KYC/payout diff keys; unknown keys are prettified. */
const KYC_FIELD_LABELS: Record<string, string> = {
  full_name: 'Full name',
  dob: 'Date of birth',
  address: 'Address',
  pan_number: 'PAN number',
  aadhaar_last4: 'Aadhaar (last 4)',
  photo_key: 'Photo document',
  pan_doc_key: 'PAN document',
  aadhaar_doc_key: 'Aadhaar front document',
  aadhaar_back_doc_key: 'Aadhaar back document',
  bank_proof_key: 'Bank proof document',
  certificate_key: 'Certificate document',
  payout_method: 'Payout method',
  upi_id: 'UPI ID',
  bank_name: 'Bank name',
  bank_account_holder: 'Account holder',
  bank_account_last4: 'Account (last 4)',
  bank_ifsc: 'IFSC code',
  bank_proof_type: 'Bank proof type',
}

function kycLabel(key: string): string {
  return KYC_FIELD_LABELS[key] ?? key.replace(/_/g, ' ').replace(/^./, c => c.toUpperCase())
}

function changedKeys(item: ProfileEditRequest): ScalarEditField[] {
  return (Object.keys(FIELD_LABELS) as ScalarEditField[]).filter(k => k in item.changes)
}

function kycChangedKeys(item: ProfileEditRequest): string[] {
  return item.changes.kyc ? Object.keys(item.changes.kyc) : []
}

function changedCount(item: ProfileEditRequest): number {
  return changedKeys(item).length + kycChangedKeys(item).length
}

export default function ProfileEditApprovalsPage(){
  const [filter,setFilter]=useState<ProfileEditStatus|'all'>('pending')
  const [items,setItems]=useState<ProfileEditRequest[]>([])
  const [error,setError]=useState<string|null>(null)
  const [loading,setLoading]=useState(true)
  const [active,setActive]=useState<ProfileEditRequest|null>(null)

  // A non-array response (older backend, error envelope) must never reach
  // `.map()`/`.length` below and white-screen the page.
  const load=useCallback(()=>{ setLoading(true); adminApi.listProfileEdits(filter).then(list=>setItems(Array.isArray(list) ? list : [])).catch(e=>setError(e.message)).finally(()=>setLoading(false)) },[filter])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function decide(id:string, approve:boolean, notes:string){
    try{ if(approve) await adminApi.approveProfileEdit(id); else await adminApi.rejectProfileEdit(id,notes); setActive(null); load() }
    catch(e){ setError((e as Error).message) }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Profile Edit Approvals"
        subtitle="Review astrologer self-service profile changes — compare each proposed value against what is live today, then approve or reject with a note."
        icon={<span className="text-[18px]">📝</span>}
        actions={
          <div className="flex items-center gap-2 rounded-full border border-border-soft bg-surface-1 p-1 shadow-sm">
            {FILTERS.map(f=><button key={f.label} onClick={()=>setFilter(f.value)} className={`rounded-full px-4 py-2 text-[12.5px] font-semibold transition-all ${filter===f.value ? 'bg-ivory text-bg-0 shadow-sm border border-border-soft' : 'text-ivory-faint hover:text-ivory hover:bg-surface-2'}`}>{f.label}</button>)}
          </div>
        }
      />

      {error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error}</div>}

      <Card className="overflow-hidden">
        {loading ? <div className="p-12 text-center text-[13px] text-ivory-faint">Loading profile edits…</div> : items.length===0 ? <div className="p-16 text-center"><div className="grid place-items-center h-14 w-14 mx-auto rounded-2xl bg-surface-1 border border-border-soft">📭</div><div className="mt-3 font-semibold">No profile edits</div><div className="text-[13px] text-ivory-faint mt-1">No edit requests in this filter.</div></div> : (
          <>
            {/* Desktop */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full border-collapse">
                <thead><tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-5 py-3.5">Astrologer</th><th className="px-5 py-3.5">Submitted</th><th className="px-5 py-3.5">Changed fields</th><th className="px-5 py-3.5">Status</th><th className="px-5 py-3.5 text-right">Action</th></tr></thead>
                <tbody className="divide-y divide-border-soft/60">
                  {items.map(it=>{
                    const n=changedCount(it)
                    return (
                      <tr key={it.id} className="hover:bg-surface-1/50 transition-colors">
                        <td className="px-5 py-4"><div className="flex items-center gap-3"><Avatar url={it.astrologer_photo} name={it.astrologer_name} className="h-9 w-9 text-[12px]" /><div className="font-semibold text-[13.5px]">{it.astrologer_name || <span className="text-ivory-faint">—</span>}</div></div></td>
                        <td className="px-5 py-4 text-[12px] text-ivory-faint">{it.submitted_at ? new Date(it.submitted_at).toLocaleDateString() : '—'}</td>
                        <td className="px-5 py-4"><span className="rounded-full bg-surface-1 border border-border-soft px-2.5 py-1 text-[12px] font-semibold">{n} field{n===1?'':'s'}</span></td>
                        <td className="px-5 py-4"><StatusBadge status={it.status} /></td>
                        <td className="px-5 py-4 text-right"><button onClick={()=>setActive(it)} className="inline-flex h-8 items-center gap-1.5 rounded-full border border-border-soft bg-ivory text-bg-0 px-4 text-[12px] font-bold hover:opacity-90 transition-colors">Review →</button></td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
            {/* Mobile */}
            <div className="grid gap-3 p-3 md:hidden">
              {items.map(it=>{
                const n=changedCount(it)
                return (
                  <div key={it.id} className="rounded-xl border border-border-soft bg-surface-1 p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex gap-3"><Avatar url={it.astrologer_photo} name={it.astrologer_name} className="h-10 w-10 text-[13px]" /><div><div className="font-semibold text-[14px]">{it.astrologer_name || '—'}</div><div className="text-[11px] text-ivory-faint">{it.submitted_at ? new Date(it.submitted_at).toLocaleDateString() : ''} · {n} field{n===1?'':'s'}</div></div></div>
                      <StatusBadge status={it.status} />
                    </div>
                    <button onClick={()=>setActive(it)} className="mt-3 w-full h-9 rounded-full bg-ivory text-bg-0 text-[12px] font-bold">Review changes</button>
                  </div>
                )
              })}
            </div>
          </>
        )}
      </Card>

      {active && <ReviewModal item={active} onClose={()=>setActive(null)} onDecide={decide} />}
    </div>
  )
}

function Avatar({url,name,className}:{url:string|null|undefined; name:string|null|undefined; className?:string}){
  if(url) return <LightboxImage src={url} label={name||'Astrologer'} className={`rounded-xl border border-border-soft bg-surface-2 ${className??''}`} />
  return <div className={`shrink-0 grid place-items-center rounded-xl bg-amber-500/10 border border-amber-500/15 text-amber-400 font-bold ${className??''}`}>{(name||'A')[0].toUpperCase()}</div>
}

/** Renders one diff value: lists joined with ", ", photo_url as a small thumbnail that opens the Lightbox, scalars as text. */
function DiffValue({field,value,side}:{field:ScalarEditField; value:unknown; side?:'current'|'proposed'}){
  if(value===null || value===undefined || value==='' || (Array.isArray(value) && value.length===0)) return <span className="text-ivory-faint">—</span>
  if(field==='photo_url' && typeof value==='string') return (
    <LightboxImage src={value} label={side==='current' ? 'Current photo' : side==='proposed' ? 'Proposed photo' : 'Profile photo'} className="h-16 w-16 rounded-[12px] border border-border-soft bg-surface-2 shadow-sm transition-colors hover:border-saffron/40" />
  )
  if(Array.isArray(value)) return <>{value.map(String).join(', ')}</>
  return <>{String(value)}</>
}

/** Shortens a storage key like "kyc/ab12…/aadhaar_back_17123.jpg" for display; full key stays in the tooltip. */
function shortKey(key: string): string {
  const tail = key.split('/').pop() || key
  return tail.length > 24 ? `${tail.slice(0, 12)}…${tail.slice(-9)}` : tail
}

/**
 * Renders one nested KYC/payout diff value. Same formatting rules as DiffValue
 * (arrays joined, nulls as —), plus: `*_key` document references render as
 * short monospace keys (staged docs have no public URL yet — expected),
 * payout enum fields get friendly labels.
 */
function KycDiffValue({field,value}:{field:string; value:unknown}){
  if(value===null || value===undefined || value==='' || (Array.isArray(value) && value.length===0)) return <span className="text-ivory-faint">—</span>
  if(field.endsWith('_key') && typeof value==='string') return (
    <span title={value} className="inline-block max-w-full break-all rounded-md border border-border-soft bg-surface-2 px-1.5 py-0.5 font-mono text-[11px] text-ivory-dim">{shortKey(value)}</span>
  )
  if(field==='payout_method' && typeof value==='string') return <>{value==='upi' ? 'UPI' : value==='bank' ? 'Bank account' : value}</>
  if(field==='bank_proof_type' && typeof value==='string') return <>{(BANK_PROOF_LABELS as Record<string,string>)[value] ?? value}</>
  if(field==='aadhaar_last4' || field==='bank_account_last4') return <span className="font-mono text-[12px]">•••• {String(value)}</span>
  if(Array.isArray(value)) return <>{value.map(String).join(', ')}</>
  return <>{String(value)}</>
}

function ReviewModal({item,onClose,onDecide}:{item:ProfileEditRequest; onClose:()=>void; onDecide:(id:string, approve:boolean, notes:string)=>void}){
  const [notes,setNotes]=useState('')
  const pending=item.status==='pending'
  const keys=changedKeys(item)
  const kycKeys=kycChangedKeys(item)
  const total=keys.length+kycKeys.length
  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4 animate-fade-in" onClick={onClose}>
      <div className="max-h-[92vh] w-full max-w-[640px] overflow-y-auto animate-pop-in rounded-xl border border-border-soft bg-surface-raised p-6 sm:p-7 shadow-[var(--shadow-3)]" onClick={e=>e.stopPropagation()}>
        <div className="flex items-start justify-between gap-4">
          <div className="flex gap-3"><Avatar url={item.astrologer_photo} name={item.astrologer_name} className="h-12 w-12 text-[15px]" /><div><h3 className="text-[17px] font-bold">{item.astrologer_name || 'Astrologer'}</h3><p className="mt-1 text-[11px] text-ivory-faint">Submitted {item.submitted_at ? new Date(item.submitted_at).toLocaleString() : '—'}{item.reviewed_at ? ` · Reviewed ${new Date(item.reviewed_at).toLocaleString()}` : ''}</p></div></div>
          <StatusBadge status={item.status} />
        </div>

        <div className="mt-6">
          <div className="text-[11px] font-bold uppercase tracking-[0.1em] text-ivory-faint border-b border-border-soft/60 pb-2.5 flex items-center gap-2"><span className="h-px w-6 bg-border-soft"/>Requested changes <span className="normal-case font-medium tracking-normal">({total} field{total===1?'':'s'})</span></div>
          {keys.length>0 && (
            <div className="mt-3 overflow-hidden rounded-xl border border-border-soft">
              <table className="w-full border-collapse text-[13px]">
                <thead><tr className="border-b border-border-soft bg-surface-1/60 text-left text-[10px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-4 py-2.5">Field</th><th className="px-4 py-2.5">Current</th><th className="px-4 py-2.5 w-6" aria-label="to" /><th className="px-4 py-2.5">Proposed</th></tr></thead>
                <tbody className="divide-y divide-border-soft/60 bg-surface-1/30">
                  {keys.map(k=>(
                    <tr key={k} className="align-top">
                      <td className="px-4 py-3 text-[11px] font-bold uppercase tracking-wide text-ivory-faint whitespace-nowrap">{FIELD_LABELS[k]}</td>
                      <td className="px-4 py-3 text-ivory-dim break-words"><DiffValue field={k} value={item.current[k]} side="current" /></td>
                      <td className="px-1 py-3 text-center text-ivory-faint">→</td>
                      <td className="px-4 py-3 font-semibold text-amber-300 break-words"><DiffValue field={k} value={item.changes[k]} side="proposed" /></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {kycKeys.length>0 && (
          <div className="mt-5">
            <div className="text-[11px] font-bold uppercase tracking-[0.1em] text-ivory-faint border-b border-border-soft/60 pb-2.5 flex items-center gap-2"><span className="h-px w-6 bg-border-soft"/>KYC / Payout changes <span className="normal-case font-medium tracking-normal">({kycKeys.length} field{kycKeys.length===1?'':'s'})</span></div>
            <div className="mt-3 overflow-hidden rounded-xl border border-border-soft">
              <table className="w-full border-collapse text-[13px]">
                <thead><tr className="border-b border-border-soft bg-surface-1/60 text-left text-[10px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-4 py-2.5">Field</th><th className="px-4 py-2.5">Current</th><th className="px-4 py-2.5 w-6" aria-label="to" /><th className="px-4 py-2.5">Proposed</th></tr></thead>
                <tbody className="divide-y divide-border-soft/60 bg-surface-1/30">
                  {kycKeys.map(k=>(
                    <tr key={k} className="align-top">
                      <td className="px-4 py-3 text-[11px] font-bold uppercase tracking-wide text-ivory-faint whitespace-nowrap">{kycLabel(k)}</td>
                      <td className="px-4 py-3 text-ivory-dim break-words"><KycDiffValue field={k} value={item.current.kyc?.[k]} /></td>
                      <td className="px-1 py-3 text-center text-ivory-faint">→</td>
                      <td className="px-4 py-3 font-semibold text-amber-300 break-words"><KycDiffValue field={k} value={item.changes.kyc?.[k]} /></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <p className="mt-2 text-[11px] leading-relaxed text-ivory-faint">Staged document uploads show their storage key — a preview URL only becomes available once the change is approved.</p>
          </div>
        )}

        {pending ? (
          <>
            <label className="mt-5 block text-[12px] font-semibold text-ivory-dim">Reviewer note (sent to the astrologer on reject)<textarea rows={3} value={notes} onChange={e=>setNotes(e.target.value)} placeholder="Explain what needs fixing…" className="mt-2 w-full rounded-xl border border-border-soft bg-surface-1 p-3.5 text-[13px] outline-none focus:border-saffron focus:bg-surface-2" /></label>
            <div className="mt-5 flex justify-end gap-2.5"><button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px] font-medium">Cancel</button><button onClick={()=>onDecide(item.id,false,notes)} className="h-10 rounded-full bg-red-500/10 border border-red-500/20 px-5 text-[13px] font-bold text-red-400 hover:bg-red-500/15">Reject</button><button onClick={()=>onDecide(item.id,true,notes)} className="h-10 rounded-full bg-emerald-500 px-6 text-[13px] font-bold text-white hover:brightness-110">Approve</button></div>
          </>
        ) : (
          <>
            {item.reviewer_notes && <div className="mt-5 rounded-xl border border-border-soft bg-surface-1 p-4"><div className="text-[10px] font-bold uppercase tracking-wide text-ivory-faint">Reviewer notes</div><p className="mt-1.5 text-[13px] leading-relaxed text-ivory-dim">{item.reviewer_notes}</p></div>}
            <div className="mt-5 flex justify-end"><button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Close</button></div>
          </>
        )}
      </div>
    </div>
  )
}
