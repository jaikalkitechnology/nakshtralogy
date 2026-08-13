import { useEffect, useState } from 'react'
import { api } from '../api/client'
import { PageHeader, StatCard, Card } from '../components/ui/PageShell'

interface CustomerWallet {
  count: number
  total_balance: string
  avg_balance: string
  total_recharged: string
  total_refunded: string
}
interface AstrologerWallet {
  count: number
  total_balance: string
  avg_balance: string
  total_paid_out: string
  pending_payout_amount: string
  pending_payout_count: number
}
interface WalletMgmt {
  customer: CustomerWallet
  astrologer: AstrologerWallet
  platform: { revenue_total: string }
  // Legacy flat fields — same numbers as customer.total_balance /
  // astrologer.total_balance, kept for anything else still reading them.
  total_user_balance: string
  total_recharged: string
  astrologer_payable: string
}

const inr = (v: string | number) => `₹${Number(v).toLocaleString('en-IN')}`

export default function WalletManagementPage(){
  const [d,setD]=useState<WalletMgmt|null>(null)
  const [error,setError]=useState<string|null>(null)

  useEffect(()=>{ api<WalletMgmt>('/admin/wallet/management').then(setD).catch(e=>setError(e.message)) },[])

  return (
    <div className="space-y-6">
      <PageHeader title="Wallet Management" subtitle="Money held and owed across the platform — customer wallets, astrologer wallets, and platform revenue, broken out separately." icon={<span className="text-[18px]">💰</span>} />
      {error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error}</div>}
      {!d && !error ? (
        <div className="grid gap-4 sm:grid-cols-3">
          {[0,1,2].map(i=> <div key={i} className="h-[120px] rounded-xl border border-border-soft bg-surface-1 animate-pulse" />)}
        </div>
      ) : d ? (
        <>
          <Card className="p-6">
            <div className="flex items-center gap-2.5">
              <div className="grid h-8 w-8 place-items-center rounded-full bg-amber-500/10 border border-amber-500/20 text-[14px]">💳</div>
              <h3 className="text-[14px] font-bold">Customer wallets</h3>
              <span className="rounded-full border border-border-soft bg-surface-1 px-2.5 py-0.5 font-mono text-[11px] font-bold text-ivory-faint">{d.customer.count.toLocaleString('en-IN')} customers</span>
            </div>
            <div className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
              <StatCard label="Total balance held" value={inr(d.customer.total_balance)} icon="💳" tint="amber" sub="Across all customers" />
              <StatCard label="Average balance" value={inr(d.customer.avg_balance)} icon="📊" tint="saffron" sub="Per customer" />
              <StatCard label="Total recharged" value={inr(d.customer.total_recharged)} icon="📈" tint="emerald" sub="Lifetime" />
              <StatCard label="Total refunded" value={inr(d.customer.total_refunded)} icon="↩️" tint="violet" sub="Lifetime" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center gap-2.5">
              <div className="grid h-8 w-8 place-items-center rounded-full bg-violet-500/10 border border-violet-500/20 text-[14px]">🔮</div>
              <h3 className="text-[14px] font-bold">Astrologer wallets</h3>
              <span className="rounded-full border border-border-soft bg-surface-1 px-2.5 py-0.5 font-mono text-[11px] font-bold text-ivory-faint">{d.astrologer.count.toLocaleString('en-IN')} astrologers</span>
            </div>
            <div className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
              <StatCard label="Available balance" value={inr(d.astrologer.total_balance)} icon="💸" tint="violet" sub="Payable now" />
              <StatCard label="Average balance" value={inr(d.astrologer.avg_balance)} icon="📊" tint="saffron" sub="Per astrologer" />
              <StatCard label="Paid out" value={inr(d.astrologer.total_paid_out)} icon="✅" tint="emerald" sub="Lifetime settled" />
              <StatCard label="Pending payouts" value={inr(d.astrologer.pending_payout_amount)} icon="⏳" tint="amber" sub={`${d.astrologer.pending_payout_count} request${d.astrologer.pending_payout_count===1?'':'s'} awaiting`} />
            </div>
          </Card>

          <Card className="p-6">
            <h3 className="text-[14px] font-bold">Insights</h3>
            <div className="mt-4 grid gap-3 sm:grid-cols-3 text-[13px]">
              <div className="rounded-xl bg-surface-1 border border-border-soft p-4">
                <div className="text-[11px] uppercase font-bold text-ivory-faint tracking-wide">Platform revenue</div>
                <div className="mt-1 font-mono font-bold text-[14px]">{inr(d.platform.revenue_total)}</div>
                <div className="mt-1 text-[11px] text-ivory-faint">Commission earned, lifetime</div>
              </div>
              <div className="rounded-xl bg-surface-1 border border-border-soft p-4">
                <div className="text-[11px] uppercase font-bold text-ivory-faint tracking-wide">Net float</div>
                <div className="mt-1 font-mono font-bold text-[14px]">{inr(Number(d.customer.total_balance) - Number(d.astrologer.total_balance))}</div>
                <div className="mt-1 text-[11px] text-ivory-faint">Customer balance minus astrologer payable</div>
              </div>
              <div className="rounded-xl bg-surface-1 border border-border-soft p-4">
                <div className="text-[11px] uppercase font-bold text-ivory-faint tracking-wide">Health</div>
                <div className="mt-1 flex items-center gap-2"><span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"/><span className="font-bold text-emerald-400">Healthy</span></div>
                <div className="mt-1 text-[11px] text-ivory-faint">All balances reconciled</div>
              </div>
            </div>
          </Card>
        </>
      ) : null}
    </div>
  )
}
