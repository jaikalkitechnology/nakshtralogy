import { useEffect, useState } from "react";
import { BarChart3, Users, Star, MessageSquare, TrendingUp } from "lucide-react";
import {
  AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend,
} from "recharts";
import { adminStats, adminAnalyticsOverview } from "@/services/api";
import GlassPanel from "@/components/premium/GlassPanel";
import StatCard from "@/components/premium/StatCard";

type RangeFilter = "Today" | "Week" | "Month" | "Year";
const RANGE_MAP: Record<RangeFilter, "today" | "week" | "month" | "year"> = {
  Today: "today", Week: "week", Month: "month", Year: "year",
};

const STATUS_COLORS: Record<string, string> = {
  completed: "bg-green-500", pending: "bg-yellow-500", ongoing: "bg-cyan-500",
  cancelled: "bg-destructive", expired: "bg-muted-foreground",
};
const TYPE_COLORS: Record<string, string> = { chat: "bg-cyan-500", call: "bg-gold", video: "bg-cosmic" };

function DistributionBar({ data, colors }: { data: Record<string, number>; colors: Record<string, string> }) {
  const entries = Object.entries(data || {});
  const total = entries.reduce((s, [, v]) => s + v, 0) || 1;
  if (entries.length === 0) {
    return <p className="py-4 text-center text-xs text-muted-foreground">No data yet.</p>;
  }
  return (
    <div className="space-y-2.5">
      {entries.map(([key, count]) => {
        const pct = Math.round((count / total) * 100);
        return (
          <div key={key}>
            <div className="flex justify-between text-xs mb-1">
              <span className="capitalize text-foreground">{key}</span>
              <span className="text-muted-foreground">{count} · {pct}%</span>
            </div>
            <div className="h-2 w-full rounded-full bg-muted overflow-hidden">
              <div className={`h-full rounded-full ${colors[key] || "bg-primary"}`} style={{ width: `${pct}%` }} />
            </div>
          </div>
        );
      })}
    </div>
  );
}

export default function Analytics() {
  const [range, setRange] = useState<RangeFilter>("Month");
  const [stats, setStats] = useState<any>(null);
  const [overview, setOverview] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let alive = true;
    adminStats().then((r) => { if (alive) setStats(r?.data ?? r ?? null); }).catch(() => {});
    return () => { alive = false; };
  }, []);

  useEffect(() => {
    let alive = true;
    setLoading(true);
    adminAnalyticsOverview(RANGE_MAP[range])
      .then((r) => { if (alive) setOverview(r?.data ?? r ?? null); })
      .catch(() => { if (alive) setOverview(null); })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [range]);

  const s = stats || {};
  const o = overview || {};
  const userGrowth = o.user_growth || [];
  const consultVolume = o.consultation_volume || [];
  const topAstrologers = o.top_astrologers || [];

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex items-center gap-2">
          <BarChart3 className="w-5 h-5 text-primary" />
          <h1 className="text-xl font-display text-gold-gradient">Analytics</h1>
        </div>
        <div className="flex gap-1.5 text-[11px]">
          {(["Today", "Week", "Month", "Year"] as RangeFilter[]).map((f) => (
            <button
              key={f}
              onClick={() => setRange(f)}
              className={f === range ? "rounded-lg bg-gold px-2.5 py-1 font-bold text-primary-foreground" : "rounded-lg border border-border/70 px-2.5 py-1 text-muted-foreground hover:text-foreground"}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      {/* Headline KPIs — all-time, from /admin/stats */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatCard label="Total Users" value={Number(s.total_users) || 0} icon={<Users className="h-[17px] w-[17px]" />} tone="purple" trendLabel="active accounts" delay={0} />
        <StatCard label="Total Astrologers" value={Number(s.total_astrologers) || 0} icon={<Star className="h-[17px] w-[17px]" />} tone="gold" trendLabel="on platform" delay={0.05} />
        <StatCard label="Live Consultations" value={Number(s.active_sessions) || 0} icon={<MessageSquare className="h-[17px] w-[17px]" />} tone="teal" trendLabel="right now" delay={0.1} />
        <StatCard label="Total Revenue" value={Number(s.total_revenue) || 0} format={(n) => `₹${Math.round(n).toLocaleString()}`} icon={<TrendingUp className="h-[17px] w-[17px]" />} tone="green" trendLabel="all time" delay={0.15} />
      </div>

      {/* Growth + volume trends for the selected range */}
      <div className="grid gap-4 lg:grid-cols-2">
        <GlassPanel title="User Growth">
          {loading ? (
            <div className="grid h-[200px] place-items-center text-xs text-muted-foreground">Loading…</div>
          ) : userGrowth.length === 0 ? (
            <div className="grid h-[200px] place-items-center text-xs text-muted-foreground">No signups in this period.</div>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <AreaChart data={userGrowth}>
                <defs>
                  <linearGradient id="ug" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="hsl(var(--cosmic))" stopOpacity={0.4} /><stop offset="1" stopColor="hsl(var(--cosmic))" stopOpacity={0} /></linearGradient>
                  <linearGradient id="ag" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stopColor="hsl(var(--gold))" stopOpacity={0.4} /><stop offset="1" stopColor="hsl(var(--gold))" stopOpacity={0} /></linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--gold) / 0.08)" />
                <XAxis dataKey="d" tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} width={28} allowDecimals={false} />
                <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} />
                <Legend wrapperStyle={{ fontSize: 11 }} />
                <Area type="monotone" dataKey="users" name="Users" stroke="hsl(var(--cosmic))" strokeWidth={2} fill="url(#ug)" />
                <Area type="monotone" dataKey="astrologers" name="Astrologers" stroke="hsl(var(--gold))" strokeWidth={2} fill="url(#ag)" />
              </AreaChart>
            </ResponsiveContainer>
          )}
        </GlassPanel>

        <GlassPanel title="Consultation Volume">
          {loading ? (
            <div className="grid h-[200px] place-items-center text-xs text-muted-foreground">Loading…</div>
          ) : consultVolume.length === 0 ? (
            <div className="grid h-[200px] place-items-center text-xs text-muted-foreground">No consultations in this period.</div>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={consultVolume}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--gold) / 0.08)" />
                <XAxis dataKey="d" tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} width={28} allowDecimals={false} />
                <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} />
                <Bar dataKey="count" name="Sessions" fill="hsl(var(--gold))" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </GlassPanel>
      </div>

      {/* All-time distributions + leaderboard */}
      <div className="grid gap-4 lg:grid-cols-3">
        <GlassPanel title="Consultation Status (all time)">
          <DistributionBar data={o.consultation_status || {}} colors={STATUS_COLORS} />
        </GlassPanel>
        <GlassPanel title="Session Type (all time)">
          <DistributionBar data={o.consultation_type || {}} colors={TYPE_COLORS} />
        </GlassPanel>
        <GlassPanel title="Top Astrologers">
          {topAstrologers.length === 0 ? (
            <p className="py-4 text-center text-xs text-muted-foreground">No data yet.</p>
          ) : (
            <div className="space-y-2">
              {topAstrologers.map((a: any, i: number) => (
                <div key={a.id} className="flex items-center gap-2.5 text-sm">
                  <span className="w-5 text-center font-bold text-gold">{i + 1}</span>
                  <div className="min-w-0 flex-1">
                    <p className="truncate font-medium text-foreground">{a.display_name || "—"}</p>
                    <p className="text-[11px] text-muted-foreground">⭐ {a.rating} · {a.total_consultations} sessions</p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </GlassPanel>
      </div>
    </div>
  );
}
