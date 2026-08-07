import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Bell, Send, Users, Star, Globe2, User as UserIcon, RefreshCw, Search, CheckCircle } from "lucide-react";
import {
  adminBroadcastNotification, adminListCampaigns, adminSendNotification, adminListUsers,
} from "@/services/api";

type Audience = "users" | "astrologers" | "all" | "individual";

/**
 * Notification Management — compose and send push + in-app notifications to a
 * segment (all users / all astrologers / everyone) or an individual account,
 * with active-only targeting, live delivery reports, and campaign history.
 */
export default function NotificationsManager() {
  const [audience, setAudience] = useState<Audience>("users");
  const [activeOnly, setActiveOnly] = useState(true);
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [sending, setSending] = useState(false);
  const [report, setReport] = useState<any>(null);

  // Individual target search
  const [search, setSearch] = useState("");
  const [results, setResults] = useState<any[]>([]);
  const [searching, setSearching] = useState(false);
  const [target, setTarget] = useState<any>(null);

  // Campaign history
  const [campaigns, setCampaigns] = useState<any[]>([]);
  const [loadingHist, setLoadingHist] = useState(false);

  const loadHistory = useCallback(async () => {
    setLoadingHist(true);
    try {
      const { ok, data } = await adminListCampaigns(50);
      if (ok) setCampaigns(data?.data ?? []);
    } finally {
      setLoadingHist(false);
    }
  }, []);
  useEffect(() => { loadHistory(); }, [loadHistory]);

  const doSearch = async () => {
    if (!search.trim()) return;
    setSearching(true);
    try {
      const { ok, data } = await adminListUsers({ search: search.trim(), limit: 10 });
      if (ok) setResults(data?.users ?? data ?? []);
    } finally {
      setSearching(false);
    }
  };

  const canSend = title.trim() && body.trim() && (audience !== "individual" || target);

  const send = async () => {
    if (!canSend) return;
    setSending(true);
    setReport(null);
    try {
      let res;
      if (audience === "individual") {
        res = await adminSendNotification(target.id, title.trim(), body.trim());
      } else {
        res = await adminBroadcastNotification(audience, title.trim(), body.trim(), activeOnly);
      }
      setReport(res.ok ? (res.data?.data ?? res.data) : { error: "Send failed" });
      loadHistory();
    } catch (e: any) {
      setReport({ error: String(e) });
    } finally {
      setSending(false);
    }
  };

  const AudienceBtn = ({ value, label, icon: Icon }: { value: Audience; label: string; icon: any }) => (
    <button
      onClick={() => { setAudience(value); setReport(null); }}
      className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-sm transition ${
        audience === value ? "border-primary bg-primary/10 text-primary" : "border-border text-muted-foreground hover:border-primary/40"
      }`}
    >
      <Icon className="w-4 h-4" /> {label}
    </button>
  );

  const audLabel: Record<string, string> = {
    users: "All Users", astrologers: "All Astrologers", all: "Everyone", individual: "Individual",
  };

  return (
    <div className="p-6 space-y-6">
      <div>
        <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><Bell className="w-6 h-6 text-primary" /> Notification Management</h1>
        <p className="text-sm text-muted-foreground">Send push + in-app notifications to a segment or an individual, with delivery reports.</p>
      </div>

      {/* Compose */}
      <div className="rounded-xl border border-border bg-card/60 p-5 space-y-4">
        <div>
          <p className="text-xs text-muted-foreground mb-2">Audience</p>
          <div className="flex flex-wrap gap-2">
            <AudienceBtn value="users" label="All Users" icon={Users} />
            <AudienceBtn value="astrologers" label="All Astrologers" icon={Star} />
            <AudienceBtn value="all" label="Everyone" icon={Globe2} />
            <AudienceBtn value="individual" label="Individual" icon={UserIcon} />
          </div>
        </div>

        {audience !== "individual" ? (
          <label className="flex items-center gap-2 text-sm text-muted-foreground cursor-pointer">
            <input type="checkbox" checked={activeOnly} onChange={(e) => setActiveOnly(e.target.checked)} />
            Active accounts only
          </label>
        ) : (
          <div>
            <p className="text-xs text-muted-foreground mb-1">Find account (name / email)</p>
            <div className="flex gap-2">
              <Input value={search} onChange={(e) => setSearch(e.target.value)} onKeyDown={(e) => e.key === "Enter" && doSearch()} placeholder="Search users / astrologers" className="bg-muted/30 border-border" />
              <Button variant="outline" onClick={doSearch} disabled={searching}><Search className="w-4 h-4" /></Button>
            </div>
            {target && (
              <div className="mt-2 flex items-center gap-2 text-sm">
                <Badge className="bg-primary/20 text-primary">selected</Badge>
                <span className="text-foreground">{target.name || target.email}</span>
                <span className="text-muted-foreground text-xs">({target.role})</span>
                <button className="text-xs text-destructive hover:underline" onClick={() => setTarget(null)}>clear</button>
              </div>
            )}
            {results.length > 0 && !target && (
              <div className="mt-2 rounded-lg border border-border divide-y divide-border max-h-48 overflow-y-auto">
                {results.map((u) => (
                  <button key={u.id} onClick={() => { setTarget(u); setResults([]); }} className="w-full text-left px-3 py-2 hover:bg-muted/30 text-sm flex items-center justify-between">
                    <span className="text-foreground">{u.name || u.email}</span>
                    <span className="text-xs text-muted-foreground">{u.role} · {u.is_active ? "active" : "blocked"}</span>
                  </button>
                ))}
              </div>
            )}
          </div>
        )}

        <div>
          <p className="text-xs text-muted-foreground mb-1">Title</p>
          <Input value={title} maxLength={80} onChange={(e) => setTitle(e.target.value)} placeholder="Notification title" className="bg-muted/30 border-border" />
        </div>
        <div>
          <p className="text-xs text-muted-foreground mb-1">Message</p>
          <Textarea value={body} maxLength={300} rows={3} onChange={(e) => setBody(e.target.value)} placeholder="Notification message" className="bg-muted/30 border-border" />
        </div>

        <div className="flex items-center justify-between">
          <p className="text-xs text-muted-foreground">
            Target: <span className="text-foreground">{audLabel[audience]}</span>
            {audience !== "individual" && <span>{activeOnly ? " · active only" : " · all accounts"}</span>}
          </p>
          <Button onClick={send} disabled={!canSend || sending}>
            <Send className="w-4 h-4 mr-1" /> {sending ? "Sending…" : "Send Notification"}
          </Button>
        </div>

        {/* Delivery report */}
        {report && (
          <div className={`rounded-lg p-3 text-sm border ${report.error ? "border-destructive/40 bg-destructive/10 text-destructive" : "border-green-500/40 bg-green-500/10 text-green-400"}`}>
            {report.error ? (
              <>Error: {report.error}</>
            ) : audience === "individual" ? (
              <div className="space-y-2">
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4" />
                  {report.push_delivered ? "Delivered to device ✓ (and saved in-app)" : (report.diagnosis || "Saved in-app; push not delivered")}
                </div>
                {/* Full token string(s) the notification was sent to */}
                {Array.isArray(report.results) && report.results.length > 0 ? (
                  <div className="space-y-2">
                    {report.results.map((r: any, i: number) => (
                      <div key={i} className="rounded-lg border border-border bg-card/60 p-2 text-foreground">
                        <div className="flex items-center justify-between mb-1">
                          <span className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">
                            {r.target} token {r.ok ? <span className="text-green-400">· delivered</span> : <span className="text-destructive">· failed</span>}
                          </span>
                          <button
                            type="button"
                            onClick={() => { navigator.clipboard?.writeText(r.token || ""); }}
                            className="text-[11px] text-primary hover:underline"
                          >Copy</button>
                        </div>
                        <code className="block break-all font-mono text-[11px] text-foreground/90">{r.token || "—"}</code>
                        {!r.ok && r.error && <div className="mt-1 text-[11px] text-destructive break-all">{String(r.error)}</div>}
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-[11px] text-muted-foreground">No device token registered for this account — saved in-app only.</div>
                )}
              </div>
            ) : (
              <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-foreground">
                <div><span className="text-muted-foreground text-xs">Targets</span><br />{report.total_targets}</div>
                <div><span className="text-muted-foreground text-xs">With token</span><br />{report.with_token}</div>
                <div><span className="text-muted-foreground text-xs">Delivered</span><br /><span className="text-green-400">{report.delivered}</span></div>
                <div><span className="text-muted-foreground text-xs">Failed</span><br /><span className="text-destructive">{report.failed}</span></div>
                {report.capped && <div className="col-span-full text-yellow-400 text-xs">Capped at {report.cap} recipients per send.</div>}
              </div>
            )}
          </div>
        )}
      </div>

      {/* Campaign history */}
      <div>
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-sm font-semibold text-primary">Sent History & Delivery Reports</h2>
          <Button variant="outline" size="sm" onClick={loadHistory} disabled={loadingHist}><RefreshCw className={`w-4 h-4 ${loadingHist ? "animate-spin" : ""}`} /></Button>
        </div>
        <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
          {campaigns.length === 0 ? (
            <p className="p-4 text-sm text-muted-foreground text-center">No notifications sent yet.</p>
          ) : (
            <div className="max-h-96 overflow-y-auto overflow-x-auto">
              <table className="w-full text-xs">
                <thead className="sticky top-0 bg-muted/60 text-muted-foreground">
                  <tr>
                    <th className="text-left p-2">Title</th>
                    <th className="text-left p-2">Audience</th>
                    <th className="text-right p-2">Targets</th>
                    <th className="text-right p-2">With token</th>
                    <th className="text-right p-2">Delivered</th>
                    <th className="text-right p-2">Failed</th>
                    <th className="text-left p-2">When</th>
                  </tr>
                </thead>
                <tbody>
                  {campaigns.map((c) => (
                    <tr key={c.id} className="border-t border-border">
                      <td className="p-2 text-foreground max-w-[200px] truncate" title={c.body}>{c.title}</td>
                      <td className="p-2"><Badge variant="outline" className="border-border capitalize">{c.audience}{c.active_only ? " · active" : ""}</Badge></td>
                      <td className="p-2 text-right text-muted-foreground">{c.total_targets}</td>
                      <td className="p-2 text-right text-muted-foreground">{c.with_token}</td>
                      <td className="p-2 text-right text-green-400">{c.delivered}</td>
                      <td className="p-2 text-right text-destructive">{c.failed}</td>
                      <td className="p-2 text-muted-foreground">{c.created_at?.slice(0, 16) || "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
