import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import {
  LineChart, Line, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid,
  Tooltip as RTooltip, ResponsiveContainer, Legend,
} from "recharts";
import {
  PhoneCall, AlertTriangle, Gauge, Wallet, CreditCard, RefreshCw,
} from "lucide-react";
import KpiCard from "@/components/KpiCard";
import { useAuth } from "@/contexts/AuthContext";
import { getUsageSummary } from "@/lib/api";

const COLORS = ["#d4af37", "#8a6fd6", "#4fb0c6", "#e07a5f"];

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

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Overview</h1>
          <p className="text-sm text-muted-foreground">Last 30 days of gateway activity for your account.</p>
        </div>
        <Button variant="outline" size="icon" onClick={load} title="Refresh"><RefreshCw className="h-4 w-4" /></Button>
      </div>

      {error && (
        <div className="flex items-center justify-between rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
          <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
          <Button size="sm" variant="outline" onClick={load}>Retry</Button>
        </div>
      )}

      {loading ? (
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          {Array.from({ length: 4 }).map((_, i) => <Skeleton key={i} className="h-24 rounded-xl" />)}
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          <KpiCard label="API Calls (30d)" value={kpis.total_calls ?? 0} icon={<PhoneCall className="h-5 w-5" />} />
          <KpiCard label="Errors (30d)" value={kpis.total_errors ?? 0} icon={<AlertTriangle className="h-5 w-5" />} tone="danger" />
          <KpiCard label="Avg Latency" value={kpis.avg_latency_ms ?? 0} suffix="ms" icon={<Gauge className="h-5 w-5" />} />
          <KpiCard label="Wallet Balance" value={Math.round(developer?.wallet_balance ?? 0)} prefix="₹" icon={<Wallet className="h-5 w-5" />} tone="success" />
        </div>
      )}

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-base">Subscription</CardTitle>
          <CreditCard className="h-5 w-5 text-primary" />
        </CardHeader>
        <CardContent>
          {developer?.subscription ? (
            <div className="grid grid-cols-2 gap-4 text-sm md:grid-cols-4">
              <div><p className="text-muted-foreground">Plan</p><p className="font-medium">{developer.subscription.plan_name}</p></div>
              <div><p className="text-muted-foreground">Status</p><p className="font-medium capitalize">{developer.subscription.status}</p></div>
              <div><p className="text-muted-foreground">TPS limit</p><p className="font-medium">{developer.subscription.tps_limit}</p></div>
              <div>
                <p className="text-muted-foreground">Expires</p>
                <p className="font-medium">{developer.subscription.expires_at ? new Date(developer.subscription.expires_at).toLocaleDateString() : "—"}</p>
              </div>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">No active subscription. Head to the Subscription tab to get started.</p>
          )}
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-2">
        <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
          <CardHeader><CardTitle className="text-base">Calls per day</CardTitle></CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={220}>
              <LineChart data={summary?.calls_by_day || []}>
                <CartesianGrid strokeDasharray="3 3" opacity={0.15} />
                <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                <YAxis tick={{ fontSize: 10 }} />
                <RTooltip />
                <Line type="monotone" dataKey="calls" stroke="#d4af37" strokeWidth={2} dot={false} />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
          <CardHeader><CardTitle className="text-base">Product mix</CardTitle></CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={220}>
              <PieChart>
                <Pie data={summary?.product_mix || []} dataKey="calls" nameKey="product" outerRadius={80} label>
                  {(summary?.product_mix || []).map((_: any, i: number) => (
                    <Cell key={i} fill={COLORS[i % COLORS.length]} />
                  ))}
                </Pie>
                <RTooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
