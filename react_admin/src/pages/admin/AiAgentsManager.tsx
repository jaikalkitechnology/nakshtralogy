import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Bot, RefreshCw, X, Users, Lock, Unlock, Clock, Plus, Trash2 } from "lucide-react";
import { adminAiAgents, adminAiAgentUpdate } from "@/services/api";
import { toast } from "sonner";

interface Agent {
  key: string; label: string; emoji?: string;
  status: "draft" | "testing" | "published";
  is_paid: boolean; price: number; free_intro?: string;
  // International (store IAP). price_usd auto-computes from ₹ unless overridden.
  price_usd?: number | null;
  iap_product_id?: string | null;
  price_usd_manual?: boolean;
  // Time pass: pay per minutes (e.g. 10 min = ₹100). Empty = one-time unlock.
  time_plans?: TimePlan[];
  test_users: { id: string; email: string; name?: string }[];
  unlocks: number;
}

interface TimePlan { minutes: number; price: number }

const planSummary = (plans: TimePlan[]) =>
  plans.map((p) => `${p.minutes} min ₹${p.price.toFixed(0)}`).join(" · ");

const STATUS_STYLE: Record<string, string> = {
  draft: "bg-muted text-muted-foreground",
  testing: "bg-yellow-500/20 text-yellow-400",
  published: "bg-green-500/20 text-green-400",
};

