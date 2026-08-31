import * as React from "react";
import { useState, useEffect, useCallback, useRef } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  BarChart, Bar, LineChart, Line, PieChart, Pie, Cell,
  XAxis, YAxis, CartesianGrid, Tooltip as RTooltip, ResponsiveContainer, Legend,
} from "recharts";
import {
  Users2, PhoneCall, AlertTriangle, Gauge, IndianRupee, ShieldCheck, RefreshCw,
} from "lucide-react";
import { adminDeveloperAnalyticsOverview } from "@/services/api";

const COLORS = ["#d4af37", "#8a6fd6", "#4fb0c6", "#e07a5f", "#81b29a"];

function useCountUp(target: number, durationMs = 800) {
  const [value, setValue] = useState(0);
  const frame = useRef<number>();
  useEffect(() => {
    const start = performance.now();
    const from = 0;
    const animate = (now: number) => {
      const progress = Math.min(1, (now - start) / durationMs);
      setValue(Math.round(from + (target - from) * progress));
      if (progress < 1) frame.current = requestAnimationFrame(animate);
    };
    frame.current = requestAnimationFrame(animate);
    return () => { if (frame.current) cancelAnimationFrame(frame.current); };
  }, [target, durationMs]);
  return value;
}

function KpiCard({ label, value, icon, suffix = "" }: { label: string; value: number; icon: React.ReactNode; suffix?: string }) {
  const animated = useCountUp(value);
  return (
    <div className="rounded-2xl border border-border/60 bg-card/60 p-4 backdrop-blur transition-transform hover:-translate-y-0.5">
      <div className="mb-2 flex items-center justify-between">
        <span className="text-primary">{icon}</span>
      </div>
      <p className="text-2xl font-semibold text-foreground">{animated.toLocaleString()}{suffix}</p>
      <p className="text-xs text-muted-foreground">{label}</p>
    </div>
  );
}

export default function DeveloperAnalytics() {
  const [data, setData] = useState<any>(null);
  const [days, setDays] = useState("30");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const { ok, data: resp } = await adminDeveloperAnalyticsOverview(parseInt(days, 10));
      if (!ok) throw new Error(resp?.detail || "Failed to load analytics");
      setData(resp);
    } catch (e: any) {
      setError(e?.message || "Something went wrong while loading analytics.");
    } finally {
      setLoading(false);
    }
  }, [days]);

  useEffect(() => { load(); }, [load]);

  const kpis = data?.kpis || {};

  return (
    <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
      <CardHeader className="flex flex-row flex-wrap items-center justify-between gap-2">
        <CardTitle className="text-lg">Revenue &amp; Usage Analytics</CardTitle>
        <div className="flex items-center gap-2">
          <Select value={days} onValueChange={setDays}>
            <SelectTrigger className="w-32"><SelectValue /></SelectTrigger>
            <SelectContent>
              <SelectItem value="7">Last 7 days</SelectItem>
              <SelectItem value="30">Last 30 days</SelectItem>
              <SelectItem value="90">Last 90 days</SelectItem>
            </SelectContent>
          </Select>
          <Button variant="outline" size="icon" onClick={load} title="Refresh"><RefreshCw className="h-4 w-4" /></Button>
        </div>
      </CardHeader>
      <CardContent>
        {error && (
          <div className="mb-4 flex flex-wrap items-center justify-between gap-2 rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
            <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
            <Button size="sm" variant="outline" onClick={load}>Retry</Button>
          </div>
        )}

        {loading ? (
          <div className="grid grid-cols-2 gap-4 md:grid-cols-6">
            {Array.from({ length: 6 }).map((_, i) => <Skeleton key={i} className="h-24 rounded-xl" />)}
          </div>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-4 md:grid-cols-6">
              <KpiCard label="Developers" value={kpis.total_developers ?? 0} icon={<Users2 className="h-5 w-5" />} />
              <KpiCard label="Active Subscriptions" value={kpis.active_subscriptions ?? 0} icon={<ShieldCheck className="h-5 w-5" />} />
              <KpiCard label="API Calls" value={kpis.total_calls ?? 0} icon={<PhoneCall className="h-5 w-5" />} />
              <KpiCard label="Errors" value={kpis.total_errors ?? 0} icon={<AlertTriangle className="h-5 w-5" />} />
              <KpiCard label="Avg Latency" value={kpis.avg_latency_ms ?? 0} suffix="ms" icon={<Gauge className="h-5 w-5" />} />
              <KpiCard label="Revenue" value={Math.round(kpis.revenue ?? 0)} icon={<IndianRupee className="h-5 w-5" />} />
            </div>

            <div className="mt-6 grid gap-4 md:grid-cols-2">
              <div className="rounded-xl border border-border/60 p-4">
                <h4 className="mb-2 text-sm font-medium text-muted-foreground">Calls per day</h4>
                <ResponsiveContainer width="100%" height={220}>
                  <LineChart data={data?.calls_by_day || []}>
                    <CartesianGrid strokeDasharray="3 3" opacity={0.15} />
                    <XAxis dataKey="date" tick={{ fontSize: 10 }} />
                    <YAxis tick={{ fontSize: 10 }} />
                    <RTooltip />
                    <Line type="monotone" dataKey="calls" stroke="#d4af37" strokeWidth={2} dot={false} />
                  </LineChart>
                </ResponsiveContainer>
              </div>

              <div className="rounded-xl border border-border/60 p-4">
                <h4 className="mb-2 text-sm font-medium text-muted-foreground">Product mix</h4>
                <ResponsiveContainer width="100%" height={220}>
                  <PieChart>
                    <Pie data={data?.product_mix || []} dataKey="calls" nameKey="product" outerRadius={80} label>
                      {(data?.product_mix || []).map((_: any, i: number) => (
                        <Cell key={i} fill={COLORS[i % COLORS.length]} />
                      ))}
                    </Pie>
                    <RTooltip />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="mt-6 rounded-xl border border-border/60 p-4">
              <h4 className="mb-2 text-sm font-medium text-muted-foreground">Top developers by call volume</h4>
              <ResponsiveContainer width="100%" height={220}>
                <BarChart data={data?.top_developers || []}>
                  <CartesianGrid strokeDasharray="3 3" opacity={0.15} />
                  <XAxis dataKey="email" tick={{ fontSize: 9 }} interval={0} angle={-20} textAnchor="end" height={60} />
                  <YAxis tick={{ fontSize: 10 }} />
                  <RTooltip />
                  <Bar dataKey="calls" fill="#8a6fd6" radius={[6, 6, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}
