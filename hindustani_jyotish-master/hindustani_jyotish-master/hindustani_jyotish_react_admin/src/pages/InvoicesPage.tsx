import { useMemo, useState } from 'react'
import { adminApi } from '../api/endpoints'
import { Pager, SearchBox } from '../components/ListControls'
import { usePagedData } from '../hooks/usePagedData'
import { PageHeader, Card } from '../components/ui/PageShell'

interface Invoice {
  id: string
  invoice_number: string
  user_id: string
  buyer_name: string | null
  source_type: string
  seller_gstin: string | null
  taxable_value: string
  tax_rate: string
  cgst_amount: string
  sgst_amount: string
  igst_amount: string
  total_amount: string
  currency: string
  created_at: string | null
}

const shortId = (v: string) => v.slice(0, 8)
const money = (v: string) => `₹${Number(v).toLocaleString('en-IN', { minimumFractionDigits: 2 })}`
const dateOnly = (v: string | null) =>
  v ? new Date(v).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' }) : '—'

export default function InvoicesPage() {
  const [search, setSearch] = useState('')
  const [applied, setApplied] = useState('')
  const endpoint = useMemo(
    () => `/admin/invoices${applied.trim() ? `?q=${encodeURIComponent(applied.trim())}` : ''}`,
    [applied],
  )
  const paged = usePagedData<Invoice>(endpoint)
  const [busy, setBusy] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  async function download(inv: Invoice) {
    setBusy(inv.id); setError(null)
    try { await adminApi.downloadInvoice(inv.id, inv.invoice_number) }
    catch (e) { setError((e as Error).message) }
    finally { setBusy(null) }
  }

  async function exportCsv() {
    setBusy('csv'); setError(null)
    try { await adminApi.exportInvoicesCsv(applied.trim() || undefined) }
    catch (e) { setError((e as Error).message) }
    finally { setBusy(null) }
  }

  return (
    <div className="space-y-5">
      <PageHeader
        title="GST Invoices"
        subtitle="One tax invoice per paid consultation (kundli is free). Download the PDF or export the filtered set as CSV. Configure the seller GSTIN, rate and HSN/SAC under Settings → GST."
        icon={<span className="text-[18px]">🧾</span>}
        actions={
          <>
            <SearchBox value={search} onChange={setSearch} placeholder="Invoice no, buyer, GSTIN…" />
            <button
              onClick={() => setApplied(search)}
              className="h-[42px] rounded-full border border-border-soft bg-surface-raised px-5 text-[13px] font-semibold shadow-sm hover:bg-surface-2"
            >Search</button>
            <button
              onClick={exportCsv}
              disabled={busy === 'csv'}
              className="h-[42px] rounded-full border border-border-soft bg-surface-raised px-5 text-[13px] font-semibold shadow-sm hover:bg-surface-2 disabled:opacity-50"
            >{busy === 'csv' ? 'Exporting…' : 'Export CSV'}</button>
            <button onClick={paged.reload} className="grid h-[42px] w-[42px] place-items-center rounded-full border border-border-soft bg-surface-raised shadow-sm">↻</button>
          </>
        }
      />

      {(error || paged.error) && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error || paged.error}</div>}

      {paged.loading && paged.rows.length === 0 ? (
        <Card><div className="p-10 text-center text-ivory-faint">Loading invoices…</div></Card>
      ) : (
        <>
          <div className="hidden md:block overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr className="border-b border-border-soft bg-surface-1/60 text-left text-[11px] font-bold uppercase tracking-wider text-ivory-faint">
                    <th className="px-5 py-3.5">Invoice No.</th>
                    <th className="px-5 py-3.5">Buyer</th>
                    <th className="px-5 py-3.5">Taxable</th>
                    <th className="px-5 py-3.5">CGST</th>
                    <th className="px-5 py-3.5">SGST</th>
                    <th className="px-5 py-3.5">Total</th>
                    <th className="px-5 py-3.5">When</th>
                    <th className="px-5 py-3.5 text-right">PDF</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border-soft/60">
                  {paged.rows.map(inv => (
                    <tr key={inv.id} className="hover:bg-surface-1/50 transition-colors">
                      <td className="px-5 py-4 font-mono text-[12px]">{inv.invoice_number}</td>
                      <td className="px-5 py-4 text-[12px]">{inv.buyer_name || <span className="font-mono text-ivory-faint">{shortId(inv.user_id)}</span>}</td>
                      <td className="px-5 py-4 font-mono text-[12px] text-ivory-dim">{money(inv.taxable_value)}</td>
                      <td className="px-5 py-4 font-mono text-[12px] text-ivory-faint">{money(inv.cgst_amount)}</td>
                      <td className="px-5 py-4 font-mono text-[12px] text-ivory-faint">{money(inv.sgst_amount)}</td>
                      <td className="px-5 py-4"><span className="rounded-full border border-emerald-500/20 bg-emerald-500/10 px-3 py-1 font-mono text-[12px] font-bold text-emerald-400">{money(inv.total_amount)}</span></td>
                      <td className="px-5 py-4 text-[12px] text-ivory-faint">{dateOnly(inv.created_at)}</td>
                      <td className="px-5 py-4 text-right">
                        <button onClick={() => download(inv)} disabled={busy === inv.id} className="h-8 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-bold hover:bg-surface-2 disabled:opacity-50">{busy === inv.id ? '…' : 'Download'}</button>
                      </td>
                    </tr>
                  ))}
                  {paged.rows.length === 0 && <tr><td colSpan={8} className="py-16 text-center text-[13px] text-ivory-faint">No invoices yet.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile */}
          <div className="grid gap-3 md:hidden">
            {paged.rows.map(inv => (
              <div key={inv.id} className="rounded-xl border border-border-soft bg-surface-raised p-4">
                <div className="flex items-center justify-between">
                  <div className="font-mono text-[12px]">{inv.invoice_number}</div>
                  <span className="text-[11px] text-ivory-faint">{dateOnly(inv.created_at)}</span>
                </div>
                <div className="mt-1 text-[12px] text-ivory-dim">{inv.buyer_name || shortId(inv.user_id)}</div>
                <div className="mt-2 flex items-center justify-between">
                  <span className="font-mono font-bold text-emerald-400">{money(inv.total_amount)}</span>
                  <button onClick={() => download(inv)} disabled={busy === inv.id} className="h-9 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-bold disabled:opacity-50">{busy === inv.id ? '…' : 'Download'}</button>
                </div>
              </div>
            ))}
            {paged.rows.length === 0 && <div className="py-10 text-center text-[13px] text-ivory-faint">No invoices yet.</div>}
          </div>

          <Pager page={paged.page} size={paged.size} total={paged.total} hasPrev={paged.hasPrev} hasNext={paged.hasNext} onPage={paged.setPage} onSize={paged.setSize} shown={paged.rows.length} />
        </>
      )}
    </div>
  )
}
