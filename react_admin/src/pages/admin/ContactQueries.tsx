import { useCallback, useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Mail, RefreshCw, Search, X, Send, CheckCircle2, Phone } from "lucide-react";
import { adminContactList, adminContactGet, adminContactUpdate, adminContactReply } from "@/services/api";
import { toast } from "sonner";

interface Query {
  id: string; name: string; email: string; phone?: string | null;
  subject?: string | null; message: string; status: string; lang?: string | null;
  admin_note?: string | null; created_at?: string | null; last_reply_at?: string | null;
  replies?: { id: string; body: string; emailed: boolean; created_at?: string | null }[];
}

const STATUSES = ["all", "new", "read", "replied", "resolved", "spam"];
const STATUS_STYLE: Record<string, string> = {
  new: "bg-amber-500/20 text-amber-400",
  read: "bg-blue-500/20 text-blue-400",
  replied: "bg-primary/20 text-primary",
  resolved: "bg-green-500/20 text-green-400",
  spam: "bg-muted text-muted-foreground",
};

export default function ContactQueries() {
  const [items, setItems] = useState<Query[]>([]);
  const [newCount, setNewCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [status, setStatus] = useState("all");
  const [q, setQ] = useState("");
  const [open, setOpen] = useState<Query | null>(null);
  const [reply, setReply] = useState("");
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminContactList({ status: status === "all" ? undefined : status, q: q || undefined });
    if (r.ok) { setItems(r.data?.items ?? []); setNewCount(r.data?.new ?? 0); }
    else if (r.status === 404) toast.error("Deploy the backend with contact/query management");
    setLoading(false);
  }, [status, q]);
  useEffect(() => { load(); }, [load]);

  const openDetail = async (row: Query) => {
    setReply("");
    const r = await adminContactGet(row.id);
    if (r.ok) { setOpen(r.data); load(); }   // reload to clear "new" badge
    else toast.error("Failed to open");
  };

  const setStatusFor = async (row: Query, s: string) => {
    const r = await adminContactUpdate(row.id, { status: s });
    if (r.ok) { toast.success(`Marked ${s}`); if (open?.id === row.id) setOpen({ ...open, status: s }); load(); }
    else toast.error("Failed");
  };

  const sendReply = async (resolve: boolean) => {
    if (!open || !reply.trim()) return;
    setBusy(true);
    const r = await adminContactReply(open.id, reply.trim(), resolve);
    setBusy(false);
    if (r.ok) {
      toast.success(r.data?.emailed ? "Reply sent by email" : (r.data?.detail || "Reply saved (email not sent)"));
      setReply("");
      openDetail(open); // refresh thread
    } else {
      toast.error(r.data?.detail || "Failed to reply");
    }
  };

  const fmt = (s?: string | null) => (s ? new Date(s).toLocaleString() : "—");

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <Mail className="w-6 h-6 text-primary" /> Query Support
            {newCount > 0 && <span className="rounded-full bg-amber-500/20 text-amber-400 text-xs font-bold px-2 py-0.5">{newCount} new</span>}
          </h1>
          <p className="text-sm text-muted-foreground">Enquiries from the website Contact Us form — read, reply by email, and track status.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap items-center gap-2">
        <div className="flex gap-1">
          {STATUSES.map((s) => (
            <button key={s} onClick={() => setStatus(s)}
              className={`rounded-md px-3 py-1 text-xs font-semibold capitalize ${status === s ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{s}</button>
          ))}
        </div>
        <div className="relative ml-auto">
          <Search className="w-4 h-4 absolute left-2.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
          <Input className="pl-8 h-9 w-56" placeholder="Search name / email / message" value={q}
            onChange={(e) => setQ(e.target.value)} onKeyDown={(e) => e.key === "Enter" && load()} />
        </div>
      </div>

      {/* Table */}
      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
              <th className="text-left p-2.5">From</th>
              <th className="text-left p-2.5">Subject</th>
              <th className="text-left p-2.5">Received</th>
              <th className="text-left p-2.5">Status</th>
              <th></th>
            </tr></thead>
            <tbody>
              {items.map((m) => (
                <tr key={m.id} className="border-t border-border hover:bg-muted/30 cursor-pointer" onClick={() => openDetail(m)}>
                  <td className="p-2.5">
                    <div className="text-foreground font-medium">{m.name}</div>
                    <div className="text-[11px] text-muted-foreground">{m.email}</div>
                  </td>
                  <td className="p-2.5 text-muted-foreground max-w-[260px] truncate">{m.subject || "—"}</td>
                  <td className="p-2.5 text-muted-foreground whitespace-nowrap">{fmt(m.created_at)}</td>
                  <td className="p-2.5"><Badge className={STATUS_STYLE[m.status] || ""}>{m.status}</Badge></td>
                  <td className="p-2.5 text-right"><Button size="sm" variant="outline" onClick={(e) => { e.stopPropagation(); openDetail(m); }}>Open</Button></td>
                </tr>
              ))}
              {items.length === 0 && !loading && <tr><td colSpan={5} className="p-6 text-center text-muted-foreground">No queries.</td></tr>}
            </tbody>
          </table>
        </div>
      </div>

      {/* Detail drawer */}
      {open && (
        <div className="fixed inset-0 z-50 flex justify-end bg-black/60" onClick={() => setOpen(null)}>
          <div className="w-full max-w-xl h-full overflow-y-auto bg-card border-l border-border p-5 space-y-4" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-start justify-between gap-3">
              <div>
                <h3 className="font-display text-lg text-foreground">{open.subject || "Enquiry"}</h3>
                <div className="text-sm text-muted-foreground">{open.name} · <a className="text-primary" href={`mailto:${open.email}`}>{open.email}</a></div>
                {open.phone && <div className="text-xs text-muted-foreground flex items-center gap-1 mt-0.5"><Phone className="w-3 h-3" /> {open.phone}</div>}
                <div className="text-[11px] text-muted-foreground mt-1">{fmt(open.created_at)}{open.lang ? ` · ${open.lang}` : ""}</div>
              </div>
              <button onClick={() => setOpen(null)} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
            </div>

            <div className="rounded-lg border border-border bg-muted/20 p-3 text-sm text-foreground whitespace-pre-wrap">{open.message}</div>

            {/* Status controls */}
            <div className="flex flex-wrap gap-1">
              {["read", "replied", "resolved", "spam"].map((s) => (
                <button key={s} onClick={() => setStatusFor(open, s)}
                  className={`rounded-md px-2.5 py-1 text-[11px] font-semibold capitalize ${open.status === s ? STATUS_STYLE[s] : "border border-border text-muted-foreground"}`}>{s}</button>
              ))}
            </div>

            {/* Reply thread */}
            {(open.replies?.length ?? 0) > 0 && (
              <div className="space-y-2">
                <div className="text-[11px] font-mono uppercase tracking-wider text-muted-foreground">Replies</div>
                {open.replies!.map((r) => (
                  <div key={r.id} className="rounded-lg border border-primary/20 bg-primary/5 p-3 text-sm text-foreground whitespace-pre-wrap">
                    {r.body}
                    <div className="mt-1 text-[10px] text-muted-foreground">{fmt(r.created_at)} · {r.emailed ? "emailed ✓" : "not emailed"}</div>
                  </div>
                ))}
              </div>
            )}

            {/* Compose reply */}
            <div className="space-y-2">
              <div className="text-[11px] font-mono uppercase tracking-wider text-muted-foreground">Reply to {open.email}</div>
              <Textarea rows={5} value={reply} onChange={(e) => setReply(e.target.value)} placeholder="Type your reply — it will be emailed to the person who wrote in." />
              <div className="flex flex-wrap justify-end gap-2">
                <Button variant="outline" onClick={() => sendReply(false)} disabled={busy || !reply.trim()}><Send className="w-4 h-4 mr-1" /> Send reply</Button>
                <Button onClick={() => sendReply(true)} disabled={busy || !reply.trim()}><CheckCircle2 className="w-4 h-4 mr-1" /> Send &amp; resolve</Button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
