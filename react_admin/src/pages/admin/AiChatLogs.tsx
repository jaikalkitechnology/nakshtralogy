import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { MessageSquare, RefreshCw, X, ChevronLeft, ChevronRight } from "lucide-react";
import { adminAgentLogs, adminAgentLogDetail } from "@/services/api";
import { toast } from "sonner";

const DOMAINS = [
  { key: "", label: "All domains" },
  { key: "career_job", label: "Career & Job" },
  { key: "business_startup", label: "Business & Startup" },
  { key: "education_career", label: "Education" },
  { key: "money_wealth", label: "Money & Wealth" },
  { key: "debt_recovery", label: "Debt Recovery" },
  { key: "love_relationship", label: "Love & Relationship" },
  { key: "marriage_family", label: "Marriage & Family" },
  { key: "health_wellness", label: "Health & Wellness" },
  { key: "mental_stress", label: "Mental Stress" },
  { key: "property_assets", label: "Property & Assets" },
  { key: "legal_dispute", label: "Legal & Dispute" },
  { key: "life_path_luck", label: "Life Path & Luck" },
];

const STATUS_STYLE: Record<string, string> = {
  success: "bg-green-500/20 text-green-400",
  error: "bg-destructive/20 text-destructive",
  timeout: "bg-yellow-500/20 text-yellow-400",
  interrupted: "bg-muted text-muted-foreground",
};

const ROUTING_STYLE: Record<string, string> = {
  template: "bg-cosmic/15 text-foreground",
  llm: "bg-primary/15 text-primary",
  sharpened_llm: "bg-primary/15 text-primary",
};

interface LogRow {
  id: string;
  user_id?: string;
  user?: { name?: string; email?: string } | null;
  provider?: string;
  domain?: string;
  language?: string;
  query?: string;
  response_preview?: string;
  status: string;
  routing?: string;
  error_message?: string;
  latency_ms?: number;
  created_at?: string;
}

const PAGE_SIZE = 30;

/**
 * AI Chat Logs — every turn through the AI chat (app/routers/agent_router.py
 * GET /agent/logs, /agent/logs/{id}): the user's question, the keyword-
 * detected intent, the model's response, routing (template vs LLM) and
 * status, for debugging and quality review.
 */
