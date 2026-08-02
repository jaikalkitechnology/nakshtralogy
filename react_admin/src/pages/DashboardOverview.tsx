import {
  IndianRupee, TrendingUp, Users, MessageSquare, Star, ShieldAlert, Server,
  Repeat, CheckCircle2, UserPlus, Ticket, CreditCard, Bell, FileText, RefreshCw,
  Database, Play, ArrowUpRight,
} from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from "recharts";
import { useAuth } from "@/contexts/AuthContext";
import StatCard from "@/components/premium/StatCard";
import GlassPanel from "@/components/premium/GlassPanel";
import Ring from "@/components/premium/Ring";
import StatusRow from "@/components/premium/StatusRow";

const spark = (seed: number) => Array.from({ length: 10 }, (_, i) => Math.sin(i + seed) * 4 + i * 1.2 + seed);
const revenue = Array.from({ length: 14 }, (_, i) => ({ d: `${i + 1}`, revenue: 40 + i * 6 + Math.sin(i) * 8, commission: 20 + i * 3 }));

const QUICK = [
  { icon: CheckCircle2, label: "Approve KYC" }, { icon: UserPlus, label: "Add Astrologer" },
  { icon: Ticket, label: "Create Coupon" }, { icon: CreditCard, label: "Create Pricing" },
  { icon: Bell, label: "Send Notification" }, { icon: FileText, label: "Generate Report" },
  { icon: RefreshCw, label: "Refresh Cache" }, { icon: Database, label: "Backup DB" }, { icon: Play, label: "API Playground" },
];

const ACTIVITY = [
  { icon: "₹", tone: "bg-emerald-500/15 text-emerald-400", title: "Wallet credited — Priya S.", meta: "Razorpay top-up • 2 min ago", right: "+₹2,000" },
  { icon: "🎥", tone: "bg-cyan-500/15 text-cyan-400", title: "Video consultation completed", meta: "Astrologer Rajesh • 8 min ago", chip: "DONE" },
  { icon: "✓", tone: "bg-gold/15 text-gold", title: "KYC approved — Kavita D.", meta: "Documents verified • 21 min ago", chip: "APPROVED" },
  { icon: "◆", tone: "bg-cosmic/15 text-cosmic-light", title: "Subscription purchased", meta: "All-Access • Nakshtralogy Labs • 34 min ago", right: "+₹4,999" },
  { icon: "↺", tone: "bg-amber-500/15 text-amber-400", title: "Refund requested", meta: "Order #48213 • 51 min ago", chip: "PENDING" },
];

export default function DashboardOverview() {
  const { user } = useAuth();
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
          <button key={q.label} className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
            <q.icon className="h-[15px] w-[15px] text-gold" />{q.label}
          </button>
        ))}
      </div>

      {/* Revenue + live status */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Revenue Analytics" action={
          <div className="flex gap-1.5 text-[11px] text-muted-foreground">
            {["Today", "Week", "Month", "Year"].map((f) => (
              <span key={f} className={f === "Month" ? "rounded-lg bg-gold px-2.5 py-1 font-bold text-primary-foreground" : "rounded-lg border border-border/70 px-2.5 py-1"}>{f}</span>
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

      {/* Activity + health */}
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

      <p className="flex items-center gap-1.5 pt-1 text-center text-[11px] text-muted-foreground">
        <ArrowUpRight className="h-3.5 w-3.5" /> Preview of the redesigned Admin dashboard — feature screens are being migrated into this shell.
      </p>
    </div>
  );
}
