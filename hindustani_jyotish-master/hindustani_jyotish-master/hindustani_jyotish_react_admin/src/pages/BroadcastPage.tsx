import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { BroadcastRecord, BroadcastResult, BroadcastRole } from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

const ROLES: { value: BroadcastRole; label: string; hint: string }[] = [
  { value: 'all', label: 'Everyone', hint: 'All customers + all astrologers' },
  { value: 'user', label: 'Customers', hint: 'The user app only' },
  { value: 'astrologer', label: 'Astrologers', hint: 'The astrologer app only' },
]

export default function BroadcastPage() {
  const [role, setRole] = useState<BroadcastRole>('all')
  const [title, setTitle] = useState('')
  const [body, setBody] = useState('')
  const [sending, setSending] = useState(false)
  const [err, setErr] = useState<string | null>(null)
  const [result, setResult] = useState<BroadcastResult | null>(null)

  const [recent, setRecent] = useState<BroadcastRecord[]>([])
  const [loadingRecent, setLoadingRecent] = useState(false)

  const loadRecent = useCallback(async () => {
    setLoadingRecent(true)
    try {
      const r = await adminApi.listBroadcasts()
      setRecent(r.items)
    } catch {
      /* recent list is a nicety — leave empty on failure */
    } finally {
      setLoadingRecent(false)
    }
  }, [])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void loadRecent() }, [loadRecent])

  async function send() {
    setErr(null)
    setResult(null)
    if (!title.trim()) { setErr('A title is required.'); return }
    if (!body.trim()) { setErr('A message body is required.'); return }
    setSending(true)
    try {
      const res = await adminApi.broadcastNotification({ role, title: title.trim(), body: body.trim() })
      setResult(res)
      setTitle('')
      setBody('')
      await loadRecent()
    } catch (e) {
      setErr((e as Error).message)
    } finally {
      setSending(false)
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="Broadcast Notification"
        subtitle="Send an in-app notification (saved to every recipient's inbox) and a push to their devices. Rows are written even when push is not configured."
        icon={<span className="text-[18px]">📢</span>}
      />

      {/* Composer */}
      <Card className="p-6 sm:p-7 max-w-[720px]">
        {err && <div className="mb-4 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{err}</div>}
        {result && (
          <div className="mb-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-4 py-3 text-[13px] text-emerald-400">
            Sent to {result.recipients} inbox{result.recipients === 1 ? '' : 'es'}
            {result.skipped
              ? ' — push skipped (Firebase not configured), but inbox rows were written.'
              : ` — push delivered to ${result.sent} device(s).`}
          </div>
        )}

        <label className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Audience</label>
        <div className="mt-2 grid gap-2.5 sm:grid-cols-3">
          {ROLES.map(r => (
            <button
              key={r.value}
              onClick={() => setRole(r.value)}
              className={`rounded-xl border px-4 py-3 text-left transition-colors ${
                role === r.value
                  ? 'border-saffron bg-saffron-soft'
                  : 'border-border-soft bg-surface-1 hover:bg-surface-2'
              }`}
            >
              <div className="text-[13px] font-bold">{r.label}</div>
              <div className="mt-0.5 text-[11px] text-ivory-faint">{r.hint}</div>
            </button>
          ))}
        </div>

        <div className="mt-5">
          <label className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Title</label>
          <input
            value={title}
            maxLength={120}
            onChange={e => setTitle(e.target.value)}
            placeholder="e.g. Festival offer"
            className="mt-2 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-4 text-[14px] outline-none focus:border-saffron focus:bg-surface-2"
          />
        </div>

        <div className="mt-4">
          <label className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Message</label>
          <textarea
            value={body}
            maxLength={500}
            rows={4}
            onChange={e => setBody(e.target.value)}
            placeholder="Write the notification your users will read…"
            className="mt-2 w-full rounded-xl border border-border-soft bg-surface-1 px-4 py-3 text-[14px] outline-none focus:border-saffron focus:bg-surface-2 resize-y"
          />
          <div className="mt-1 text-right text-[11px] text-ivory-faint">{body.length}/500</div>
        </div>

        <button
          disabled={sending}
          onClick={send}
          className="mt-4 h-11 rounded-xl bg-ivory text-bg-0 px-6 text-[13px] font-bold hover:opacity-90 disabled:opacity-50 shadow-sm"
        >
          {sending ? 'Sending…' : 'Send broadcast'}
        </button>
      </Card>

      {/* Recently sent */}
      <Card className="p-0 overflow-hidden">
        <div className="flex items-center justify-between gap-3 border-b border-border-soft p-5">
          <div>
            <div className="text-[13px] font-bold">Recently sent</div>
            <div className="mt-0.5 text-[12px] text-ivory-faint">The last broadcasts, newest first.</div>
          </div>
          <button onClick={loadRecent} className="h-9 rounded-xl border border-border-soft bg-surface-raised px-4 text-[12px] font-bold hover:bg-surface-1">Refresh</button>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse">
            <thead>
              <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                <th className="px-5 py-3">Title</th>
                <th className="px-5 py-3">Audience</th>
                <th className="px-5 py-3 text-right">Recipients</th>
                <th className="px-5 py-3">Sent</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border-soft/60">
              {loadingRecent && <tr><td colSpan={4} className="py-10 text-center text-ivory-faint">Loading…</td></tr>}
              {!loadingRecent && recent.map(r => (
                <tr key={r.id} className="hover:bg-surface-1/50 align-top">
                  <td className="px-5 py-3.5">
                    <div className="text-[13px] font-semibold">{r.title}</div>
                    {r.body && <div className="mt-0.5 max-w-[420px] text-[12px] text-ivory-faint">{r.body}</div>}
                  </td>
                  <td className="px-5 py-3.5 text-[12px] capitalize">{r.role}</td>
                  <td className="px-5 py-3.5 text-right font-mono text-[12px]">{r.recipient_count}</td>
                  <td className="px-5 py-3.5 text-[12px] text-ivory-faint">{r.created_at ? new Date(r.created_at).toLocaleString('en-IN') : '—'}</td>
                </tr>
              ))}
              {!loadingRecent && recent.length === 0 && <tr><td colSpan={4} className="py-16 text-center text-[13px] text-ivory-faint">No broadcasts sent yet.</td></tr>}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  )
}