export default function AiAgentsManager() {
  const [items, setItems] = useState<Agent[]>([]);
  const [loading, setLoading] = useState(false);
  const [editing, setEditing] = useState<Agent | null>(null);
  const [testerText, setTesterText] = useState("");
  // Pricing type in the editor: "one_time" (pay once, unlimited) or "time" (pay per minutes).
  const [pricingMode, setPricingMode] = useState<"one_time" | "time">("one_time");
  const [plans, setPlans] = useState<TimePlan[]>([]);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminAiAgents();
    if (r.ok) setItems(r.data?.items ?? []);
    else if (r.status === 404) toast.error("Deploy the backend with AI agent management");
    setLoading(false);
  }, []);
  useEffect(() => { load(); }, [load]);

  const openEdit = (a: Agent) => {
    setEditing(a);
    setTesterText((a.test_users || []).map((u) => u.email).join(", "));
    const existing = a.time_plans || [];
    setPricingMode(existing.length ? "time" : "one_time");
    setPlans(existing.length ? existing : [{ minutes: 10, price: 100 }, { minutes: 20, price: 200 }]);
  };

  const updatePlan = (i: number, patch: Partial<TimePlan>) =>
    setPlans(plans.map((p, j) => (j === i ? { ...p, ...patch } : p)));

  const save = async () => {
    if (!editing) return;
    const testers = testerText.split(",").map((s) => s.trim()).filter(Boolean);
    const timeMode = editing.is_paid && pricingMode === "time";
    const cleanPlans = plans.filter((p) => p.minutes >= 1 && p.price >= 0);
    if (timeMode && cleanPlans.length === 0) {
      toast.error("Add at least one time plan (minutes and price)");
      return;
    }
    const r = await adminAiAgentUpdate(editing.key, {
      status: editing.status,
      is_paid: editing.is_paid,
      price: editing.price,
      // USD/store IAP: send the override only when the admin has chosen manual.
      // Otherwise leave price_usd_manual=false so the backend auto-computes it
      // from the ₹ price (and mints the store product id).
      price_usd_manual: !!editing.price_usd_manual,
      ...(editing.price_usd_manual
        ? { price_usd: editing.price_usd ?? 0 }
        : {}),
      free_intro: editing.free_intro || null,
      test_user_ids: testers,
      // [] = one-time unlock; plans = pay per minutes.
      time_plans: timeMode ? cleanPlans : [],
    });
    if (r.ok) { toast.success("Agent updated"); setEditing(null); load(); }
    else toast.error(r.data?.detail || "Save failed");
  };

  // Quick inline status change without opening the editor.
  const quickStatus = async (a: Agent, status: string) => {
    const r = await adminAiAgentUpdate(a.key, { status });
    if (r.ok) load();
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><Bot className="w-6 h-6 text-primary" /> AI Chat Agents</h1>
          <p className="text-sm text-muted-foreground">Publish AI specialists, run them in testing for selected users, and set unlock pricing.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-muted-foreground text-xs"><tr>
              <th className="text-left p-2.5">Agent</th>
              <th className="text-left p-2.5">Status</th>
              <th className="text-left p-2.5">Pricing</th>
              <th className="text-left p-2.5">Testers</th>
              <th className="text-left p-2.5">Unlocks</th>
              <th></th>
            </tr></thead>
            <tbody>
              {items.map((a) => (
                <tr key={a.key} className="border-t border-border hover:bg-muted/30">
                  <td className="p-2.5 text-foreground">{a.emoji} {a.label}</td>
                  <td className="p-2.5">
                    <div className="flex gap-1">
                      {(["draft", "testing", "published"] as const).map((s) => (
                        <button key={s} onClick={() => quickStatus(a, s)}
                          className={`rounded-md px-2 py-0.5 text-[11px] font-semibold ${a.status === s ? STATUS_STYLE[s] : "border border-border text-muted-foreground"}`}>{s}</button>
                      ))}
                    </div>
                  </td>
                  <td className="p-2.5">
                    {a.is_paid && a.time_plans?.length
                      ? <span className="inline-flex items-center gap-1 text-primary"><Clock className="w-3.5 h-3.5" /> {planSummary(a.time_plans)}</span>
                      : a.is_paid
                      ? <span className="inline-flex items-center gap-1 text-primary"><Lock className="w-3.5 h-3.5" /> ₹{a.price.toFixed(0)} one-time
                          {a.price_usd != null && <span className="text-muted-foreground">· ${a.price_usd.toFixed(2)}</span>}</span>
                      : <span className="inline-flex items-center gap-1 text-green-400"><Unlock className="w-3.5 h-3.5" /> Free</span>}
                  </td>
                  <td className="p-2.5 text-muted-foreground">{a.status === "testing" ? `${a.test_users?.length || 0}` : "—"}</td>
                  <td className="p-2.5 text-muted-foreground">{a.unlocks}</td>
                  <td className="p-2.5 text-right"><Button size="sm" variant="outline" onClick={() => openEdit(a)}>Manage</Button></td>
                </tr>
              ))}
              {items.length === 0 && !loading && <tr><td colSpan={6} className="p-6 text-center text-muted-foreground">No AI agents.</td></tr>}
            </tbody>
          </table>
        </div>
      </div>

      {editing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/60 p-4" onClick={() => setEditing(null)}>
          <div className="my-8 w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-4" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between">
              <h3 className="font-display text-lg text-foreground">{editing.emoji} {editing.label}</h3>
              <button onClick={() => setEditing(null)} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
            </div>

            <div>
              <p className="text-xs font-semibold text-muted-foreground mb-1">Visibility</p>
              <div className="flex gap-2">
                {(["draft", "testing", "published"] as const).map((s) => (
                  <button key={s} onClick={() => setEditing({ ...editing, status: s })}
                    className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${editing.status === s ? STATUS_STYLE[s] : "border border-border text-muted-foreground"}`}>{s}</button>
                ))}
              </div>
              <p className="mt-1 text-[11px] text-muted-foreground">
                draft = hidden · testing = only listed testers · published = all users
              </p>
            </div>

            {editing.status === "testing" && (
              <div>
                <p className="text-xs font-semibold text-muted-foreground mb-1 flex items-center gap-1"><Users className="w-3.5 h-3.5" /> Test users (emails, comma-separated)</p>
                <Textarea rows={2} value={testerText} onChange={(e) => setTesterText(e.target.value)} placeholder="tester1@email.com, tester2@email.com" />
              </div>
            )}

            <div>
              <p className="text-xs font-semibold text-muted-foreground mb-1">Pricing</p>
              <label className="flex items-center gap-2 text-sm text-foreground">
                <input type="checkbox" checked={editing.is_paid} onChange={(e) => setEditing({ ...editing, is_paid: e.target.checked })} />
                Paid — users must pay to use this AI chat
              </label>
              {editing.is_paid && (
                <div className="mt-2 flex gap-2">
                  {([["one_time", "One-time unlock"], ["time", "Per time (minutes)"]] as const).map(([m, label]) => (
                    <button key={m} onClick={() => setPricingMode(m)}
                      className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${pricingMode === m ? "bg-primary/20 text-primary" : "border border-border text-muted-foreground"}`}>{label}</button>
                  ))}
                </div>
              )}
              {editing.is_paid && pricingMode === "time" && (
                <div className="mt-3 space-y-2">
                  {plans.map((p, i) => (
                    <div key={i} className="flex items-center gap-2">
                      <Input type="number" min={1} className="w-24" value={p.minutes}
                        onChange={(e) => updatePlan(i, { minutes: parseInt(e.target.value) || 0 })} />
                      <span className="text-sm text-muted-foreground">min =</span>
                      <span className="text-sm text-muted-foreground">₹</span>
                      <Input type="number" min={0} className="w-28" value={p.price}
                        onChange={(e) => updatePlan(i, { price: parseFloat(e.target.value) || 0 })} />
                      <button onClick={() => setPlans(plans.filter((_, j) => j !== i))}
                        className="text-muted-foreground hover:text-red-400" title="Remove plan"><Trash2 className="w-4 h-4" /></button>
                    </div>
                  ))}
                  {plans.length < 8 && (
                    <Button size="sm" variant="outline" onClick={() => setPlans([...plans, { minutes: (plans[plans.length - 1]?.minutes || 0) + 10, price: 0 }])}>
                      <Plus className="w-3.5 h-3.5 mr-1" /> Add plan
                    </Button>
                  )}
                  <p className="text-[11px] text-muted-foreground">
                    Example: 10 min = ₹100, 20 min = ₹200. The user picks a plan and pays from the ₹ wallet; time starts at
                    payment, and buying again adds minutes to the time left. When time ends the chat locks until they buy more.
                    Time plans are India-only (wallet) — international users can't buy this topic while it is priced by time.
                  </p>
                </div>
              )}
              {editing.is_paid && pricingMode === "one_time" && (
                <div className="mt-3 space-y-3">
                  <div className="flex items-center gap-2">
                    <span className="text-sm text-muted-foreground">Unlock price ₹ (India · wallet)</span>
                    <Input type="number" className="w-28" value={editing.price} onChange={(e) => setEditing({ ...editing, price: parseFloat(e.target.value) || 0 })} />
                  </div>
                  <div className="rounded-lg border border-border/60 p-2.5 space-y-2">
                    <label className="flex items-center gap-2 text-sm text-foreground">
                      <input type="checkbox" checked={!!editing.price_usd_manual}
                        onChange={(e) => setEditing({ ...editing, price_usd_manual: e.target.checked })} />
                      Override international USD price (store IAP)
                    </label>
                    {editing.price_usd_manual ? (
                      <div className="flex items-center gap-2">
                        <span className="text-sm text-muted-foreground">Unlock price $</span>
                        <Input type="number" step="0.01" className="w-28"
                          value={editing.price_usd ?? 0}
                          onChange={(e) => setEditing({ ...editing, price_usd: parseFloat(e.target.value) || 0 })} />
                      </div>
                    ) : (
                      <p className="text-[11px] text-muted-foreground">
                        Auto: ${editing.price_usd != null ? editing.price_usd.toFixed(2) : "—"} — computed from ₹ and rounded to the nearest App Store / Google Play tier. Sold via store IAP to international users.
                      </p>
                    )}
                    {editing.iap_product_id && (
                      <p className="text-[11px] text-muted-foreground break-all">SKU: {editing.iap_product_id}</p>
                    )}
                  </div>
                </div>
              )}
            </div>

            <div>
              <p className="text-xs font-semibold text-muted-foreground mb-1">Teaser (shown before unlock, optional)</p>
              <Textarea rows={2} value={editing.free_intro || ""} onChange={(e) => setEditing({ ...editing, free_intro: e.target.value })} placeholder="e.g. Get personalised guidance on your career from your birth chart." />
            </div>

            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setEditing(null)}>Cancel</Button>
              <Button onClick={save}>Save</Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
