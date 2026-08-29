import { useEffect, useState } from "react";
import { createPortal } from "react-dom";
import { fetchAuthedObjectUrl } from "@/services/api";
import { FileText, ImageOff, Loader2, X } from "lucide-react";

/**
 * Renders a single KYC document (image or PDF) served from an auth-protected
 * API path. Browsers can't attach an Authorization header to <img src>, so we
 * fetch the file as a blob with the admin token and show it via an object URL.
 *
 * Clicking the thumbnail opens a full-size preview in an in-page lightbox
 * (portalled to <body> so it isn't clipped by an ancestor Dialog's overflow/
 * z-index) rather than a new browser tab — admins review documents without
 * ever leaving the current page.
 */
export default function KycFileView({ label, path }: { label: string; path?: string | null }) {
  const [obj, setObj] = useState<{ url: string; contentType: string } | null>(null);
  const [loading, setLoading] = useState(false);
  const [failed, setFailed] = useState(false);
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    let active = true;
    let created: string | null = null;
    if (path) {
      setLoading(true);
      setFailed(false);
      fetchAuthedObjectUrl(path).then((r) => {
        if (!active) {
          if (r) URL.revokeObjectURL(r.url);
          return;
        }
        if (r) {
          created = r.url;
          setObj(r);
        } else {
          setFailed(true);
        }
        setLoading(false);
      });
    }
    return () => {
      active = false;
      if (created) URL.revokeObjectURL(created);
    };
  }, [path]);

  // Close the lightbox on Escape.
  useEffect(() => {
    if (!expanded) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setExpanded(false);
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [expanded]);

  if (!path) return null;

  const isPdf = (obj?.contentType || "").includes("pdf") || path.toLowerCase().endsWith(".pdf");

  return (
    <div className="flex flex-col gap-1">
      <span className="text-[11px] text-muted-foreground">{label}</span>
      <div className="h-32 w-full rounded-lg border border-border bg-muted/30 flex items-center justify-center overflow-hidden">
        {loading ? (
          <Loader2 className="w-5 h-5 text-primary animate-spin" />
        ) : failed || !obj ? (
          <div className="flex flex-col items-center text-muted-foreground text-[11px]">
            <ImageOff className="w-5 h-5 mb-1" /> Unavailable
          </div>
        ) : isPdf ? (
          <button
            type="button"
            onClick={() => setExpanded(true)}
            className="flex flex-col items-center text-primary text-xs hover:underline"
          >
            <FileText className="w-8 h-8 mb-1" /> View PDF
          </button>
        ) : (
          <button type="button" onClick={() => setExpanded(true)} title="View full size" className="h-full w-full">
            <img src={obj.url} alt={label} className="h-32 w-full object-contain" />
          </button>
        )}
      </div>

      {expanded && obj &&
        createPortal(
          <div
            className="fixed inset-0 z-[999] bg-black/85 flex flex-col items-center justify-center p-6"
            onClick={() => setExpanded(false)}
          >
            <button
              type="button"
              onClick={() => setExpanded(false)}
              className="absolute top-4 right-4 text-white/80 hover:text-white bg-white/10 hover:bg-white/20 rounded-full p-2"
              aria-label="Close"
            >
              <X className="w-5 h-5" />
            </button>
            <span className="text-white/70 text-xs mb-3">{label}</span>
            {isPdf ? (
              <iframe
                src={obj.url}
                title={label}
                className="w-full max-w-3xl h-[80vh] bg-white rounded-lg"
                onClick={(e) => e.stopPropagation()}
              />
            ) : (
              <img
                src={obj.url}
                alt={label}
                className="max-w-full max-h-[85vh] object-contain rounded-lg"
                onClick={(e) => e.stopPropagation()}
              />
            )}
          </div>,
          document.body,
        )}
    </div>
  );
}
