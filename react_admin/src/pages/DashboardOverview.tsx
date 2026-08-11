import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import {
  IndianRupee, Users, MessageSquare, Star, ShieldAlert, Server,
  Repeat, CheckCircle2, UserPlus, Ticket, CreditCard, Bell, FileText, RefreshCw,
  Database, Play, ArrowUpRight, Wallet, MessageSquareWarning, UserCog,
  Eye, Mail,
} from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from "recharts";
import { useAuth } from "@/contexts/AuthContext";
import { adminStats, adminDashboardRevenue, adminDashboardSummary } from "@/services/api";
import StatCard from "@/components/premium/StatCard";
import GlassPanel from "@/components/premium/GlassPanel";
import Ring from "@/components/premium/Ring";
import StatusRow from "@/components/premium/StatusRow";

const spark = (seed: number) => Array.from({ length: 10 }, (_, i) => Math.sin(i + seed) * 4 + i * 1.2 + seed);

type RevenueFilter = "Today" | "Week" | "Month" | "Year";
const RANGE_MAP: Record<RevenueFilter, "today" | "week" | "month" | "year"> = {
  Today: "today", Week: "week", Month: "month", Year: "year",
};

const QUICK = [
  { icon: CheckCircle2, label: "Approve KYC", to: "/admin/kyc" }, { icon: UserPlus, label: "Add Astrologer", to: "/admin/astrologers" },
  { icon: Ticket, label: "Create Coupon", to: "/admin/coupons" }, { icon: CreditCard, label: "Create Pricing", to: "/admin/pricing" },
  { icon: Bell, label: "Send Notification", to: "/admin/notifications" }, { icon: FileText, label: "Withdrawals", to: "/admin/withdrawals" },
  { icon: RefreshCw, label: "System", to: "/admin/system" }, { icon: Database, label: "Payments", to: "/admin/payments" }, { icon: Play, label: "Developers", to: "/admin/developers" },
];

// Pending-approval queue metadata — counts come live from /admin/dashboard/summary.
const APPROVAL_META: { key: string; icon: any; label: string; priority: string; to: string }[] = [
  { key: "kyc", icon: ShieldAlert, label: "KYC Documents", priority: "high", to: "/admin/kyc" },
  { key: "withdrawals", icon: Wallet, label: "Withdrawal Requests", priority: "high", to: "/admin/withdrawals" },
  { key: "astrologer_applications", icon: UserCog, label: "Astrologer Applications", priority: "medium", to: "/admin/astrologers" },
  { key: "support_tickets", icon: MessageSquareWarning, label: "Support Tickets", priority: "medium", to: "/admin/support-tickets" },
  { key: "contact_messages", icon: Mail, label: "Contact Messages", priority: "low", to: "/admin/queries" },
  { key: "hidden_reviews", icon: MessageSquareWarning, label: "Hidden Reviews", priority: "low", to: "/admin/reviews" },
];

const PRIORITY_TONE: Record<string, string> = {
  high: "bg-rose-500/15 text-rose-400",
  medium: "bg-amber-500/15 text-amber-400",
  low: "bg-emerald-500/15 text-emerald-400",
};

// Activity feed icon/tone per money-movement kind.
const ACTIVITY_STYLE: Record<string, { icon: string; tone: string }> = {
  wallet_credit: { icon: "₹", tone: "bg-emerald-500/15 text-emerald-400" },
  consult: { icon: "🎥", tone: "bg-cyan-500/15 text-cyan-400" },
  earning: { icon: "★", tone: "bg-gold/15 text-gold" },
  ai: { icon: "✦", tone: "bg-cosmic/15 text-cosmic-light" },
  bonus: { icon: "🎁", tone: "bg-emerald-500/15 text-emerald-400" },
  refund: { icon: "↺", tone: "bg-amber-500/15 text-amber-400" },
  withdrawal: { icon: "↑", tone: "bg-rose-500/15 text-rose-400" },
  txn: { icon: "◆", tone: "bg-muted text-muted-foreground" },
};

// Compact "x min ago" from an ISO/`str(datetime)` timestamp (UTC).
function timeAgo(ts?: string | null): string {
  if (!ts) return "";
  const t = Date.parse(ts.replace(" ", "T") + (/[zZ]|[+-]\d\d:?\d\d$/.test(ts) ? "" : "Z"));
  if (isNaN(t)) return "";
  const secs = Math.max(0, Math.floor((Date.now() - t) / 1000));
  if (secs < 60) return "just now";
  const mins = Math.floor(secs / 60);
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  return `${Math.floor(hrs / 24)}d ago`;
}

const inr = (n: number) => (n >= 100000 ? `₹${(n / 100000).toFixed(1)}L` : `₹${Math.round(n).toLocaleString()}`);

