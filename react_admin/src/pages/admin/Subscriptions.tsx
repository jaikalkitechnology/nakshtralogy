import { useCallback, useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Crown, RefreshCw, Plus, X, Trash2, Sparkles } from "lucide-react";
import {
  adminPlusPlans, adminPlusPlanCreate, adminPlusPlanUpdate, adminPlusPlanDelete,
  adminPlusSubscribers, adminPlusPlanSeed,
} from "@/services/api";
import { toast } from "sonner";

interface PlanRow {
  id: string; code: string; name: string; duration_days: number;
  price: number; original_price: number | null; price_usd: number | null;
  price_usd_manual: boolean; icon: string | null; features: string[];
  is_active: boolean; sort_order: number;
}

function blank(): Partial<PlanRow> {
  return { code: "", name: "", duration_days: 30, price: 0, is_active: true, features: [] };
}

export default function Subscriptions() {
  const [tab, setTab] = useState<"plans" | "subscribers">("plans");
  const [plans, setPlans] = useState<PlanRow[]>([]);
  const [subs, setSubs] = useState<any[]>([]);
  const [activeCount, setActiveCount] = useState(0);
  const [revenue, setRevenue] = useState(0);
  const [loading, setLoading] = useState(false);
  const [editing, setEditing] = useState<Partial<PlanRow> | null>(null);
  const [saving, setSaving] = useState(false);
  const [seeding, setSeeding] = useState(false);

  const loadPlans = useCallback(async () => {
    setLoading(true);
    const r = await adminPlusPlans();
    if (r.ok) setPlans(r.data?.items ?? []);
    else if (r.status === 404) toast.error("Deploy the backend with NakshtralogyPlus");
    setLoading(false);
  }, []);

  const loadSubs = useCallback(async () => {
    setLoading(true);
    const r = await adminPlusSubscribers({ status: "active" });
    if (r.ok) { setSubs(r.data?.items ?? []); setActiveCount(r.data?.active_count ?? 0); setRevenue(r.data?.total_revenue ?? 0); }
    setLoading(false);
  }, []);

  useEffect(() => { if (tab === "plans") loadPlans(); else loadSubs(); }, [tab, loadPlans, loadSubs]);

  const save = async () => {
    if (!editing) return;
    if (!editing.code || !editing.name || !editing.duration_days) {
      toast.error("Code, name and duration are required"); return;
    }
    setSaving(true);
    const body = {
      code: editing.code, name: editing.name, duration_days: Number(editing.duration_days),
      price: Number(editing.price ?? 0),
      original_price: editing.original_price != null ? Number(editing.original_price) : undefined,
      price_usd: editing.price_usd != null ? Number(editing.price_usd) : undefined,
      price_usd_manual: editing.price_usd_manual,
      icon: editing.icon, features: editing.features,
      is_active: editing.is_active, sort_order: editing.sort_order,
    };
    const r = editing.id ? await adminPlusPlanUpdate(editing.id, body) : await adminPlusPlanCreate(body);
    setSaving(false);
    if (r.ok) { toast.success("Saved"); setEditing(null); loadPlans(); }
    else toast.error(r.data?.detail || "Failed to save");
  };

  const seedDefaults = async () => {
    setSeeding(true);
    const r = await adminPlusPlanSeed();
    setSeeding(false);
    if (r.ok) {
      const n = r.data?.created ?? 0;
      toast.success(n > 0 ? `Added ${n} default plan${n === 1 ? "" : "s"}` : "Default plans already exist");
      loadPlans();
    } else toast.error(r.data?.detail || "Could not seed plans");
  };

  const del = async (p: PlanRow) => {
    if (!window.confirm(`Delete plan "${p.name}"? (deactivated if it has subscribers)`)) return;
    const r = await adminPlusPlanDelete(p.id);
    if (r.ok) { toast.success(r.data?.status === "deactivated" ? "Deactivated (has subscribers)" : "Deleted"); loadPlans(); }
    else toast.error(r.data?.detail || "Failed");
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <Crown className="w-6 h-6 text-primary" /> NakshtralogyPlus
          </h1>
          <p className="text-sm text-muted-foreground">All-access membership plans (7 / 15 / 30 days). Unlocks every product except live astrologer chat/call/video.</p>
        </div>
        <div className="flex items-center gap-3">
          {tab === "subscribers" && (
            <span className="text-sm text-primary font-semibold">{activeCount} active · ₹{revenue.toFixed(0)} revenue</span>
          )}
          <Button variant="outline" size="sm" onClick={() => (tab === "plans" ? loadPlans() : loadSubs())} disabled={loading}>
            <RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} />
          </Button>
          {tab === "plans" && (
            <Button variant="outline" size="sm" onClick={seedDefaults} disabled={seeding}>
              <Sparkles className={`w-4 h-4 mr-1 ${seeding ? "animate-pulse" : ""}`} /> Seed defaults
            </Button>
          )}
          {tab === "plans" && <Button size="sm" onClick={() => setEditing(blank())}><Plus className="w-4 h-4 mr-1" /> New plan</Button>}
        </div>
      </div>

      <div className="flex gap-1">
        {(["plans", "subscribers"] as const).map((t) => (
          <button key={t} onClick={() => setTab(t)}
            className={`rounded-md px-3 py-1 text-xs font-semibold capitalize ${tab === t ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{t}</button>
        ))}
      </div>

      {tab === "plans" ? (
        <div className="grid gap-3 md:grid-cols-2 lg:grid-cols-3">
          {plans.map((p) => (
            <div key={p.id} className="rounded-xl border border-border bg-card/60 p-4 space-y-2">
              <div className="flex items-start justify-between">
                <div>
                  <div className="text-lg font-semibold text-foreground">{p.icon} {p.name}</div>
                  <div className="text-xs text-muted-foreground font-mono">{p.code} · {p.duration_days} days</div>
                </div>
                <Badge className={p.is_active ? "bg-green-500/20 text-green-400" : "bg-muted text-muted-foreground"}>{p.is_active ? "active" : "off"}</Badge>
              </div>
              <div className="text-primary font-bold">₹{p.price}{p.original_price ? <span className="ml-2 text-xs text-muted-foreground line-through">₹{p.original_price}</span> : null}
                {p.price_usd ? <span className="ml-2 text-xs text-muted-foreground">${p.price_usd}</span> : null}
              </div>
              {p.features?.length ? <ul className="text-[11px] text-muted-foreground list-disc pl-4">{p.features.slice(0, 4).map((f, i) => <li key={i}>{f}</li>)}</ul> : null}
              <div className="flex gap-2 pt-1">
                <Button size="sm" variant="outline" onClick={() => setEditing({ ...p })}>Edit</Button>
                <Button size="sm" variant="ghost" onClick={() => del(p)}><Trash2 className="w-4 h-4 text-red-400" /></Button>
              </div>
            </div>
          ))}
          {plans.length === 0 && !loading && (
            <div className="col-span-full grid place-items-center gap-3 rounded-xl border border-dashed border-border py-10 text-center">
              <Crown className="w-8 h-8 text-primary/60" />
              <p className="text-sm text-muted-foreground">No plans yet. Seed the 3 default plans (7 / 15 / 30 days) to get started.</p>
              <Button size="sm" onClick={seedDefaults} disabled={seeding}>
                <Sparkles className="w-4 h-4 mr-1" /> {seeding ? "Seeding…" : "Seed default plans"}
              </Button>
            </div>
          )}
        </div>
      ) : (
        <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
                <th className="text-left p-2.5">User</th>
                <th className="text-left p-2.5">Plan</th>
                <th className="text-left p-2.5">Started</th>
                <th className="text-left p-2.5">Expires</th>
                <th className="text-right p-2.5">Paid</th>
                <th className="text-left p-2.5">Coupon</th>
                <th className="text-left p-2.5">Status</th>
              </tr></thead>
              <tbody>
                {subs.map((s) => (
                  <tr key={s.id} className="border-t border-border">
                    <td className="p-2.5"><div className="text-foreground">{s.user_name || "—"}</div><div className="text-[11px] text-muted-foreground">{s.user_email}</div></td>
                    <td className="p-2.5 font-mono text-xs">{s.plan_code}</td>
                    <td className="p-2.5 text-xs text-muted-foreground">{s.started_at ? new Date(s.started_at).toLocaleDateString() : ""}</td>
                    <td className="p-2.5 text-xs text-muted-foreground">{s.expires_at ? new Date(s.expires_at).toLocaleDateString() : ""}</td>
                    <td className="p-2.5 text-right text-foreground">₹{Number(s.amount_paid).toFixed(0)}</td>
                    <td className="p-2.5 text-xs text-primary font-mono">{s.coupon_code || "—"}</td>
                    <td className="p-2.5"><Badge className={s.live ? "bg-green-500/20 text-green-400" : "bg-muted text-muted-foreground"}>{s.live ? "active" : s.status}</Badge></td>
                  </tr>
                ))}
                {subs.length === 0 && !loading && <tr><td colSpan={7} className="p-6 text-center text-muted-foreground">No active subscribers.</td></tr>}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {editing && (
        <div className="fixed inset-0 z-50 grid place-items-center bg-black/60 p-4" onClick={() => setEditing(null)}>
          <div className="w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-3" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold text-foreground">{editing.id ? "Edit plan" : "New plan"}</h2>
              <button onClick={() => setEditing(null)}><X className="w-5 h-5 text-muted-foreground" /></button>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <label className="text-xs text-muted-foreground">Code (plus_7…)<Input value={editing.code ?? ""} onChange={(e) => setEditing({ ...editing, code: e.target.value })} /></label>
              <label className="text-xs text-muted-foreground">Duration (days)<Input type="number" value={editing.duration_days ?? 0} onChange={(e) => setEditing({ ...editing, duration_days: Number(e.target.value) })} /></label>
              <label className="col-span-2 text-xs text-muted-foreground">Name<Input value={editing.name ?? ""} onChange={(e) => setEditing({ ...editing, name: e.target.value })} /></label>
              <label className="text-xs text-muted-foreground">Price ₹<Input type="number" value={editing.price ?? 0} onChange={(e) => setEditing({ ...editing, price: Number(e.target.value) })} /></label>
              <label className="text-xs text-muted-foreground">Strike ₹ (optional)<Input type="number" value={editing.original_price ?? ""} onChange={(e) => setEditing({ ...editing, original_price: e.target.value === "" ? null : Number(e.target.value) })} /></label>
              <label className="text-xs text-muted-foreground">Icon (emoji)<Input value={editing.icon ?? ""} onChange={(e) => setEditing({ ...editing, icon: e.target.value })} /></label>
              <label className="text-xs text-muted-foreground">Sort order<Input type="number" value={editing.sort_order ?? 0} onChange={(e) => setEditing({ ...editing, sort_order: Number(e.target.value) })} /></label>
              <label className="col-span-2 text-xs text-muted-foreground">Features (one per line)
                <textarea className="mt-1 w-full rounded-md border border-border bg-background px-2 py-1 text-sm text-foreground" rows={4}
                  value={(editing.features ?? []).join("\n")}
                  onChange={(e) => setEditing({ ...editing, features: e.target.value.split("\n").map((s) => s.trim()).filter(Boolean) })} />
              </label>
              <label className="col-span-2 flex items-center gap-2 text-xs text-muted-foreground">
                <input type="checkbox" checked={editing.is_active ?? true} onChange={(e) => setEditing({ ...editing, is_active: e.target.checked })} /> Active
              </label>
            </div>
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
