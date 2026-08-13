import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { SchemaApplyResult, SchemaDiff, SchemaSyncLogEntry } from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

/**
 * SchemaSyncPage — admin "Database Schema Sync" ("auto mode").
 *
 * Schema is owned by Alembic; this is an additive safety net on top of it. It
 * auto-diffs the SQLAlchemy models vs the live DB and applies ONLY additive
 * changes — create missing tables + add missing NULL-able columns. It never
 * drops or renames. Columns present in the DB but not in the models are shown
 * for review only. Backend: /admin/system/schema/*  (admin-only).
 */

type Msg = { ok: boolean; text: string } | null

export default function SchemaSyncPage() {
  const [diff, setDiff] = useState<SchemaDiff | null>(null)
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<Msg>(null)
  const [applyResult, setApplyResult] = useState<SchemaApplyResult | null>(null)
  const [autoOn, setAutoOn] = useState<boolean | null>(null)
  const [history, setHistory] = useState<SchemaSyncLogEntry[]>([])

  const loadDiff = useCallback(async () => {
    setBusy(true); setMsg(null); setApplyResult(null)
    try {
      const r = await adminApi.schemaDiff()
      setDiff(r.data)
    } catch (e) { setMsg({ ok: false, text: (e as Error).message || 'Failed to read schema diff.' }) }
    finally { setBusy(false) }
  }, [])

  const loadHistory = useCallback(async () => {
    try { const r = await adminApi.schemaHistory(10); setHistory(r.data ?? []) } catch { /* ignore */ }
  }, [])

  const loadAuto = useCallback(async () => {
    try { const r = await adminApi.schemaAutoGet(); setAutoOn(!!r.data?.enabled) } catch { /* ignore */ }
  }, [])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void loadDiff(); void loadAuto(); void loadHistory() }, [loadDiff, loadAuto, loadHistory])

  async function toggleAuto() {
    if (autoOn === null) return
    const next = !autoOn
    setAutoOn(next) // optimistic
    try {
      const r = await adminApi.schemaAutoSet(next)
      setAutoOn(!!r.data?.enabled)
    } catch (e) { setAutoOn(!next); setMsg({ ok: false, text: (e as Error).message || 'Could not update auto-mode.' }) }
  }

  async function applySchema() {
    if (!window.confirm(
      'Apply additive schema changes (create missing tables + add missing columns)?\n\n' +
      'This never drops or renames anything. Columns are added NULL-able.',
    )) return
    setBusy(true); setMsg(null)
    try {
      const r = await adminApi.schemaSync(false)
      const res = r.data
      setApplyResult(res)
      setMsg({ ok: true, text:
        `Applied: ${res.created_tables?.length || 0} table(s), ${res.added_columns?.length || 0} column(s)` +
        (res.errors?.length ? `, ${res.errors.length} error(s)` : '') })
      await loadDiff(); await loadHistory()
    } catch (e) { setMsg({ ok: false, text: (e as Error).message || 'Sync failed.' }) }
    finally { setBusy(false) }
  }

  const inSync = diff?.in_sync
  const missingCols = diff?.missing_columns || []
  const missingTables = diff?.missing_tables || []
  const extraCols = diff?.extra_columns || []
  const pending = missingTables.length + missingCols.length

  return (
    <div className="space-y-6">
      <PageHeader
        title="Database Schema Sync"
        subtitle="Additive safety net on top of Alembic. Auto-diff the models vs the live DB and apply missing tables/columns — never drops or renames. New NULL-able columns land without a manual migration."
        icon={<span className="text-[18px]">🗄️</span>}
      />

      {/* Auto-apply on deploy */}
      <Card className="p-6">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h3 className="text-[15px] font-bold">Auto-apply on deploy</h3>
            <p className="mt-1 max-w-[46ch] text-[12px] leading-relaxed text-ivory-faint">
              When ON, every startup/redeploy automatically applies missing tables &amp; columns
              from the models — no manual step. Additive only; nothing is ever dropped.
            </p>
          </div>
          <button
            role="switch"
            aria-checked={!!autoOn}
            onClick={toggleAuto}
            disabled={autoOn === null}
            className={`relative mt-1 h-6 w-11 shrink-0 rounded-full transition-colors disabled:opacity-50 ${autoOn ? 'bg-emerald-500/70' : 'bg-surface-1 border border-border-soft'}`}
          >
            <span className={`absolute top-0.5 h-5 w-5 rounded-full bg-ivory transition-all ${autoOn ? 'left-[22px]' : 'left-0.5'}`} />
          </button>
        </div>
      </Card>

      {/* Check / apply */}
      <Card className="p-6 space-y-4">
        <div className="flex flex-wrap items-center gap-3">
          {diff && (inSync
            ? <span className="rounded-full border border-emerald-500/20 bg-emerald-500/10 px-3 py-1 text-[11px] font-bold uppercase text-emerald-400">In sync</span>
            : <span className="rounded-full border border-amber-500/20 bg-amber-500/10 px-3 py-1 text-[11px] font-bold uppercase text-amber-400">{pending} change(s) pending</span>)}
          <button
            onClick={loadDiff}
            disabled={busy}
            className="h-9 rounded-xl border border-border-soft bg-surface-1 px-4 text-[13px] font-medium hover:bg-surface-2 disabled:opacity-50"
          >
            {busy ? 'Checking…' : 'Check for changes'}
          </button>
          <button
            onClick={applySchema}
            disabled={busy || !!inSync}
            className="h-9 rounded-xl bg-saffron px-4 text-[13px] font-bold text-bg-0 hover:opacity-90 disabled:opacity-50"
          >
            Apply additive changes
          </button>
          {msg && (
            <span className={`text-[12px] ${msg.ok ? 'text-emerald-400' : 'text-red-300'}`}>{msg.text}</span>
          )}
        </div>

        {diff && !inSync && (
          <div className="space-y-3 rounded-xl border border-border-soft bg-surface-1 p-4 text-[12px]">
            {missingTables.length > 0 && (
              <div>
                <div className="mb-1.5 text-[10px] font-bold uppercase tracking-wider text-amber-400">Missing tables ({missingTables.length})</div>
                <div className="flex flex-wrap gap-1.5">{missingTables.map((t) => <code key={t} className="rounded bg-surface-2 px-1.5 py-0.5 font-mono text-ivory">{t}</code>)}</div>
              </div>
            )}
            {missingCols.length > 0 && (
              <div>
                <div className="mb-1.5 text-[10px] font-bold uppercase tracking-wider text-amber-400">Missing columns ({missingCols.length})</div>
                <div className="space-y-0.5">{missingCols.map((c, i) => (
                  <div key={i} className="font-mono text-[11px] text-ivory-faint"><span className="text-ivory">{c.table}.{c.column}</span> — {c.type}</div>
                ))}</div>
              </div>
            )}
            {extraCols.length > 0 && (
              <div>
                <div className="mb-1.5 text-[10px] font-bold uppercase tracking-wider text-ivory-faint">In DB but not in models — review only, never dropped ({extraCols.length})</div>
                <div className="flex flex-wrap gap-1.5">{extraCols.map((c, i) => <code key={i} className="rounded bg-surface-2 px-1.5 py-0.5 font-mono text-ivory-faint">{c.table}.{c.column}</code>)}</div>
              </div>
            )}
          </div>
        )}

        {applyResult && applyResult.notes.length > 0 && (
          <div className="rounded-xl border border-amber-500/20 bg-amber-500/10 p-4 text-[11px] text-amber-300">
            {applyResult.notes.map((n, i) => <div key={i}>• {n}</div>)}
          </div>
        )}
      </Card>

      {/* Sync activity */}
      <Card className="p-6 space-y-3">
        <div className="flex items-center justify-between">
          <h3 className="text-[13px] font-bold uppercase tracking-wide text-ivory-faint">Sync activity</h3>
          <button onClick={loadHistory} className="text-[11px] font-medium text-saffron hover:underline">Refresh</button>
        </div>
        {history.length === 0
          ? <div className="rounded-xl border border-border-soft bg-surface-1 p-4 text-[12px] text-ivory-faint">No sync activity yet.</div>
          : (
            <div className="max-h-64 overflow-auto rounded-xl border border-border-soft">
              <table className="w-full text-[12px]">
                <thead className="bg-surface-1 text-ivory-faint">
                  <tr>
                    <th className="px-3 py-2 text-left font-semibold">When</th>
                    <th className="px-3 py-2 text-left font-semibold">Source</th>
                    <th className="px-3 py-2 text-left font-semibold">Applied</th>
                  </tr>
                </thead>
                <tbody>
                  {history.map((h) => {
                    const nt = (h.created_tables || []).length
                    const nc = (h.added_columns || []).length
                    const ne = (h.errors || []).length
                    return (
                      <tr key={h.id} className="border-t border-border-soft">
                        <td className="whitespace-nowrap px-3 py-2 text-ivory-faint">{h.created_at ? new Date(h.created_at).toLocaleString() : '—'}</td>
                        <td className="px-3 py-2">
                          <span className={`rounded px-1.5 py-0.5 text-[10px] font-bold uppercase ${h.source === 'startup' ? 'bg-violet-500/10 text-violet-400' : 'bg-surface-2 text-ivory-faint'}`}>{h.source}</span>
                        </td>
                        <td className="px-3 py-2 text-ivory">
                          {nt || nc ? `${nt} table(s), ${nc} column(s)` : 'no changes'}
                          {ne > 0 && <span className="ml-1 text-red-300">· {ne} error(s)</span>}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          )}
      </Card>
    </div>
  )
}
