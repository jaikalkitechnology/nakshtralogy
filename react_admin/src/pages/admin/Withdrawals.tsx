import { useCallback, useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Banknote, RefreshCw, Check, X } from "lucide-react";
import { adminWithdrawals, adminWithdrawalAction } from "@/services/api";
import { toast } from "sonner";

interface W {
  id: string; user_id: string; astrologer_name?: string | null;
  amount: number; tds_amount: number; net_amount: number; tds_pan?: string | null;
  status: string; bank_account_name?: string | null; bank_account_number?: string | null;
  bank_ifsc?: string | null; upi_id?: string | null; notes?: string | null;
  admin_note?: string | null; bank_ref?: string | null; requested_at?: string | null;
}

const STATUS: Record<string, string> = {
  pending: "bg-yellow-500/20 text-yellow-400",
  approved: "bg-blue-500/20 text-blue-400",
  paid: "bg-green-500/20 text-green-400",
  rejected: "bg-red-500/20 text-red-400",
};
const TABS = ["pending", "approved", "paid", "rejected", ""] as const;

export default function Withdrawals() {
  const [items, setItems] = useState<W[]>([]);
  const [tds, setTds] = useState(0);
  const [status, setStatus] = useState<string>("pending");
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminWithdrawals({ status });
    if (r.ok) { setItems(r.data?.items ?? []); setTds(r.data?.total_tds_collected ?? 0); }
    else if (r.status === 404) toast.error("Deploy the backend with payout management");
    setLoading(false);
  }, [status]);
  useEffect(() => { load(); }, [load]);

  const act = async (w: W, action: "approve" | "paid" | "reject") => {
    let bank_ref: string | undefined;
    let admin_note: string | undefined;
    if (action === "paid") bank_ref = window.prompt("Bank transfer reference (UTR/txn id):") || undefined;
    if (action === "reject") admin_note = window.prompt("Reason for rejection:") || undefined;
    const r = await adminWithdrawalAction(w.id, { action, bank_ref, admin_note });
    if (r.ok) { toast.success(`Marked ${r.data?.status}`); load(); } else toast.error(r.data?.detail || "Failed");
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <Banknote className="w-6 h-6 text-primary" /> Astrologer Payouts
          </h1>
          <p className="text-sm text-muted-foreground">Approve withdrawals and record the bank transfer. 10% TDS is withheld against each PAN; net is paid to the bank.</p>
        </div>
        <div className="flex items-center gap-3">
          <span className="text-sm text-primary font-semibold">₹{tds.toFixed(2)} TDS collected</span>
          <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
        </div>
      </div>

      <div className="flex gap-1">
        {TABS.map((t) => (
          <button key={t || "all"} onClick={() => setStatus(t)}
            className={`rounded-md px-3 py-1 text-xs font-semibold capitalize ${status === t ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{t || "all"}</button>
        ))}
      </div>

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
              <th className="text-left p-2.5">Astrologer</th>
              <th className="text-left p-2.5">Bank / UPI</th>
              <th className="text-left p-2.5">PAN</th>
              <th className="text-right p-2.5">Gross</th>
              <th className="text-right p-2.5">TDS 10%</th>
              <th className="text-right p-2.5">Net payable</th>
              <th className="text-left p-2.5">Status</th>
              <th className="text-right p-2.5">Action</th>
            </tr></thead>
            <tbody>
              {items.map((w) => (
                <tr key={w.id} className="border-t border-border align-top">
                  <td className="p-2.5"><div className="text-foreground">{w.astrologer_name || w.user_id.slice(0, 8)}</div><div className="text-[11px] text-muted-foreground">{w.requested_at ? new Date(w.requested_at).toLocaleDateString() : ""}</div></td>
                  <td className="p-2.5 text-muted-foreground text-xs">{w.upi_id || `${w.bank_account_name || ""} ${w.bank_account_number || ""} ${w.bank_ifsc || ""}`.trim() || "—"}</td>
                  <td className="p-2.5 font-mono text-xs text-foreground">{w.tds_pan || "—"}</td>
                  <td className="p-2.5 text-right text-foreground">₹{w.amount.toFixed(2)}</td>
                  <td className="p-2.5 text-right text-amber-400">−₹{w.tds_amount.toFixed(2)}</td>
                  <td className="p-2.5 text-right text-green-400 font-semibold">₹{w.net_amount.toFixed(2)}</td>
                  <td className="p-2.5"><Badge className={STATUS[w.status] || ""}>{w.status}</Badge></td>
                  <td className="p-2.5 text-right whitespace-nowrap">
                    {(w.status === "pending" || w.status === "approved") && (
                      <>
                        {w.status === "pending" && <Button size="sm" variant="outline" onClick={() => act(w, "approve")}>Approve</Button>}
                        <Button size="sm" variant="ghost" onClick={() => act(w, "paid")} title="Mark paid"><Check className="w-4 h-4 text-green-400" /></Button>
                        <Button size="sm" variant="ghost" onClick={() => act(w, "reject")} title="Reject"><X className="w-4 h-4 text-red-400" /></Button>
                      </>
                    )}
                    {w.bank_ref && <span className="text-[11px] text-muted-foreground">ref {w.bank_ref}</span>}
                  </td>
                </tr>
              ))}
              {items.length === 0 && !loading && <tr><td colSpan={8} className="p-6 text-center text-muted-foreground">No withdrawals.</td></tr>}
            </tbody>
          </table>
        </div>
      </div>
      <p className="text-[11px] text-muted-foreground">Payouts are manual bank transfers for now; automated payouts land later. The gross amount is already debited from the astrologer's wallet at request time; rejecting re-credits it.</p>
    </div>
  );
}
