import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Bot, RefreshCw, X, Users, Lock, Unlock } from "lucide-react";
import { adminAiAgents, adminAiAgentUpdate } from "@/services/api";
import { toast } from "sonner";

interface Agent {
  key: string; label: string; emoji?: string;
  status: "draft" | "testing" | "published";
  is_paid: boolean; price: number; free_intro?: string;
  test_users: { id: string; email: string; name?: string }[];
  unlocks: number;
}

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
  };

  const save = async () => {
    if (!editing) return;
    const testers = testerText.split(",").map((s) => s.trim()).filter(Boolean);
    const r = await adminAiAgentUpdate(editing.key, {
      status: editing.status,
      is_paid: editing.is_paid,
      price: editing.price,
      free_intro: editing.free_intro || null,
      test_user_ids: testers,
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
                    {a.is_paid
                      ? <span className="inline-flex items-center gap-1 text-primary"><Lock className="w-3.5 h-3.5" /> ₹{a.price.toFixed(0)}</span>
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
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={() => setEditing(null)}>
          <div className="w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-4" onClick={(e) => e.stopPropagation()}>
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
                Paid — users unlock this AI chat once from their wallet
              </label>
              {editing.is_paid && (
                <div className="mt-2 flex items-center gap-2">
                  <span className="text-sm text-muted-foreground">Unlock price ₹</span>
                  <Input type="number" className="w-28" value={editing.price} onChange={(e) => setEditing({ ...editing, price: parseFloat(e.target.value) || 0 })} />
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