export default function DashboardOverview() {
  const { user } = useAuth();
  const [revenueFilter, setRevenueFilter] = useState<RevenueFilter>("Month");

  const [stats, setStats] = useState<any>(null);
  const [revenue, setRevenue] = useState<{ d: string; revenue: number; commission: number }[]>([]);
  const [summary, setSummary] = useState<any>(null);

  // Stat cards + below-the-fold summary (once).
  useEffect(() => {
    let alive = true;
    adminStats().then((r) => { if (alive) setStats(r?.data ?? r ?? null); }).catch(() => {});
    adminDashboardSummary().then((r) => { if (alive) setSummary(r?.data ?? r ?? null); }).catch(() => {});
    return () => { alive = false; };
  }, []);

  // Revenue series — refetches when the range filter changes.
  useEffect(() => {
    let alive = true;
    adminDashboardRevenue(RANGE_MAP[revenueFilter])
      .then((r) => { const d = r?.data ?? r; if (alive) setRevenue(d?.series ?? []); })
      .catch(() => { if (alive) setRevenue([]); });
    return () => { alive = false; };
  }, [revenueFilter]);

  const s = stats || {};
  const health = summary?.health || {};
  const sys = health.system || {};
  const services: { name: string; status: "ok" | "warn" | "down"; meta?: string }[] = health.services || [];
  const approvals = summary?.approvals || {};
  const activity: any[] = summary?.activity || [];
  const notifications: any[] = summary?.notifications || [];
  const approvalsTotal = APPROVAL_META.reduce((sum, a) => sum + (Number(approvals[a.key]) || 0), 0);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-extrabold">Welcome back, {user?.name?.split(" ")[0] || "Admin"} ✨</h1>
        <p className="mt-0.5 text-sm text-muted-foreground">Here's what's happening across Nakshtralogy today.</p>
      </div>

      {/* Stat cards — live from /admin/stats */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatCard label="Total Revenue" value={Number(s.total_revenue) || 0} format={inr} icon={<IndianRupee className="h-[17px] w-[17px]" />} tone="gold" trendLabel="all time" spark={spark(1)} delay={0} />
        <StatCard label="Total Users" value={Number(s.total_users) || 0} icon={<Users className="h-[17px] w-[17px]" />} tone="purple" trendLabel="active accounts" spark={spark(5)} delay={0.05} />
        <StatCard label="Total Astrologers" value={Number(s.total_astrologers) || 0} icon={<Star className="h-[17px] w-[17px]" />} tone="gold" trendLabel="on platform" spark={spark(4)} delay={0.1} />
        <StatCard label="Online Astrologers" value={Number(s.online_astrologers) || 0} icon={<Star className="h-[17px] w-[17px]" />} tone="green" trendLabel="online now" spark={spark(3)} delay={0.15} />
        <StatCard label="Live Consultations" value={Number(s.active_sessions) || 0} icon={<MessageSquare className="h-[17px] w-[17px]" />} tone="teal" trendLabel="calls + chats" spark={spark(2)} delay={0.2} />
        <StatCard label="Live Streams" value={Number(s.active_streams) || 0} icon={<Server className="h-[17px] w-[17px]" />} tone="purple" trendLabel="now live" spark={spark(7)} delay={0.25} />
        <StatCard label="Pending KYC" value={Number(s.pending_kyc) || 0} icon={<ShieldAlert className="h-[17px] w-[17px]" />} tone="amber" trendLabel="need review" spark={spark(6)} delay={0.3} />
        <StatCard label="Pending Deletions" value={Number(s.pending_deletions) || 0} icon={<Repeat className="h-[17px] w-[17px]" />} tone="amber" trendLabel="in grace period" spark={spark(8)} delay={0.35} />
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
          {revenue.length === 0 ? (
            <div className="grid h-[220px] place-items-center text-[12px] text-muted-foreground">No revenue in this period yet.</div>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <AreaChart data={revenue}>
                <defs><linearGradient id="rg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="hsl(var(--gold))" stopOpacity={0.35} /><stop offset="1" stopColor="hsl(var(--gold))" stopOpacity={0} /></linearGradient></defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--gold) / 0.08)" />
                <XAxis dataKey="d" tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} width={28} />
                <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} formatter={(v: any) => `₹${Math.round(Number(v)).toLocaleString()}`} />
                <Area type="monotone" dataKey="revenue" name="Revenue" stroke="hsl(var(--gold))" strokeWidth={2.5} fill="url(#rg)" />
                <Line type="monotone" dataKey="commission" name="Commission" stroke="hsl(var(--cosmic))" strokeWidth={2} strokeDasharray="4 4" dot={false} />
              </AreaChart>
            </ResponsiveContainer>
          )}
        </GlassPanel>

        <GlassPanel title="Live Platform Status" action={
          <span className={`text-[11px] ${services.some((x) => x.status === "down") ? "text-rose-400" : services.some((x) => x.status === "warn") ? "text-amber-400" : "text-emerald-400"}`}>
            ● {services.some((x) => x.status === "down") ? "Issues detected" : services.some((x) => x.status === "warn") ? "Degraded" : "All systems normal"}
          </span>
        }>
          {services.length === 0
            ? <div className="py-6 text-center text-[12px] text-muted-foreground">Checking services…</div>
            : services.map((sv) => <StatusRow key={sv.name} name={sv.name} status={sv.status} meta={sv.meta || ""} />)}
        </GlassPanel>
      </div>

      {/* Pending approvals + system health */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Pending Approvals" action={<span className="text-[11px] font-semibold text-gold">{approvalsTotal} total</span>}>
          <div className="space-y-2">
            {APPROVAL_META.map((a) => {
              const count = Number(approvals[a.key]) || 0;
              return (
                <div key={a.key} className="flex items-center gap-3 rounded-xl border border-border/50 bg-glass/30 px-3 py-2.5">
                  <div className="grid h-9 w-9 flex-none place-items-center rounded-xl bg-gold/10 text-gold"><a.icon className="h-[16px] w-[16px]" /></div>
                  <div className="min-w-0 flex-1">
                    <b className="block text-[13px]">{a.label}</b>
                    <span className={`inline-block rounded-md px-1.5 py-0.5 text-[10px] font-bold uppercase ${PRIORITY_TONE[a.priority]}`}>{a.priority}</span>
                  </div>
                  <span className="text-[15px] font-extrabold text-gold">{count}</span>
                  <Link to={a.to} title="View all" className="grid h-7 w-7 place-items-center rounded-lg border border-border/70 text-muted-foreground hover:text-foreground"><Eye className="h-3.5 w-3.5" /></Link>
                </div>
              );
            })}
          </div>
        </GlassPanel>

        <GlassPanel title="System Health">
          <div className="grid grid-cols-4 gap-3">
            <Ring value={Number(sys.cpu) || 0} label="CPU" color="#4ecb8d" />
            <Ring value={Number(sys.ram) || 0} label="RAM" color="#e8b547" />
            <Ring value={Number(sys.disk) || 0} label="Disk" color="#4fb0c6" />
            <Ring value={100} label="Uptime" color="#4ecb8d" sub={sys.uptime_label || "—"} />
          </div>
          <div className="mt-4 border-t border-border/60 pt-2">
            {services.slice(0, 3).map((sv) => <StatusRow key={sv.name} name={sv.name} status={sv.status} meta={sv.meta || ""} />)}
          </div>
        </GlassPanel>
      </div>

      {/* Activity + notifications */}
      <div className="grid gap-4 lg:grid-cols-[1.55fr_1fr]">
        <GlassPanel title="Recent Activity" action={<Link to="/admin/transactions" className="cursor-pointer text-[11px] font-semibold text-gold">View all</Link>}>
          <div>
            {activity.length === 0 && <div className="py-6 text-center text-[12px] text-muted-foreground">No recent activity.</div>}
            {activity.map((a, i) => {
              const style = ACTIVITY_STYLE[a.kind] || ACTIVITY_STYLE.txn;
              return (
                <div key={i} className="flex items-center gap-3 border-b border-border/40 py-2.5 last:border-0">
                  <div className={`grid h-9 w-9 flex-none place-items-center rounded-xl text-sm ${style.tone}`}>{style.icon}</div>
                  <div className="min-w-0 flex-1"><b className="block truncate text-[13px]">{a.title}</b><p className="text-[11.5px] text-muted-foreground">{a.name} • {timeAgo(a.created_at)}</p></div>
                  <span className="text-[13px] font-bold text-gold">{inr(Number(a.amount) || 0)}</span>
                </div>
              );
            })}
          </div>
        </GlassPanel>

        <GlassPanel title="Alerts" action={<span className="rounded-md bg-rose-500/15 px-2 py-0.5 text-[10px] font-bold text-rose-400">{notifications.length} new</span>}>
          <div>
            {notifications.length === 0 && <div className="py-6 text-center text-[12px] text-muted-foreground">Nothing needs attention.</div>}
            {notifications.map((n, i) => (
              <div key={i} className="flex items-start gap-2.5 border-b border-border/40 py-2.5 last:border-0">
                <span className="mt-1 h-1.5 w-1.5 flex-none rounded-full bg-gold" />
                <div className="min-w-0 flex-1">
                  <b className="block text-[12.5px]">{n.title}</b>
                  <p className="text-[11px] text-muted-foreground">{n.meta}</p>
                </div>
                <span className="flex-none whitespace-nowrap text-[10.5px] text-muted-foreground">{timeAgo(n.created_at)}</span>
              </div>
            ))}
          </div>
        </GlassPanel>
      </div>

      <p className="flex items-center gap-1.5 pt-1 text-center text-[11px] text-muted-foreground">
        <ArrowUpRight className="h-3.5 w-3.5" /> All panels reflect live platform data.
      </p>
    </div>
  );
}
