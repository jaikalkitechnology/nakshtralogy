import { useMemo, useState } from 'react'
import { adminApi } from '../api/endpoints'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { PageHeader, Card } from '../components/ui/PageShell'

interface Txn {
  id: string
  user_id: string
  type: string
  amount: string
  balance_after: string
  reference_id: string | null
  status: string
  created_at: string
}

const shortId = (v: string) => v.slice(0, 8)
const money = (v: string) => `₹${Number(v).toLocaleString('en-IN', { minimumFractionDigits: 2 })}`
const dateOnly = (v: string) => new Date(v).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })

export default function WalletTransactionsPage() {
  const paged = usePagedData<Txn>('/admin/wallet/transactions')
  const [search, setSearch] = useState('')
  const [refunding, setRefunding] = useState<Txn | null>(null)

  const visible = useMemo(() => {
    const q = search.trim().toLowerCase()
    if (!q) return paged.rows
    return paged.rows.filter(t => [t.user_id, t.type, t.status, t.reference_id].some(v => v && String(v).toLowerCase().includes(q)))
  }, [paged.rows, search])

  return (
    <div className="space-y-5">
      <PageHeader
        title="Wallet Transactions"
        subtitle="Every credit and debit across all customer wallets. Refund a specific charge to return it to the customer's wallet."
        icon={<span className="text-[18px]">🧾</span>}
        actions={<><SearchBox value={search} onChange={setSearch} placeholder="User, type, status…" /><button onClick={paged.reload} className="grid h-[42px] w-[42px] place-items-center rounded-full border border-border-soft bg-surface-raised shadow-sm">↻</button></>}
      />

      {paged.error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{paged.error}</div>}

      {paged.loading && paged.rows.length === 0 ? (
        <Card><div className="p-10 text-center text-ivory-faint">Loading transactions…</div></Card>
      ) : (
        <>
          <div className="hidden md:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                    <th className="px-5 py-3.5">User</th>
                    <th className="px-5 py-3.5">Type</th>
                    <th className="px-5 py-3.5">Amount</th>
                    <th className="px-5 py-3.5">Balance</th>
                    <th className="px-5 py-3.5">Status</th>
                    <th className="px-5 py-3.5">When</th>
                    <th className="px-5 py-3.5 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border-soft/60">
                  {visible.map(t => {
                    const isCharge = Number(t.amount) < 0
                    const refundable = isCharge && t.type !== 'refund'
                    return (
                      <tr key={t.id} className="hover:bg-surface-1/50 transition-colors">
                        <td className="px-5 py-4 font-mono text-[11px] text-ivory-faint">{shortId(t.user_id)}</td>
                        <td className="px-5 py-4 text-[12px] capitalize">{t.type.replace(/_/g, ' ')}</td>
                        <td className="px-5 py-4"><span className={`rounded-full border px-3 py-1 font-mono text-[12px] font-bold ${isCharge ? 'border-red-500/20 bg-red-500/10 text-red-400' : 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400'}`}>{money(t.amount)}</span></td>
                        <td className="px-5 py-4 font-mono text-[12px] text-ivory-dim">{money(t.balance_after)}</td>
                        <td className="px-5 py-4 text-[12px] capitalize">{t.status}</td>
                        <td className="px-5 py-4 text-[12px] text-ivory-faint">{dateOnly(t.created_at)}</td>
                        <td className="px-5 py-4 text-right">
                          {refundable ? (
                            <button onClick={() => setRefunding(t)} className="h-8 rounded-full border border-amber-500/20 bg-amber-500/10 px-4 text-[12px] font-bold text-amber-400 hover:bg-amber-500/20">Refund</button>
                          ) : <span className="text-[12px] text-ivory-faint">—</span>}
                        </td>
                      </tr>
                    )
                  })}
                  {visible.length === 0 && <tr><td colSpan={7} className="py-16 text-center text-[13px] text-ivory-faint">No transactions.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile */}
          <div className="grid gap-3 md:hidden">
            {visible.map(t => {
              const isCharge = Number(t.amount) < 0
              const refundable = isCharge && t.type !== 'refund'
              return (
                <div key={t.id} className="rounded-xl border border-border-soft bg-surface-raised p-4">
                  <div className="flex items-center justify-between">
                    <div className="font-mono text-[11px] text-ivory-faint">{shortId(t.user_id)}</div>
                    <span className="text-[11px] capitalize text-ivory-faint">{t.type.replace(/_/g, ' ')}</span>
                  </div>
                  <div className="mt-2 flex items-center justify-between">
                    <span className={`font-mono font-bold ${isCharge ? 'text-red-400' : 'text-emerald-400'}`}>{money(t.amount)}</span>
                    <span className="text-[11px] text-ivory-faint">{dateOnly(t.created_at)}</span>
                  </div>
                  {refundable && <button onClick={() => setRefunding(t)} className="mt-3 w-full h-9 rounded-full border border-amber-500/20 bg-amber-500/10 text-amber-400 text-[12px] font-bold">Refund</button>}
                </div>
              )
            })}
          </div>

          <Pager page={paged.page} size={paged.size} total={search.trim() ? null : paged.total} hasPrev={paged.hasPrev} hasNext={!search.trim() && paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={visible.length} />
        </>
      )}

      {refunding && (
        <RefundModal
          txn={refunding}
          onClose={() => setRefunding(null)}
          onDone={() => { setRefunding(null); paged.reload() }}
        />
      )}
    </div>
  )
}

function RefundModal({ txn, onClose, onDone }: { txn: Txn; onClose: () => void; onDone: () => void }) {
  const maxAmount = Math.abs(Number(txn.amount))
  const [amount, setAmount] = useState(maxAmount.toFixed(2))
  const [reason, setReason] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)

  async function submit() {
    const n = Number(amount)
    if (!Number.isFinite(n) || n <= 0) { setError('Enter a valid refund amount.'); return }
    if (n > maxAmount) { setError(`Cannot refund more than ${money(String(maxAmount))}.`); return }
    setSaving(true); setError(null)
    try {
      await adminApi.refundTransaction(txn.id, amount, reason.trim() || undefined)
      onDone()
    } catch (e) { setError((e as Error).message) } finally { setSaving(false) }
  }

  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4" onClick={onClose}>
      <div className="w-full max-w-[440px] rounded-xl border border-border-soft bg-surface-raised p-6 shadow-2xl animate-pop-in" onClick={e => e.stopPropagation()}>
        <div className="flex items-center justify-between">
          <h3 className="text-[16px] font-bold">Refund charge</h3>
          <button onClick={onClose} className="grid h-8 w-8 place-items-center rounded-full bg-surface-1 border border-border-soft">✕</button>
        </div>
        <p className="mt-1 text-[11px] text-ivory-faint capitalize">{txn.type.replace(/_/g, ' ')} · charged {money(String(maxAmount))} · customer {shortId(txn.user_id)}</p>
        {error && <div className="mt-3 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}
        <div className="mt-4 grid gap-3">
          <label className="text-[12px] font-medium text-ivory-dim">
            Refund amount (₹)
            <input value={amount} onChange={e => setAmount(e.target.value)} className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px] outline-none focus:border-saffron" />
          </label>
          <label className="text-[12px] font-medium text-ivory-dim">
            Reason (shown to the customer)
            <input value={reason} onChange={e => setReason(e.target.value)} placeholder="e.g. Session disconnected early" className="mt-1.5 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px] outline-none focus:border-saffron" />
          </label>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Cancel</button>
          <button disabled={saving} onClick={submit} className="h-10 rounded-full bg-amber-500 px-6 text-[13px] font-bold text-white hover:brightness-110 disabled:opacity-50">{saving ? 'Refunding…' : 'Refund'}</button>
        </div>
      </div>
    </div>
  )
}
