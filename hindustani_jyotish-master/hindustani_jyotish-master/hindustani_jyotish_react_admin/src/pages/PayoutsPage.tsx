import { useMemo, useState } from 'react'
import { adminApi } from '../api/endpoints'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { PageHeader, Card } from '../components/ui/PageShell'

interface Payout { id:string; astrologer_id:string; astrologer_name?:string|null; amount:string; status:string; bank_account_last4:string|null; ifsc:string|null; created_at:string|null; tds_amount?:string; net_paid?:string; tds_pan?:string|null }

// Matches app/models/payout.py::PayoutStatus exactly (requested → approve
// → processing → mark-paid → paid, or reject → failed at any point before
// paid). The previous map had a "approved" entry the backend never sends —
// after Approve the row is "processing", so the status badge fell back to
// "Pending" and the "Mark paid" button (gated on status==='approved') never
// appeared, stalling every payout right after approval.
const STATUS: Record<string,{label:string; cls:string}> = {
  requested:{label:'Pending',cls:'border-amber-500/20 bg-amber-500/10 text-amber-400'},
  processing:{label:'Processing',cls:'border-sky-500/20 bg-sky-500/10 text-sky-400'},
  paid:{label:'Paid',cls:'border-emerald-500/20 bg-emerald-500/10 text-emerald-400'},
  failed:{label:'Rejected',cls:'border-red-500/20 bg-red-500/10 text-red-400'},
}

