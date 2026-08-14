import { useCallback, useEffect, useState, type FormEvent } from 'react'
import { adminApi } from '../api/endpoints'
import type { Faq, FaqApp, FaqInput } from '../api/types'
import { PageHeader } from '../components/ui/PageShell'

const APPS: { value: FaqApp; label: string }[] = [
  { value: 'both', label: 'Both apps' },
  { value: 'user', label: 'User app' },
  { value: 'astro', label: 'Astrologer app' },
]

const APP_FILTERS: { value: string; label: string }[] = [
  { value: '', label: 'All' },
  ...APPS,
]

function emptyForm(): FaqInput {
  return {
    app: 'both',
    category: '',
    question_en: '',
    answer_en: '',
    question_hi: '',
    answer_hi: '',
    sort_order: 0,
    is_active: true,
  }
}

/** Admin FAQ CRUD: per app (user/astro/both), paired English + Hindi text,
 *  sort order and an active toggle. One row carries both languages; the apps'
 *  public feed serves the caller's language (English fallback per field). */
export default function FaqManager() {
  const [rows, setRows] = useState<Faq[]>([])
  const [filter, setFilter] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [editing, setEditing] = useState<Faq | null>(null)
  const [creating, setCreating] = useState(false)

  const load = useCallback(async () => {
    try {
      const data = await adminApi.listFaqs(filter || undefined)
      setRows(Array.isArray(data) ? data : [])
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    }
  }, [filter])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  async function remove(id: string) {
    if (!confirm('Delete this FAQ?')) return
    try { await adminApi.deleteFaq(id); await load() }
    catch (e) { setError((e as Error).message) }
  }

  async function move(row: Faq, dir: -1 | 1) {
    // Swap sort_order with the adjacent row in the current (sorted) list.
    const idx = rows.findIndex((r) => r.id === row.id)
    const other = rows[idx + dir]
    if (!other) return
    try {
      await adminApi.reorderFaqs([
        { id: row.id, sort_order: other.sort_order },
        { id: other.id, sort_order: row.sort_order },
      ])
      await load()
    } catch (e) { setError((e as Error).message) }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title="FAQ"
        subtitle="Help articles shown in each app's Help & Support screen — per app, in English and Hindi."
        icon={<span className="text-[18px]">❓</span>}
        actions={
          <button
            onClick={() => setCreating(true)}
            className="h-9 rounded-full bg-ivory text-bg-0 px-5 text-[13px] font-bold hover:opacity-90"
          >
            + Add FAQ
          </button>
        }
      />

      {error && (
        <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error}</div>
      )}

      <div className="flex flex-wrap gap-2">
        {APP_FILTERS.map((f) => (
          <button
            key={f.value}
            onClick={() => setFilter(f.value)}
            className={`h-8 rounded-full border px-4 text-[12px] font-semibold ${filter === f.value ? 'bg-saffron/15 border-saffron/40 text-saffron' : 'border-border-soft bg-surface-1 text-ivory-dim'}`}
          >
            {f.label}
          </button>
        ))}
      </div>

      <div className="overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full border-collapse">
            <thead>
              <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                <th className="px-5 py-3.5">Order</th>
                <th className="px-5 py-3.5">App</th>
                <th className="px-5 py-3.5">Category</th>
                <th className="px-5 py-3.5">Question (EN)</th>
                <th className="px-5 py-3.5">Hindi</th>
                <th className="px-5 py-3.5">Active</th>
                <th className="px-5 py-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border-soft/60">
              {rows.map((r, i) => (
                <tr key={r.id} className="hover:bg-surface-1/50">
                  <td className="px-5 py-4 text-[13px]">
                    <div className="flex items-center gap-1">
                      <button onClick={() => move(r, -1)} disabled={i === 0} className="grid h-6 w-6 place-items-center rounded border border-border-soft disabled:opacity-30">↑</button>
                      <button onClick={() => move(r, 1)} disabled={i === rows.length - 1} className="grid h-6 w-6 place-items-center rounded border border-border-soft disabled:opacity-30">↓</button>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-[13px]"><span className="rounded-full bg-surface-1 border border-border-soft px-2.5 py-1 text-[11px] capitalize">{r.app}</span></td>
                  <td className="px-5 py-4 text-[13px]">{r.category || <span className="text-ivory-faint">—</span>}</td>
                  <td className="px-5 py-4 text-[13px]"><span className="line-clamp-1 max-w-[280px]">{r.question_en}</span></td>
                  <td className="px-5 py-4 text-[13px]">{r.question_hi ? <span className="text-emerald-400">✓</span> : <span className="text-ivory-faint">—</span>}</td>
                  <td className="px-5 py-4 text-[13px]">
                    <span className={`rounded-full px-2.5 py-1 text-[11px] font-bold border ${r.is_active ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' : 'bg-surface-2 text-ivory-faint border-border-soft'}`}>{r.is_active ? 'Yes' : 'No'}</span>
                  </td>
                  <td className="px-5 py-4 text-right">
                    <div className="inline-flex gap-1.5">
                      <button onClick={() => setEditing(r)} className="h-8 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2">Edit</button>
                      <button onClick={() => remove(r.id)} className="h-8 rounded-full bg-red-500/10 border border-red-500/20 px-4 text-[12px] font-bold text-red-400">Delete</button>
                    </div>
                  </td>
                </tr>
              ))}
              {rows.length === 0 && (
                <tr><td colSpan={7} className="py-16 text-center text-[13px] text-ivory-faint">No FAQ yet — add your first article.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {(creating || editing) && (
        <FaqModal
          faq={editing}
          onClose={() => { setCreating(false); setEditing(null) }}
          onDone={() => { setCreating(false); setEditing(null); void load() }}
        />
      )}
    </div>
  )
}

function FaqModal({ faq, onClose, onDone }: { faq: Faq | null; onClose: () => void; onDone: () => void }) {
  const [form, setForm] = useState<FaqInput>(() =>
    faq
      ? {
          app: faq.app,
          category: faq.category ?? '',
          question_en: faq.question_en,
          answer_en: faq.answer_en,
          question_hi: faq.question_hi ?? '',
          answer_hi: faq.answer_hi ?? '',
          sort_order: faq.sort_order,
          is_active: faq.is_active,
        }
      : emptyForm(),
  )
  const [error, setError] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)

  function set<K extends keyof FaqInput>(key: K, value: FaqInput[K]) {
    setForm((prev) => ({ ...prev, [key]: value }))
  }

  async function submit(e: FormEvent) {
    e.preventDefault()
    setSaving(true); setError(null)
    try {
      if (faq) await adminApi.updateFaq(faq.id, form)
      else await adminApi.createFaq(form)
      onDone()
    } catch (err) {
      setError((err as Error).message)
      setSaving(false)
    }
  }

  const inputCls = 'h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 text-[13px] outline-none focus:border-saffron'
  const areaCls = 'w-full rounded-xl border border-border-soft bg-surface-1 px-3.5 py-2.5 text-[13px] outline-none focus:border-saffron'

  return (
    <div className="fixed inset-0 z-[60] grid place-items-center bg-slate-900/40 p-4" onClick={onClose}>
      <form onSubmit={submit} className="w-full max-w-[640px] max-h-[90vh] overflow-y-auto rounded-xl border border-border-soft bg-surface-raised p-6 shadow-2xl animate-pop-in" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between">
          <h3 className="text-[16px] font-bold">{faq ? 'Edit FAQ' : 'New FAQ'}</h3>
          <button type="button" onClick={onClose} className="grid h-8 w-8 place-items-center rounded-full bg-surface-1 border border-border-soft">✕</button>
        </div>
        {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[13px] text-red-400">{error}</div>}
        <div className="mt-5 grid gap-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <label className="text-[11px] font-semibold text-ivory-dim">App
              <select value={form.app} onChange={(e) => set('app', e.target.value as FaqApp)} className={`mt-1.5 ${inputCls}`}>
                {APPS.map((a) => <option key={a.value} value={a.value}>{a.label}</option>)}
              </select>
            </label>
            <label className="text-[11px] font-semibold text-ivory-dim">Category
              <input value={form.category ?? ''} onChange={(e) => set('category', e.target.value)} placeholder="Wallet, Calls…" className={`mt-1.5 ${inputCls}`} />
            </label>
          </div>
          <label className="text-[11px] font-semibold text-ivory-dim">Question (English)
            <input required value={form.question_en} onChange={(e) => set('question_en', e.target.value)} className={`mt-1.5 ${inputCls}`} />
          </label>
          <label className="text-[11px] font-semibold text-ivory-dim">Answer (English)
            <textarea required rows={3} value={form.answer_en} onChange={(e) => set('answer_en', e.target.value)} className={`mt-1.5 ${areaCls}`} />
          </label>
          <label className="text-[11px] font-semibold text-ivory-dim">Question (Hindi)
            <input value={form.question_hi ?? ''} onChange={(e) => set('question_hi', e.target.value)} className={`mt-1.5 ${inputCls}`} />
          </label>
          <label className="text-[11px] font-semibold text-ivory-dim">Answer (Hindi)
            <textarea rows={3} value={form.answer_hi ?? ''} onChange={(e) => set('answer_hi', e.target.value)} className={`mt-1.5 ${areaCls}`} />
          </label>
          <div className="grid gap-4 sm:grid-cols-2">
            <label className="text-[11px] font-semibold text-ivory-dim">Sort order
              <input type="number" value={form.sort_order ?? 0} onChange={(e) => set('sort_order', Number(e.target.value))} className={`mt-1.5 ${inputCls}`} />
            </label>
            <label className="flex items-center gap-2 self-end pb-2 text-[13px] font-semibold text-ivory-dim">
              <input type="checkbox" checked={form.is_active ?? true} onChange={(e) => set('is_active', e.target.checked)} className="h-4 w-4 accent-saffron" />
              Active
            </label>
          </div>
        </div>
        <div className="mt-6 flex justify-end gap-2.5">
          <button type="button" onClick={onClose} className="h-10 rounded-full border border-border-soft bg-surface-1 px-5 text-[13px]">Cancel</button>
          <button type="submit" disabled={saving} className="h-10 rounded-full bg-ivory text-bg-0 px-6 text-[13px] font-bold disabled:opacity-50">{saving ? 'Saving…' : 'Save'}</button>
        </div>
      </form>
    </div>
  )
}
