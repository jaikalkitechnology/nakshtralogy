import { useState, useEffect, useCallback } from "react";
import { Link } from "react-router-dom";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import {
  LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid,
  Tooltip as RTooltip, ResponsiveContainer, Legend,
} from "recharts";
import {
  PhoneCall, AlertTriangle, Gauge, Wallet, CreditCard, RefreshCw, Zap,
  Webhook, Download, Tag, TrendingUp, KeyRound, BookOpen, ArrowUpRight,
} from "lucide-react";
import StatCard from "@/components/premium/StatCard";
import GlassPanel from "@/components/premium/GlassPanel";
import StatusRow from "@/components/premium/StatusRow";
import { useAuth } from "@/contexts/AuthContext";
import { getUsageSummary } from "@/lib/api";

const COLORS = ["#d4af37", "#8a6fd6", "#4fb0c6", "#e07a5f"];
const spark = (seed: number) => Array.from({ length: 10 }, (_, i) => Math.sin(i + seed) * 4 + i * 1.2 + seed);

export default function DashboardPage() {
  const { developer } = useAuth();
  const [summary, setSummary] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const { ok, data } = await getUsageSummary(30);
      if (!ok) throw new Error(data?.detail || "Failed to load usage summary");
      setSummary(data);
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const kpis = summary?.kpis || {};
  const successRate = kpis.total_calls ? Math.max(0, 100 - (100 * (kpis.total_errors || 0)) / kpis.total_calls) : 100;
  const sub = developer?.subscription;

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <h1 className="text-2xl font-extrabold">Welcome back, {developer?.profile?.company_name || developer?.name || "Developer"} ⚡</h1>
          <p className="mt-0.5 text-sm text-muted-foreground">Last 30 days of gateway activity for your account.</p>
        </div>
        <Button variant="outline" size="icon" onClick={load} title="Refresh"><RefreshCw className="h-4 w-4" /></Button>
      </div>

      {error && (
        <div className="flex items-center justify-between rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
          <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
          <Button size="sm" variant="outline" onClick={load}>Retry</Button>
        </div>
      )}

      {/* Stripe-like KPI grid — real numbers from /developer/usage/summary + /developer/me */}
      {loading ? (
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          {Array.from({ length: 8 }).map((_, i) => <Skeleton key={i} className="h-28 rounded-2xl" />)}
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          <StatCard label="API Calls (30d)" value={kpis.total_calls ?? 0} icon={<PhoneCall className="h-[17px] w-[17px]" />} tone="gold" spark={spark(1)} />
          <StatCard label="Success Rate" value={successRate} format={(n) => `${n.toFixed(2)}%`} icon={<TrendingUp className="h-[17px] w-[17px]" />} tone="green" spark={spark(2)} />
          <StatCard label="Avg Latency" value={kpis.avg_latency_ms ?? 0} suffix=" ms" icon={<Gauge className="h-[17px] w-[17px]" />} tone="teal" spark={spark(3)} />
          <StatCard label="Errors (30d)" value={kpis.total_errors ?? 0} icon={<AlertTriangle className="h-[17px] w-[17px]" />} tone="red" spark={spark(4)} />
          <StatCard label="Wallet Balance" value={Math.round(developer?.wallet_balance ?? 0)} prefix="₹" icon={<Wallet className="h-[17px] w-[17px]" />} tone="purple" spark={spark(5)} />
          <StatCard label="TPS Limit" value={sub?.tps_limit ?? 0} suffix=" req/s" icon={<Zap className="h-[17px] w-[17px]" />} tone="amber" spark={spark(6)} />
          <StatCard label="Plan" value={0} format={() => sub?.plan_name || "No plan"} icon={<CreditCard className="h-[17px] w-[17px]" />} tone="gold" />
          <StatCard label="Monthly Calls Used" value={kpis.total_calls ?? 0} icon={<Tag className="h-[17px] w-[17px]" />} tone="purple" spark={spark(7)} />
        </div>
      )}

      <div className="flex flex-wrap gap-2.5">
        <Link to="/keys" className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
          <KeyRound className="h-[15px] w-[15px] text-gold" /> Manage API Keys
        </Link>
        <Link to="/docs" className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
          <BookOpen className="h-[15px] w-[15px] text-gold" /> Open Playground
        </Link>
        <Link to="/subscription" className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
          <CreditCard className="h-[15px] w-[15px] text-gold" /> Upgrade Plan
        </Link>
        <Link to="/wallet" className="lift flex items-center gap-2 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2.5 text-[12.5px] font-semibold text-foreground">
          <Wallet className="h-[15px] w-[15px] text-gold" /> Recharge Wallet
        </Link>
      </div>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-base">Subscription</CardTitle>
          <CreditCard className="h-5 w-5 text-primary" />
        </CardHeader>
        <CardContent>
          {sub ? (
            <div className="grid grid-cols-2 gap-4 text-sm md:grid-cols-4">
              <div><p className="text-muted-foreground">Plan</p><p className="font-medium">{sub.plan_name}</p></div>
              <div><p className="text-muted-foreground">Status</p><p className="font-medium capitalize">{sub.status}</p></div>
              <div><p className="text-muted-foreground">TPS limit</p><p className="font-medium">{sub.tps_limit}</p></div>
              <div>
                <p className="text-muted-foreground">Expires</p>
                <p className="font-medium">{sub.expires_at ? new Date(sub.expires_at).toLocaleDateString() : "—"}</p>
              </div>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">
              No active subscription. Head to the <Link to="/subscription" className="text-primary hover:underline">Subscription</Link> tab to get started.
            </p>
          )}
        </CardContent>
      </Card>

      <div className="grid gap-4 lg:grid-cols-2">
        <GlassPanel title="Calls per day">
          <ResponsiveContainer width="100%" height={220}>
            <LineChart data={summary?.calls_by_day || []}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--gold) / 0.08)" />
              <XAxis dataKey="date" tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: "hsl(var(--muted-foreground))" }} axisLine={false} tickLine={false} width={28} />
              <RTooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} />
              <Line type="monotone" dataKey="calls" stroke="hsl(var(--gold))" strokeWidth={2.5} dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </GlassPanel>

        <GlassPanel title="Product mix">
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <Pie data={summary?.product_mix || []} dataKey="calls" nameKey="product" outerRadius={80} label>
                {(summary?.product_mix || []).map((_: any, i: number) => (
                  <Cell key={i} fill={COLORS[i % COLORS.length]} />
                ))}
              </Pie>
              <RTooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: 12 }} />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </GlassPanel>
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <GlassPanel title="Platform status">
          <StatusRow name="Gateway (/api/v2)" status="ok" meta="live" />
          <StatusRow name="Webhooks" status="warn" meta="not configured" />
          <StatusRow name="API version" status="ok" meta="v2 (current)" />
          <StatusRow name="SDKs" status="ok" meta="curl · Python · Node · PHP" />
        </GlassPanel>

        <GlassPanel title="Get started">
          <div className="space-y-2.5 text-[13px]">
            <p className="flex items-center gap-2 text-muted-foreground"><Webhook className="h-4 w-4 text-gold" /> Webhooks are not configured yet — add an endpoint from API Keys once available.</p>
            <p className="flex items-center gap-2 text-muted-foreground"><Download className="h-4 w-4 text-gold" /> No official SDK packages yet — copyable curl/Python/Node/PHP samples are in the Docs & Playground tab.</p>
            <p className="flex items-center gap-2 text-muted-foreground"><ArrowUpRight className="h-4 w-4 text-gold" /> Gateway is on API version <b className="text-foreground">v2</b> (/api/v2), covering Kundli, Reports, Rashi and Forecast.</p>
          </div>
        </GlassPanel>
      </div>
    </div>
  );
}