export default function PayoutsPage(){
  const paged = usePagedData<Payout>('/admin/payouts')
  const [search,setSearch]=useState('')
  const [busyId,setBusyId]=useState<string|null>(null)
  const [error,setError]=useState<string|null>(null)

  const visible = useMemo(()=>{
    const q=search.trim().toLowerCase()
    if(!q) return paged.rows
    return paged.rows.filter(p=>[p.astrologer_name,p.astrologer_id,p.status,p.ifsc].some(v=>v&&String(v).toLowerCase().includes(q)))
  },[paged.rows,search])

  async function run(id:string, fn:()=>Promise<unknown>){
    setBusyId(id); setError(null)
    try{ await fn(); paged.reload() } catch(e){ setError((e as Error).message) } finally{ setBusyId(null) }
  }

  return (
    <div className="space-y-5">
      <PageHeader
        title="Payouts"
        subtitle="Approve and settle astrologer withdrawals. Track pending, approved and completed payouts."
        icon={<span className="text-[18px]">💸</span>}
        actions={<><SearchBox value={search} onChange={setSearch} placeholder="Astrologer, status…" /><button onClick={paged.reload} className="grid h-[42px] w-[42px] place-items-center rounded-full border border-border-soft bg-surface-raised shadow-sm">↻</button></>}
      />

      {(paged.error||error) && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{paged.error ?? error}</div>}

      {paged.loading && paged.rows.length===0 ? <Card><div className="p-10 text-center text-ivory-faint">Loading payouts…</div></Card> : (
        <>
          <div className="hidden md:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead><tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-5 py-3.5">Astrologer</th><th className="px-5 py-3.5">Gross</th><th className="px-5 py-3.5">TDS / Net</th><th className="px-5 py-3.5">Status</th><th className="px-5 py-3.5">Bank</th><th className="px-5 py-3.5">Date</th><th className="px-5 py-3.5 text-right">Actions</th></tr></thead>
                <tbody className="divide-y divide-border-soft/60">
                  {visible.map(p=>{
                    const st=STATUS[p.status] ?? STATUS.requested
                    const requested=p.status==='requested'
                    const processing=p.status==='processing'
                    return (
                      <tr key={p.id} className="hover:bg-surface-1/50 transition-colors">
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-3"><div className="grid h-9 w-9 place-items-center rounded-xl bg-saffron-soft border border-saffron/15 text-[12px] font-bold text-saffron">{(p.astrologer_name||p.astrologer_id||'A')[0].toUpperCase()}</div><div className="text-[13.5px] font-semibold">{p.astrologer_name ?? <span className="font-mono text-[11px] text-ivory-faint">{p.astrologer_id.slice(0,8)}</span>}</div></div>
                        </td>
                        <td className="px-5 py-4"><span className="rounded-full border border-amber-500/20 bg-amber-500/10 px-3 py-1 font-mono text-[12px] font-bold text-amber-400">₹{Number(p.amount).toLocaleString('en-IN')}</span></td>
                        <td className="px-5 py-4 text-[12px]"><div className="text-amber-400">−₹{Number(p.tds_amount ?? 0).toLocaleString('en-IN')} TDS</div><div className="text-emerald-400 font-semibold">₹{Number(p.net_paid ?? p.amount).toLocaleString('en-IN')} net</div>{p.tds_pan && <div className="font-mono text-[10px] text-ivory-faint">{p.tds_pan}</div>}</td>
                        <td className="px-5 py-4"><span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${st.cls}`}>{st.label}</span></td>
                        <td className="px-5 py-4 font-mono text-[11px]">{p.bank_account_last4 ? `•••• ${p.bank_account_last4}` : '—'} <span className="text-ivory-faint">{p.ifsc ?? ''}</span></td>
                        <td className="px-5 py-4 text-[12px] text-ivory-faint">{p.created_at ? new Date(p.created_at).toLocaleDateString('en-IN',{day:'numeric',month:'short'}) : '—'}</td>
                        <td className="px-5 py-4 text-right">
                          {requested ? (
                            <div className="inline-flex gap-1.5">
                              <button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.approvePayout(p.id))} className="h-8 rounded-full bg-emerald-500 px-4 text-[12px] font-bold text-white hover:brightness-110 disabled:opacity-50">{busyId===p.id?'…':'Approve'}</button>
                              <button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.rejectPayout(p.id))} className="h-8 rounded-full border border-red-500/20 bg-red-500/10 px-4 text-[12px] font-bold text-red-400 hover:bg-red-500/20 disabled:opacity-50">Reject</button>
                            </div>
                          ) : processing ? (
                            <div className="inline-flex gap-1.5">
                              <button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.markPayoutPaid(p.id))} className="h-8 rounded-full bg-saffron px-4 text-[12px] font-bold text-white hover:brightness-110 disabled:opacity-50">{busyId===p.id?'…':'Mark paid'}</button>
                              <button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.rejectPayout(p.id))} className="h-8 rounded-full border border-red-500/20 bg-red-500/10 px-4 text-[12px] font-bold text-red-400 hover:bg-red-500/20 disabled:opacity-50">Reject</button>
                            </div>
                          ) : <span className="text-[12px] text-ivory-faint">—</span>}
                        </td>
                      </tr>
                    )
                  })}
                  {visible.length===0 && <tr><td colSpan={7} className="py-16 text-center text-[13px] text-ivory-faint">No payout requests.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile */}
          <div className="grid gap-3 md:hidden">
            {visible.map(p=>{
              const st=STATUS[p.status] ?? STATUS.requested
              const requested=p.status==='requested'
              const processing=p.status==='processing'
              return (
                <div key={p.id} className="rounded-xl border border-border-soft bg-surface-raised p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2.5"><div className="grid h-9 w-9 place-items-center rounded-xl bg-saffron-soft text-saffron font-bold">{(p.astrologer_name||'A')[0].toUpperCase()}</div><div className="font-semibold text-[13px]">{p.astrologer_name ?? p.astrologer_id.slice(0,8)}</div></div>
                    <span className={`rounded-full border px-2.5 py-1 text-[10px] font-bold uppercase ${st.cls}`}>{st.label}</span>
                  </div>
                  <div className="mt-3 flex items-center justify-between"><span className="font-mono font-bold text-amber-400">₹{Number(p.amount).toLocaleString('en-IN')}</span><span className="text-[11px] text-ivory-faint">{p.created_at ? new Date(p.created_at).toLocaleDateString() : ''}</span></div>
                  <div className="mt-1 flex items-center gap-3 text-[11px]"><span className="text-amber-400">−₹{Number(p.tds_amount ?? 0).toLocaleString('en-IN')} TDS</span><span className="text-emerald-400 font-semibold">₹{Number(p.net_paid ?? p.amount).toLocaleString('en-IN')} net</span></div>
                  <div className="mt-3 flex gap-2">
                    {requested && <><button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.approvePayout(p.id))} className="flex-1 h-9 rounded-full bg-emerald-500 text-white text-[12px] font-bold">Approve</button><button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.rejectPayout(p.id))} className="flex-1 h-9 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-[12px] font-bold">Reject</button></>}
                    {processing && <><button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.markPayoutPaid(p.id))} className="flex-1 h-9 rounded-full bg-saffron text-white text-[12px] font-bold">Mark paid</button><button disabled={busyId===p.id} onClick={()=>run(p.id,()=>adminApi.rejectPayout(p.id))} className="flex-1 h-9 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-[12px] font-bold">Reject</button></>}
                  </div>
                </div>
              )
            })}
          </div>

          <Pager page={paged.page} size={paged.size} total={search.trim()?null:paged.total} hasPrev={paged.hasPrev} hasNext={!search.trim()&&paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={visible.length} />
        </>
      )}
    </div>
  )
}
