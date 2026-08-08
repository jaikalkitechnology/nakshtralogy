import { useCallback, useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ShieldAlert, RefreshCw, Flag } from "lucide-react";
import { adminChatFlags } from "@/services/api";
import { toast } from "sonner";

interface Flag {
  id: string; session_id: string; astrologer_id?: string | null; astrologer_name?: string | null;
  user_id?: string | null; content?: string | null;
  flagged: boolean; flag_reasons: string[]; reported: boolean; report_reason?: string | null;
  created_at?: string | null;
}

const KINDS = [
  { key: "all", label: "All" },
  { key: "flagged", label: "Auto-flagged" },
  { key: "reported", label: "User-reported" },
] as const;

const REASON_LABEL: Record<string, string> = {
  upi: "UPI", phone: "Phone", payment_app: "Payment app", contact_channel: "Contact channel",
  solicitation: "Solicitation", long_number: "Long number",
};

export default function ChatGuard() {
  const [items, setItems] = useState<Flag[]>([]);
  const [total, setTotal] = useState(0);
  const [kind, setKind] = useState<"all" | "flagged" | "reported">("all");
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminChatFlags(kind);
    if (r.ok) { setItems(r.data?.items ?? []); setTotal(r.data?.total ?? 0); }
    else if (r.status === 404) toast.error("Deploy the backend with chat-guard moderation");
    setLoading(false);
  }, [kind]);
  useEffect(() => { load(); }, [load]);

  const fmt = (s?: string | null) => (s ? new Date(s).toLocaleString() : "—");

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <ShieldAlert className="w-6 h-6 text-primary" /> Chat Guard
            {total > 0 && <span className="rounded-full bg-amber-500/20 text-amber-400 text-xs font-bold px-2 py-0.5">{total}</span>}
          </h1>
          <p className="text-sm text-muted-foreground">Astrologer chat messages auto-flagged for off-platform payment/solicitation, plus user reports.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      <div className="flex gap-1">
        {KINDS.map((k) => (
          <button key={k.key} onClick={() => setKind(k.key)}
            className={`rounded-md px-3 py-1 text-xs font-semibold ${kind === k.key ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{k.label}</button>
        ))}
      </div>

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
              <th className="text-left p-2.5">When</th>
              <th className="text-left p-2.5">Astrologer</th>
              <th className="text-left p-2.5">Message</th>
              <th className="text-left p-2.5">Signals</th>
              <th className="text-left p-2.5">Status</th>
            </tr></thead>
            <tbody>
              {items.map((m) => (
                <tr key={m.id} className="border-t border-border align-top">
                  <td className="p-2.5 text-muted-foreground whitespace-nowrap">{fmt(m.created_at)}</td>
                  <td className="p-2.5 text-foreground whitespace-nowrap">{m.astrologer_name || m.astrologer_id || "—"}</td>
                  <td className="p-2.5 text-foreground max-w-[360px]"><span className="line-clamp-3">{m.content || "—"}</span></td>
                  <td className="p-2.5">
                    <div className="flex flex-wrap gap-1">
                      {(m.flag_reasons || []).map((r) => (
                        <Badge key={r} className="bg-amber-500/15 text-amber-400 text-[10px]">{REASON_LABEL[r] || r}</Badge>
                      ))}
                    </div>
                  </td>
                  <td className="p-2.5">
                    <div className="flex flex-col gap-1">
                      {m.flagged && <Badge className="bg-amber-500/20 text-amber-400 w-fit">auto-flagged</Badge>}
                      {m.reported && <Badge className="bg-red-500/20 text-red-400 w-fit flex items-center gap-1"><Flag className="w-3 h-3" /> reported</Badge>}
                    </div>
                  </td>
                </tr>
              ))}
              {items.length === 0 && !loading && <tr><td colSpan={5} className="p-6 text-center text-muted-foreground">No flags — clean.</td></tr>}
            </tbody>
          </table>
        </div>
      </div>
      <p className="text-[11px] text-muted-foreground">Detection is recall-biased (may flag borderline messages). Review before acting; repeat offenders can be suspended per Terms C4.</p>
    </div>
  );
}
