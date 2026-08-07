import { useState, useEffect, useCallback, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Images, Plus, Trash2, Pencil, RefreshCw, X, Eye, EyeOff, Upload } from "lucide-react";
import {
  adminBannerList, adminBannerCreate, adminBannerUpdate, adminBannerDelete,
  adminBannerUpload, bannerImageSrc,
} from "@/services/api";
import { toast } from "sonner";

type Audience = "user" | "astrologer" | "both";
interface Banner {
  id: string; audience: Audience; title?: string; image_url: string;
  link_url?: string; sort_order: number; is_active: boolean;
}
const AUD: { key: string; label: string }[] = [
  { key: "", label: "All" }, { key: "user", label: "User app" },
  { key: "astrologer", label: "Astrologer app" }, { key: "both", label: "Both" },
];

export default function BannerManager() {
  const [items, setItems] = useState<Banner[]>([]);
  const [filter, setFilter] = useState("");
  const [loading, setLoading] = useState(false);
  const [editing, setEditing] = useState<Partial<Banner> | null>(null);
  const [uploading, setUploading] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminBannerList(filter || undefined);
    if (r.ok) setItems(r.data?.items ?? []);
    setLoading(false);
  }, [filter]);
  useEffect(() => { load(); }, [load]);

  const pickImage = async (f?: File | null) => {
    if (!f || !editing) return;
    setUploading(true);
    const r = await adminBannerUpload(f);
    setUploading(false);
    if (r.ok && r.media_url) setEditing({ ...editing, image_url: r.media_url });
    else toast.error(r.error || "Upload failed");
  };

  const save = async () => {
    if (!editing) return;
    if (!editing.image_url) { toast.error("Upload a banner image first"); return; }
    const body = {
      audience: editing.audience || "user",
      title: editing.title || null,
      image_url: editing.image_url,
      link_url: editing.link_url || null,
      sort_order: editing.sort_order ?? 0,
      is_active: editing.is_active ?? true,
    };
    const r = editing.id ? await adminBannerUpdate(editing.id, body) : await adminBannerCreate(body);
    if (r.ok) { toast.success(editing.id ? "Banner updated" : "Banner added"); setEditing(null); load(); }
    else toast.error(r.data?.detail || "Save failed");
  };

  const remove = async (id: string) => {
    if (!confirm("Delete this banner?")) return;
    const r = await adminBannerDelete(id);
    if (r.ok) { toast.success("Deleted"); load(); }
  };
  const toggle = async (b: Banner) => {
    const r = await adminBannerUpdate(b.id, { is_active: !b.is_active });
    if (r.ok) load();
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2"><Images className="w-6 h-6 text-primary" /> Banner Management</h1>
          <p className="text-sm text-muted-foreground">Promotional banners shown in the home-screen slider of each app.</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
          <Button size="sm" onClick={() => setEditing({ audience: "user", is_active: true, sort_order: items.length })}><Plus className="w-4 h-4 mr-1" /> Add Banner</Button>
        </div>
      </div>

      <div className="flex flex-wrap gap-2">
        {AUD.map((a) => (
          <button key={a.key} onClick={() => setFilter(a.key)}
            className={`rounded-lg px-3 py-1.5 text-sm font-semibold ${filter === a.key ? "bg-gradient-to-br from-gold to-gold-light text-primary-foreground" : "border border-border text-muted-foreground hover:text-foreground"}`}>{a.label}</button>
        ))}
      </div>

      <div className="grid gap-3 md:grid-cols-2">
        {items.length === 0 && !loading && <p className="text-sm text-muted-foreground">No banners yet.</p>}
        {items.map((b) => (
          <div key={b.id} className="rounded-xl border border-border bg-card/60 overflow-hidden">
            <div className="aspect-[16/7] bg-muted/40">
              {b.image_url && <img src={bannerImageSrc(b.image_url)} alt={b.title || "banner"} className="h-full w-full object-cover" />}
            </div>
            <div className="p-3">
              <div className="flex items-center gap-2 mb-1">
                <Badge className="bg-cosmic/15 text-foreground">{b.audience}</Badge>
                {!b.is_active && <Badge className="bg-muted text-muted-foreground">hidden</Badge>}
                <span className="ml-auto text-xs text-muted-foreground">order {b.sort_order}</span>
              </div>
              {b.title && <p className="text-sm font-semibold text-foreground truncate">{b.title}</p>}
              {b.link_url && <p className="text-xs text-primary truncate">{b.link_url}</p>}
              <div className="mt-2 flex gap-1">
                <button onClick={() => toggle(b)} className="p-2 text-muted-foreground hover:text-foreground" title={b.is_active ? "Hide" : "Show"}>{b.is_active ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}</button>
                <button onClick={() => setEditing(b)} className="p-2 text-muted-foreground hover:text-primary"><Pencil className="w-4 h-4" /></button>
                <button onClick={() => remove(b.id)} className="p-2 text-muted-foreground hover:text-destructive"><Trash2 className="w-4 h-4" /></button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {editing && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={() => setEditing(null)}>
          <div className="w-full max-w-lg rounded-2xl border border-border bg-card p-5 space-y-3" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between">
              <h3 className="font-display text-lg text-foreground">{editing.id ? "Edit Banner" : "Add Banner"}</h3>
              <button onClick={() => setEditing(null)} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
            </div>

            <div className="aspect-[16/7] rounded-lg border border-dashed border-border bg-muted/30 grid place-items-center overflow-hidden">
              {editing.image_url
                ? <img src={bannerImageSrc(editing.image_url)} className="h-full w-full object-cover" />
                : <span className="text-xs text-muted-foreground">No image</span>}
            </div>
            <input ref={fileRef} type="file" accept="image/*" hidden onChange={(e) => pickImage(e.target.files?.[0])} />
            <Button variant="outline" size="sm" onClick={() => fileRef.current?.click()} disabled={uploading}>
              <Upload className="w-4 h-4 mr-1" /> {uploading ? "Uploading…" : "Upload image (16:7 recommended)"}
            </Button>

            <div className="flex flex-wrap items-center gap-2">
              {(["user", "astrologer", "both"] as Audience[]).map((a) => (
                <button key={a} onClick={() => setEditing({ ...editing, audience: a })}
                  className={`rounded-lg px-3 py-1.5 text-xs font-semibold ${editing.audience === a ? "bg-primary text-primary-foreground" : "border border-border text-muted-foreground"}`}>{a}</button>
              ))}
            </div>
            <Input placeholder="Title (optional)" value={editing.title || ""} onChange={(e) => setEditing({ ...editing, title: e.target.value })} />
            <Input placeholder="Link URL on tap (optional, e.g. https://…)" value={editing.link_url || ""} onChange={(e) => setEditing({ ...editing, link_url: e.target.value })} />
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
