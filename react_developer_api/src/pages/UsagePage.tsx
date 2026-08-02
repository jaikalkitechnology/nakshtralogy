import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RTooltip, ResponsiveContainer } from "recharts";
import { Activity, RefreshCw } from "lucide-react";
import DataTable, { type DataTableColumn } from "@/components/DataTable";
import KpiCard from "@/components/KpiCard";
import { listUsage, getUsageSummary } from "@/lib/api";
import { PhoneCall, AlertTriangle, Gauge } from "lucide-react";

interface LogRow {
  id: string;
  product: string;
  endpoint: string | null;
  http_status: number;
  cache_hit: boolean;
  latency_ms: number | null;
  created_at: string | null;
}

const PAGE_SIZE = 10;

export default function UsagePage() {
  const [logs, setLogs] = useState<LogRow[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [product, setProduct] = useState("all");
  const [summary, setSummary] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const params: Record<string, any> = { page, page_size: PAGE_SIZE };
      if (product !== "all") params.product = product;
      const [logsRes, summaryRes] = await Promise.all([listUsage(params), getUsageSummary(30)]);
      if (!logsRes.ok) throw new Error(logsRes.data?.detail || "Failed to load usage logs");
      setLogs(logsRes.data.logs || []);
      setTotal(logsRes.data.total || 0);
      if (summaryRes.ok) setSummary(summaryRes.data);
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, [page, product]);

  useEffect(() => { load(); }, [load]);

  const kpis = summary?.kpis || {};

  const columns: DataTableColumn<LogRow>[] = [
    { key: "product", header: "Product", render: (l) => <span className="capitalize">{l.product}</span> },
    { key: "endpoint", header: "Endpoint", render: (l) => <code className="text-xs">{l.endpoint}</code> },
    {
      key: "http_status", header: "Status",
      render: (l) => (
        <Badge variant="outline" className={l.http_status >= 400 ? "border-red-500/30 text-red-400" : "border-emerald-500/30 text-emerald-400"}>
          {l.http_status}
        </Badge>
      ),
    },
    { key: "cache_hit", header: "Cache", render: (l) => (l.cache_hit ? "Hit" : "Miss") },
    { key: "latency_ms", header: "Latency", align: "right", render: (l) => (l.latency_ms ? `${l.latency_ms}ms` : "—") },
    { key: "created_at", header: "Date", render: (l) => (l.created_at ? new Date(l.created_at).toLocaleString() : "—") },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Usage &amp; Analytics</h1>
          <p className="text-sm text-muted-foreground">Calls, latency and errors across your keys.</p>
        </div>
        <Button variant="outline" size="icon" onClick={load} title="Refresh"><RefreshCw className="h-4 w-4" /></Button>
      </div>

      <div className="grid grid-cols-2 gap-4 md:grid-cols-3">
        <KpiCard label="Calls (30d)" value={kpis.total_calls ?? 0} icon={<PhoneCall className="h-5 w-5" />} />
        <KpiCard label="Errors (30d)" value={kpis.total_errors ?? 0} icon={<AlertTriangle className="h-5 w-5" />} tone="danger" />
        <KpiCard label="Avg latency" value={kpis.avg_latency_ms ?? 0} suffix="ms" icon={<Gauge className="h-5 w-5" />} />
      </div>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Calls per day (30d)</CardTitle></CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={summary?.calls_by_day || []}>
              <CartesianGrid strokeDasharray="3 3" opacity={0.15} />
              <XAxis dataKey="date" tick={{ fontSize: 10 }} />
              <YAxis tick={{ fontSize: 10 }} />
              <RTooltip />
              <Bar dataKey="calls" fill="#8a6fd6" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="flex items-center gap-2 text-base"><Activity className="h-4 w-4 text-primary" /> Call log</CardTitle>
          <Select value={product} onValueChange={(v) => { setPage(1); setProduct(v); }}>
            <SelectTrigger className="w-40"><SelectValue placeholder="Product" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All products</SelectItem>
              <SelectItem value="kundli">Kundli</SelectItem>
              <SelectItem value="reports">Special Reports</SelectItem>
              <SelectItem value="rashi">Rashi</SelectItem>
              <SelectItem value="forecast">Today Forecast</SelectItem>
              <SelectItem value="specialist">Special Reports (legacy)</SelectItem>
              <SelectItem value="milan">Kundli Milan (legacy)</SelectItem>
            </SelectContent>
          </Select>
        </CardHeader>
        <CardContent>
          <DataTable
            columns={columns}
            rows={logs}
            rowKey={(l) => l.id}
            loading={loading}
            error={error}
            onRetry={load}
            emptyTitle="No API calls yet"
            emptyDescription="Once you start calling the gateway, every request will show up here."
            page={page}
            pageSize={PAGE_SIZE}
            total={total}
            onPageChange={setPage}
          />
        </CardContent>
      </Card>
    </div>
  );
}
