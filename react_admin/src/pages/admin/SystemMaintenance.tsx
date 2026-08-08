import { useCallback, useEffect, useState, type ReactNode } from "react";
import {
  Server, RefreshCw, CheckCircle2, XCircle, Save, Settings, Check,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  adminSchemaDiff, adminSchemaSync, adminSeedCatalog, adminSeedRun,
  adminGetSystemConfig, adminReloadConfig,
  adminSchemaAutoGet, adminSchemaAutoSet, adminSchemaHistory,
} from "@/services/api";

/**
 * SystemMaintenance — admin "System" screen.
 *
 * One place to apply developer-side changes to a running deployment (the backend
 * uses create_all() with no Alembic):
 *  • Schema  — auto-diff the models vs the live DB and apply ADDITIVE changes
 *              (missing tables/columns). Renames/drops are never auto-applied.
 *  • Seeders — re-run the idempotent seeders.
 *  • Config  — view the effective (secret-masked) config and reload env values.
 *
 * All calls hit /api/v1/admin/system/* (admin-only) via the shared api client.
 */

type Msg = { ok: boolean; text: string } | null;

function Section({
  icon: Icon, title, subtitle, children,
}: { icon: any; title: string; subtitle: string; children: ReactNode }) {
  return (
    <div className="space-y-4 rounded-xl border border-border bg-card/60 p-5">
      <div className="flex items-center gap-2">
        <Icon className="h-4 w-4 text-primary" />
        <div>
          <h3 className="text-base font-semibold text-foreground">{title}</h3>
          <p className="text-[11px] text-muted-foreground">{subtitle}</p>
        </div>
      </div>
      {children}
    </div>
  );
}

