import { useEffect, useState } from 'react'
import { api } from '../api/client'
import { adminApi } from '../api/endpoints'
import { StatusBadge } from '../components/Badge'
import { ConfirmDialog } from '../components/ConfirmDialog'
import { DetailDrawer } from '../components/DetailDrawer'
import { Lightbox, LightboxImage } from '../components/Lightbox'
import { PageHeader, Card } from '../components/ui/PageShell'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { ProfilePhotoField } from '../components/ProfilePhotoField'
import type { KycDocSet } from '../components/KycDocs'
import type { AstrologerEditInput, KYCStatus } from '../api/types'

const KYC_DOC_TYPES: { key: keyof KycDocSet; type: string; label: string }[] = [
  { key: 'photo_url', type: 'photo', label: 'Photo' },
  { key: 'pan_doc_url', type: 'pan', label: 'PAN card' },
  { key: 'aadhaar_doc_url', type: 'aadhaar', label: 'Aadhaar front' },
  { key: 'aadhaar_back_doc_url', type: 'aadhaar_back', label: 'Aadhaar back' },
  { key: 'bank_proof_url', type: 'bank_proof', label: 'Bank proof' },
  { key: 'certificate_url', type: 'certificate', label: 'Certificate' },
]

function KycDocsEditor({astrologerId,docs,onChange}:{astrologerId:string; docs:KycDocSet; onChange:(docs:KycDocSet)=>void}){
  const [busy,setBusy]=useState<string|null>(null)
  const [err,setErr]=useState<string|null>(null)
  const [preview,setPreview]=useState<{url:string; label:string}|null>(null)

  async function handleFile(type:string, file:File){
    setBusy(type); setErr(null)
    try{ onChange(await adminApi.uploadAstrologerKycDoc(astrologerId,type,file)) }
    catch(e){ setErr((e as Error).message) }
    finally{ setBusy(null) }
  }

  return (
    <div>
      {err && <div className="mb-2.5 rounded-lg border border-red-500/20 bg-red-500/10 px-3 py-2 text-[12px] text-red-400">{err}</div>}
      <div className="grid grid-cols-2 gap-2.5 sm:grid-cols-3">
        {KYC_DOC_TYPES.map(d=>{
          const url=docs[d.key]
          const uploading=busy===d.type
          return (
            <div key={d.type} className="overflow-hidden rounded-xl border border-border-soft bg-surface-1">
              <button type="button" disabled={!url} onClick={()=>url && setPreview({url,label:d.label})} className="block h-20 w-full overflow-hidden bg-surface-2 disabled:cursor-default">
                {url ? <img src={url} alt={d.label} className="h-full w-full object-cover" /> : <div className="grid h-full place-items-center text-[10px] text-ivory-faint">No file</div>}
              </button>
              <label className="flex items-center justify-between gap-1.5 px-2.5 py-2 cursor-pointer">
                <span className="truncate text-[10px] font-bold uppercase tracking-wide text-ivory-faint">{d.label}</span>
                <span className="shrink-0 text-[10px] font-semibold text-saffron">{uploading?'…':url?'Replace':'Upload'}</span>
                <input type="file" accept="image/*,.pdf" className="hidden" disabled={uploading} onChange={e=>{ const f=e.target.files?.[0]; if(f) void handleFile(d.type,f); e.target.value='' }} />
              </label>
            </div>
          )
        })}
      </div>
      {preview && <Lightbox url={preview.url} label={preview.label} onClose={()=>setPreview(null)} />}
    </div>
  )
}

interface AstrologerRow { id:string; name:string|null; mobile:string|null; photo_url?:string|null; skills:string[]|null; experience:number|null; kyc_status:KYCStatus; is_online:boolean; avg_rating:string; available_balance:string }

