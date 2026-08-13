import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import { ConfirmDialog } from '../components/ConfirmDialog'
import { PageHeader, Card } from '../components/ui/PageShell'
import type { DeletedAccount, DeletedAccountType } from '../api/types'

const FILTERS: { value: DeletedAccountType; label: string }[] = [
  { value: 'all', label: 'All' },
  { value: 'user', label: 'Customers' },
  { value: 'astrologer', label: 'Astrologers' },
]

function fmt(d: string | null): string {
  if (!d) return '—'
  const dt = new Date(d)
  return Number.isNaN(dt.getTime()) ? '—' : dt.toLocaleDateString()
}

function windowPassed(deadline: string | null): boolean {
  if (!deadline) return true
  const dt = new Date(deadline)
  return Number.isNaN(dt.getTime()) ? true : dt.getTime() < Date.now()
}

/**
 * Deleted accounts (soft-delete + anonymise). Lists anonymised shells with the
 * reason + date and a restore-by deadline; an admin can restore an account
 * within the window (re-enables login — anonymised PII is not recovered).
 * Force-delete for a live account lives on the Customers / Astrologers pages.
 */
export default function DeletedAccountsPage() {
  const [type, setType] = useState<DeletedAccountType>('all')
  const [rows, setRows] = useState<DeletedAccount[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [restore, setRestore] = useState<DeletedAccount | null>(null)
  const [busy, setBusy] = useState(false)
  const [restoreError, setRestoreError] = useState<string | null>(null)

  const load = useCallback(async () => {
    setLoading(true)
    try {
      setRows(await adminApi.listDeletedAccounts(type))
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }, [type])

  useEffect(() => {
    void load()
  }, [load])

  async function confirmRestore() {
    if (!restore) return
    setBusy(true)
    setRestoreError(null)
    try {
      if (restore.type === 'user') await adminApi.restoreCustomer(restore.id)
      else await adminApi.restoreAstrologer(restore.id)
      setRestore(null)
      await load()
    } catch (e) {
      setRestoreError((e as Error).message)
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className="space-y-5">
      <PageHeader
        title="Deleted Accounts"
        subtitle="Soft-deleted, anonymised accounts. Restore an account within the window to re-enable login (anonymised data is not recovered)."
        actions={
          <div className="inline-flex rounded-full border border-border-soft bg-surface-1 p-1">
            {FILTERS.map((f) => (
              <button
                key={f.value}
                onClick={() => setType(f.value)}
                className={`h-8 rounded-full px-4 text-[12.5px] font-semibold transition-colors ${
                  type === f.value ? 'bg-saffron text-white' : 'text-ivory-dim hover:text-ivory'
                }`}
              >
                {f.label}
              </button>
            ))}
          </div>
        }
        icon={<span className="text-[18px]">🗑️</span>}
      />

      {error && (
        <div className="flex gap-3 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">
          {error}
        </div>
      )}

      {loading && rows.length === 0 ? (
        <Card>
          <div className="p-10 text-center text-[13px] text-ivory-faint">Loading deleted accounts…</div>
        </Card>
      ) : (
        <div className="overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
          <div className="overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                  <th className="px-5 py-3.5">Account</th>
                  <th className="px-5 py-3.5">Type</th>
                  <th className="px-5 py-3.5">Reason</th>
                  <th className="px-5 py-3.5">Deleted</th>
                  <th className="px-5 py-3.5">Restore by</th>
                  <th className="px-5 py-3.5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border-soft/60">
                {rows.map((r) => {
                  const expired = windowPassed(r.restore_deadline)
                  return (
                    <tr key={`${r.type}-${r.id}`} className="hover:bg-surface-1/50 transition-colors">
                      <td className="px-5 py-4">
                        <div className="text-[13.5px] font-semibold">{r.name ?? <span className="text-ivory-faint">(anonymised)</span>}</div>
                        <div className="font-mono text-[11px] text-ivory-faint">{r.mobile ?? r.email ?? r.id}</div>
                      </td>
                      <td className="px-5 py-4">
                        <span className="rounded-full bg-surface-1 border border-border-soft px-2.5 py-1 text-[11px] capitalize">{r.type}</span>
                      </td>
                      <td className="px-5 py-4 text-[12.5px] capitalize">{r.deleted_reason ?? '—'}</td>
                      <td className="px-5 py-4 text-[12.5px]">{fmt(r.deleted_at)}</td>
                      <td className="px-5 py-4 text-[12.5px]">
                        <span className={expired ? 'text-red-400' : 'text-ivory-dim'}>{fmt(r.restore_deadline)}</span>
                      </td>
                      <td className="px-5 py-4 text-right">
                        <button
                          disabled={expired}
                          onClick={() => setRestore(r)}
                          className="h-8 rounded-full border border-emerald-500/20 bg-emerald-500/10 px-3.5 text-[12px] font-semibold text-emerald-400 hover:bg-emerald-500/20 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                          title={expired ? 'Restore window has passed' : 'Restore account'}
                        >
                          Restore
                        </button>
                      </td>
                    </tr>
                  )
                })}
                {rows.length === 0 && (
                  <tr>
                    <td colSpan={6} className="py-16 text-center text-[13px] text-ivory-faint">No deleted accounts.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {restore && (
        <ConfirmDialog
          title="Restore account"
          message={`Reactivate this ${restore.type}? Login is re-enabled, but anonymised profile data (name, contact, birth details) is not recovered — the person re-completes their profile.`}
          confirmLabel="Restore account"
          busy={busy}
          error={restoreError}
          onConfirm={confirmRestore}
          onClose={() => {
            setRestore(null)
            setRestoreError(null)
          }}
        />
      )}
    </div>
  )
}
