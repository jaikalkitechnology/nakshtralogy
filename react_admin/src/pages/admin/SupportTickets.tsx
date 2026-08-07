import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { LifeBuoy, RefreshCw, X, Send, Lock, Image as ImageIcon } from "lucide-react";
import {
  adminSupportTickets, adminSupportTicketDetail, adminSupportReply, adminSupportStatus,
} from "@/services/api";
import { toast } from "sonner";

const STATUSES = [
  { key: "", label: "All" },
  { key: "pending", label: "Pending" },
  { key: "in_progress", label: "In progress" },
  { key: "completed", label: "Completed" },
  { key: "closed", label: "Closed" },
];
const API_ORIGIN = "https://api.nakshatralogy.com";

function statusClass(s: string) {
  return ({
    pending: "bg-yellow-500/20 text-yellow-400",
    in_progress: "bg-primary/20 text-primary",
    completed: "bg-green-500/20 text-green-400",
    closed: "bg-muted text-muted-foreground",
  } as Record<string, string>)[s] || "bg-muted text-muted-foreground";
}

export default function SupportTickets() {
  const [tickets, setTickets] = useState<any[]>([]);
  const [counts, setCounts] = useState<Record<string, number>>({});
  const [status, setStatus] = useState("");
  const [role, setRole] = useState("");
  const [search, setSearch] = useState("");
  const [loading, setLoading] = useState(false);
  const [detail, setDetail] = useState<any>(null);

  const load = useCallback(async () => {
    setLoading(true);
    const params: Record<string, any> = {};
    if (status) params.status = status;
    if (role) params.role = role;
    if (search.trim()) params.search = search.trim();
    const r = await adminSupportTickets(params);
    if (r.ok) { setTickets(r.data?.items ?? []); setCounts(r.data?.counts ?? {}); }
    setLoading(false);
  }, [status, role, search]);

  useEffect(() => { load(); }, [load]);

  const open = async (id: string) => {
    const r = await adminSupportTicketDetail(id);
    if (r.ok) setDetail(r.data);
  };

  return (
    <div className="p-6 space-y-5">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><LifeBuoy className="w-6 h-6 text-primary" /> Support Tickets</h1>
          <p className="text-sm text-muted-foreground">Complaints & help requests from the user and astrologer apps.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      {/* status counters */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        {["pending", "in_progress", "completed", "closed"].map((s) => (
          <button key={s} onClick={() => setStatus(status === s ? "" : s)}
            className={`rounded-xl border p-3 text-left ${status === s ? "border-primary" : "border-border"} bg-card/60`}>
            <p className="text-xs text-muted-foreground capitalize">{s.replace("_", " ")}</p>
            <p className="text-2xl font-display text-primary">{counts[s] ?? 0}</p>
          </button>
        ))}
      </div>

      <div className="flex flex-wrap items-center gap-2">
        {STATUSES.map((s) => (
          <button key={s.key} onClick={() => setStatus(s.key)}
            className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${status === s.key ? "bg-gradient-to-br from-gold to-gold-light text-primary-foreground" : "border border-border text-muted-foreground"}`}>{s.label}</button>
        ))}
        <span className="mx-1 h-4 w-px bg-border" />
        {["", "user", "astrologer"].map((r) => (
          <button key={r || "all"} onClick={() => setRole(r)}
            className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${role === r ? "bg-cosmic/30 text-foreground" : "border border-border text-muted-foreground"}`}>{r || "All roles"}</button>
        ))}
        <Input placeholder="Search subject / user…" value={search} onChange={(e) => setSearch(e.target.value)} className="ml-auto max-w-xs" />
      </div>

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        {tickets.length === 0 && !loading ? (
          <p className="p-6 text-center text-sm text-muted-foreground">No tickets.</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-xs">
              <thead className="bg-muted/50 text-muted-foreground"><tr>
                <th className="text-left p-2.5">Subject</th><th className="text-left p-2.5">From</th>
                <th className="text-left p-2.5">Role</th><th className="text-left p-2.5">Category</th>
                <th className="text-left p-2.5">Status</th><th className="text-left p-2.5">Updated</th><th></th>
              </tr></thead>
              <tbody>
                {tickets.map((t) => (
                  <tr key={t.id} className="border-t border-border hover:bg-muted/30">
                    <td className="p-2.5 text-foreground max-w-[260px] truncate">{t.subject}</td>
                    <td className="p-2.5 text-muted-foreground">{t.user_name || "—"}</td>
                    <td className="p-2.5 text-muted-foreground">{t.role}</td>
                    <td className="p-2.5 text-muted-foreground">{t.category || "—"}</td>
                    <td className="p-2.5"><Badge className={statusClass(t.status)}>{t.status.replace("_", " ")}</Badge></td>
                    <td className="p-2.5 text-muted-foreground">{(t.updated_at || "").slice(0, 16)}</td>
                    <td className="p-2.5"><Button size="sm" variant="outline" onClick={() => open(t.id)}>Open</Button></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {detail && <TicketDrawer data={detail} onClose={() => setDetail(null)} onChanged={() => { load(); open(detail.id); }} />}
    </div>
  );
}

function TicketDrawer({ data, onClose, onChanged }: { data: any; onClose: () => void; onChanged: () => void }) {
  const [msg, setMsg] = useState("");
  const [internal, setInternal] = useState(false);
  const [sending, setSending] = useState(false);
  const replies: any[] = data.replies || [];

  const send = async () => {
    if (!msg.trim()) return;
    setSending(true);
    const r = await adminSupportReply(data.id, msg.trim(), internal);
    setSending(false);
    if (r.ok) { toast.success(internal ? "Internal note added" : "Reply sent + user notified"); setMsg(""); onChanged(); }
    else toast.error(r.data?.detail || "Failed");
  };

  const setStatus = async (s: string) => {
    const r = await adminSupportStatus(data.id, s);
    if (r.ok) { toast.success(`Status → ${s.replace("_", " ")} (user notified)`); onChanged(); }
  };

  return (
    <div className="fixed inset-0 z-50 flex justify-end bg-black/60" onClick={onClose}>
      <div className="h-full w-full max-w-lg overflow-y-auto bg-card border-l border-border" onClick={(e) => e.stopPropagation()}>
        <div className="sticky top-0 flex items-center justify-between border-b border-border bg-card p-4">
          <div className="min-w-0">
            <h3 className="font-display text-lg text-foreground truncate">{data.subject}</h3>
            <p className="text-xs text-muted-foreground">{data.user_name} · {data.user_email} · {data.role}</p>
          </div>
          <button onClick={onClose} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
        </div>

        <div className="p-4 space-y-4">
          {/* status actions */}
          <div className="flex flex-wrap gap-2">
            {["pending", "in_progress", "completed", "closed"].map((s) => (
              <button key={s} onClick={() => setStatus(s)}
                className={`rounded-lg px-2.5 py-1 text-xs font-semibold ${data.status === s ? statusClass(s) : "border border-border text-muted-foreground"}`}>{s.replace("_", " ")}</button>
            ))}
          </div>

          {/* original message */}
          <div className="rounded-xl bg-muted/30 p-3">
            <p className="text-xs font-semibold text-muted-foreground mb-1">{data.user_name || "User"}</p>
            <p className="text-sm text-foreground whitespace-pre-wrap">{data.description}</p>
            {Array.isArray(data.images) && data.images.length > 0 && (
              <div className="mt-2 flex gap-2">
                {data.images.map((u: string, i: number) => (
                  <a key={i} href={u.startsWith("http") ? u : API_ORIGIN + u} target="_blank" rel="noreferrer"
                    className="flex items-center gap-1 rounded-lg border border-border px-2 py-1 text-xs text-primary">
                    <ImageIcon className="w-3.5 h-3.5" /> image {i + 1}
                  </a>
                ))}
              </div>
            )}
          </div>

          {/* thread */}
          {replies.map((r) => (
            <div key={r.id} className={`rounded-xl p-3 ${r.author === "admin" ? "bg-primary/10 ml-6" : "bg-muted/30 mr-6"} ${r.is_internal ? "border border-yellow-500/40" : ""}`}>
              <p className="mb-1 flex items-center gap-1 text-xs font-semibold text-muted-foreground">
                {r.author === "admin" ? "Support" : (data.user_name || "User")}
                {r.is_internal && <span className="inline-flex items-center gap-0.5 text-yellow-400"><Lock className="w-3 h-3" /> internal</span>}
              </p>
              <p className="text-sm text-foreground whitespace-pre-wrap">{r.message}</p>
            </div>
          ))}

          {/* reply box */}
          <div className="space-y-2 rounded-xl border border-border p-3">
            <Textarea rows={3} placeholder="Write a reply to the user…" value={msg} onChange={(e) => setMsg(e.target.value)} />
            <div className="flex items-center justify-between">
              <label className="flex items-center gap-2 text-xs text-muted-foreground">
                <input type="checkbox" checked={internal} onChange={(e) => setInternal(e.target.checked)} />
                Internal note (not sent to user)
              </label>
              <Button size="sm" onClick={send} disabled={sending || !msg.trim()}>
                <Send className="w-4 h-4 mr-1" /> {internal ? "Add note" : "Send + notify"}
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
