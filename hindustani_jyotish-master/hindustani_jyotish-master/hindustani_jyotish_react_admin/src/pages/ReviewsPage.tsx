import { useMemo, useState } from 'react'
import { adminApi } from '../api/endpoints'
import { ConfirmDialog } from '../components/ConfirmDialog'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { PageHeader, Card } from '../components/ui/PageShell'

interface Review {
  id: string
  consultation_id: string
  user_id: string
  user_name: string | null
  astrologer_id: string
  astrologer_name: string | null
  rating: number
  review: string | null
  created_at: string
}

const dateOnly = (v: string) => new Date(v).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })
const stars = (n: number) => '★'.repeat(Math.max(0, Math.min(5, n))) + '☆'.repeat(Math.max(0, 5 - n))

export default function ReviewsPage() {
  const paged = usePagedData<Review>('/admin/reviews')
  const [search, setSearch] = useState('')
  const [edit, setEdit] = useState<Review | null>(null)
  const [remove, setRemove] = useState<Review | null>(null)
  const [removing, setRemoving] = useState(false)
  const [removeError, setRemoveError] = useState<string | null>(null)

  const visible = useMemo(() => {
    const q = search.trim().toLowerCase()
    if (!q) return paged.rows
    return paged.rows.filter(r => [r.user_name, r.astrologer_name, r.review, String(r.rating)].some(v => v && String(v).toLowerCase().includes(q)))
  }, [paged.rows, search])

  async function confirmDelete() {
    if (!remove) return
    setRemoving(true); setRemoveError(null)
    try { await adminApi.deleteReview(remove.id); setRemove(null); paged.reload() }
    catch (e) { setRemoveError((e as Error).message) } finally { setRemoving(false) }
  }

  return (
    <div className="space-y-5">
      <PageHeader
        title="Reviews"
        subtitle="Every rating customers left after a consultation. Edit or remove a review — astrologer averages update automatically."
        icon={<span className="text-[18px]">⭐</span>}
        actions={<><SearchBox value={search} onChange={setSearch} placeholder="Customer, astrologer, text…" /><button onClick={paged.reload} className="grid h-[42px] w-[42px] place-items-center rounded-full border border-border-soft bg-surface-raised shadow-sm">↻</button></>}
      />

      {paged.error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{paged.error}</div>}

      {paged.loading && paged.rows.length === 0 ? (
        <Card><div className="p-10 text-center text-ivory-faint">Loading reviews…</div></Card>
      ) : (
        <>
          <div className="hidden md:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                    <th className="px-5 py-3.5">Customer</th>
                    <th className="px-5 py-3.5">Astrologer</th>
                    <th className="px-5 py-3.5">Rating</th>
                    <th className="px-5 py-3.5">Review</th>
                    <th className="px-5 py-3.5">When</th>
                    <th className="px-5 py-3.5 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border-soft/60">
                  {visible.map(r => (
                    <tr key={r.id} className="hover:bg-surface-1/50 transition-colors">
                      <td className="px-5 py-4 text-[13px] font-semibold">{r.user_name ?? <span className="font-mono text-[11px] text-ivory-faint">{r.user_id.slice(0, 8)}</span>}</td>
                      <td className="px-5 py-4 text-[13px]">{r.astrologer_name ?? <span className="font-mono text-[11px] text-ivory-faint">{r.astrologer_id.slice(0, 8)}</span>}</td>
                      <td className="px-5 py-4"><span className="font-mono text-[13px] text-amber-400">{stars(r.rating)}</span></td>
                      <td className="px-5 py-4 max-w-[320px] text-[12.5px] text-ivory-dim"><span className="line-clamp-2">{r.review || <span className="text-ivory-faint">—</span>}</span></td>
                      <td className="px-5 py-4 text-[12px] text-ivory-faint">{dateOnly(r.created_at)}</td>
                      <td className="px-5 py-4 text-right">
                        <div className="inline-flex gap-1.5">
                          <button onClick={() => setEdit(r)} className="h-8 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2">Edit</button>
                          <button onClick={() => setRemove(r)} className="h-8 rounded-full border border-red-500/20 bg-red-500/10 px-4 text-[12px] font-bold text-red-400 hover:bg-red-500/20">Delete</button>
                        </div>
                      </td>
                    </tr>
                  ))}
                  {visible.length === 0 && <tr><td colSpan={6} className="py-16 text-center text-[13px] text-ivory-faint">No reviews yet.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile */}
          <div className="grid gap-3 md:hidden">
            {visible.map(r => (
              <div key={r.id} className="rounded-xl border border-border-soft bg-surface-raised p-4">
                <div className="flex items-center justify-between">
                  <div className="text-[13px] font-semibold">{r.user_name ?? r.user_id.slice(0, 8)}</div>
                  <span className="font-mono text-[12px] text-amber-400">{stars(r.rating)}</span>
                </div>
                <div className="mt-1 text-[11px] text-ivory-faint">for {r.astrologer_name ?? r.astrologer_id.slice(0, 8)} · {dateOnly(r.created_at)}</div>
                {r.review && <p className="mt-2 text-[12.5px] text-ivory-dim">{r.review}</p>}
                <div className="mt-3 flex gap-2">
                  <button onClick={() => setEdit(r)} className="flex-1 h-9 rounded-full border border-border-soft bg-surface-1 text-[12px] font-bold">Edit</button>
                  <button onClick={() => setRemove(r)} className="flex-1 h-9 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-[12px] font-bold">Delete</button>
                </div>
              </div>
            ))}
          </div>

          <Pager page={paged.page} size={paged.size} total={search.trim() ? null : paged.total} hasPrev={paged.hasPrev} hasNext={!search.trim() && paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={visible.length} />
        </>
      )}

      {edit && <EditReviewModal review={edit} onClose={() => setEdit(null)} onDone={() => { setEdit(null); paged.reload() }} />}
      {remove && <ConfirmDialog title="Delete review" message={`Remove this ${remove.rating}-star review? The astrologer's average rating will be recalculated. The consultation record itself is kept.`} confirmLabel="Delete review" busy={removing} error={removeError} onConfirm={confirmDelete} onClose={() => { setRemove(null); setRemoveError(null) }} />}
    </div>
  )
}

function EditReviewModal({ review, onClose, onDone }: { review: Review; onClose: () => void; onDone: () => void }) {
  const [rating, setRating] = useState(review.rating)
  const [text, setText] = useState(review.review ?? '')
  const [error, setError] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)

  async function submit() {
    setSaving(true); setError(null)
    try {
      await adminApi.editReview(review.id, { rating, review: text.trim() || null })
      onDone()
    } catch (e) { setError((e as Error).message) } finally { setSaving(false) }
  }

  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4" onClick={onClose}>
      <div className="w-full max-w-[460px] rounded-xl border border-border-soft bg-surface-raised p-6 shadow-2xl animate-pop-in" onClick={e => e.stopPropagation()}>
        <div className="flex items-center justify-between">
          <h3 className="text-[16px] font-bold">Edit review</h3>
          <button onClick={onClose} className="grid h-8 w-8 place-items-center rounded-full bg-surface-1 border border-border-soft">✕</button>
        </div>
        <p className="mt-1 text-[11px] text-ivory-faint">{review.user_name ?? 'Customer'} → {review.astrologer_name ?? 'Astrologer'}</p>
        {error && <div className="mt-3 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}
        <div className="mt-4 grid gap-4">
          <div>
            <div className="text-[12px] font-semibold text-ivory-dim">Rating</div>
            <div className="mt-1.5 flex gap-1">
              {[1, 2, 3, 4, 5].map(n => (
                <button key={n} onClick={() => setRating(n)} className={`grid h-10 w-10 place-items-center rounded-xl border text-[18px] transition-colors ${n <= rating ? 'border-amber-500/30 bg-amber-500/10 text-amber-400' : 'border-border-soft bg-surface-1 text-ivory-faint'}`}>★</button>
              ))}
            </div>
          </div>
          <label className="text-[12px] font-semibold text-ivory-dim">
            Review text (leave empty to keep the rating only)
            <textarea value={text} onChange={e => setText(e.target.value)} rows={4} className="mt-1.5 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 py-2.5 text-[13px] outline-none focus:border-saffron resize-y" />
          </label>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <button onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Cancel</button>
          <button disabled={saving} onClick={submit} className="h-10 rounded-full bg-ivory text-bg-0 px-6 text-[13px] font-bold disabled:opacity-50">{saving ? 'Saving…' : 'Save changes'}</button>
        </div>
      </div>
    </div>
  )
}
