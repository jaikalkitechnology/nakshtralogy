import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { SupportTicket, TicketStatus } from '../api/types'
import { PageHeader } from '../components/ui/PageShell'

const TABS: { value: '' | TicketStatus; label: string }[] = [
  { value: '', label: 'All' },
  { value: 'open', label: 'Open' },
  { value: 'pending', label: 'Awaiting user' },
  { value: 'closed', label: 'Closed' },
]

const STATUS_STYLE: Record<TicketStatus, string> = {
  open: 'bg-sky-500/10 text-sky-400 border-sky-500/20',
  pending: 'bg-amber-500/10 text-amber-400 border-amber-500/20',
  closed: 'bg-surface-2 text-ivory-faint border-border-soft',
}

const fmt = (v: string | null) => (v ? new Date(v).toLocaleString() : '—')

/** Admin helpdesk: list tickets (filter by status), open a thread, reply and
 *  close. Replying moves a ticket to `pending` and best-effort notifies the
 *  requester via push. */
export default function SupportTickets() {
  const [status, setStatus] = useState<'' | TicketStatus>('')
  const [rows, setRows] = useState<SupportTicket[]>([])
  const [counts, setCounts] = useState<Record<string, number>>({})
  const [error, setError] = useState<string | null>(null)
  const [openId, setOpenId] = useState<string | null>(null)

  const load = useCallback(async () => {
    try {
      const data = await adminApi.listTickets(status || undefined)
      setRows(data.items)
      setCounts(data.counts ?? {})
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    }
  }, [status])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  return (
    <div className="space-y-6">
      <PageHeader
        title="Support Tickets"
        subtitle="Helpdesk queue for both apps — reply and close user & astrologer tickets."
        icon={<span className="text-[18px]">🎫</span>}
      />

      {error && (
        <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error}</div>
      )}

      <div className="flex flex-wrap gap-2">
        {TABS.map((t) => {
          const c = t.value ? counts[t.value] : undefined
          return (
            <button
              key={t.value}
              onClick={() => setStatus(t.value)}
              className={`h-8 rounded-full border px-4 text-[12px] font-semibold ${status === t.value ? 'bg-saffron/15 border-saffron/40 text-saffron' : 'border-border-soft bg-surface-1 text-ivory-dim'}`}
            >
              {t.label}{c != null ? ` (${c})` : ''}
            </button>
          )
        })}
      </div>

      <div className="overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse">
            <thead>
              <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                <th className="px-5 py-3.5">Subject</th>
                <th className="px-5 py-3.5">Requester</th>
                <th className="px-5 py-3.5">Role</th>
                <th className="px-5 py-3.5">Status</th>
                <th className="px-5 py-3.5">Updated</th>
                <th className="px-5 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border-soft/60">
              {rows.map((t) => (
                <tr key={t.id} className="hover:bg-surface-1/50">
                  <td className="px-5 py-4 text-[13px]"><span className="line-clamp-1 max-w-[280px]">{t.subject}</span></td>
                  <td className="px-5 py-4 text-[13px]">{t.requester_name || <span className="font-mono text-[11px]">{t.requester_id.slice(0, 8)}</span>}</td>
                  <td className="px-5 py-4 text-[13px] capitalize">{t.requester_role}</td>
                  <td className="px-5 py-4 text-[13px]"><span className={`rounded-full px-2.5 py-1 text-[11px] font-bold border ${STATUS_STYLE[t.status]}`}>{t.status}</span></td>
                  <td className="px-5 py-4 text-[12px] text-ivory-dim">{fmt(t.updated_at)}</td>
                  <td className="px-5 py-4 text-right">
                    <button onClick={() => setOpenId(t.id)} className="h-8 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2">Open</button>
                  </td>
                </tr>
              ))}
              {rows.length === 0 && (
                <tr><td colSpan={6} className="py-16 text-center text-[13px] text-ivory-faint">No tickets in this view.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {openId && (
        <TicketThread id={openId} onClose={() => setOpenId(null)} onChanged={() => void load()} />
      )}
    </div>
  )
}

function TicketThread({ id, onClose, onChanged }: { id: string; onClose: () => void; onChanged: () => void }) {
  const [ticket, setTicket] = useState<SupportTicket | null>(null)
  const [reply, setReply] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  const load = useCallback(async () => {
    try { setTicket(await adminApi.ticketDetail(id)); setError(null) }
    catch (e) { setError((e as Error).message) }
  }, [id])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  async function send() {
    if (!reply.trim()) return
    setBusy(true); setError(null)
    try {
      await adminApi.replyTicket(id, reply.trim())
      setReply('')
      await load()
      onChanged()
    } catch (e) { setError((e as Error).message) } finally { setBusy(false) }
  }

  async function close() {
    setBusy(true); setError(null)
    try { await adminApi.closeTicket(id); await load(); onChanged() }
    catch (e) { setError((e as Error).message) } finally { setBusy(false) }
  }

  const closed = ticket?.status === 'closed'

  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4" onClick={onClose}>
      <div className="flex w-full max-w-[600px] max-h-[90vh] flex-col rounded-xl border border-border-soft bg-surface-raised shadow-2xl animate-pop-in" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-start justify-between gap-3 border-b border-border-soft p-5">
          <div>
            <h3 className="text-[15px] font-bold">{ticket?.subject ?? 'Ticket'}</h3>
            {ticket && (
              <div className="mt-1 flex items-center gap-2 text-[11px] text-ivory-dim">
                <span className="capitalize">{ticket.requester_role}</span>
                <span>·</span>
                <span>{ticket.requester_name || ticket.requester_id.slice(0, 8)}</span>
                <span>·</span>
                <span className={`rounded-full px-2 py-0.5 font-bold border ${STATUS_STYLE[ticket.status]}`}>{ticket.status}</span>
              </div>
            )}
          </div>
          <button onClick={onClose} className="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-surface-1 border border-border-soft">✕</button>
        </div>

        {error && <div className="mx-5 mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}

        <div className="flex-1 space-y-3 overflow-y-auto p-5">
          {(ticket?.messages ?? []).map((m) => {
            const admin = m.sender === 'admin'
            return (
              <div key={m.id} className={`flex ${admin ? 'justify-end' : 'justify-start'}`}>
                <div className={`max-w-[78%] rounded-2xl border px-4 py-2.5 ${admin ? 'bg-saffron/10 border-saffron/20' : 'bg-surface-1 border-border-soft'}`}>
                  <div className="mb-1 text-[10px] font-bold uppercase tracking-wide text-ivory-faint">{admin ? 'Admin' : m.sender}</div>
                  <div className="text-[13px] whitespace-pre-wrap">{m.body}</div>
                  <div className="mt-1 text-[10px] text-ivory-faint">{fmt(m.created_at)}</div>
                </div>
              </div>
            )
          })}
          {ticket && (ticket.messages?.length ?? 0) === 0 && (
            <div className="py-8 text-center text-[13px] text-ivory-faint">No messages.</div>
          )}
        </div>

        <div className="border-t border-border-soft p-4">
          <textarea
            rows={2}
            value={reply}
            onChange={(e) => setReply(e.target.value)}
            placeholder={closed ? 'Ticket is closed — reply to continue' : 'Type a reply…'}
            className="w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 py-2.5 text-[13px] outline-none focus:border-saffron"
          />
          <div className="mt-2.5 flex justify-between gap-2">
            <button onClick={close} disabled={busy || closed} className="h-9 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold disabled:opacity-40">Close ticket</button>
            <button onClick={send} disabled={busy || !reply.trim()} className="h-9 rounded-full bg-ivory text-bg-0 px-6 text-[13px] font-bold disabled:opacity-50">{busy ? '…' : 'Send reply'}</button>
          </div>
        </div>
      </div>
    </div>
  )
}
