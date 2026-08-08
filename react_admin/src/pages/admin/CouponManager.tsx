import { useCallback, useEffect, useState, type ReactNode } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Ticket, RefreshCw, Plus, X, Check, Ban, Trash2 } from "lucide-react";
import {
  adminCoupons, adminCouponCreate, adminCouponUpdate,
  adminCouponModerate, adminCouponDelete, adminCouponRedemptions,
} from "@/services/api";
import { toast } from "sonner";

interface Coupon {
  id: string; code: string | null; owner_type: string; owner_id: string | null;
  kind: string; discount_type: string; discount_value: number;
  max_discount_amt: number | null; min_order_amt: number | null;
  applies_to: string[] | null; first_time_only: boolean;
  per_user_limit: number | null; max_redemptions: number | null;
  redeemed_count: number; funded_by: string;
  starts_at: string | null; expires_at: string | null; status: string;
  title: string; description: string;
}

const STATUS_STYLE: Record<string, string> = {
  active: "bg-green-500/20 text-green-400",
  paused: "bg-muted text-muted-foreground",
  pending_review: "bg-yellow-500/20 text-yellow-400",
  rejected: "bg-red-500/20 text-red-400",
  expired: "bg-muted text-muted-foreground",
};

const blank = (): any => ({
  code: "", kind: "product", discount_type: "percent", discount_value: 10,
  max_discount_amt: "", min_order_amt: "", applies_to: "", first_time_only: true,
  per_user_limit: 1, max_redemptions: "", funded_by: "platform",
  starts_at: "", expires_at: "", status: "active", title: "",
});

