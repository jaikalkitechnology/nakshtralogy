import { useMemo, useState } from 'react'
import { DetailDrawer, type DetailKind } from '../components/DetailDrawer'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { PageHeader, Card } from '../components/ui/PageShell'

interface LedgerRow {
  id: string
  role: 'customer' | 'astrologer'
  name: string | null
  mobile: string | null
  total_credit: string
  total_debit: string
  balance: string
}

const money = (v: string) => `₹${Number(v).toLocaleString('en-IN', { minimumFractionDigits: 2 })}`

function RoleBadge({ role }: { role: 'customer' | 'astrologer' }) {
  return role === 'astrologer'
    ? <span className="inline-flex items-center gap-1.5 rounded-full border border-amber-500/20 bg-amber-500/10 px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide text-amber-400">🔮 Astrologer</span>
    : <span className="inline-flex items-center gap-1.5 rounded-full border border-violet-500/20 bg-violet-500/10 px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide text-violet-400">👤 Customer</span>
}

export default function WalletLedgerPage() {
  const [role, setRole] = useState<'customer' | 'astrologer'>('customer')
  const paged = usePagedData<LedgerRow>(`/admin/wallet/ledger?role=${role}`)
  const [search, setSearch] = useState('')
  const [detail, setDetail] = useState<{ kind: DetailKind; id: string } | null>(null)

  const visible = useMemo(() => {
    const q = search.trim().toLowerCase()
    if (!q) return paged.rows
    return paged.rows.filter(r => [r.name, r.mobile].some(v => v && v.toLowerCase().includes(q)))
  }, [paged.rows, search])

  const creditLabel = role === 'astrologer' ? 'Earned' : 'Credited'
  const debitLabel = role === 'astrologer' ? 'Paid out' : 'Debited'

  return (
    <div className="space-y-5">
      <PageHeader
        title="Wallet Ledger"
        subtitle="Per-person money totals — switch between customer wallets and astrologer earnings. Click a row for the full detail."
        icon={<span className="text-[18px]">📒</span>}
        actions={<><SearchBox value={search} onChange={setSearch} placeholder="Name, mobile…" /><button onClick={paged.reload} className="grid h-[42px] w-[42px] place-items-center rounded-full border border-border-soft bg-surface-raised shadow-sm">↻</button></>}
      />

      {/* Role toggle */}
      <div className="inline-flex rounded-full border border-border-soft bg-surface-1 p-1">
        {(['customer', 'astrologer'] as const).map(r => (
          <button key={r} onClick={() => { setRole(r); paged.setPage(1) }} className={`h-9 rounded-full px-5 text-[12.5px] font-bold capitalize transition-colors ${role === r ? 'bg-ivory text-bg-0' : 'text-ivory-dim hover:text-ivory'}`}>
            {r === 'customer' ? '👤 Customers' : '🔮 Astrologers'}
          </button>
        ))}
      </div>

      {paged.error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{paged.error}</div>}

      {paged.loading && paged.rows.length === 0 ? (
        <Card><div className="p-10 text-center text-ivory-faint">Loading ledger…</div></Card>
      ) : (
        <>
          <div className="hidden md:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                    <th className="px-5 py-3.5">Name</th>
                    <th className="px-5 py-3.5">Role</th>
                    <th className="px-5 py-3.5">Mobile</th>
                    <th className="px-5 py-3.5">{creditLabel}</th>
                    <th className="px-5 py-3.5">{debitLabel}</th>
                    <th className="px-5 py-3.5">Balance</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border-soft/60">
                  {visible.map(r => (
                    <tr key={r.id} onClick={() => setDetail({ kind: r.role, id: r.id })} className="cursor-pointer hover:bg-surface-1/50 transition-colors">
                      <td className="px-5 py-4 text-[13.5px] font-semibold">{r.name ?? <span className="text-ivory-faint">—</span>}</td>
                      <td className="px-5 py-4"><RoleBadge role={r.role} /></td>
                      <td className="px-5 py-4 font-mono text-[12px] text-ivory-dim">{r.mobile ?? '—'}</td>
                      <td className="px-5 py-4 font-mono text-[12px] font-bold text-emerald-400">{money(r.total_credit)}</td>
                      <td className="px-5 py-4 font-mono text-[12px] font-bold text-red-400">{money(r.total_debit)}</td>
                      <td className="px-5 py-4"><span className="rounded-full border border-amber-500/20 bg-amber-500/10 px-3 py-1 font-mono text-[12px] font-bold text-amber-400">{money(r.balance)}</span></td>
                    </tr>
                  ))}
                  {visible.length === 0 && <tr><td colSpan={6} className="py-16 text-center text-[13px] text-ivory-faint">No {role}s found.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile */}
          <div className="grid gap-3 md:hidden">
            {visible.map(r => (
              <button key={r.id} onClick={() => setDetail({ kind: r.role, id: r.id })} className="rounded-xl border border-border-soft bg-surface-raised p-4 text-left">
                <div className="flex items-center justify-between">
                  <div className="text-[13.5px] font-semibold">{r.name ?? '—'}</div>
                  <RoleBadge role={r.role} />
                </div>
                <div className="mt-1 font-mono text-[11px] text-ivory-faint">{r.mobile ?? '—'}</div>
                <div className="mt-3 flex items-center justify-between text-[12px]">
                  <span className="text-emerald-400 font-mono font-bold">+{money(r.total_credit)}</span>
                  <span className="text-red-400 font-mono font-bold">−{money(r.total_debit)}</span>
                  <span className="font-mono font-bold text-amber-400">{money(r.balance)}</span>
                </div>
              </button>
            ))}
          </div>

          <Pager page={paged.page} size={paged.size} total={search.trim() ? null : paged.total} hasPrev={paged.hasPrev} hasNext={!search.trim() && paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={visible.length} />
        </>
      )}

      {detail && <DetailDrawer kind={detail.kind} id={detail.id} onClose={() => setDetail(null)} />}
    </div>
  )
}
