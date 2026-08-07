import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { HelpCircle, Plus, Trash2, Pencil, RefreshCw, X, Eye, EyeOff } from "lucide-react";
import { adminFaqList, adminFaqCreate, adminFaqUpdate, adminFaqDelete, adminFaqSeed } from "@/services/api";
import { toast } from "sonner";

type Audience = "user" | "astrologer" | "both";
interface Faq {
  id: string; audience: Audience; lang?: string; category?: string; question: string;
  answer: string; sort_order: number; is_active: boolean;
}

const AUDIENCES: { key: string; label: string }[] = [
  { key: "", label: "All" },
  { key: "user", label: "User app" },
  { key: "astrologer", label: "Astrologer app" },
  { key: "both", label: "Both" },
];

// Supported languages (match the apps' locales). code → label.
const LANGS: { code: string; label: string }[] = [
  { code: "en", label: "English" },
  { code: "hi", label: "हिन्दी (Hindi)" },
  { code: "bn", label: "বাংলা (Bengali)" },
  { code: "ta", label: "தமிழ் (Tamil)" },
  { code: "te", label: "తెలుగు (Telugu)" },
  { code: "mr", label: "मराठी (Marathi)" },
  { code: "gu", label: "ગુજરાતી (Gujarati)" },
  { code: "kn", label: "ಕನ್ನಡ (Kannada)" },
  { code: "ml", label: "മലയാളം (Malayalam)" },
  { code: "pa", label: "ਪੰਜਾਬੀ (Punjabi)" },
  { code: "fr", label: "Français (French)" },
  { code: "es", label: "Español (Spanish)" },
  { code: "pt", label: "Português (Portuguese)" },
  { code: "de", label: "Deutsch (German)" },
  { code: "it", label: "Italiano (Italian)" },
  { code: "ru", label: "Русский (Russian)" },
  { code: "ar", label: "العربية (Arabic)" },
  { code: "id", label: "Indonesia (Indonesian)" },
  { code: "ja", label: "日本語 (Japanese)" },
];
const langLabel = (c?: string) => LANGS.find((l) => l.code === c)?.label || (c || "en");

