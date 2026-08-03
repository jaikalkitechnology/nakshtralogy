import { useState } from "react";
import { Link } from "react-router-dom";
import {
  IndianRupee, TrendingUp, Users, MessageSquare, Star, ShieldAlert, Server,
  Repeat, CheckCircle2, UserPlus, Ticket, CreditCard, Bell, FileText, RefreshCw,
  Database, Play, ArrowUpRight, Wallet, MessageSquareWarning, UserCog, RotateCcw,
  Check, X as XIcon, Eye,
} from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from "recharts";
import { useAuth } from "@/contexts/AuthContext";
import StatCard from "@/components/premium/StatCard";
import GlassPanel from "@/components/premium/GlassPanel";
import Ring from "@/components/premium/Ring";
import StatusRow from "@/components/premium/StatusRow";

const spark = (seed: number) => Array.from({ length: 10 }, (_, i) => Math.sin(i + seed) * 4 + i * 1.2 + seed);

type RevenueFilter = "Today" | "Week" | "Month" | "Year";
const REVENUE_BY_FILTER: Record<RevenueFilter, { d: string; revenue: number; commission: number }[]> = {
  Today: Array.from({ length: 12 }, (_, i) => ({ d: `${i * 2}h`, revenue: 3 + i * 1.6 + Math.sin(i) * 1.2, commission: 1 + i * 0.6 })),
  Week: Array.from({ length: 7 }, (_, i) => ({ d: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][i], revenue: 30 + i * 8 + Math.sin(i) * 6, commission: 15 + i * 4 })),
  Month: Array.from({ length: 14 }, (_, i) => ({ d: `${i + 1}`, revenue: 40 + i * 6 + Math.sin(i) * 8, commission: 20 + i * 3 })),
  Year: Array.from({ length: 12 }, (_, i) => ({ d: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][i], revenue: 400 + i * 60 + Math.sin(i) * 80, commission: 200 + i * 30 })),
};

const QUICK = [
  { icon: CheckCircle2, label: "Approve KYC", to: "/admin/kyc" }, { icon: UserPlus, label: "Add Astrologer", to: "/admin/astrologers" },
  { icon: Ticket, label: "Create Coupon", to: "/admin/gifts" }, { icon: CreditCard, label: "Create Pricing", to: "/admin/pricing" },
  { icon: Bell, label: "Send Notification", to: "/admin/notifications" }, { icon: FileText, label: "Generate Report", to: "/admin/analytics" },
  { icon: RefreshCw, label: "Refresh Cache", to: "/admin/settings" }, { icon: Database, label: "Backup DB", to: "/admin/settings" }, { icon: Play, label: "API Playground", to: "/admin/api" },
];

const ACTIVITY = [
  { icon: "₹", tone: "bg-emerald-500/15 text-emerald-400", title: "Wallet credited — Priya S.", meta: "Razorpay top-up • 2 min ago", right: "+₹2,000" },
  { icon: "🎥", tone: "bg-cyan-500/15 text-cyan-400", title: "Video consultation completed", meta: "Astrologer Rajesh • 8 min ago", chip: "DONE" },
  { icon: "✓", tone: "bg-gold/15 text-gold", title: "KYC approved — Kavita D.", meta: "Documents verified • 21 min ago", chip: "APPROVED" },
  { icon: "◆", tone: "bg-cosmic/15 text-cosmic-light", title: "Subscription purchased", meta: "All-Access • Nakshtralogy Labs • 34 min ago", right: "+₹4,999" },
  { icon: "↺", tone: "bg-amber-500/15 text-amber-400", title: "Refund requested", meta: "Order #48213 • 51 min ago", chip: "PENDING" },
];

const APPROVALS = [
  { icon: ShieldAlert, label: "KYC Documents", count: 37, priority: "high", to: "/admin/kyc" },
  { icon: Wallet, label: "Withdrawal Requests", count: 12, priority: "high", to: "/admin/wallet" },
  { icon: MessageSquareWarning, label: "Reported Reviews", count: 5, priority: "medium", to: "/admin/reviews" },
  { icon: UserCog, label: "Astrologer Applications", count: 9, priority: "medium", to: "/admin/astrologers" },
  { icon: RotateCcw, label: "Refund Requests", count: 3, priority: "low", to: "/admin/wallet" },
];

const PRIORITY_TONE: Record<string, string> = {
  high: "bg-rose-500/15 text-rose-400",
  medium: "bg-amber-500/15 text-amber-400",
  low: "bg-emerald-500/15 text-emerald-400",
};

const NOTIFICATIONS = [
  { title: "New astrologer application", meta: "Dr. Meera Joshi applied for verification", time: "5m ago", unread: true },
  { title: "High-value withdrawal requested", meta: "₹18,500 · Astrologer Rajesh K.", time: "22m ago", unread: true },
  { title: "Weekly revenue report ready", meta: "Auto-generated analytics report for this week", time: "1h ago", unread: true },
  { title: "System backup completed", meta: "Nightly database backup finished successfully", time: "3h ago", unread: false },
  { title: "API rate-limit warning", meta: "Developer 'astro-labs' nearing plan quota", time: "5h ago", unread: false },
];

