import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { RefreshCw, CheckCircle, XCircle, Bell, Smartphone, Globe } from "lucide-react";
import { adminFcmDiagnostics, adminFcmRecent } from "@/services/api";

/**
 * FCM Logs — one screen to see whether push notifications are healthy and what
 * the server got back on recent sends. Reads:
 *   GET /admin/fcm/diagnostics  (init state, web-push readiness, token counts)
 *   GET /admin/fcm/recent       (last ~30 send attempts with ok/error)
 */
export default function FcmLogs() {
  const [diag, setDiag] = useState<any>(null);
  const [recent, setRecent] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [auto, setAuto] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setErr(null);
    try {
      const [d, r] = await Promise.all([adminFcmDiagnostics(), adminFcmRecent()]);
      if (d.ok) setDiag(d.data?.data ?? d.data);
      if (r.ok) setRecent(r.data?.data ?? []);
      if (!d.ok && d.status === 404) setErr("Endpoint not found — the backend is not deployed with FCM diagnostics yet.");
    } catch (e: any) {
      setErr(String(e));
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);
  useEffect(() => {
    if (!auto) return;
    const id = setInterval(load, 5000);
    return () => clearInterval(id);
  }, [auto, load]);

  const fcm = diag?.fcm || {};
  const webpush = diag?.webpush || {};
  const tokens = diag?.tokens || {};

  const Bool = ({ v }: { v: any }) =>
    v ? <CheckCircle className="inline w-4 h-4 text-green-400" /> : <XCircle className="inline w-4 h-4 text-destructive" />;

  const ProjectCard = ({ title, f }: { title: string; f: any }) => (
    <div className="rounded-xl border border-border bg-card/60 p-4 space-y-2">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-semibold text-foreground flex items-center gap-1"><Smartphone className="w-4 h-4 text-primary" /> {title}</h3>
        <Badge className={f?.initialized ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>
          {f?.initialized ? "initialized" : "not initialized"}
        </Badge>
      </div>
      <div className="text-xs text-muted-foreground space-y-1">
        <div>Project loaded: <span className="text-foreground font-mono">{f?.project_id || "—"}</span></div>
        <div>SA file present: <Bool v={f?.file_present} /> · DB copy: <Bool v={f?.db_sa_json_present} /></div>
        {f?.error && <div className="text-destructive break-all">Error: {f.error}</div>}
      </div>
    </div>
  );

  const WebCard = ({ title, w }: { title: string; w: any }) => (
    <div className="rounded-xl border border-border bg-card/60 p-4 space-y-2">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-semibold text-foreground flex items-center gap-1"><Globe className="w-4 h-4 text-primary" /> {title}</h3>
        <Badge className={w?.ready ? "bg-green-500/20 text-green-400" : "bg-yellow-500/20 text-yellow-400"}>
          {w?.ready ? "ready" : "incomplete"}
        </Badge>
      </div>
      <div className="text-xs text-muted-foreground space-y-1">
        <div>Web project: <span className="text-foreground font-mono">{w?.web_project_id || "—"}</span></div>
        {Array.isArray(w?.missing_keys) && w.missing_keys.length > 0 && (
          <div className="text-yellow-400">Missing: {w.missing_keys.join(", ")}</div>
        )}
      </div>
    </div>
  );

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><Bell className="w-6 h-6 text-primary" /> FCM Logs</h1>
          <p className="text-sm text-muted-foreground">Push-notification health + recent send results. Expected project: <span className="font-mono">{diag?.expected_firebase_project || "—"}</span></p>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" size="sm" onClick={() => setAuto((a) => !a)} className={auto ? "border-primary text-primary" : ""}>
            {auto ? "Auto-refresh: on" : "Auto-refresh: off"}
          </Button>
          <Button size="sm" onClick={load} disabled={loading}>
            <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} /> Refresh
          </Button>
        </div>
      </div>

      {err && <div className="rounded-lg border border-destructive/40 bg-destructive/10 text-destructive text-sm p-3">{err}</div>}

      {/* Native FCM readiness */}
      <div>
        <h2 className="text-sm font-semibold text-primary mb-2">Native FCM (Android / iOS)</h2>
        <div className="grid md:grid-cols-2 gap-3">
          <ProjectCard title="User project" f={fcm.user} />
          <ProjectCard title="Astrologer project" f={fcm.astro} />
        </div>
      </div>

      {/* Web push readiness */}
      <div>
        <h2 className="text-sm font-semibold text-primary mb-2">Web Push</h2>
        <div className="grid md:grid-cols-2 gap-3">
          <WebCard title="User web push" w={webpush.user} />
          <WebCard title="Astrologer web push" w={webpush.astro} />
        </div>
      </div>

      {/* Registered token counts */}
      <div>
        <h2 className="text-sm font-semibold text-primary mb-2">Registered Tokens</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          <div className="rounded-xl border border-border bg-card/60 p-3"><p className="text-xs text-muted-foreground">User · native</p><p className="text-xl font-display text-primary">{tokens.user?.native ?? "—"}</p></div>
          <div className="rounded-xl border border-border bg-card/60 p-3"><p className="text-xs text-muted-foreground">User · web</p><p className="text-xl font-display text-primary">{tokens.user?.web ?? "—"}</p></div>
          <div className="rounded-xl border border-border bg-card/60 p-3"><p className="text-xs text-muted-foreground">Astro · native</p><p className="text-xl font-display text-primary">{tokens.astro?.native ?? "—"}</p></div>
          <div className="rounded-xl border border-border bg-card/60 p-3"><p className="text-xs text-muted-foreground">Astro · web</p><p className="text-xl font-display text-primary">{tokens.astro?.web ?? "—"}</p></div>
        </div>
      </div>

      {/* Recent send log */}
      <div>
        <h2 className="text-sm font-semibold text-primary mb-2">Recent Sends (last {recent.length})</h2>
        <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
          {recent.length === 0 ? (
            <p className="p-4 text-sm text-muted-foreground text-center">No send attempts recorded yet. Trigger a notification (chat/call or Send Notification), then refresh.</p>
          ) : (
            <div className="max-h-96 overflow-auto">
              <table className="w-full min-w-[480px] text-xs">
                <thead className="sticky top-0 bg-muted/60 text-muted-foreground">
                  <tr>
                    <th className="text-left p-2">Status</th>
                    <th className="text-left p-2">Kind</th>
                    <th className="text-left p-2">Token</th>
                    <th className="text-left p-2">Error</th>
                  </tr>
                </thead>
                <tbody>
                  {recent.map((r, i) => (
                    <tr key={i} className="border-t border-border">
                      <td className="p-2">{r.ok ? <Badge className="bg-green-500/20 text-green-400">ok</Badge> : <Badge className="bg-destructive/20 text-destructive">fail</Badge>}</td>
                      <td className="p-2 text-muted-foreground">{r.kind || "—"}</td>
                      <td className="p-2 font-mono text-muted-foreground">…{r.token_tail || ""}</td>
                      <td className="p-2 text-destructive break-all">{r.error || ""}</td>
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