export default function SystemMaintenance() {
  // ── Schema ──
  const [diff, setDiff] = useState<any>(null);
  const [schemaBusy, setSchemaBusy] = useState(false);
  const [schemaMsg, setSchemaMsg] = useState<Msg>(null);
  const [applyResult, setApplyResult] = useState<any>(null);

  const [autoOn, setAutoOn] = useState<boolean | null>(null);
  const [history, setHistory] = useState<any[]>([]);

  const loadDiff = useCallback(async () => {
    setSchemaBusy(true); setSchemaMsg(null); setApplyResult(null);
    try {
      const { ok, data } = await adminSchemaDiff();
      if (ok) setDiff(data.data ?? data);
      else setSchemaMsg({ ok: false, text: "Failed to read schema diff." });
    } catch { setSchemaMsg({ ok: false, text: "Failed to read schema diff." }); }
    finally { setSchemaBusy(false); }
  }, []);

  const loadHistory = useCallback(async () => {
    try {
      const { ok, data } = await adminSchemaHistory(10);
      if (ok) setHistory(data.data ?? data ?? []);
    } catch { /* ignore */ }
  }, []);

  const loadAuto = useCallback(async () => {
    try {
      const { ok, data } = await adminSchemaAutoGet();
      if (ok) setAutoOn(!!(data.data ?? data)?.enabled);
    } catch { /* ignore */ }
  }, []);

  useEffect(() => { loadDiff(); loadAuto(); loadHistory(); }, [loadDiff, loadAuto, loadHistory]);

  const toggleAuto = async () => {
    const next = !autoOn;
    setAutoOn(next); // optimistic
    try {
      const { ok } = await adminSchemaAutoSet(next);
      if (!ok) { setAutoOn(!next); setSchemaMsg({ ok: false, text: "Could not update auto-mode." }); }
    } catch { setAutoOn(!next); setSchemaMsg({ ok: false, text: "Could not update auto-mode." }); }
  };

  const applySchema = async () => {
    if (!window.confirm(
      "Apply additive schema changes (create missing tables + add missing columns)?\n\n" +
      "This never drops or renames anything. Columns are added NULL-able.",
    )) return;
    setSchemaBusy(true); setSchemaMsg(null);
    try {
      const { ok, data } = await adminSchemaSync(false);
      const r = data.data ?? data;
      setApplyResult(r);
      if (ok) {
        setSchemaMsg({ ok: true, text:
          `Applied: ${r.created_tables?.length || 0} table(s), ${r.added_columns?.length || 0} column(s)` +
          (r.errors?.length ? `, ${r.errors.length} error(s)` : "") });
        await loadDiff();
        await loadHistory();
      } else setSchemaMsg({ ok: false, text: "Sync failed." });
    } catch { setSchemaMsg({ ok: false, text: "Sync failed." }); }
    finally { setSchemaBusy(false); }
  };

  const inSync = diff?.in_sync;
  const missingCols = diff?.missing_columns || [];
  const missingTables = diff?.missing_tables || [];
  const extraCols = diff?.extra_columns || [];

  // ── Seeders ──
  const [catalog, setCatalog] = useState<{ key: string; description: string }[]>([]);
  const [selected, setSelected] = useState<Record<string, boolean>>({});
  const [seedBusy, setSeedBusy] = useState(false);
  const [seedMsg, setSeedMsg] = useState<Msg>(null);
  const [seedResult, setSeedResult] = useState<any>(null);

  useEffect(() => {
    (async () => {
      try {
        const { ok, data } = await adminSeedCatalog();
        if (ok) setCatalog(data.data ?? data ?? []);
      } catch { /* ignore */ }
    })();
  }, []);

  const runSeed = async (all: boolean) => {
    const keys = all ? null : Object.keys(selected).filter((k) => selected[k]);
    if (!all && (!keys || keys.length === 0)) { setSeedMsg({ ok: false, text: "Select at least one seeder." }); return; }
    if (!window.confirm(`Run ${all ? "ALL" : keys!.length} seeder(s)? Seeders are idempotent (safe to re-run).`)) return;
    setSeedBusy(true); setSeedMsg(null); setSeedResult(null);
    try {
      const { ok, data } = await adminSeedRun(keys, all);
      const r = data.data ?? data;
      setSeedResult(r);
      setSeedMsg(ok
        ? { ok: !(r.errors && Object.keys(r.errors).length), text: `Ran: ${(r.ran || []).join(", ")}` }
        : { ok: false, text: "Seed run failed." });
    } catch { setSeedMsg({ ok: false, text: "Seed run failed." }); }
    finally { setSeedBusy(false); }
  };

  // ── Config ──
  const [config, setConfig] = useState<Record<string, any> | null>(null);
  const [cfgBusy, setCfgBusy] = useState(false);
  const [cfgMsg, setCfgMsg] = useState<Msg>(null);

  const loadConfig = async () => {
    setCfgBusy(true); setCfgMsg(null);
    try {
      const { ok, data } = await adminGetSystemConfig();
      if (ok) setConfig(data.data ?? data);
      else setCfgMsg({ ok: false, text: "Failed to load config." });
    } catch { setCfgMsg({ ok: false, text: "Failed to load config." }); }
    finally { setCfgBusy(false); }
  };

  const reloadConfig = async () => {
    setCfgBusy(true); setCfgMsg(null);
    try {
      const { ok, data } = await adminReloadConfig();
      const r = data.data ?? data;
      setCfgMsg(ok
        ? { ok: true, text: `Reloaded. Changed: ${(r.changed_keys || []).length} key(s).` }
        : { ok: false, text: "Reload failed." });
      await loadConfig();
    } catch { setCfgMsg({ ok: false, text: "Reload failed." }); }
    finally { setCfgBusy(false); }
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Server className="h-5 w-5 text-primary" />
          <h1 className="text-lg font-extrabold text-foreground">System &amp; Maintenance</h1>
        </div>
      </div>
      <p className="text-xs text-muted-foreground">
        Apply developer-side changes to this running deployment: sync database schema from the
        models, re-run seeders, and view/reload config. Additive &amp; idempotent — nothing is dropped.
      </p>

      {/* ── Schema Sync ── */}
      <Section
        icon={RefreshCw}
        title="Database Schema Sync"
        subtitle="Auto-diff the models vs the live DB and apply missing tables/columns (never drops or renames)."
      >
        {/* Auto-mode toggle: apply additive changes automatically on every deploy/restart */}
        <div className="flex items-start justify-between gap-3 rounded-lg border border-border bg-muted/20 p-3">
          <div>
            <div className="text-sm font-semibold text-foreground">Auto-apply on deploy</div>
            <p className="text-[11px] text-muted-foreground">
              When ON, every startup/redeploy automatically applies missing tables &amp; columns
              from the models — no manual step. Additive only; nothing is ever dropped.
            </p>
          </div>
          <button
            role="switch"
            aria-checked={!!autoOn}
            onClick={toggleAuto}
            disabled={autoOn === null}
            className={`relative mt-0.5 h-6 w-11 shrink-0 rounded-full transition-colors ${autoOn ? "bg-green-500/70" : "bg-muted"}`}
          >
            <span className={`absolute top-0.5 h-5 w-5 rounded-full bg-white transition-all ${autoOn ? "left-[22px]" : "left-0.5"}`} />
          </button>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          {diff && (inSync
            ? <Badge className="flex items-center gap-1 bg-green-500/20 text-green-400"><CheckCircle2 className="h-3 w-3" /> In sync</Badge>
            : <Badge className="flex items-center gap-1 bg-amber-500/20 text-amber-400"><XCircle className="h-3 w-3" /> {missingTables.length + missingCols.length} change(s) pending</Badge>)}
          <Button size="sm" variant="outline" className="h-8 border-border text-muted-foreground" onClick={loadDiff} disabled={schemaBusy}>
            <RefreshCw className={`mr-1 h-3 w-3 ${schemaBusy ? "animate-spin" : ""}`} /> Check for changes
          </Button>
          <Button size="sm" className="gradient-gold text-primary-foreground" onClick={applySchema} disabled={schemaBusy || inSync}>
            <Save className="mr-1 h-3 w-3" /> Apply additive changes
          </Button>
          <span className={`text-xs ${schemaMsg ? (schemaMsg.ok ? "text-green-400" : "text-destructive") : "text-transparent"}`}>{schemaMsg?.text || "."}</span>
        </div>

        {diff && !inSync && (
          <div className="space-y-3 rounded-lg border border-border bg-muted/20 p-3 text-xs">
            {missingTables.length > 0 && (
              <div>
                <div className="mb-1 font-mono text-[10px] uppercase tracking-wider text-amber-400">Missing tables ({missingTables.length})</div>
                <div className="flex flex-wrap gap-1">{missingTables.map((t: string) => <code key={t} className="rounded bg-card px-1.5 py-0.5 text-foreground">{t}</code>)}</div>
              </div>
            )}
            {missingCols.length > 0 && (
              <div>
                <div className="mb-1 font-mono text-[10px] uppercase tracking-wider text-amber-400">Missing columns ({missingCols.length})</div>
                <div className="space-y-0.5">{missingCols.map((c: any, i: number) => (
                  <div key={i} className="font-mono text-[11px] text-muted-foreground"><span className="text-foreground">{c.table}.{c.column}</span> — {c.type}</div>
                ))}</div>
              </div>
            )}
            {extraCols.length > 0 && (
              <div>
                <div className="mb-1 font-mono text-[10px] uppercase tracking-wider text-muted-foreground">In DB but not in models — review only, never dropped ({extraCols.length})</div>
                <div className="flex flex-wrap gap-1">{extraCols.map((c: any, i: number) => <code key={i} className="rounded bg-card px-1.5 py-0.5 text-muted-foreground">{c.table}.{c.column}</code>)}</div>
              </div>
            )}
          </div>
        )}

        {applyResult?.notes?.length > 0 && (
          <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-3 text-[11px] text-amber-300">
            {applyResult.notes.map((n: string, i: number) => <div key={i}>• {n}</div>)}
          </div>
        )}

        {/* Apply activity — auto (startup/redeploy) + manual syncs, newest first */}
        <div>
          <div className="mb-1 flex items-center justify-between">
            <div className="font-mono text-[10px] uppercase tracking-wider text-muted-foreground">Sync activity</div>
            <button onClick={loadHistory} className="text-[10px] text-primary hover:underline">Refresh</button>
          </div>
          {history.length === 0
            ? <div className="rounded-lg border border-border bg-muted/10 p-3 text-[11px] text-muted-foreground">No sync activity yet.</div>
            : (
              <div className="max-h-56 overflow-auto rounded-lg border border-border bg-card">
                <table className="w-full text-[11px]">
                  <thead className="bg-muted/40 text-muted-foreground">
                    <tr>
                      <th className="px-2 py-1.5 text-left">When</th>
                      <th className="px-2 py-1.5 text-left">Source</th>
                      <th className="px-2 py-1.5 text-left">Applied</th>
                    </tr>
                  </thead>
                  <tbody>
                    {history.map((h) => {
                      const nt = (h.created_tables || []).length;
                      const nc = (h.added_columns || []).length;
                      const ne = (h.errors || []).length;
                      return (
                        <tr key={h.id} className="border-t border-border/50">
                          <td className="whitespace-nowrap px-2 py-1.5 text-muted-foreground">{h.created_at ? new Date(h.created_at).toLocaleString() : "—"}</td>
                          <td className="px-2 py-1.5">
                            <span className={`rounded px-1.5 py-0.5 text-[10px] font-semibold ${h.source === "startup" ? "bg-blue-500/20 text-blue-400" : "bg-muted text-muted-foreground"}`}>{h.source}</span>
                          </td>
                          <td className="px-2 py-1.5 text-foreground">
                            {nt || nc ? `${nt} table(s), ${nc} column(s)` : "no changes"}
                            {ne > 0 && <span className="ml-1 text-destructive">· {ne} error(s)</span>}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            )}
        </div>
      </Section>

      {/* ── Seeders ── */}
      <Section
        icon={RefreshCw}
        title="Run Seeders"
        subtitle="Idempotent — safe to re-run. Upserts catalog data (pricing, plans, platform_settings, AI config, questions)."
      >
        <div className="space-y-2">
          {catalog.map((s) => (
            <label key={s.key} className="flex cursor-pointer items-start gap-2 rounded-lg border border-border bg-muted/20 p-2.5 text-xs">
              <input
                type="checkbox"
                checked={!!selected[s.key]}
                onChange={(e) => setSelected({ ...selected, [s.key]: e.target.checked })}
                className="mt-0.5 accent-primary"
              />
              <span>
                <span className="font-mono font-semibold text-foreground">{s.key}</span>
                <span className="ml-2 text-muted-foreground">{s.description}</span>
              </span>
            </label>
          ))}
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button size="sm" variant="outline" className="h-8 border-border text-muted-foreground" onClick={() => runSeed(false)} disabled={seedBusy}>
            <RefreshCw className={`mr-1 h-3 w-3 ${seedBusy ? "animate-spin" : ""}`} /> Run selected
          </Button>
          <Button size="sm" className="gradient-gold text-primary-foreground" onClick={() => runSeed(true)} disabled={seedBusy}>
            Run all
          </Button>
          <span className={`text-xs ${seedMsg ? (seedMsg.ok ? "text-green-400" : "text-destructive") : "text-transparent"}`}>{seedMsg?.text || "."}</span>
        </div>
        {seedResult && (
          <pre className="max-h-56 overflow-auto rounded-lg border border-border bg-card p-3 text-[11px] text-muted-foreground">
            {JSON.stringify({ summary: seedResult.summary, errors: seedResult.errors }, null, 2)}
          </pre>
        )}
      </Section>

      {/* ── Config ── */}
      <Section
        icon={Settings}
        title="Effective Config"
        subtitle="Process/env config (secrets masked). DB-backed config (OAuth, web push, pricing) is edited on its own screens."
      >
        <div className="flex flex-wrap items-center gap-2">
          <Button size="sm" variant="outline" className="h-8 border-border text-muted-foreground" onClick={loadConfig} disabled={cfgBusy}>
            <RefreshCw className={`mr-1 h-3 w-3 ${cfgBusy ? "animate-spin" : ""}`} /> Load config
          </Button>
          <Button size="sm" className="gradient-gold text-primary-foreground" onClick={reloadConfig} disabled={cfgBusy}>
            <Check className="mr-1 h-3 w-3" /> Reload from env
          </Button>
          <span className={`text-xs ${cfgMsg ? (cfgMsg.ok ? "text-green-400" : "text-destructive") : "text-transparent"}`}>{cfgMsg?.text || "."}</span>
        </div>
        {config && (
          <div className="max-h-72 overflow-auto rounded-lg border border-border bg-card">
            <table className="w-full text-[11px]">
              <tbody>
                {Object.entries(config).map(([k, v]) => (
                  <tr key={k} className="border-b border-border/50">
                    <td className="whitespace-nowrap px-3 py-1.5 font-mono text-muted-foreground">{k}</td>
                    <td className="px-3 py-1.5 font-mono text-foreground">{String(v)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Section>
    </div>
  );
}