export default function FaqManager() {
  const [items, setItems] = useState<Faq[]>([]);
  const [loading, setLoading] = useState(false);
  const [filter, setFilter] = useState<string>("");
  const [langFilter, setLangFilter] = useState<string>("");
  const [editing, setEditing] = useState<Partial<Faq> | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminFaqList(filter || undefined, langFilter || undefined);
    if (r.ok) setItems(r.data?.items ?? []);
    setLoading(false);
  }, [filter, langFilter]);

  useEffect(() => { load(); }, [load]);

  const save = async () => {
    if (!editing) return;
    if (!editing.question?.trim() || !editing.answer?.trim()) { toast.error("Question and answer are required"); return; }
    const body = {
      audience: editing.audience || "user",
      lang: editing.lang || "en",
      category: editing.category || null,
      question: editing.question,
      answer: editing.answer,
      sort_order: editing.sort_order ?? 0,
      is_active: editing.is_active ?? true,
    };
    const r = editing.id ? await adminFaqUpdate(editing.id, body) : await adminFaqCreate(body);
    if (r.ok) { toast.success(editing.id ? "FAQ updated" : "FAQ added"); setEditing(null); load(); }
    else toast.error(r.data?.detail || "Save failed");
  };

  const remove = async (id: string) => {
    if (!confirm("Delete this FAQ?")) return;
    const r = await adminFaqDelete(id);
    if (r.ok) { toast.success("Deleted"); load(); }
  };

  const toggle = async (f: Faq) => {
    const r = await adminFaqUpdate(f.id, { is_active: !f.is_active });
    if (r.ok) load();
  };

  const seed = async () => {
    const r = await adminFaqSeed();
    if (r.ok) {
      const n = r.data?.seeded ?? 0;
      toast.success(n ? `Added ${n} recommended FAQ${n === 1 ? "" : "s"}` : "All recommended FAQs are already present");
      load();
    } else {
      toast.error(r.data?.detail || "Failed");
    }
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><HelpCircle className="w-6 h-6 text-primary" /> FAQ Management</h1>
          <p className="text-sm text-muted-foreground">Help content shown in the apps' Customer Support screen — separate per app.</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={seed}>Add recommended FAQ</Button>
          <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
          <Button size="sm" onClick={() => setEditing({ audience: "user", lang: langFilter || "en", is_active: true, sort_order: items.length })}><Plus className="w-4 h-4 mr-1" /> Add FAQ</Button>
        </div>
      </div>

      <div className="flex flex-wrap items-center gap-2">
        {AUDIENCES.map((a) => (
          <button key={a.key} onClick={() => setFilter(a.key)}
            className={`rounded-lg px-3 py-1.5 text-sm font-semibold ${filter === a.key ? "bg-gradient-to-br from-gold to-gold-light text-primary-foreground" : "border border-border text-muted-foreground hover:text-foreground"}`}>
            {a.label}
          </button>
        ))}
        <span className="mx-1 h-4 w-px bg-border" />
        <select
          value={langFilter}
          onChange={(e) => setLangFilter(e.target.value)}
          className="rounded-lg border border-border bg-card px-3 py-1.5 text-sm text-foreground"
          title="Filter by language"
        >
          <option value="">All languages</option>
          {LANGS.map((l) => <option key={l.code} value={l.code}>{l.label}</option>)}
        </select>
      </div>

      <div className="space-y-2">
        {items.length === 0 && !loading && <p className="text-sm text-muted-foreground text-center py-8">No FAQ yet.</p>}
        {items.map((f) => (
          <div key={f.id} className="rounded-xl border border-border bg-card/60 p-4">
            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0">
                <div className="flex flex-wrap items-center gap-2 mb-1">
                  <Badge className="bg-cosmic/15 text-foreground">{f.audience}</Badge>
                  <Badge className="bg-cosmic/10 text-muted-foreground">{langLabel(f.lang)}</Badge>
                  {f.category && <Badge className="bg-primary/15 text-primary">{f.category}</Badge>}
                  {!f.is_active && <Badge className="bg-muted text-muted-foreground">hidden</Badge>}
                </div>
                <p className="font-semibold text-foreground">{f.question}</p>
                <p className="text-sm text-muted-foreground mt-1 line-clamp-2">{f.answer}</p>
              </div>
              <div className="flex flex-none gap-1">
                <button onClick={() => toggle(f)} title={f.is_active ? "Hide" : "Show"} className="p-2 text-muted-foreground hover:text-foreground">{f.is_active ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}</button>
                <button onClick={() => setEditing(f)} className="p-2 text-muted-foreground hover:text-primary"><Pencil className="w-4 h-4" /></button>
                <button onClick={() => remove(f.id)} className="p-2 text-muted-foreground hover:text-destructive"><Trash2 className="w-4 h-4" /></button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {editing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={() => setEditing(null)}>
          <div className="w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-3" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between">
              <h3 className="font-display text-lg text-foreground">{editing.id ? "Edit FAQ" : "Add FAQ"}</h3>
              <button onClick={() => setEditing(null)} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              {(["user", "astrologer", "both"] as Audience[]).map((a) => (
                <button key={a} onClick={() => setEditing({ ...editing, audience: a })}
                  className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${editing.audience === a ? "bg-primary text-primary-foreground" : "border border-border text-muted-foreground"}`}>{a}</button>
              ))}
              <span className="mx-1 h-4 w-px bg-border" />
              <select
                value={editing.lang || "en"}
                onChange={(e) => setEditing({ ...editing, lang: e.target.value })}
                className="rounded-lg border border-border bg-card px-3 py-1.5 text-xs text-foreground"
                title="Language"
              >
                {LANGS.map((l) => <option key={l.code} value={l.code}>{l.label}</option>)}
              </select>
            </div>
            <Input placeholder="Category (e.g. Notifications)" value={editing.category || ""} onChange={(e) => setEditing({ ...editing, category: e.target.value })} />
            <Input placeholder="Question" value={editing.question || ""} onChange={(e) => setEditing({ ...editing, question: e.target.value })} />
            <Textarea placeholder="Answer" rows={4} value={editing.answer || ""} onChange={(e) => setEditing({ ...editing, answer: e.target.value })} />
            <div className="flex items-center gap-3">
              <label className="text-sm text-muted-foreground">Order</label>
              <Input type="number" className="w-24" value={editing.sort_order ?? 0} onChange={(e) => setEditing({ ...editing, sort_order: parseInt(e.target.value) || 0 })} />
              <label className="ml-auto flex items-center gap-2 text-sm text-muted-foreground">
                <input type="checkbox" checked={editing.is_active ?? true} onChange={(e) => setEditing({ ...editing, is_active: e.target.checked })} /> Active
              </label>
            </div>
            <div className="flex justify-end gap-2 pt-1">
              <Button variant="outline" onClick={() => setEditing(null)}>Cancel</Button>
              <Button onClick={save}>{editing.id ? "Save" : "Add"}</Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
