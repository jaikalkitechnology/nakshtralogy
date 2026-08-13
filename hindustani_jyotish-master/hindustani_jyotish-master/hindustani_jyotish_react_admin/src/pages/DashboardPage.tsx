import { useEffect, useRef, useState, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api/client'
import { useAuth } from '../auth/AuthContext'
import { BarChart, DonutChart, LineChart, type Point } from '../components/Charts'

interface Overview {
  customers: number
  astrologers: number
  pending_approvals: number
  online_astrologers: number
  consultations: number
  completed_consultations: number
  active_sessions: number
  pending_payouts: number
  coupons: number
  banners: number
  wallet_balance_total: string
  astrologer_payable_total: string
  platform_revenue_total: string
  refunds_total: string
}
interface Txn { amount?: string|number; type?: string; created_at?: string }

function unwrap<T>(payload: unknown): T[] {
  if (Array.isArray(payload)) return payload as T[]
  const p = (payload ?? {}) as { items?: T[]; results?: T[]; data?: T[] }
  return p.items ?? p.results ?? p.data ?? []
}
function dailySeries(txns: Txn[], days: number): { amount: Point[]; count: Point[] } {
  const today=new Date()
  const buckets: { key:string; label:string; amount:number; count:number }[]=[]
  for(let i=days-1;i>=0;i--){ const d=new Date(today); d.setDate(today.getDate()-i); buckets.push({ key:d.toISOString().slice(0,10), label:d.toLocaleDateString('en-IN',{day:'numeric',month:'short'}), amount:0, count:0 }) }
  const idx=new Map(buckets.map((b,i)=>[b.key,i]))
  for(const t of txns){ if(!t.created_at) continue; const key=new Date(t.created_at).toISOString().slice(0,10); const i=idx.get(key); if(i==null) continue; buckets[i].count++; buckets[i].amount+=Math.abs(Number(t.amount)||0) }
  return { amount: buckets.map(b=>({label:b.label,value:Math.round(b.amount)})), count: buckets.map(b=>({label:b.label,value:b.count})) }
}

const inr=(n:number)=>`₹${Math.round(n).toLocaleString('en-IN')}`
function inrCompact(n:number){ const abs=Math.abs(n); const t=(x:number)=>String(Math.round(x*10)/10); if(abs>=1e7) return `₹${t(n/1e7)}Cr`; if(abs>=1e5) return `₹${t(n/1e5)}L`; if(abs>=1e3) return `₹${t(n/1e3)}K`; return `₹${Math.round(n)}` }
function relTime(iso?:string){ if(!iso) return '—'; const t=new Date(iso).getTime(); if(Number.isNaN(t)) return '—'; const m=Math.max(0,Math.round((Date.now()-t)/60000)); if(m<1) return 'just now'; if(m<60) return `${m}m ago`; const h=Math.floor(m/60); if(h<24) return `${h}h ago`; const d=Math.floor(h/24); if(d<7) return `${d}d ago`; return new Date(t).toLocaleDateString('en-IN',{day:'numeric',month:'short'}) }
function greeting(){ const h=new Date().getHours(); if(h<5) return 'Working late'; if(h<12) return 'Good morning'; if(h<17) return 'Good afternoon'; return 'Good evening' }
function txnDir(type?:string){ const t=(type??'').toLowerCase(); if(/credit|recharge|top.?up|refund|cashback|bonus/.test(t)) return 'cr'; if(/debit|charge|consult|spend|withdraw/.test(t)) return 'dr'; return 'na' }

function useCountUp(target:number, duration=900){
  const [val,setVal]=useState(0)
  const from=useRef(0)
  useEffect(()=>{
    if(window.matchMedia('(prefers-reduced-motion: reduce)').matches){ const raf=requestAnimationFrame(()=>setVal(target)); return()=>cancelAnimationFrame(raf) }
    const start=from.current; const delta=target-start; if(delta===0) return; let raf:number; const t0=performance.now()
    const tick=(now:number)=>{ const p=Math.min((now-t0)/duration,1); const eased=1-Math.pow(1-p,3); setVal(Math.round(start+delta*eased)); if(p<1) raf=requestAnimationFrame(tick); else from.current=target }
    raf=requestAnimationFrame(tick); return()=>{ from.current=target; cancelAnimationFrame(raf) }
  },[target,duration])
  return val
}

function Svg({children}:{children:ReactNode}){ return <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden>{children}</svg> }
const IconUsers=()=><Svg><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></Svg>
const IconStar=()=><Svg><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></Svg>
const IconChat=()=><Svg><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></Svg>
const IconTicket=()=><Svg><path d="M2 9V7a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4z"/><path d="M9 9h.01"/><path d="M15 9h.01"/></Svg>

function KpiCard({label,value,to,tint,icon,sub,subDot,trend}:{label:string; value:number; to:string; tint:'saffron'|'gold'|'violet'|'emerald'; icon:ReactNode; sub:string; subDot?:string; trend?:string}){
  const animated=useCountUp(value)
  const tints={
    saffron:'bg-orange-500/10 text-orange-400 border-orange-500/20',
    gold:'bg-amber-500/10 text-amber-400 border-amber-500/20',
    violet:'bg-violet-500/10 text-violet-400 border-violet-500/20',
    emerald:'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
  } as const
  return (
    <Link to={to} className="group relative overflow-hidden rounded-[14px] border border-border-soft bg-surface-raised shadow-[var(--shadow-1)] transition-all hover:shadow-[var(--shadow-2)] hover:border-border-mid no-underline">
      <div className="relative h-full p-5">
        <div className="relative flex items-start justify-between">
          <div className={`grid h-10 w-10 place-items-center rounded-lg border ${tints[tint]}`}>{icon}</div>
          <div className="flex items-center gap-2">
            {trend && <span className="hidden sm:inline-flex items-center gap-1 rounded-full bg-emerald-500/10 border border-emerald-500/15 px-2 py-1 text-[10px] font-bold text-emerald-400"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>{trend}</span>}
            <span className="grid h-8 w-8 place-items-center rounded-full bg-surface-1 border border-border-soft text-ivory-faint opacity-0 group-hover:opacity-100 transition-all translate-x-1 group-hover:translate-x-0">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M7 17L17 7M8 7h9v9"/></svg>
            </span>
          </div>
        </div>
        <div className="relative mt-5 text-[30px] font-bold leading-none tracking-tight tabular-nums">{animated.toLocaleString('en-IN')}</div>
        <div className="relative mt-2 text-[12px] font-medium text-ivory-dim">{label}</div>
        <div className="relative mt-3 flex items-center gap-2 border-t border-border-soft pt-3 text-[11.5px] text-ivory-faint">
          {subDot && <span className="h-2 w-2 rounded-full" style={{background:subDot}} />}
          {sub}
        </div>
      </div>
    </Link>
  )
}

function Skeleton({className=''}:{className?:string}) {
  return <div className={`relative overflow-hidden rounded-xl border border-border-soft bg-surface-2 ${className} animate-pulse`}><div className="absolute inset-0 -translate-x-full bg-gradient-to-r from-transparent via-black/[0.03] to-transparent animate-[shimmer_1.6s_infinite]" /></div>
}

export default function DashboardPage(){
  const { admin }=useAuth()
  const [data,setData]=useState<Overview|null>(null)
  const [series,setSeries]=useState<{amount:Point[]; count:Point[]}|null>(null)
  const [txns,setTxns]=useState<Txn[]>([])
  const [error,setError]=useState<string|null>(null)

  useEffect(()=>{
    api<Overview>('/admin/overview').then(setData).catch(e=>setError(e.message))
    api<unknown>('/admin/wallet/transactions?page=1&size=500').then(p=>{
      const list=unwrap<Txn>(p); setSeries(dailySeries(list,14)); setTxns([...list].sort((a,b)=>(b.created_at??'').localeCompare(a.created_at??'')).slice(0,6))
    }).catch(()=>{ setSeries({amount:[],count:[]}); setTxns([]) })
  },[])

  const name=admin?.name?.trim() || admin?.email?.split('@')[0].replace(/[._-]+/g,' ').trim().split(' ').map(w=>w.charAt(0).toUpperCase()+w.slice(1)).join(' ') || ''
  const today=new Date().toLocaleDateString('en-IN',{weekday:'long', day:'numeric', month:'long'})
  const attention=data ? [{n:data.pending_approvals,label:data.pending_approvals===1?'KYC pending':'KYC pending',to:'/approval',icon:'🪪'},{n:data.pending_payouts,label:data.pending_payouts===1?'Payout pending':'Payouts pending',to:'/payouts',icon:'💸'}].filter(a=>a.n>0) : []
  const todayVolume=series?.amount.length ? series.amount[series.amount.length-1].value : null
  const progressOnline = data ? Math.round((data.online_astrologers / Math.max(data.astrologers,1))*100) : 0

  if(!data && !error){
    return (
      <div className="space-y-6">
        <Skeleton className="h-[260px] rounded-2xl" />
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">{[0,1,2,3].map(i=><Skeleton key={i} className="h-[180px]" />)}</div>
        <div className="grid grid-cols-1 gap-5 lg:grid-cols-12"><Skeleton className="h-[380px] lg:col-span-8" /><Skeleton className="h-[380px] lg:col-span-4" /></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {error && <div className="flex gap-3 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3.5 text-[13px] text-red-300"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="mt-0.5 shrink-0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>{error}</div>}

      {data && (
        <>
          {/* Hero */}
          <section className="relative overflow-hidden rounded-2xl border border-border-soft bg-surface-raised p-6 sm:p-8 shadow-[var(--shadow-1)]">
            <div className="relative z-10 grid gap-8 lg:grid-cols-[1.2fr_0.8fr] lg:items-start">
              <div>
                <div className="inline-flex items-center gap-2 rounded-full border border-amber-500/20 bg-amber-500/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-wide text-amber-400">
                  <span className="relative flex h-2 w-2"><span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-50"></span><span className="relative inline-flex rounded-full h-2 w-2 bg-amber-500"></span></span> Mission Control · Live
                </div>
                <h1 className="mt-4 text-[24px] sm:text-[28px] font-semibold leading-tight tracking-[-0.02em]">
                  {greeting()}{name ? `, ${name}` : ''}
                </h1>
                <p className="mt-2.5 max-w-[56ch] text-[13.5px] leading-[1.6] text-ivory-dim">{today} — here’s what’s happening across your marketplace. Everything in one place.</p>

                {attention.length>0 ? (
                  <div className="mt-7 flex flex-wrap items-center gap-2.5">
                    <span className="inline-flex items-center gap-2 rounded-full border border-amber-500/20 bg-amber-500/10 px-3.5 py-2 text-[11px] font-semibold uppercase tracking-wide text-amber-400"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> Needs attention</span>
                    {attention.map(a=>(
                      <Link key={a.to} to={a.to} className="group inline-flex items-center gap-2.5 rounded-full border border-border-soft bg-surface-raised px-4 py-2.5 text-[12.5px] font-[550] shadow-[var(--shadow-1)] transition-all hover:-translate-y-0.5 hover:border-saffron/30 hover:shadow-[var(--shadow-2)] no-underline">
                        <span className="text-[14px]">{a.icon}</span> <b className="font-mono text-saffron text-[13px]">{a.n.toLocaleString('en-IN')}</b> {a.label} <span className="grid h-5 w-5 place-items-center rounded-full bg-surface-1 border border-border-soft group-hover:bg-saffron group-hover:text-white transition-colors"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M7 17L17 7M8 7h9v9"/></svg></span>
                      </Link>
                    ))}
                  </div>
                ) : (
                  <div className="mt-7 inline-flex items-center gap-2 rounded-full border border-emerald-500/20 bg-emerald-500/10 px-4 py-2 text-[12px] font-medium text-emerald-400">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg> All clear — no pending actions
                  </div>
                )}


              </div>

              <div className="relative">
                <div className="rounded-[14px] border border-border-soft bg-surface-1 p-5">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-[11px] font-semibold uppercase tracking-wide text-ivory-faint"><span className="relative grid h-2.5 w-2.5 place-items-center"><span className="absolute h-2.5 w-2.5 animate-ping rounded-full bg-emerald-500/60"/><span className="relative h-2.5 w-2.5 rounded-full bg-emerald-500"/></span> Live pulse</div>
                    <span className="rounded-full bg-surface-raised border border-border-soft px-2.5 py-1 text-[10px] font-mono font-bold">LIVE</span>
                  </div>
                  <div className="mt-5 grid gap-4">
                    {[
                      { label:'astrologers online', value:data.online_astrologers.toLocaleString('en-IN'), sub:`${progressOnline}% of network`, dot:'bg-emerald-500', bar: progressOnline },
                      { label:'sessions active', value:data.active_sessions.toLocaleString('en-IN'), sub: data.active_sessions>0 ? 'Live consultations ongoing' : 'No active calls', dot:'bg-orange-500', bar: Math.min(data.active_sessions*12,100) },
                      { label:'wallet volume today', value: todayVolume==null ? '—' : inr(todayVolume), sub: 'Gross transaction volume', dot:'bg-amber-500', gold:true, bar: 72 },
                    ].map(r=>(
                      <div key={r.label} className="group">
                        <div className="flex items-center justify-between">
                          <div className="flex items-center gap-2.5">
                            <span className={`h-2.5 w-2.5 rounded-full ${r.dot}`} />
                            <div><div className={`text-[22px] font-bold leading-none tabular-nums ${r.gold ? 'text-amber-300' : ''}`}>{r.value}</div><div className="mt-1 text-[11px] text-ivory-faint">{r.label}</div></div>
                          </div>
                          <div className="text-[10px] font-mono text-ivory-faint">{r.bar}%</div>
                        </div>
                        <div className="mt-2.5 h-1.5 w-full overflow-hidden rounded-full bg-surface-3">
                          <div className={`h-full rounded-full transition-all duration-1000 ${r.dot}`} style={{ width: `${r.bar}%` }} />
                        </div>
                        <div className="mt-1.5 text-[10.5px] text-ivory-faint">{r.sub}</div>
                      </div>
                    ))}
                  </div>
                  <div className="mt-5 grid grid-cols-2 gap-2">
                    <Link to="/astrologers" className="inline-flex h-9 items-center justify-center gap-1.5 rounded-full bg-ivory text-bg-0 text-[12px] font-semibold hover:opacity-90 transition-colors no-underline">View astrologers →</Link>
                    <Link to="/wallet" className="inline-flex h-9 items-center justify-center gap-1.5 rounded-full border border-border-soft bg-surface-1 text-[12px] font-semibold hover:bg-surface-2 transition-colors no-underline">Financials</Link>
                  </div>
                </div>


              </div>
            </div>
          </section>

          {/* KPI */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <KpiCard label="Customers" value={data.customers} to="/customers" tint="saffron" icon={<IconUsers/>} sub="Registered seekers" trend="+8%" />
            <KpiCard label="Astrologers" value={data.astrologers} to="/astrologers" tint="gold" icon={<IconStar/>} sub={data.online_astrologers>0 ? `${data.online_astrologers} online now` : 'No one online'} subDot={data.online_astrologers>0 ? 'var(--color-success)' : undefined} trend="+3%" />
            <KpiCard label="Consultations" value={data.consultations} to="/sessions" tint="violet" icon={<IconChat/>} sub={`${data.completed_consultations.toLocaleString('en-IN')} completed${data.active_sessions>0 ? ` · ${data.active_sessions} live` : ''}`} subDot={data.active_sessions>0 ? 'var(--color-saffron)' : undefined} trend="+12%" />
            <KpiCard label="Coupons" value={data.coupons} to="/coupons" tint="emerald" icon={<IconTicket/>} sub="Active promo codes" />
          </div>

          {/* Revenue & payables — the money-side complement to the KPI counts above */}
          <section className="rounded-xl border border-border-soft bg-surface-raised p-5 sm:p-6 shadow-[var(--shadow-1)]">
            <div className="mb-5 flex items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <div className="grid h-9 w-9 place-items-center rounded-xl bg-amber-500/10 border border-amber-500/15 text-amber-400"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M12 1v22"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                <div><h3 className="text-[14px] font-bold tracking-tight">Revenue &amp; payables</h3><p className="text-[11px] text-ivory-faint">Platform money at a glance</p></div>
              </div>
              <Link to="/wallet" className="rounded-full bg-ivory text-bg-0 px-3 py-1.5 text-[11px] font-bold no-underline hover:opacity-90 transition-colors">Full breakdown</Link>
            </div>
            <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
              {[
                { label:'Wallet balances held', value: inrCompact(Number(data.wallet_balance_total)), sub:'Customer wallets' },
                { label:'Astrologer payable', value: inrCompact(Number(data.astrologer_payable_total)), sub:'Owed to astrologers' },
                { label:'Platform revenue', value: inrCompact(Number(data.platform_revenue_total)), sub:'Commission earned' },
                { label:'Refunds issued', value: inrCompact(Number(data.refunds_total)), sub:'Lifetime' },
              ].map(t=>(
                <div key={t.label} className="rounded-xl bg-surface-1 border border-border-soft p-4">
                  <div className="text-[11px] uppercase font-bold text-ivory-faint tracking-wide">{t.label}</div>
                  <div className="mt-1 font-mono font-bold text-[16px]">{t.value}</div>
                  <div className="mt-1 text-[11px] text-ivory-faint">{t.sub}</div>
                </div>
              ))}
            </div>
          </section>

          {/* Charts */}
          <div className="grid grid-cols-1 gap-5 lg:grid-cols-12">
            <section className="rounded-xl border border-border-soft bg-surface-raised p-5 sm:p-6 shadow-[var(--shadow-1)] lg:col-span-8 overflow-hidden">
              <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="grid h-9 w-9 place-items-center rounded-xl bg-saffron-soft border border-saffron/15 text-saffron"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M3 3v18h18"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></div>
                  <div><h3 className="text-[14px] font-bold tracking-tight">Wallet volume</h3><p className="text-[11px] text-ivory-faint">Daily gross across all transactions</p></div>
                </div>
                <div className="flex items-center gap-2">
                  <span className="rounded-full border border-border-soft bg-surface-1 px-3 py-1.5 font-mono text-[10px] font-bold tracking-wide">₹ / day · 14d</span>
                  <span className="hidden sm:inline-flex items-center gap-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/15 px-3 py-1.5 text-[11px] font-bold text-emerald-400"><span className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse"/>Live data</span>
                </div>
              </div>
              {series ? <LineChart data={series.amount} formatValue={inr} /> : <div className="grid place-items-center rounded-xl border border-dashed border-border-soft bg-surface-1 p-10 text-[13px] text-ivory-faint">Loading…</div>}
            </section>
            <section className="rounded-xl border border-border-soft bg-surface-raised p-5 sm:p-6 shadow-[var(--shadow-1)] lg:col-span-4">
              <div className="mb-6 flex items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="grid h-9 w-9 place-items-center rounded-xl bg-violet-500/10 border border-violet-500/15 text-violet-400"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg></div>
                  <div><h3 className="text-[14px] font-bold tracking-tight">Network</h3><p className="text-[11px] text-ivory-faint">{data.astrologers.toLocaleString('en-IN')} total astrologers</p></div>
                </div>
                <span className="rounded-full border border-border-soft bg-surface-1 px-3 py-1 font-mono text-[10px] font-bold">{progressOnline}% online</span>
              </div>
              <DonutChart centerSub="astrologers" slices={[{label:'Online now', value:data.online_astrologers, color:'var(--color-success)'},{label:'KYC pending', value:data.pending_approvals, color:'var(--color-gold)'},{label:'Registered', value:Math.max(data.astrologers - data.online_astrologers - data.pending_approvals,0), color:'var(--color-saffron)'}]} />
              <div className="mt-6 grid grid-cols-3 gap-2 text-center">
                {[
                  { k:'Online', v:data.online_astrologers },
                  { k:'Pending', v:data.pending_approvals },
                  { k:'Total', v:data.astrologers }
                ].map(s=>(
                  <div key={s.k} className="rounded-xl bg-surface-1 border border-border-soft px-2 py-2.5">
                    <div className="text-[18px] font-bold leading-none">{s.v}</div>
                    <div className="mt-1 text-[10px] font-bold uppercase tracking-wide text-ivory-faint">{s.k}</div>
                  </div>
                ))}
              </div>
            </section>
          </div>

          <div className="grid grid-cols-1 gap-5 lg:grid-cols-12">
            <section className="rounded-xl border border-border-soft bg-surface-raised p-5 sm:p-6 shadow-[var(--shadow-1)] lg:col-span-7">
              <div className="mb-6 flex items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="grid h-9 w-9 place-items-center rounded-xl bg-amber-500/10 border border-amber-500/15 text-amber-400"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M12 20v2"/><path d="M12 2v2"/><path d="M17 20v2"/><path d="M17 2v2"/><path d="M2 12h2"/><path d="M2 17h2"/><path d="M2 7h2"/><path d="M20 12h2"/><path d="M20 17h2"/><path d="M20 7h2"/><path d="M7 20v2"/><path d="M7 2v2"/><rect x="2" y="2" width="20" height="20" rx="5"/></svg></div>
                  <div><h3 className="text-[14px] font-bold tracking-tight">Daily transactions</h3><p className="text-[11px] text-ivory-faint">Count per day · last 14 days</p></div>
                </div>
                <span className="rounded-full border border-border-soft bg-surface-1 px-3 py-1.5 font-mono text-[10px] font-bold">count / day</span>
              </div>
              {series ? <BarChart data={series.count} formatValue={v=>v.toLocaleString('en-IN')} /> : <div className="grid place-items-center rounded-xl border border-dashed border-border-soft bg-surface-1 p-10 text-[13px] text-ivory-faint">Loading…</div>}
            </section>
            <section className="rounded-xl border border-border-soft bg-surface-raised p-5 sm:p-6 shadow-[var(--shadow-1)] lg:col-span-5 flex flex-col">
              <div className="mb-6 flex items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="grid h-9 w-9 place-items-center rounded-xl bg-emerald-500/10 border border-emerald-500/15 text-emerald-400"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>
                  <div><h3 className="text-[14px] font-bold tracking-tight">Latest activity</h3><p className="text-[11px] text-ivory-faint">Recent wallet movements</p></div>
                </div>
                <Link to="/wallet-transactions" className="rounded-full bg-ivory text-bg-0 px-3 py-1.5 text-[11px] font-bold no-underline hover:opacity-90 transition-colors">View all</Link>
              </div>
              {series==null ? <div className="grid place-items-center rounded-xl border border-dashed border-border-soft bg-surface-1 p-10 text-[13px] text-ivory-faint">Loading…</div> : txns.length===0 ? <div className="py-10 text-center text-[13px] text-ivory-faint">No recent transactions.</div> : (
                <div className="divide-y divide-border-soft/60 -mx-1">
                  {txns.map((t,i)=>{
                    const dir=txnDir(t.type); const amt=Math.abs(Number(t.amount)||0)
                    return (
                      <div key={i} className="flex items-center gap-3.5 py-3.5 px-1 group hover:bg-surface-1/50 rounded-xl transition-colors">
                        <span className={`grid h-10 w-10 place-items-center rounded-xl font-mono text-[14px] font-bold border shadow-sm group-hover:scale-105 transition-transform ${dir==='cr' ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/15' : dir==='dr' ? 'bg-red-500/10 text-red-400 border-red-500/15' : 'bg-amber-500/10 text-amber-400 border-amber-500/15'}`}>{dir==='cr'?'+':dir==='dr'?'−':'•'}</span>
                        <div className="min-w-0 flex-1"><div className="truncate text-[13.5px] font-[550] capitalize">{(t.type??'transaction').replace(/_/g,' ')}</div><div className="flex items-center gap-1.5 text-[11px] text-ivory-faint mt-0.5"><span className="h-1 w-1 rounded-full bg-ivory-faint"/>{relTime(t.created_at)}</div></div>
                        <span className={`font-mono text-[13px] font-bold px-2.5 py-1 rounded-full border ${dir==='cr'?'text-emerald-400 bg-emerald-500/10 border-emerald-500/15':dir==='dr'?'text-red-400 bg-red-500/10 border-red-500/15':'text-ivory bg-surface-1 border-border-soft'}`}>{dir==='cr'?'+':dir==='dr'?'−':''}{inrCompact(amt)}</span>
                      </div>
                    )
                  })}
                </div>
              )}

              <div className="mt-auto pt-6">
                <div className="rounded-xl bg-saffron-soft border border-saffron/20 p-4 flex items-center justify-between">
                  <div className="flex items-center gap-2.5">
                    <div className="grid h-8 w-8 place-items-center rounded-full bg-saffron text-white font-bold">✦</div>
                    <div><div className="text-[12px] font-bold">Pro tip</div><div className="text-[11px] text-ivory-dim">Check KYC queue daily for faster approvals.</div></div>
                  </div>
                  <Link to="/approval" className="grid h-8 w-8 place-items-center rounded-full bg-ivory text-bg-0 no-underline"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M7 17L17 7M8 7h9v9"/></svg></Link>
                </div>
              </div>
            </section>
          </div>
        </>
      )}
    </div>
  )
}
