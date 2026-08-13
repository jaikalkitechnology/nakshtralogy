// Shared full-screen image lightbox. Any thumbnail in the admin panel opens
// here instead of jumping to a new tab; the raw file stays one click away via
// the secondary "Open original" link inside the overlay.
//
// - `Lightbox` is the overlay itself (portaled to <body> so it always sits
//   above drawers/modals regardless of stacking context or transforms).
// - `LightboxImage` is a convenience thumbnail button that manages its own
//   open/closed state — drop it anywhere an <img> thumb used to be.
//
// Closes on X, backdrop click and Escape. The Escape listener runs in the
// capture phase and stops propagation so a lightbox opened above a drawer or
// modal doesn't close its parent too.

import { useEffect, useState } from 'react'
import { createPortal } from 'react-dom'

export interface LightboxProps {
  url: string
  /** Caption shown under the image (e.g. "PAN card", astrologer name). */
  label?: string | null
  onClose: () => void
}

export function Lightbox({ url, label, onClose }: LightboxProps) {
  useEffect(() => {
    const fn = (e: KeyboardEvent) => {
      if (e.key === 'Escape') { e.stopPropagation(); onClose() }
    }
    window.addEventListener('keydown', fn, true)
    return () => window.removeEventListener('keydown', fn, true)
  }, [onClose])

  return createPortal(
    // stopPropagation everywhere: portals bubble through the React tree, so a
    // click here would otherwise reach the backdrop of a parent drawer/modal.
    <div
      role="dialog"
      aria-modal="true"
      aria-label={label ? `${label} — full screen preview` : 'Image preview'}
      onClick={e => { e.stopPropagation(); onClose() }}
      className="fixed inset-0 z-[90] flex flex-col items-center justify-center gap-4 bg-slate-900/70 p-4 sm:p-8 animate-fade-in"
    >
      <button
        type="button"
        onClick={onClose}
        aria-label="Close preview"
        className="absolute right-4 top-4 grid h-10 w-10 place-items-center rounded-full border border-white/15 bg-white/10 text-white/80 backdrop-blur-sm transition-colors hover:bg-white/20 hover:text-white"
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
      </button>
      <img
        src={url}
        alt={label ?? 'Full size preview'}
        onClick={e => e.stopPropagation()}
        className="max-h-[85vh] max-w-[90vw] rounded-xl object-contain shadow-2xl animate-pop-in"
      />
      <div className="flex flex-wrap items-center justify-center gap-2.5" onClick={e => e.stopPropagation()}>
        {label && <span className="rounded-full border border-white/15 bg-white/10 px-3.5 py-1.5 text-[12px] font-semibold text-white/90 backdrop-blur-sm">{label}</span>}
        <a
          href={url}
          target="_blank"
          rel="noreferrer"
          className="inline-flex items-center gap-1.5 rounded-full border border-white/15 bg-white/10 px-3.5 py-1.5 text-[12px] font-medium text-white/70 backdrop-blur-sm transition-colors hover:bg-white/20 hover:text-white"
        >
          Open original <span aria-hidden>↗</span>
        </a>
      </div>
    </div>,
    document.body,
  )
}

export interface LightboxImageProps {
  src: string
  /** Caption in the lightbox; also used as the alt text. */
  label?: string | null
  /** Sizing/border/rounding for the thumbnail button (e.g. "h-9 w-9 rounded-xl border …"). */
  className?: string
  /** Override the inner <img> classes; defaults to a cover-fit with hover zoom. */
  imgClassName?: string
}

/** Clickable image thumbnail that opens `src` full screen in the shared Lightbox. */
export function LightboxImage({ src, label, className, imgClassName }: LightboxImageProps) {
  const [open, setOpen] = useState(false)
  return (
    <>
      <button
        type="button"
        onClick={e => { e.stopPropagation(); setOpen(true) }}
        title={`View ${label ?? 'image'} full screen`}
        className={`group shrink-0 cursor-zoom-in overflow-hidden p-0 ${className ?? ''}`}
      >
        <img src={src} alt={label ?? ''} loading="lazy" className={imgClassName ?? 'h-full w-full object-cover transition-transform duration-300 group-hover:scale-[1.05]'} />
      </button>
      {open && <Lightbox url={src} label={label} onClose={() => setOpen(false)} />}
    </>
  )
}
