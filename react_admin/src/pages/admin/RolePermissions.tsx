import { useEffect, useState } from "react";
import { Lock, Plus, Pencil, Crown, ShieldCheck, FileText } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { toast } from "sonner";
import {
  adminGetPermissionCatalog, adminListAdmins, adminCreateAdmin, adminUpdateAdminPermissions,
} from "@/services/api";
import { PAGE_CATALOG } from "@/components/layout/AdminShell";

interface PermissionDef { key: string; label: string; description: string }

function FullAccessToggle({ checked, onChange }: { checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <label className="flex items-start gap-2.5 rounded-lg border border-primary/40 bg-primary/5 p-3 cursor-pointer">
      <Checkbox checked={checked} onCheckedChange={(v) => onChange(!!v)} className="mt-0.5" />
      <div>
        <p className="text-sm font-medium text-foreground flex items-center gap-1.5">
          <Crown className="w-3.5 h-3.5 text-gold" /> Super Admin — full access
        </p>
        <p className="text-xs text-muted-foreground">Unrestricted — every action and every page, including managing other admins.</p>
      </div>
    </label>
  );
}

function PermissionChecklist({
  catalog, selected, onToggle,
}: { catalog: PermissionDef[]; selected: string[]; onToggle: (key: string, v: boolean) => void }) {
  return (
    <div className="space-y-1.5 max-h-56 overflow-y-auto pr-1">
      {catalog.map((p) => (
        <label key={p.key} className="flex items-start gap-2.5 rounded-lg border border-border p-2.5 cursor-pointer hover:bg-muted/40">
          <Checkbox checked={selected.includes(p.key)} onCheckedChange={(v) => onToggle(p.key, !!v)} className="mt-0.5" />
          <div>
            <p className="text-sm text-foreground">{p.label}</p>
            <p className="text-xs text-muted-foreground">{p.description}</p>
          </div>
        </label>
      ))}
    </div>
  );
}

