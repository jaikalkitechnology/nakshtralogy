// Labeled KYC document thumbnails + payout details block, shared by the KYC
// review queue and the astrologer detail drawer. Each available document
// renders as a small image card that opens full screen in the shared Lightbox
// (which keeps an "Open original" new-tab link). Null/missing docs are skipped.

import { useState } from 'react'
import { Lightbox } from './Lightbox'
import type { BankProofType, PayoutMethod } from '../api/types'

export interface KycDocSet {
  photo_url?: string | null
  pan_doc_url?: string | null
  aadhaar_doc_url?: string | null
  aadhaar_back_doc_url?: string | null
  bank_proof_url?: string | null
  certificate_url?: string | null
}

const DOC_FIELDS: { key: keyof KycDocSet; label: string }[] = [
  { key: 'photo_url', label: 'Photo' },
  { key: 'pan_doc_url', label: 'PAN card' },
  { key: 'aadhaar_doc_url', label: 'Aadhaar front' },
  { key: 'aadhaar_back_doc_url', label: 'Aadhaar back' },
  { key: 'bank_proof_url', label: 'Bank proof' },
  { key: 'certificate_url', label: 'Certificate' },
]

export function KycDocThumbs({ docs }: { docs: KycDocSet }) {
  const [preview, setPreview] = useState<{ url: string; label: string } | null>(null)
  const available = DOC_FIELDS.filter(d => docs[d.key])
  if (available.length === 0) {
    return <div className="rounded-xl border border-dashed border-border-soft bg-surface-1 px-4 py-5 text-center text-[12px] text-ivory-faint">No documents uploaded.</div>
  }
  return (
    <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
      {available.map(d => {
        const url = docs[d.key] as string
        return (
          <button key={d.key} type="button" onClick={() => setPreview({ url, label: d.label })} title={`View ${d.label} full screen`} className="group cursor-zoom-in overflow-hidden rounded-xl border border-border-soft bg-surface-1 p-0 text-left shadow-sm transition-colors hover:border-saffron/40">
            <div className="h-24 w-full overflow-hidden bg-surface-2">
              <img src={url} alt={d.label} loading="lazy" className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-[1.04]" />
            </div>
            <div className="flex w-full items-center justify-between px-3 py-2">
              <span className="text-[10px] font-bold uppercase tracking-wide text-ivory-faint transition-colors group-hover:text-ivory">{d.label}</span>
              <span className="text-[11px] text-ivory-faint" aria-hidden>⤢</span>
            </div>
          </button>
        )
      })}
      {preview && <Lightbox url={preview.url} label={preview.label} onClose={() => setPreview(null)} />}
    </div>
  )
}

// ---- Payout details (blueprint §5 — UPI or Bank Account) ----

// eslint-disable-next-line react-refresh/only-export-components
export const BANK_PROOF_LABELS: Record<BankProofType, string> = {
  passbook: 'Passbook',
  cancelled_cheque: 'Cancelled cheque',
  bank_statement: 'Bank statement',
}

export interface PayoutInfo {
  payout_method?: PayoutMethod | null
  upi_id?: string | null
  bank_name?: string | null
  /** Not present on KYC-queue rows — the row is omitted when undefined. */
  bank_account_holder?: string | null
  bank_account_last4?: string | null
  bank_ifsc?: string | null
  bank_proof_type?: BankProofType | null
}

/** Method badge (UPI / Bank) + the fields for the selected payout method. */
export function PayoutBlock({ payout }: { payout: PayoutInfo }) {
  // Legacy submissions predate payout_method — infer it from what was filled in.
  const method: PayoutMethod | null =
    payout.payout_method ?? (payout.bank_account_last4 || payout.bank_ifsc || payout.bank_name ? 'bank' : payout.upi_id ? 'upi' : null)
  if (!method) {
    return <div className="rounded-xl border border-dashed border-border-soft bg-surface-1 px-4 py-5 text-center text-[12px] text-ivory-faint">No payout details provided.</div>
  }
  const dash = <span className="text-ivory-faint">—</span>
  return (
    <div className="rounded-xl border border-border-soft bg-surface-1 p-4">
      <div className="flex items-center gap-2.5">
        <span className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Method</span>
        <span className={`rounded-full border px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-wide ${method === 'upi' ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' : 'bg-indigo-500/10 text-indigo-300 border-indigo-500/20'}`}>{method === 'upi' ? 'UPI' : 'Bank'}</span>
      </div>
      <div className="mt-3 grid gap-2.5 text-[13px] sm:grid-cols-[130px_1fr] [&>.k]:text-[11px] [&>.k]:font-bold [&>.k]:uppercase [&>.k]:tracking-wide [&>.k]:text-ivory-faint">
        {method === 'upi' ? (
          <>
            <div className="k">UPI ID</div><div className="font-mono text-[12px] font-semibold">{payout.upi_id || dash}</div>
          </>
        ) : (
          <>
            <div className="k">Bank name</div><div className="font-semibold">{payout.bank_name || dash}</div>
            {payout.bank_account_holder !== undefined && <><div className="k">Holder</div><div>{payout.bank_account_holder || dash}</div></>}
            <div className="k">Account</div><div className="font-mono text-[12px]">{payout.bank_account_last4 ? `•••• ${payout.bank_account_last4}` : dash}</div>
            <div className="k">IFSC</div><div className="font-mono text-[12px]">{payout.bank_ifsc || dash}</div>
            <div className="k">Proof</div><div>{payout.bank_proof_type ? BANK_PROOF_LABELS[payout.bank_proof_type] : dash}</div>
          </>
        )}
      </div>
    </div>
  )
}
