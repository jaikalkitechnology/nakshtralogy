import { useCallback, useEffect, useMemo, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { TdsReport } from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

/** Current Indian financial year label, e.g. "2025-26". */
function currentFY(): string {
  const now = new Date()
  const y = now.getMonth() >= 3 ? now.getFullYear() : now.getFullYear() - 1
  return `${y}-${String(y + 1).slice(-2)}`
}

function periodOptions(): { value: string; label: string }[] {
  const now = new Date()
  const startY = now.getMonth() >= 3 ? now.getFullYear() : now.getFullYear() - 1
  const out: { value: string; label: string }[] = []
  for (let i = 0; i < 3; i++) {
    const y = startY - i
    const fy = `${y}-${String(y + 1).slice(-2)}`
    out.push({ value: fy, label: `FY ${fy}` })
    for (let q = 1; q <= 4; q++) out.push({ value: `${fy}-Q${q}`, label: `FY ${fy} · Q${q}` })
  }
  return out
}

export default function TdsPage() {
  // ── Settings ──
  const [ratePct, setRatePct] = useState('')
  const [noPanPct, setNoPanPct] = useState('')
  const [panRequired, setPanRequired] = useState(true)
  const [savedMsg, setSavedMsg] = useState(false)
  const [saving, setSaving] = useState(false)
  const [settingsErr, setSettingsErr] = useState<string | null>(null)

  const loadSettings = useCallback(async () => {
    try {
      const s = await adminApi.getTdsSettings()
      setRatePct(String(Math.round((s.rate || 0) * 10000) / 100))
      setNoPanPct(String(Math.round((s.no_pan_rate || 0) * 10000) / 100))
      setPanRequired(!!s.pan_required)
      setSettingsErr(null)
    } catch (e) { setSettingsErr((e as Error).message) }
  }, [])

  async function saveSettings() {
    setSettingsErr(null); setSavedMsg(false)
    const r = Number(ratePct), n = Number(noPanPct)
    if (Number.isNaN(r) || r < 0 || r > 100) { setSettingsErr('Rate must be 0-100%'); return }
    if (Number.isNaN(n) || n < 0 || n > 100) { setSettingsErr('No-PAN rate must be 0-100%'); return }
    setSaving(true)
    try {
      await adminApi.saveTdsSettings({ rate: r / 100, pan_required: panRequired, no_pan_rate: n / 100 })
      setSavedMsg(true)
    } catch (e) { setSettingsErr((e as Error).message) } finally { setSaving(false) }
  }

  // ── Challan report ──
  const [period, setPeriod] = useState(currentFY())
  const [report, setReport] = useState<TdsReport | null>(null)
  const [loading, setLoading] = useState(false)
  const [reportErr, setReportErr] = useState<string | null>(null)
  const options = useMemo(periodOptions, [])

  const loadReport = useCallback(async (p: string) => {
    setLoading(true); setReportErr(null)
    try { setReport(await adminApi.tdsReport(p)) }
    catch (e) { setReportErr((e as Error).message) } finally { setLoading(false) }
  }, [])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void loadSettings() }, [loadSettings])
  useEffect(() => { void loadReport(period) }, [period, loadReport])

  return (
    <div className="space-y-6">
      <PageHeader
        title="TDS on Payouts"
        subtitle="Tax deducted at source against each astrologer's PAN. Set the rate, block payouts without a PAN, and file the challan report per financial year."
        icon={<span className="text-[18px]">🧾</span>}
      />

      {/* Settings */}
      <Card className="p-6 sm:p-7 max-w-[720px]">
        {settingsErr && <div className="mb-4 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{settingsErr}</div>}
        {savedMsg && <div className="mb-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-4 py-3 text-[13px] text-emerald-400 flex items-center gap-2"><span className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse" />Saved.</div>}

        <div className="flex items-center justify-between">
          <div><div className="text-[12px] font-bold uppercase tracking-widest text-ivory-faint">Deduction settings</div><div className="mt-1 text-[12px] text-ivory-faint">Applied to every payout on request</div></div>
          <span className="rounded-full bg-amber-500/10 border border-amber-500/20 px-3 py-1 text-[11px] font-bold text-amber-400">Live setting</span>
        </div>

        <div className="mt-6 grid gap-5 sm:grid-cols-2">
          <div>
            <label className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">TDS rate (with PAN)</label>
            <div className="relative mt-2">
              <input type="number" min={0} max={100} step="0.1" value={ratePct} onChange={e => { setSavedMsg(false); setRatePct(e.target.value) }} className="h-[52px] w-full rounded-xl border border-border-soft bg-surface-1 px-5 pr-12 text-[20px] font-bold outline-none focus:border-saffron focus:bg-surface-2 shadow-sm" />
              <span className="pointer-events-none absolute right-5 top-1/2 -translate-y-1/2 text-[16px] font-bold text-ivory-faint">%</span>
            </div>
          </div>
          <div>
            <label className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">No-PAN rate (if not blocked)</label>
            <div className="relative mt-2">
              <input type="number" min={0} max={100} step="0.1" value={noPanPct} disabled={panRequired} onChange={e => { setSavedMsg(false); setNoPanPct(e.target.value) }} className="h-[52px] w-full rounded-xl border border-border-soft bg-surface-1 px-5 pr-12 text-[20px] font-bold outline-none focus:border-saffron focus:bg-surface-2 shadow-sm disabled:opacity-40" />
              <span className="pointer-events-none absolute right-5 top-1/2 -translate-y-1/2 text-[16px] font-bold text-ivory-faint">%</span>
            </div>
          </div>
        </div>

        <label className="mt-5 flex items-center gap-3 cursor-pointer select-none">
          <input type="checkbox" checked={panRequired} onChange={e => { setSavedMsg(false); setPanRequired(e.target.checked) }} className="h-5 w-5 accent-saffron" />
          <span className="text-[13px]"><span className="font-semibold">Require a valid PAN</span> — block any payout when the astrologer has no valid PAN on file (recommended).</span>
        </label>

        <div className="mt-5 rounded-xl bg-gradient-to-br from-amber-500/10 to-orange-500/10 border border-amber-500/15 p-4 text-[12px] text-ivory-dim flex gap-3">
          <span className="text-[16px]">💡</span>
          <span>TDS is withheld on the gross withdrawal (already net of platform commission). At 10%, a ₹1,000 payout deducts ₹100 TDS and pays ₹900 to the bank. With "Require PAN" on, payouts without a PAN are blocked until the astrologer adds one.</span>
        </div>

        <button disabled={saving} onClick={saveSettings} className="mt-6 h-11 rounded-xl bg-ivory text-bg-0 px-6 text-[13px] font-bold hover:opacity-90 disabled:opacity-50 shadow-sm">{saving ? 'Saving…' : 'Save settings'}</button>
      </Card>

      {/* Challan report */}
      <Card className="p-0 overflow-hidden">
        <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border-soft p-5">
          <div>
            <div className="text-[13px] font-bold">TDS Challan Report</div>
            <div className="mt-0.5 text-[12px] text-ivory-faint">TDS collected on settled payouts, per astrologer (with PAN).</div>
          </div>
          <div className="flex items-center gap-2">
            <select value={period} onChange={e => setPeriod(e.target.value)} className="h-10 rounded-xl border border-border-soft bg-surface-1 px-3 text-[13px] outline-none focus:border-saffron">
              {options.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
            <button onClick={() => adminApi.exportTdsReportCsv(period)} className="h-10 rounded-xl border border-border-soft bg-surface-raised px-4 text-[12px] font-bold hover:bg-surface-1">Export CSV</button>
          </div>
        </div>

        {reportErr && <div className="m-4 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{reportErr}</div>}

        {report && (
          <div className="grid grid-cols-2 gap-3 p-5 sm:grid-cols-4">
            <Stat label="TDS collected" value={`₹${Number(report.totals.tds).toLocaleString('en-IN')}`} accent="text-amber-400" />
            <Stat label="Gross payouts" value={`₹${Number(report.totals.gross).toLocaleString('en-IN')}`} />
            <Stat label="Net paid" value={`₹${Number(report.totals.net).toLocaleString('en-IN')}`} accent="text-emerald-400" />
            <Stat label="Astrologers" value={`${report.totals.astrologers} · ${report.totals.payouts} payouts`} />
          </div>
        )}

        <div className="overflow-x-auto">
          <table className="w-full border-collapse">
            <thead><tr className="border-y border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint"><th className="px-5 py-3">Astrologer</th><th className="px-5 py-3">PAN</th><th className="px-5 py-3 text-right">Gross</th><th className="px-5 py-3 text-right">TDS</th><th className="px-5 py-3 text-right">Net</th><th className="px-5 py-3 text-right">Payouts</th></tr></thead>
            <tbody className="divide-y divide-border-soft/60">
              {loading && <tr><td colSpan={6} className="py-10 text-center text-ivory-faint">Loading…</td></tr>}
              {!loading && report?.items.map(r => (
                <tr key={r.astrologer_id} className="hover:bg-surface-1/50">
                  <td className="px-5 py-3.5 text-[13px] font-semibold">{r.astrologer_name ?? <span className="font-mono text-[11px] text-ivory-faint">{r.astrologer_id.slice(0, 8)}</span>}</td>
                  <td className="px-5 py-3.5 font-mono text-[12px]">{r.pan ?? '—'}</td>
                  <td className="px-5 py-3.5 text-right font-mono text-[12px]">₹{Number(r.gross).toLocaleString('en-IN')}</td>
                  <td className="px-5 py-3.5 text-right font-mono text-[12px] text-amber-400">₹{Number(r.tds).toLocaleString('en-IN')}</td>
                  <td className="px-5 py-3.5 text-right font-mono text-[12px] text-emerald-400">₹{Number(r.net).toLocaleString('en-IN')}</td>
                  <td className="px-5 py-3.5 text-right text-[12px]">{r.payouts}</td>
                </tr>
              ))}
              {!loading && report && report.items.length === 0 && <tr><td colSpan={6} className="py-16 text-center text-[13px] text-ivory-faint">No TDS collected in this period.</td></tr>}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  )
}

function Stat({ label, value, accent }: { label: string; value: string; accent?: string }) {
  return (
    <div className="rounded-xl border border-border-soft bg-surface-1 p-4">
      <div className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{label}</div>
      <div className={`mt-1 text-[18px] font-bold ${accent ?? ''}`}>{value}</div>
    </div>
  )
}