/** Which admin-panel sidebar pages the account can see/open, grouped like the sidebar itself. */
function PageAccessChecklist({
  selected, onToggle, onToggleGroup,
}: { selected: string[]; onToggle: (to: string, v: boolean) => void; onToggleGroup: (paths: string[], v: boolean) => void }) {
  return (
    <div className="space-y-3 max-h-64 overflow-y-auto pr-1">
      {PAGE_CATALOG.map((g) => {
        const paths = g.items.map((it) => it.to);
        const allChecked = paths.every((p) => selected.includes(p));
        return (
          <div key={g.heading} className="rounded-lg border border-border">
            <label className="flex items-center gap-2 px-2.5 py-2 border-b border-border bg-muted/30 cursor-pointer">
              <Checkbox
                checked={allChecked}
                onCheckedChange={(v) => onToggleGroup(paths, !!v)}
              />
              <span className="text-[11px] font-bold tracking-wide text-muted-foreground uppercase">{g.heading}</span>
            </label>
            <div className="p-1.5 space-y-0.5">
              {g.items.map((it) => (
                <label key={it.to} className="flex items-center gap-2.5 rounded-md px-2 py-1.5 cursor-pointer hover:bg-muted/40">
                  <Checkbox checked={selected.includes(it.to)} onCheckedChange={(v) => onToggle(it.to, !!v)} />
                  <span className="text-sm text-foreground">{it.label}</span>
                </label>
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
}

function AccessEditor({
  catalog, fullAccess, onToggleFull, perms, onTogglePerm, pages, onTogglePage, onToggleGroup,
}: {
  catalog: PermissionDef[]; fullAccess: boolean; onToggleFull: (v: boolean) => void;
  perms: string[]; onTogglePerm: (key: string, v: boolean) => void;
  pages: string[]; onTogglePage: (to: string, v: boolean) => void; onToggleGroup: (paths: string[], v: boolean) => void;
}) {
  return (
    <div className="space-y-4">
      <FullAccessToggle checked={fullAccess} onChange={onToggleFull} />
      {!fullAccess && (
        <>
          <div>
            <p className="text-xs font-semibold text-foreground mb-1.5 flex items-center gap-1.5"><ShieldCheck className="w-3.5 h-3.5" /> Actions this admin can perform</p>
            <PermissionChecklist catalog={catalog} selected={perms} onToggle={onTogglePerm} />
          </div>
          <div>
            <p className="text-xs font-semibold text-foreground mb-1.5 flex items-center gap-1.5"><FileText className="w-3.5 h-3.5" /> Pages this admin can see</p>
            <p className="text-[11px] text-muted-foreground mb-1.5">Dashboard is always visible. Leave everything unchecked below and they'll only see Dashboard.</p>
            <PageAccessChecklist selected={pages} onToggle={onTogglePage} onToggleGroup={onToggleGroup} />
          </div>
        </>
      )}
    </div>
  );
}

export default function RolePermissions() {
  const [catalog, setCatalog] = useState<PermissionDef[]>([]);
  const [admins, setAdmins] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [forbidden, setForbidden] = useState(false);

  const [editing, setEditing] = useState<any | null>(null); // admin row being edited, or null
  const [editFullAccess, setEditFullAccess] = useState(true);
  const [editPerms, setEditPerms] = useState<string[]>([]);
  const [editPages, setEditPages] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);

  const [createOpen, setCreateOpen] = useState(false);
  const [newEmail, setNewEmail] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [newName, setNewName] = useState("");
  const [newFullAccess, setNewFullAccess] = useState(false);
  const [newPerms, setNewPerms] = useState<string[]>([]);
  const [newPages, setNewPages] = useState<string[]>([]);
  const [creating, setCreating] = useState(false);

  const loadAdmins = () => {
    setLoading(true);
    adminListAdmins()
      .then((r) => {
        if (r.status === 403) { setForbidden(true); setAdmins([]); return; }
        setForbidden(false);
        setAdmins((r?.data ?? r)?.admins ?? []);
      })
      .catch(() => setForbidden(true))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    adminGetPermissionCatalog().then((r) => setCatalog((r?.data ?? r)?.permissions ?? [])).catch(() => setCatalog([]));
    loadAdmins();
  }, []);

  const toggleGroup = (setter: (fn: (prev: string[]) => string[]) => void) => (paths: string[], v: boolean) => {
    setter((prev) => v ? Array.from(new Set([...prev, ...paths])) : prev.filter((p) => !paths.includes(p)));
  };

  const openEdit = (a: any) => {
    setEditing(a);
    setEditFullAccess(!a.permissions && !a.allowed_pages);
    setEditPerms(a.permissions || []);
    setEditPages(a.allowed_pages || []);
  };

  const saveEdit = async () => {
    if (!editing) return;
    setSaving(true);
    try {
      const { ok, data } = await adminUpdateAdminPermissions(
        editing.id,
        editFullAccess ? null : editPerms,
        editFullAccess ? null : editPages,
      );
      if (!ok) { toast.error(data?.detail || "Could not update access"); return; }
      toast.success("Access updated");
      setEditing(null);
      loadAdmins();
    } catch {
      toast.error("Could not update access");
    } finally {
      setSaving(false);
    }
  };

  const submitCreate = async () => {
    if (!newEmail || !newPassword) { toast.error("Email and password are required"); return; }
    setCreating(true);
    try {
      const { ok, data } = await adminCreateAdmin({
        email: newEmail, password: newPassword, name: newName || undefined,
        permissions: newFullAccess ? null : newPerms,
        allowed_pages: newFullAccess ? null : newPages,
      });
      if (!ok) { toast.error(data?.detail || "Could not create admin"); return; }
      toast.success("Admin account created");
      setCreateOpen(false);
      setNewEmail(""); setNewPassword(""); setNewName(""); setNewFullAccess(false); setNewPerms([]); setNewPages([]);
      loadAdmins();
    } catch {
      toast.error("Could not create admin");
    } finally {
      setCreating(false);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex items-center gap-2">
          <Lock className="w-5 h-5 text-primary" />
          <h1 className="text-xl font-display text-gold-gradient">Role Permissions</h1>
        </div>
        <Button onClick={() => setCreateOpen(true)} className="gradient-gold text-primary-foreground" disabled={forbidden}>
          <Plus className="w-4 h-4 mr-1" /> Add Admin
        </Button>
      </div>
      <p className="text-xs text-muted-foreground">
        Every admin created before this feature keeps full ("Super Admin") access. Scope a new admin to specific
        actions (what they can do) and specific pages (what they can see in the sidebar) independently.
      </p>

      {forbidden ? (
        <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
          Only a Super Admin (unrestricted access) can view or manage other admin accounts.
        </div>
      ) : loading ? (
        <div className="p-8 text-center text-muted-foreground">Loading…</div>
      ) : (
        <div className="space-y-3">
          {admins.length === 0 && (
            <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
              No admin accounts found.
            </div>
          )}
          {admins.map((a) => (
            <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4 space-y-2.5">
              <div className="flex flex-wrap items-center gap-3">
                <div className="min-w-0 flex-1">
                  <p className="font-semibold text-foreground truncate flex items-center gap-2">
                    {a.name || a.email}
                    {a.is_self && <Badge variant="outline" className="border-border text-[10px]">You</Badge>}
                    {!a.is_active && <Badge className="bg-destructive/20 text-destructive text-[10px]">blocked</Badge>}
                  </p>
                  <p className="text-xs text-muted-foreground truncate">{a.email}</p>
                </div>
                <Button
                  size="sm" variant="outline" className="border-border text-xs shrink-0"
                  onClick={() => openEdit(a)}
                  disabled={a.is_self}
                  title={a.is_self ? "You cannot change your own access" : "Edit access"}
                >
                  <Pencil className="w-3 h-3 mr-1" /> Edit
                </Button>
              </div>

              {!a.permissions && !a.allowed_pages ? (
                <Badge className="bg-gold/20 text-gold inline-flex items-center gap-1">
                  <Crown className="w-3 h-3" /> Super Admin — full access
                </Badge>
              ) : (
                <div className="space-y-1.5">
                  <div className="flex flex-wrap items-center gap-1.5">
                    <span className="text-[10px] font-bold uppercase text-muted-foreground">Actions:</span>
                    {!a.permissions ? (
                      <Badge variant="outline" className="border-primary/40 text-primary text-[10px]">All actions</Badge>
                    ) : a.permissions.length === 0 ? (
                      <Badge variant="outline" className="border-border text-muted-foreground text-[10px]">None</Badge>
                    ) : (
                      a.permissions.map((p: string) => (
                        <Badge key={p} variant="outline" className="border-border text-[10px] inline-flex items-center gap-1">
                          <ShieldCheck className="w-2.5 h-2.5" /> {catalog.find((c) => c.key === p)?.label || p}
                        </Badge>
                      ))
                    )}
                  </div>
                  <div className="flex flex-wrap items-center gap-1.5">
                    <span className="text-[10px] font-bold uppercase text-muted-foreground">Pages:</span>
                    {!a.allowed_pages ? (
                      <Badge variant="outline" className="border-primary/40 text-primary text-[10px]">All pages</Badge>
                    ) : a.allowed_pages.length === 0 ? (
                      <Badge variant="outline" className="border-border text-muted-foreground text-[10px]">Dashboard only</Badge>
                    ) : (
                      a.allowed_pages.map((p: string) => {
                        const label = PAGE_CATALOG.flatMap((g) => g.items).find((it) => it.to === p)?.label || p;
                        return (
                          <Badge key={p} variant="outline" className="border-border text-[10px] inline-flex items-center gap-1">
                            <FileText className="w-2.5 h-2.5" /> {label}
                          </Badge>
                        );
                      })
                    )}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Edit access dialog */}
      <Dialog open={editing !== null} onOpenChange={(v) => !v && setEditing(null)}>
        <DialogContent className="bg-card border-border max-w-md max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Edit Access</DialogTitle>
          </DialogHeader>
          {editing && (
            <div className="space-y-4 py-2">
              <p className="text-sm text-muted-foreground">{editing.email}</p>
              <AccessEditor
                catalog={catalog}
                fullAccess={editFullAccess}
                onToggleFull={setEditFullAccess}
                perms={editPerms}
                onTogglePerm={(key, v) => setEditPerms((prev) => v ? [...prev, key] : prev.filter((k) => k !== key))}
                pages={editPages}
                onTogglePage={(to, v) => setEditPages((prev) => v ? [...prev, to] : prev.filter((p) => p !== to))}
                onToggleGroup={toggleGroup(setEditPages)}
              />
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditing(null)} disabled={saving}>Cancel</Button>
            <Button onClick={saveEdit} disabled={saving} className="gradient-gold text-primary-foreground">
              {saving ? "Saving..." : "Save"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Create admin dialog */}
      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent className="bg-card border-border max-w-md max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Add Admin Account</DialogTitle>
          </DialogHeader>
          <div className="space-y-3 py-2">
            <div>
              <Label className="text-foreground/80">Email</Label>
              <Input value={newEmail} onChange={(e) => setNewEmail(e.target.value)} placeholder="admin@example.com" className="bg-muted border-border mt-1" />
            </div>
            <div>
              <Label className="text-foreground/80">Name</Label>
              <Input value={newName} onChange={(e) => setNewName(e.target.value)} placeholder="Optional" className="bg-muted border-border mt-1" />
            </div>
            <div>
              <Label className="text-foreground/80">Password</Label>
              <Input type="password" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} placeholder="Set an initial password" className="bg-muted border-border mt-1" />
            </div>
            <AccessEditor
              catalog={catalog}
              fullAccess={newFullAccess}
              onToggleFull={setNewFullAccess}
              perms={newPerms}
              onTogglePerm={(key, v) => setNewPerms((prev) => v ? [...prev, key] : prev.filter((k) => k !== key))}
              pages={newPages}
              onTogglePage={(to, v) => setNewPages((prev) => v ? [...prev, to] : prev.filter((p) => p !== to))}
              onToggleGroup={toggleGroup(setNewPages)}
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCreateOpen(false)} disabled={creating}>Cancel</Button>
            <Button onClick={submitCreate} disabled={creating} className="gradient-gold text-primary-foreground">
              {creating ? "Creating..." : "Create Admin"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