function RowAvatar({photo,name,className}:{photo:string|null|undefined; name:string|null; className:string}){
  if(photo) return <LightboxImage src={photo} label={name||'Astrologer'} className={`rounded-xl border border-saffron/15 bg-surface-2 ${className}`} />
  return <div className={`shrink-0 grid place-items-center rounded-xl bg-saffron-soft border border-saffron/15 font-bold text-saffron ${className}`}>{(name||'A')[0].toUpperCase()}</div>
}

export default function AstrologerDetailsPage(){
  const paged = usePagedData<AstrologerRow>('/admin/astrologers/list', 50)
  const [busyId,setBusyId]=useState<string|null>(null)
  const [actionError,setActionError]=useState<string|null>(null)
  const [query,setQuery]=useState('')
  const [credit,setCredit]=useState<AstrologerRow|null>(null)
  const [edit,setEdit]=useState<AstrologerRow|null>(null)
  const [remove,setRemove]=useState<AstrologerRow|null>(null)
  const [removing,setRemoving]=useState(false)
  const [removeError,setRemoveError]=useState<string|null>(null)
  const [detailId,setDetailId]=useState<string|null>(null)

  const filtered = paged.rows.filter(r=>{
    const q=query.toLowerCase()
    if(!q) return true
    return [r.name,r.mobile,r.skills?.join(' '),r.kyc_status].some(v=>v&&String(v).toLowerCase().includes(q))
  })

  async function act(id:string, action:'block'|'unblock'){ setBusyId(id); setActionError(null); try{ await api(`/admin/astrologers/${id}/${action}`,{method:'POST'}); await paged.reload() } catch(e){ setActionError((e as Error).message) } finally{ setBusyId(null) } }
  async function confirmDelete(){ if(!remove) return; setRemoving(true); setRemoveError(null); try{ await adminApi.deleteAstrologer(remove.id); setRemove(null); await paged.reload() } catch(e){ setRemoveError((e as Error).message) } finally{ setRemoving(false) } }

  return (
    <div className="space-y-5">
      <PageHeader
        title="Astrologers"
        subtitle="All astrologers — view detailed profiles, edit, block, or verify KYC status in one place."
        icon={<span className="text-[18px]">🔮</span>}
        actions={<><SearchBox value={query} onChange={setQuery} placeholder="Name, mobile, skills…" /><button onClick={paged.reload} className="h-[42px] rounded-full border border-border-soft bg-surface-raised px-5 text-[13px] font-semibold shadow-sm">↻ Refresh</button></>}
      />

      {(paged.error || actionError) && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{paged.error ?? actionError}</div>}

      {paged.loading && paged.rows.length===0 ? <Card><div className="p-10 text-center text-ivory-faint">Loading astrologers…</div></Card> : paged.rows.length===0 ? <Card><div className="p-16 text-center"><div className="text-[14px] font-semibold">No astrologers</div><div className="text-[12px] text-ivory-faint">No astrologers found in system.</div></div></Card> : (
        <>
          {/* Desktop */}
          <div className="hidden lg:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead><tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-5 py-3.5">Astrologer</th><th className="px-5 py-3.5">Skills</th><th className="px-5 py-3.5">KYC</th><th className="px-5 py-3.5">Status</th><th className="px-5 py-3.5">Rating</th><th className="px-5 py-3.5">Balance</th><th className="px-5 py-3.5 text-right">Actions</th></tr></thead>
                <tbody className="divide-y divide-border-soft/60">
                  {filtered.map(a=>{
                    const blocked=a.kyc_status==='rejected'
                    return (
                      <tr key={a.id} className="hover:bg-surface-1/50 transition-colors">
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-3">
                            <RowAvatar photo={a.photo_url} name={a.name} className="h-10 w-10 text-[12px]" />
                            <div><div className="text-[13.5px] font-semibold">{a.name ?? <span className="text-ivory-faint">—</span>}</div><div className="font-mono text-[11px] text-ivory-faint">{a.mobile ?? '—'} {a.experience!=null ? `· ${a.experience}y` : ''}</div></div>
                          </div>
                        </td>
                        <td className="px-5 py-4 text-[12px] text-ivory-dim max-w-[180px] truncate">{a.skills?.length ? a.skills.join(', ') : <span className="text-ivory-faint">—</span>}</td>
                        <td className="px-5 py-4"><StatusBadge status={a.kyc_status} /></td>
                        <td className="px-5 py-4"><span className={`inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-[11px] font-bold ${a.is_online ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-border-soft bg-surface-2 text-ivory-faint'}`}><span className={`h-1.5 w-1.5 rounded-full ${a.is_online?'bg-emerald-500 animate-pulse':'bg-ivory-faint'}`}/>{a.is_online?'online':'offline'}</span></td>
                        <td className="px-5 py-4 text-[12px] font-medium">⭐ {a.avg_rating}</td>
                        <td className="px-5 py-4"><span className="rounded-full bg-amber-500/10 border border-amber-500/20 px-3 py-1 font-mono text-[11px] font-bold text-amber-400">₹{a.available_balance}</span></td>
                        <td className="px-5 py-4 text-right">
                          <div className="inline-flex items-center gap-1 rounded-full border border-border-soft bg-surface-1 p-1 shadow-sm">
                            <button onClick={()=>setCredit(a)} className="grid h-8 w-8 place-items-center rounded-full bg-surface-raised border border-border-soft text-ivory-dim hover:text-amber-500 hover:border-amber-500/20 transition-colors" title="Credit balance">₹</button>
                            <button onClick={()=>setDetailId(a.id)} className="grid h-8 w-8 place-items-center rounded-full bg-surface-raised border border-border-soft text-ivory-dim hover:text-ivory">👁</button>
                            <button onClick={()=>setEdit(a)} className="grid h-8 w-8 place-items-center rounded-full bg-surface-raised border border-border-soft text-ivory-dim hover:text-ivory"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></button>
                            <button disabled={busyId===a.id} onClick={()=>act(a.id, blocked?'unblock':'block')} className={`grid h-8 w-8 place-items-center rounded-full border text-[11px] font-bold ${blocked ? 'bg-emerald-500/10 border-emerald-500/20 text-emerald-400' : 'bg-amber-500/10 border-amber-500/20 text-amber-400'}`}>{busyId===a.id?'…':blocked?'↺':'⊘'}</button>
                            <button onClick={()=>setRemove(a)} className="grid h-8 w-8 place-items-center rounded-full bg-red-500/10 border border-red-500/20 text-red-400">✕</button>
                          </div>
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile cards */}
          <div className="grid gap-3 lg:hidden">
            {filtered.map(a=>(
              <div key={a.id} className="rounded-xl border border-border-soft bg-surface-raised p-4 shadow-sm">
                <div className="flex items-start justify-between gap-3">
                  <div className="flex gap-3"><RowAvatar photo={a.photo_url} name={a.name} className="h-11 w-11 text-[13px]" /><div><div className="font-semibold text-[14px]">{a.name ?? '—'}</div><div className="text-[11px] text-ivory-faint">{a.mobile ?? ''} · {a.experience ?? 0}y · ⭐{a.avg_rating}</div></div></div>
                  <StatusBadge status={a.kyc_status} />
                </div>
                <div className="mt-3 flex items-center justify-between"><span className="text-[12px] text-ivory-dim truncate max-w-[160px]">{a.skills?.join(', ') ?? '—'}</span><span className={`text-[10px] font-bold uppercase px-2.5 py-1 rounded-full border ${a.is_online ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' : 'bg-surface-2 text-ivory-faint border-border-soft'}`}>{a.is_online?'online':'offline'}</span></div>
                <div className="mt-3 flex gap-2">
                  <button onClick={()=>setDetailId(a.id)} className="flex-1 h-9 rounded-full bg-ivory text-bg-0 text-[12px] font-bold">View</button>
                  <button onClick={()=>setCredit(a)} className="h-9 rounded-full bg-saffron px-3 text-[12px] font-semibold text-white">Credit</button>
                  <button onClick={()=>setEdit(a)} className="h-9 w-9 grid place-items-center rounded-full border border-border-soft bg-surface-1">✎</button>
                </div>
              </div>
            ))}
          </div>

          <Pager page={paged.page} size={paged.size} total={query.trim()?null:paged.total} hasPrev={paged.hasPrev} hasNext={!query.trim()&&paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={filtered.length} />
        </>
      )}

      {credit && <CreditModal astrologer={credit} onClose={()=>setCredit(null)} onDone={()=>{setCredit(null); void paged.reload()}} />}
      {edit && <EditModal astrologer={edit} onClose={()=>setEdit(null)} onDone={()=>{setEdit(null); void paged.reload()}} />}
      {remove && <ConfirmDialog title="Delete astrologer" message="This permanently deletes the astrologer and all their data. Continue?" confirmLabel="Delete astrologer" busy={removing} error={removeError} onConfirm={confirmDelete} onClose={()=>{setRemove(null); setRemoveError(null)}} />}
      <DetailDrawer kind="astrologer" id={detailId} onClose={()=>setDetailId(null)} />
    </div>
  )
}

const KYC_OPTIONS: KYCStatus[]=['pending','approved','rejected']

function EditModal({astrologer,onClose,onDone}:{astrologer:AstrologerRow; onClose:()=>void; onDone:()=>void}){
  // The list row (astrologer) only carries a handful of columns — bio,
  // email, languages and rates aren't part of it, so seeding the form from
  // it alone left most fields blank even though the astrologer already has
  // values (looking like the edit form just "doesn't show data"). Fetch the
  // full profile via the existing GET /astrologers/{id}/detail (same call
  // the detail drawer uses) and prefill from that instead.
  const [loading,setLoading]=useState(true)
  const [loadError,setLoadError]=useState<string|null>(null)
  const [displayName,setDisplayName]=useState(astrologer.name??'')
  const [bio,setBio]=useState('')
  const [mobile,setMobile]=useState(astrologer.mobile??'')
  const [email,setEmail]=useState('')
  const [skills,setSkills]=useState((astrologer.skills??[]).join(', '))
  const [languages,setLanguages]=useState('')
  const [years,setYears]=useState(astrologer.experience!=null?String(astrologer.experience):'')
  const [rateChat,setRateChat]=useState('')
  const [rateCall,setRateCall]=useState('')
  const [rateVideo,setRateVideo]=useState('')
  const [kyc,setKyc]=useState<KYCStatus>(astrologer.kyc_status)
  const [isOnline,setIsOnline]=useState(astrologer.is_online)
  const [photoUrl,setPhotoUrl]=useState<string|null>(astrologer.photo_url??null)
  const [photoChanged,setPhotoChanged]=useState(false)
  const [docs,setDocs]=useState<KycDocSet>({})
  const [error,setError]=useState<string|null>(null)
  const [saving,setSaving]=useState(false)

  useEffect(()=>{
    let cancelled=false
    adminApi.astrologerDetail(astrologer.id).then(d=>{
      if(cancelled) return
      const p=d.profile
      setDisplayName(p.display_name??'')
      setBio(p.bio??'')
      setMobile(p.mobile??'')
      setEmail(p.email??'')
      setSkills((p.skills??[]).join(', '))
      setLanguages((p.languages??[]).join(', '))
      setYears(p.years_experience!=null?String(p.years_experience):'')
      setRateChat(p.rate_chat_per_msg??'')
      setRateCall(p.rate_call_per_min??'')
      setRateVideo(p.rate_video_per_min??'')
      setKyc(p.kyc_status)
      setIsOnline(p.is_online)
      setPhotoUrl(prev=>prev??p.photo_url)
      // No KYC row yet (astrologer never submitted) — admin can still
      // upload the first documents; the backend creates the row for it.
      setDocs(d.kyc ?? {})
    }).catch(e=>{ if(!cancelled) setLoadError((e as Error).message) })
      .finally(()=>{ if(!cancelled) setLoading(false) })
    return ()=>{ cancelled=true }
  },[astrologer.id])

  async function submit(){
    const body: AstrologerEditInput={ kyc_status:kyc, is_online:isOnline }
    if(photoChanged&&photoUrl) body.photo_url=photoUrl
    const dn=displayName.trim(); if(dn) body.display_name=dn
    const b=bio.trim(); if(b) body.bio=b
    const m=mobile.trim(); if(m) body.mobile=m
    const em=email.trim(); if(em) body.email=em
    const sk=skills.split(',').map(s=>s.trim()).filter(Boolean); if(sk.length) body.skills=sk
    const lg=languages.split(',').map(s=>s.trim()).filter(Boolean); if(lg.length) body.languages=lg
    const numField=(raw:string)=>{ const t=raw.trim(); if(!t) return null; const n=Number(t); return Number.isFinite(n)?n:NaN }
    const nums: [string,keyof AstrologerEditInput,string][]=[[years,'years_experience','Years'],[rateChat,'rate_chat_per_msg','Chat rate'],[rateCall,'rate_call_per_min','Call rate'],[rateVideo,'rate_video_per_min','Video rate']]
    for(const [raw,key,label] of nums){ const n=numField(raw); if(n===null) continue; if(Number.isNaN(n)){ setError(`${label} must be a number.`); return } ;(body as Record<string,unknown>)[key]=n }
    setSaving(true); setError(null)
    try{ await adminApi.editAstrologer(astrologer.id,body); onDone() } catch(e){ setError((e as Error).message) } finally{ setSaving(false) }
  }

  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4" onClick={onClose}>
      <div className="max-h-[92vh] w-full max-w-[560px] overflow-y-auto rounded-xl border border-border-soft bg-surface-raised p-6 shadow-2xl animate-pop-in" onClick={e=>e.stopPropagation()}>
        <div className="flex items-center justify-between"><h3 className="text-[16px] font-bold">Edit astrologer</h3><button onClick={onClose} className="grid h-8 w-8 place-items-center rounded-full bg-surface-1 border border-border-soft">✕</button></div>
        <p className="mt-1 text-[11px] text-ivory-faint">{loading ? 'Loading current details…' : 'Leave blank fields unchanged.'}</p>
        {loadError && <div className="mt-3 rounded-xl border border-amber-500/20 bg-amber-500/10 px-3 py-2 text-[13px] text-amber-400">Couldn't load full profile ({loadError}) — showing what's available; unfetched fields are blank.</div>}
        {error && <div className="mt-3 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}
        <div className={`mt-4 grid gap-3 ${loading ? 'opacity-50 pointer-events-none' : ''}`}>
          <ProfilePhotoField url={photoUrl} fallbackLetter={(displayName||astrologer.name||'A')[0].toUpperCase()} onChange={u=>{setPhotoUrl(u); setPhotoChanged(true)}} />
          <label className="text-[12px] font-medium text-ivory-dim">Display name<input value={displayName} onChange={e=>setDisplayName(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px] outline-none focus:border-saffron" /></label>
          <label className="text-[12px] font-medium text-ivory-dim">Bio<input value={bio} onChange={e=>setBio(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label>
          <div className="grid grid-cols-2 gap-3"><label className="text-[12px]">Mobile<input value={mobile} onChange={e=>setMobile(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label><label className="text-[12px]">Email<input value={email} onChange={e=>setEmail(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label></div>
          <label className="text-[12px] font-medium text-ivory-dim">Skills (comma)<input value={skills} onChange={e=>setSkills(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label>
          <label className="text-[12px] font-medium text-ivory-dim">Languages (comma)<input value={languages} onChange={e=>setLanguages(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label>
          <div className="grid grid-cols-2 gap-3"><label className="text-[12px]">Years exp<input value={years} onChange={e=>setYears(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label><label className="text-[12px]">KYC<select value={kyc} onChange={e=>setKyc(e.target.value as KYCStatus)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]">{KYC_OPTIONS.map(o=><option key={o} value={o}>{o}</option>)}</select></label></div>
          <div className="grid grid-cols-3 gap-3"><label className="text-[12px]">Chat ₹<input value={rateChat} onChange={e=>setRateChat(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label><label className="text-[12px]">Call ₹<input value={rateCall} onChange={e=>setRateCall(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label><label className="text-[12px]">Video ₹<input value={rateVideo} onChange={e=>setRateVideo(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px]" /></label></div>
          <label className="flex items-center gap-2 text-[13px] rounded-xl border border-border-soft bg-surface-1 p-3"><input type="checkbox" checked={isOnline} onChange={e=>setIsOnline(e.target.checked)} className="h-4 w-4 rounded border-border-soft" /> Online</label>
        </div>

        <div className="mt-6 text-[11px] font-semibold uppercase tracking-[0.1em] text-ivory-faint border-b border-border-soft pb-2.5">KYC Documents</div>
        <div className={`mt-3 ${loading ? 'opacity-50 pointer-events-none' : ''}`}>
          {loading ? <div className="text-[12px] text-ivory-faint">Loading…</div> : <KycDocsEditor astrologerId={astrologer.id} docs={docs} onChange={setDocs} />}
        </div>

        <div className="mt-6 flex justify-end gap-2"><button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Cancel</button><button disabled={saving||loading} onClick={submit} className="h-10 rounded-full bg-ivory text-bg-0 px-6 text-[13px] font-bold disabled:opacity-50">{saving?'Saving…':'Save changes'}</button></div>
      </div>
    </div>
  )
}

function CreditModal({astrologer,onClose,onDone}:{astrologer:AstrologerRow; onClose:()=>void; onDone:()=>void}){
  const [amount,setAmount]=useState('')
  const [note,setNote]=useState('')
  const [error,setError]=useState<string|null>(null)
  const [saving,setSaving]=useState(false)
  async function submit(){
    const amt=Number(amount); if(Number.isNaN(amt)||amt<=0){ setError('Enter amount > 0'); return }
    setSaving(true); setError(null)
    try{ await adminApi.creditAstrologerWallet(astrologer.id,amt,note); onDone() } catch(e){ setError((e as Error).message) } finally{ setSaving(false) }
  }
  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4 animate-fade-in" onClick={onClose}>
      <div className="w-full max-w-[420px] animate-pop-in rounded-xl border border-border-soft bg-surface-raised p-6 shadow-2xl" onClick={e=>e.stopPropagation()}>
        <h3 className="text-[16px] font-bold">Credit balance</h3>
        <p className="mt-1.5 text-[12px] text-ivory-faint flex items-center gap-2"><span className="grid h-6 w-6 place-items-center rounded-full bg-amber-500/10 border border-amber-500/20 text-amber-400 font-bold text-[10px]">₹</span>{astrologer.name||'Astrologer'} · balance ₹{astrologer.available_balance ?? '0.00'}</p>
        {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}
        <div className="mt-5 grid gap-4">
          <label className="block text-[12px] font-semibold text-ivory-dim">Amount (₹)<input inputMode="decimal" value={amount} onChange={e=>setAmount(e.target.value)} placeholder="500" className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[14px] font-bold outline-none focus:border-saffron" /></label>
          <label className="block text-[12px] font-semibold text-ivory-dim">Note (optional, sent to the astrologer)<input value={note} onChange={e=>setNote(e.target.value)} placeholder="Reason" className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px] outline-none focus:border-saffron" /></label>
        </div>
        <div className="mt-6 flex justify-end gap-2.5"><button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Cancel</button><button disabled={saving} onClick={submit} className="h-10 rounded-full bg-saffron px-6 text-[13px] font-bold text-white hover:brightness-110 disabled:opacity-50">{saving?'Crediting…':'Credit balance'}</button></div>
      </div>
    </div>
  )
}