export default function AiChatLogs() {
  const [rows, setRows] = useState<LogRow[]>([]);
  const [total, setTotal] = useState(0);
  const [offset, setOffset] = useState(0);
  const [loading, setLoading] = useState(false);
  const [domain, setDomain] = useState("");
  const [status, setStatus] = useState("");
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const [detail, setDetail] = useState<any>(null);
  const [detailOpen, setDetailOpen] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    const params: Record<string, any> = { limit: PAGE_SIZE, offset };
    if (domain) params.domain = domain;
    if (status) params.status = status;
    if (search) params.q = search;
    const r = await adminAgentLogs(params);
    if (r.ok) {
      setRows(r.data?.items ?? []);
      setTotal(r.data?.total ?? 0);
    } else if (r.status === 404) {
      toast.error("Deploy the backend with AI chat logs");
    } else {
      toast.error(r.data?.detail || "Failed to load logs");
    }
    setLoading(false);
  }, [domain, status, search, offset]);

  useEffect(() => { load(); }, [load]);

  const openDetail = async (id: string) => {
    setDetailOpen(true);
    setDetailLoading(true);
    const r = await adminAgentLogDetail(id);
    setDetailLoading(false);
    if (r.ok) setDetail(r.data);
    else { toast.error(r.data?.detail || "Failed to load log"); setDetailOpen(false); }
  };

  const applySearch = () => { setOffset(0); setSearch(searchInput.trim()); };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><MessageSquare className="w-6 h-6 text-primary" /> AI Chat Logs</h1>
          <p className="text-sm text-muted-foreground">Every chat turn — question, detected intent, response, routing and status.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        <select value={domain} onChange={(e) => { setOffset(0); setDomain(e.target.value); }}
          className="rounded-lg border border-border bg-card px-2.5 py-1.5 text-xs text-foreground">
          {DOMAINS.map((d) => <option key={d.key} value={d.key}>{d.label}</option>)}
        </select>
        <select value={status} onChange={(e) => { setOffset(0); setStatus(e.target.value); }}
          className="rounded-lg border border-border bg-card px-2.5 py-1.5 text-xs text-foreground">
          <option value="">All statuses</option>
          <option value="success">success</option>
          <option value="error">error</option>
          <option value="timeout">timeout</option>
          <option value="interrupted">interrupted</option>
        </select>
        <div className="flex items-center gap-1.5">
          <Input value={searchInput} onChange={(e) => setSearchInput(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && applySearch()}
            placeholder="Search question/response…" className="h-8 w-56 text-xs" />
          <Button size="sm" variant="outline" onClick={applySearch}>Search</Button>
        </div>
        <span className="ml-auto text-xs text-muted-foreground">{total} total</span>
      </div>

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-xs">
            <thead className="bg-muted/50 text-muted-foreground"><tr>
              <th className="text-left p-2.5">When</th>
              <th className="text-left p-2.5">User</th>
              <th className="text-left p-2.5">Domain</th>
              <th className="text-left p-2.5">Lang</th>
              <th className="text-left p-2.5">Question</th>
              <th className="text-left p-2.5">Routing</th>
              <th className="text-left p-2.5">Status</th>
              <th className="text-left p-2.5">Latency</th>
              <th></th>
            </tr></thead>
            <tbody>
              {rows.map((l) => (
                <tr key={l.id} className="border-t border-border hover:bg-muted/30">
                  <td className="p-2.5 text-muted-foreground whitespace-nowrap">{(l.created_at || "").slice(0, 16)}</td>
                  <td className="p-2.5 text-foreground">{l.user?.name || l.user?.email || l.user_id?.slice(0, 8) || "—"}</td>
                  <td className="p-2.5 text-foreground">{l.domain || "—"}</td>
                  <td className="p-2.5 text-muted-foreground">{l.language || "—"}</td>
                  <td className="p-2.5 text-foreground max-w-[260px] truncate" title={l.query}>{l.query}</td>
                  <td className="p-2.5"><Badge className={ROUTING_STYLE[l.routing || ""] || "bg-muted text-muted-foreground"}>{l.routing || "—"}</Badge></td>
                  <td className="p-2.5"><Badge className={STATUS_STYLE[l.status] || "bg-muted text-muted-foreground"}>{l.status}</Badge></td>
                  <td className="p-2.5 text-muted-foreground">{l.latency_ms != null ? `${l.latency_ms}ms` : "—"}</td>
                  <td className="p-2.5 text-right"><Button size="sm" variant="outline" onClick={() => openDetail(l.id)}>View</Button></td>
                </tr>
              ))}
              {rows.length === 0 && !loading && (
                <tr><td colSpan={9} className="p-6 text-center text-muted-foreground">No logs found.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="flex items-center justify-between">
        <Button size="sm" variant="outline" disabled={offset === 0} onClick={() => setOffset(Math.max(0, offset - PAGE_SIZE))}>
          <ChevronLeft className="w-4 h-4 mr-1" /> Prev
        </Button>
        <span className="text-xs text-muted-foreground">{total === 0 ? 0 : offset + 1}–{Math.min(offset + PAGE_SIZE, total)} of {total}</span>
        <Button size="sm" variant="outline" disabled={offset + PAGE_SIZE >= total} onClick={() => setOffset(offset + PAGE_SIZE)}>
          Next <ChevronRight className="w-4 h-4 ml-1" />
        </Button>
      </div>

      {detailOpen && <LogDetailModal data={detail} loading={detailLoading} onClose={() => { setDetailOpen(false); setDetail(null); }} />}
    </div>
  );
}

function LogDetailModal({ data, loading, onClose }: { data: any; loading: boolean; onClose: () => void }) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={onClose}>
      <div className="w-full max-w-2xl max-h-[85vh] overflow-hidden rounded-2xl border border-border bg-card shadow-xl flex flex-col" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between border-b border-border p-4">
          <h3 className="font-display text-lg text-foreground">Chat turn detail</h3>
          <button onClick={onClose} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
        </div>
        <div className="overflow-y-auto p-4 space-y-4 text-sm">
          {loading || !data ? (
            <p className="text-center text-muted-foreground py-8">Loading…</p>
          ) : (
            <>
              <div className="flex flex-wrap gap-2 text-xs">
                <Badge className="bg-cosmic/15 text-foreground">{data.user?.name || data.user?.email || data.user_id || "—"}</Badge>
                <Badge className={STATUS_STYLE[data.status] || "bg-muted text-muted-foreground"}>{data.status}</Badge>
                {data.routing && <Badge className={ROUTING_STYLE[data.routing] || "bg-muted text-muted-foreground"}>{data.routing}</Badge>}
                <Badge className="bg-cosmic/15 text-foreground">{data.domain || "—"}</Badge>
                <Badge className="bg-cosmic/15 text-foreground">{data.language || "—"}</Badge>
                {data.latency_ms != null && <Badge className="bg-cosmic/15 text-foreground">{data.latency_ms}ms</Badge>}
              </div>

              <div>
                <p className="text-xs font-semibold text-muted-foreground mb-1">Question</p>
                <p className="rounded-lg bg-muted/30 p-3 text-foreground whitespace-pre-wrap break-words">{data.raw_query || data.query_first_100 || "—"}</p>
              </div>

              {data.intent && (
                <div>
                  <p className="text-xs font-semibold text-muted-foreground mb-1">Detected intent</p>
                  <pre className="rounded-lg bg-muted/30 p-3 text-[11px] text-muted-foreground overflow-x-auto">{JSON.stringify(data.intent, null, 2)}</pre>
                </div>
              )}

              <div>
                <p className="text-xs font-semibold text-muted-foreground mb-1">Response</p>
                <p className="rounded-lg bg-muted/30 p-3 text-foreground whitespace-pre-wrap break-words">{data.response_text || <span className="text-muted-foreground">—</span>}</p>
              </div>

              {data.error_message && (
                <div>
                  <p className="text-xs font-semibold text-destructive mb-1">Error</p>
                  <p className="rounded-lg bg-destructive/10 p-3 text-destructive whitespace-pre-wrap break-words">{data.error_message}</p>
                </div>
              )}

              <div>
                <p className="text-xs font-semibold text-muted-foreground mb-1">Full prompt sent to the model</p>
                <pre className="rounded-lg bg-muted/30 p-3 text-[11px] text-muted-foreground overflow-x-auto max-h-60 overflow-y-auto whitespace-pre-wrap">{data.full_query_prompt || "—"}</pre>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
