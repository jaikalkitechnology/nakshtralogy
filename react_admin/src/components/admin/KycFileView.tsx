import { useEffect, useState } from "react";
import { fetchAuthedObjectUrl } from "@/services/api";
import { FileText, ImageOff, Loader2 } from "lucide-react";

/**
 * Renders a single KYC document (image or PDF) served from an auth-protected
 * API path. Browsers can't attach an Authorization header to <img src>, so we
 * fetch the file as a blob with the admin token and show it via an object URL.
 */
export default function KycFileView({ label, path }: { label: string; path?: string | null }) {
  const [obj, setObj] = useState<{ url: string; contentType: string } | null>(null);
  const [loading, setLoading] = useState(false);
  const [failed, setFailed] = useState(false);

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
          <a
            href={obj.url}
            target="_blank"
            rel="noreferrer"
            className="flex flex-col items-center text-primary text-xs hover:underline"
          >
            <FileText className="w-8 h-8 mb-1" /> View PDF
          </a>
        ) : (
          <a href={obj.url} target="_blank" rel="noreferrer" title="Open full size">
            <img src={obj.url} alt={label} className="h-32 w-full object-contain" />
          </a>
        )}
      </div>
    </div>
  );
}