export default function DashboardOverview() {
  const { user } = useAuth();
  const [revenueFilter, setRevenueFilter] = useState<RevenueFilter>("Month");
  const revenue = REVENUE_BY_FILTER[revenueFilter];
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold">Good evening, {user?.name?.split(" ")[0] || "Admin"} ✨</h1>
        <p className="mt-0.5 text-sm text-muted-foreground">Here's what's happening across Nakshtralogy today.</p>
      </div>

      {/* Stat cards */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatCard label="Total Revenue" value={1840000} format={(n) => `₹${(n / 100000).toFixed(1)}L`} icon={<IndianRupee className="h-[17px] w-[17px]" />} tone="gold" trend={12.4} trendLabel="vs last month" spark={spark(1)} delay={0} />
        <StatCard label="Today's Revenue" value={64200} format={(n) => `₹${Math.round(n).toLocaleString()}`} icon={<TrendingUp className="h-[17px] w-[17px]" />} tone="green" trend={8.1} trendLabel="today" spark={spark(3)} delay={0.05} />
        <StatCard label="Total Users" value={42318} icon={<Users className="h-[17px] w-[17px]" />} tone="purple" trend={3.9} trendLabel="this week" spark={spark(5)} delay={0.1} />
        <StatCard label="Live Consultations" value={128} icon={<MessageSquare className="h-[17px] w-[17px]" />} tone="teal" trend={22} trendLabel="now live" spark={spark(2)} delay={0.15} />
        <StatCard label="Active Astrologers" value={1204} icon={<Star className="h-[17px] w-[17px]" />} tone="gold" trend={5} trendLabel="online now" spark={spark(4)} delay={0.2} />
        <StatCard label="Pending KYC" value={37} icon={<ShieldAlert className="h-[17px] w-[17px]" />} tone="amber" trend={9} trendLabel="need review" spark={spark(6)} delay={0.25} />
        <StatCard label="API Requests (24h)" value={312000} format={(n) => `${Math.round(n / 1000)}K`} icon={<Server className="h-[17px] w-[17px]" />} tone="purple" trend={14.7} trendLabel="" spark={spark(7)} delay={0.3} />
        <StatCard label="Subscription MRR" value={210000} format={(n) => `₹${(n / 100000).toFixed(1)}L`} icon={<Repeat className="h-[17px] w-[17px]" />} tone="green" trend={6.2} trendLabel="" spark={spark(8)} delay={0.35} />
      </div>

      {/* Quick actions */}
      <div className="flex flex-wrap gap-2.5">
        {QUICK.map((q) => (
          <Link key={q.label} to={q.to} className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
            <q.icon className="h-[15px] w-[15px] text-gold" />{q.label}
          </Link>
        ))}
      </div>

      {/* Revenue + live status */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Revenue Analytics" action={
          <div className="flex gap-1.5 text-[11px]">
            {(["Today", "Week", "Month", "Year"] as RevenueFilter[]).map((f) => (
              <button
                key={f}
                onClick={() => setRevenueFilter(f)}
                className={f === revenueFilter ? "rounded-lg bg-gold px-2.5 py-1 font-bold text-primary-foreground" : "rounded-lg border border-border/70 px-2.5 py-1 text-muted-foreground hover:text-foreground"}
              >
                {f}
              </button>
            ))}
          </div>
        }>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={revenue}>
              <defs><linearGradient id="rg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="hsl(var(--gold))" stopOpacity={0.35} /><stop offset="1" stopColor="hsl(var(--gold))" stopOpacity={0} /></linearGradient></defs>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--gold) / 0.08)" />
              <XAxis dataKey="d" tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} width={28} />
              <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} />
              <Area type="monotone" dataKey="revenue" stroke="hsl(var(--gold))" strokeWidth={2.5} fill="url(#rg)" />
              <Line type="monotone" dataKey="commission" stroke="hsl(var(--cosmic))" strokeWidth={2} strokeDasharray="4 4" dot={false} />
            </AreaChart>
          </ResponsiveContainer>
        </GlassPanel>

        <GlassPanel title="Live Platform Status" action={<span className="text-[11px] text-emerald-400">● All systems normal</span>}>
          <StatusRow name="API Server" status="ok" meta="42 ms" />
          <StatusRow name="Database" status="ok" meta="11 ms" />
          <StatusRow name="Redis Cache" status="ok" meta="3 ms" />
          <StatusRow name="Agora RTC" status="warn" meta="210 ms" />
          <StatusRow name="WebSocket" status="ok" meta="28 ms" />
          <StatusRow name="Payment Gateway" status="ok" meta="96 ms" />
          <StatusRow name="Email Service" status="down" meta="timeout" />
          <StatusRow name="Queue Workers" status="ok" meta="5 active" />
        </GlassPanel>
      </div>

      {/* Pending approvals + system health */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Pending Approvals" action={<span className="text-[11px] font-semibold text-gold">{APPROVALS.reduce((s, a) => s + a.count, 0)} total</span>}>
          <div className="space-y-2">
            {APPROVALS.map((a) => (
              <div key={a.label} className="flex items-center gap-3 rounded-xl border border-border/50 bg-glass/30 px-3 py-2.5">
                <div className="grid h-9 w-9 flex-none place-items-center rounded-xl bg-gold/10 text-gold"><a.icon className="h-[16px] w-[16px]" /></div>
                <div className="min-w-0 flex-1">
                  <b className="block text-[13px]">{a.label}</b>
                  <span className={`inline-block rounded-md px-1.5 py-0.5 text-[10px] font-bold uppercase ${PRIORITY_TONE[a.priority]}`}>{a.priority}</span>
                </div>
                <span className="text-[15px] font-extrabold text-gold">{a.count}</span>
                <div className="flex items-center gap-1">
                  <button title="Approve" className="grid h-7 w-7 place-items-center rounded-lg border border-emerald-500/40 text-emerald-400 hover:bg-emerald-500/10"><Check className="h-3.5 w-3.5" /></button>
                  <button title="Reject" className="grid h-7 w-7 place-items-center rounded-lg border border-rose-500/40 text-rose-400 hover:bg-rose-500/10"><XIcon className="h-3.5 w-3.5" /></button>
                  <Link to={a.to} title="View all" className="grid h-7 w-7 place-items-center rounded-lg border border-border/70 text-muted-foreground hover:text-foreground"><Eye className="h-3.5 w-3.5" /></Link>
                </div>
              </div>
            ))}
          </div>
        </GlassPanel>

        <GlassPanel title="System Health">
          <div className="grid grid-cols-4 gap-3">
            <Ring value={58} label="CPU" color="#4ecb8d" />
            <Ring value={69} label="RAM" color="#e8b547" />
            <Ring value={40} label="Disk" color="#4fb0c6" />
            <Ring value={99.6} label="Uptime" color="#4ecb8d" sub="99.6%" />
          </div>
          <div className="mt-4 border-t border-border/60 pt-2">
            <StatusRow name="API Latency (p95)" status="ok" meta="142 ms" />
            <StatusRow name="Success Rate" status="ok" meta="99.71%" />
            <StatusRow name="Errors (1h)" status="warn" meta="14" />
          </div>
        </GlassPanel>
      </div>

      {/* Activity + notifications */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Recent Activity" action={<span className="cursor-pointer text-[11px] font-semibold text-gold">View all</span>}>
          <div>
            {ACTIVITY.map((a, i) => (
              <div key={i} className="flex items-center gap-3 border-b border-border/40 py-2.5 last:border-0">
                <div className={`grid h-9 w-9 flex-none place-items-center rounded-xl text-sm ${a.tone}`}>{a.icon}</div>
                <div className="min-w-0 flex-1"><b className="block truncate text-[13px]">{a.title}</b><p className="text-[11.5px] text-muted-foreground">{a.meta}</p></div>
                {a.right && <span className="text-[13px] font-bold text-gold">{a.right}</span>}
                {a.chip && <span className={`rounded-md px-2 py-0.5 text-[10px] font-bold ${a.chip === "PENDING" ? "bg-amber-500/15 text-amber-400" : "bg-emerald-500/15 text-emerald-400"}`}>{a.chip}</span>}
              </div>
            ))}
          </div>
        </GlassPanel>

        <GlassPanel title="Notification Center" action={<span className="rounded-md bg-rose-500/15 px-2 py-0.5 text-[10px] font-bold text-rose-400">{NOTIFICATIONS.filter((n) => n.unread).length} new</span>}>
          <div>
            {NOTIFICATIONS.map((n, i) => (
              <div key={i} className="flex items-start gap-2.5 border-b border-border/40 py-2.5 last:border-0">
                <span className={`mt-1 h-1.5 w-1.5 flex-none rounded-full ${n.unread ? "bg-gold" : "bg-transparent"}`} />
                <div className="min-w-0 flex-1">
                  <b className="block text-[12.5px]">{n.title}</b>
                  <p className="text-[11px] text-muted-foreground">{n.meta}</p>
                </div>
                <span className="flex-none whitespace-nowrap text-[10.5px] text-muted-foreground">{n.time}</span>
              </div>
            ))}
          </div>
        </GlassPanel>
      </div>

      <p className="flex items-center gap-1.5 pt-1 text-center text-[11px] text-muted-foreground">
        <ArrowUpRight className="h-3.5 w-3.5" /> Live counters above illustrate layout; wire real endpoints as the platform grows.
      </p>
    </div>
  );
}