export default function CouponManager() {
  const [tab, setTab] = useState<"coupons" | "redemptions">("coupons");
  const [items, setItems] = useState<Coupon[]>([]);
  const [loading, setLoading] = useState(false);
  const [fOwner, setFOwner] = useState("");
  const [fStatus, setFStatus] = useState("");
  const [editing, setEditing] = useState<any | null>(null);
  const [saving, setSaving] = useState(false);

  const [reds, setReds] = useState<any[]>([]);
  const [redTotal, setRedTotal] = useState(0);
  const [redDiscount, setRedDiscount] = useState(0);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminCoupons({ owner_type: fOwner, status: fStatus });
    if (r.ok) setItems(r.data?.items ?? []);
    else if (r.status === 404) toast.error("Deploy the backend with coupon management");
    setLoading(false);
  }, [fOwner, fStatus]);

  const loadReds = useCallback(async () => {
    const r = await adminCouponRedemptions({ limit: 100 });
    if (r.ok) { setReds(r.data?.items ?? []); setRedTotal(r.data?.total ?? 0); setRedDiscount(r.data?.total_discount_applied ?? 0); }
  }, []);

  useEffect(() => { if (tab === "coupons") load(); else loadReds(); }, [tab, load, loadReds]);

  const openCreate = () => setEditing(blank());
  const openEdit = (c: Coupon) => setEditing({
    ...blank(), ...c,
    applies_to: (c.applies_to || []).join(", "),
    max_discount_amt: c.max_discount_amt ?? "",
    min_order_amt: c.min_order_amt ?? "",
    max_redemptions: c.max_redemptions ?? "",
    starts_at: c.starts_at?.slice(0, 16) ?? "",
    expires_at: c.expires_at?.slice(0, 16) ?? "",
  });

  const save = async () => {
    if (!editing) return;
    setSaving(true);
    const payload: any = {
      code: editing.code || null,
      kind: editing.kind,
      discount_type: editing.discount_type,
      discount_value: Number(editing.discount_value) || 0,
      max_discount_amt: editing.max_discount_amt === "" ? null : Number(editing.max_discount_amt),
      min_order_amt: editing.min_order_amt === "" ? null : Number(editing.min_order_amt),
      applies_to: editing.applies_to ? String(editing.applies_to).split(",").map((s: string) => s.trim()).filter(Boolean) : null,
      first_time_only: !!editing.first_time_only,
      per_user_limit: editing.per_user_limit === "" ? null : Number(editing.per_user_limit),
      max_redemptions: editing.max_redemptions === "" ? null : Number(editing.max_redemptions),
      funded_by: editing.funded_by,
      starts_at: editing.starts_at || null,
      expires_at: editing.expires_at || null,
      status: editing.status,
      title: editing.title || null,
    };
    const r = editing.id
      ? await adminCouponUpdate(editing.id, payload)
      : await adminCouponCreate(payload);
    if (r.ok) { toast.success(editing.id ? "Coupon updated" : "Coupon created"); setEditing(null); load(); }
    else toast.error(r.data?.detail || "Save failed");
    setSaving(false);
  };

  const moderate = async (c: Coupon, action: "approve" | "reject") => {
    const r = await adminCouponModerate(c.id, action);
    if (r.ok) { toast.success(`Coupon ${action}d`); load(); } else toast.error("Failed");
  };
  const remove = async (c: Coupon) => {
    if (!confirm(`Delete coupon ${c.code || c.id}?`)) return;
    const r = await adminCouponDelete(c.id);
    if (r.ok) { toast.success("Deleted"); load(); } else toast.error("Failed");
  };

  const discountLabel = (c: Coupon) =>
    c.discount_type === "full" ? "100% FREE"
      : c.discount_type === "flat" ? `₹${c.discount_value} off`
        : `${c.discount_value}% off${c.max_discount_amt ? ` (max ₹${c.max_discount_amt})` : ""}`;

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <Ticket className="w-6 h-6 text-primary" /> Coupons & Discounts
          </h1>
          <p className="text-sm text-muted-foreground">Platform coupons, 100% codes, product discounts, and astrologer-coupon moderation.</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={() => (tab === "coupons" ? load() : loadReds())} disabled={loading}>
            <RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} />
          </Button>
          {tab === "coupons" && <Button size="sm" onClick={openCreate}><Plus className="w-4 h-4 mr-1" /> New coupon</Button>}
        </div>
      </div>

      <div className="flex gap-1">
        {(["coupons", "redemptions"] as const).map((t) => (
          <button key={t} onClick={() => setTab(t)}
            className={`rounded-md px-3 py-1 text-xs font-semibold capitalize ${tab === t ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{t}</button>
        ))}
      </div>

      {tab === "coupons" ? (
        <>
          <div className="flex flex-wrap gap-2">
            <select value={fOwner} onChange={(e) => setFOwner(e.target.value)} className="rounded-md border border-border bg-card px-2 py-1 text-xs text-foreground">
              <option value="">All owners</option>
              <option value="platform">Platform (admin)</option>
              <option value="astrologer">Astrologer</option>
            </select>
            <select value={fStatus} onChange={(e) => setFStatus(e.target.value)} className="rounded-md border border-border bg-card px-2 py-1 text-xs text-foreground">
              <option value="">All statuses</option>
              {["active", "paused", "pending_review", "rejected"].map((s) => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>

          <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
                  <th className="text-left p-2.5">Code / Title</th>
                  <th className="text-left p-2.5">Owner</th>
                  <th className="text-left p-2.5">Kind</th>
                  <th className="text-left p-2.5">Discount</th>
                  <th className="text-left p-2.5">Used</th>
                  <th className="text-left p-2.5">Status</th>
                  <th className="text-right p-2.5">Actions</th>
                </tr></thead>
                <tbody>
                  {items.map((c) => (
                    <tr key={c.id} className="border-t border-border align-top">
                      <td className="p-2.5"><div className="font-mono text-foreground">{c.code || "—"}</div><div className="text-[11px] text-muted-foreground">{c.title}</div></td>
                      <td className="p-2.5 text-muted-foreground">{c.owner_type}</td>
                      <td className="p-2.5 text-muted-foreground">{c.kind}</td>
                      <td className="p-2.5 text-primary">{discountLabel(c)}</td>
                      <td className="p-2.5 text-muted-foreground">{c.redeemed_count}{c.max_redemptions ? `/${c.max_redemptions}` : ""}</td>
                      <td className="p-2.5"><Badge className={STATUS_STYLE[c.status] || ""}>{c.status}</Badge></td>
                      <td className="p-2.5 text-right whitespace-nowrap">
                        {c.status === "pending_review" && (
                          <>
                            <Button size="sm" variant="ghost" onClick={() => moderate(c, "approve")} title="Approve"><Check className="w-4 h-4 text-green-400" /></Button>
                            <Button size="sm" variant="ghost" onClick={() => moderate(c, "reject")} title="Reject"><Ban className="w-4 h-4 text-red-400" /></Button>
                          </>
                        )}
                        <Button size="sm" variant="outline" onClick={() => openEdit(c)}>Edit</Button>
                        <Button size="sm" variant="ghost" onClick={() => remove(c)}><Trash2 className="w-4 h-4 text-red-400" /></Button>
                      </td>
                    </tr>
                  ))}
                  {items.length === 0 && !loading && <tr><td colSpan={7} className="p-6 text-center text-muted-foreground">No coupons yet.</td></tr>}
                </tbody>
              </table>
            </div>
          </div>
        </>
      ) : (
        <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
          <div className="flex items-center justify-between p-3 text-sm">
            <span className="text-muted-foreground">{redTotal} redemptions</span>
            <span className="text-primary font-semibold">₹{redDiscount.toFixed(2)} total discount applied</span>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
                <th className="text-left p-2.5">When</th>
                <th className="text-left p-2.5">Coupon</th>
                <th className="text-left p-2.5">User</th>
                <th className="text-left p-2.5">Context</th>
                <th className="text-left p-2.5">Base</th>
                <th className="text-left p-2.5">Discount</th>
                <th className="text-left p-2.5">Funded by</th>
                <th className="text-left p-2.5">Status</th>
              </tr></thead>
              <tbody>
                {reds.map((r) => (
                  <tr key={r.id} className="border-t border-border">
                    <td className="p-2.5 text-muted-foreground whitespace-nowrap">{r.created_at ? new Date(r.created_at).toLocaleString() : "—"}</td>
                    <td className="p-2.5 font-mono text-foreground">{r.coupon_code || r.coupon_id?.slice(0, 8)}</td>
                    <td className="p-2.5 text-muted-foreground">{r.user_id?.slice(0, 8)}</td>
                    <td className="p-2.5 text-muted-foreground">{r.context_type}</td>
                    <td className="p-2.5 text-muted-foreground">{r.currency} {r.base_amount}</td>
                    <td className="p-2.5 text-primary">−{r.discount_amount}</td>
                    <td className="p-2.5 text-muted-foreground">{r.funded_by}</td>
                    <td className="p-2.5"><Badge className={r.status === "applied" ? "bg-green-500/15 text-green-400" : "bg-muted text-muted-foreground"}>{r.status}</Badge></td>
                  </tr>
                ))}
                {reds.length === 0 && <tr><td colSpan={8} className="p-6 text-center text-muted-foreground">No redemptions yet.</td></tr>}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {editing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 overflow-y-auto" onClick={() => setEditing(null)}>
          <div className="w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-3 my-8" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between">
              <h3 className="font-display text-lg text-foreground">{editing.id ? "Edit coupon" : "New coupon"}</h3>
              <button onClick={() => setEditing(null)} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <Field label="Code (optional)"><Input value={editing.code} onChange={(e) => setEditing({ ...editing, code: e.target.value.toUpperCase() })} placeholder="FREE100" /></Field>
              <Field label="Kind">
                <Select value={editing.kind} onChange={(v) => setEditing({ ...editing, kind: v })} opts={["product", "all_free", "flat", "consultation", "first_consult"]} />
              </Field>
              <Field label="Discount type">
                <Select value={editing.discount_type} onChange={(v) => setEditing({ ...editing, discount_type: v })} opts={["percent", "flat", "full"]} />
              </Field>
              <Field label="Value (% or ₹)"><Input type="number" value={editing.discount_value} onChange={(e) => setEditing({ ...editing, discount_value: e.target.value })} /></Field>
              <Field label="Max discount ₹ (cap)"><Input type="number" value={editing.max_discount_amt} onChange={(e) => setEditing({ ...editing, max_discount_amt: e.target.value })} /></Field>
              <Field label="Min order ₹"><Input type="number" value={editing.min_order_amt} onChange={(e) => setEditing({ ...editing, min_order_amt: e.target.value })} /></Field>
              <Field label="Per-user limit"><Input type="number" value={editing.per_user_limit} onChange={(e) => setEditing({ ...editing, per_user_limit: e.target.value })} /></Field>
              <Field label="Max redemptions"><Input type="number" value={editing.max_redemptions} onChange={(e) => setEditing({ ...editing, max_redemptions: e.target.value })} placeholder="unlimited" /></Field>
              <Field label="Funded by">
                <Select value={editing.funded_by} onChange={(v) => setEditing({ ...editing, funded_by: v })} opts={["platform", "astrologer"]} />
              </Field>
              <Field label="Status">
                <Select value={editing.status} onChange={(v) => setEditing({ ...editing, status: v })} opts={["active", "paused", "pending_review", "rejected"]} />
              </Field>
              <Field label="Starts at"><Input type="datetime-local" value={editing.starts_at} onChange={(e) => setEditing({ ...editing, starts_at: e.target.value })} /></Field>
              <Field label="Expires at"><Input type="datetime-local" value={editing.expires_at} onChange={(e) => setEditing({ ...editing, expires_at: e.target.value })} /></Field>
            </div>
            <Field label="Applies to (service_keys, comma-sep — blank = all)"><Input value={editing.applies_to} onChange={(e) => setEditing({ ...editing, applies_to: e.target.value })} placeholder="career, marriage" /></Field>
            <Field label="Title (English — shown to user)"><Input value={editing.title} onChange={(e) => setEditing({ ...editing, title: e.target.value })} placeholder="Get 20% off your first report" /></Field>
            <label className="flex items-center gap-2 text-sm text-foreground">
              <input type="checkbox" checked={editing.first_time_only} onChange={(e) => setEditing({ ...editing, first_time_only: e.target.checked })} />
              First-time users only
            </label>
            <div className="flex justify-end gap-2 pt-1">
              <Button variant="outline" onClick={() => setEditing(null)}>Cancel</Button>
              <Button onClick={save} disabled={saving}>{saving ? "Saving…" : "Save"}</Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="space-y-1">
      <p className="text-[11px] font-semibold text-muted-foreground">{label}</p>
      {children}
    </div>
  );
}
function Select({ value, onChange, opts }: { value: string; onChange: (v: string) => void; opts: string[] }) {
  return (
    <select value={value} onChange={(e) => onChange(e.target.value)} className="w-full rounded-md border border-border bg-card px-2 py-2 text-sm text-foreground">
      {opts.map((o) => <option key={o} value={o}>{o}</option>)}
    </select>
  );
}
