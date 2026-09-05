import { useEffect, useState } from "react";
import { Lock, Plus, Pencil, Crown, ShieldCheck } from "lucide-react";
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

interface PermissionDef { key: string; label: string; description: string }

function PermissionChecklist({
  catalog, selected, fullAccess, onToggleFull, onTogglePerm,
}: {
  catalog: PermissionDef[]; selected: string[]; fullAccess: boolean;
  onToggleFull: (v: boolean) => void; onTogglePerm: (key: string, v: boolean) => void;
}) {
  return (
    <div className="space-y-3">
      <label className="flex items-start gap-2.5 rounded-lg border border-primary/40 bg-primary/5 p-3 cursor-pointer">
        <Checkbox checked={fullAccess} onCheckedChange={(v) => onToggleFull(!!v)} className="mt-0.5" />
        <div>
          <p className="text-sm font-medium text-foreground flex items-center gap-1.5">
            <Crown className="w-3.5 h-3.5 text-gold" /> Super Admin — full access
          </p>
          <p className="text-xs text-muted-foreground">Unrestricted — can do everything, including manage other admins.</p>
        </div>
      </label>

      {!fullAccess && (
        <div className="space-y-1.5 max-h-72 overflow-y-auto pr-1">
          {catalog.map((p) => (
            <label key={p.key} className="flex items-start gap-2.5 rounded-lg border border-border p-2.5 cursor-pointer hover:bg-muted/40">
              <Checkbox
                checked={selected.includes(p.key)}
                onCheckedChange={(v) => onTogglePerm(p.key, !!v)}
                className="mt-0.5"
              />
              <div>
                <p className="text-sm text-foreground">{p.label}</p>
                <p className="text-xs text-muted-foreground">{p.description}</p>
              </div>
            </label>
          ))}
        </div>
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
  const [saving, setSaving] = useState(false);

  const [createOpen, setCreateOpen] = useState(false);
  const [newEmail, setNewEmail] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [newName, setNewName] = useState("");
  const [newFullAccess, setNewFullAccess] = useState(false);
  const [newPerms, setNewPerms] = useState<string[]>([]);
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

  const openEdit = (a: any) => {
    setEditing(a);
    setEditFullAccess(!a.permissions);
    setEditPerms(a.permissions || []);
  };

  const saveEdit = async () => {
    if (!editing) return;
    setSaving(true);
    try {
      const { ok, data } = await adminUpdateAdminPermissions(editing.id, editFullAccess ? null : editPerms);
      if (!ok) { toast.error(data?.detail || "Could not update permissions"); return; }
      toast.success("Permissions updated");
      setEditing(null);
      loadAdmins();
    } catch {
      toast.error("Could not update permissions");
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
      });
      if (!ok) { toast.error(data?.detail || "Could not create admin"); return; }
      toast.success("Admin account created");
      setCreateOpen(false);
      setNewEmail(""); setNewPassword(""); setNewName(""); setNewFullAccess(false); setNewPerms([]);
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
        Every admin created before this feature keeps full ("Super Admin") access. Give a new admin a scoped set of
        permissions here to limit what they can do — enforcement currently covers wallet, KYC, astrologer approval,
        user management, and admin-account actions.
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
            <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4 flex flex-wrap items-center gap-3">
              <div className="min-w-0 flex-1">
                <p className="font-semibold text-foreground truncate flex items-center gap-2">
                  {a.name || a.email}
                  {a.is_self && <Badge variant="outline" className="border-border text-[10px]">You</Badge>}
                  {!a.is_active && <Badge className="bg-destructive/20 text-destructive text-[10px]">blocked</Badge>}
                </p>
                <p className="text-xs text-muted-foreground truncate">{a.email}</p>
              </div>
              <div className="flex flex-wrap gap-1.5 max-w-full">
                {!a.permissions ? (
                  <Badge className="bg-gold/20 text-gold inline-flex items-center gap-1">
                    <Crown className="w-3 h-3" /> Super Admin
                  </Badge>
                ) : a.permissions.length === 0 ? (
                  <Badge variant="outline" className="border-border text-muted-foreground">No permissions</Badge>
                ) : (
                  a.permissions.map((p: string) => (
                    <Badge key={p} variant="outline" className="border-border text-[10px] inline-flex items-center gap-1">
                      <ShieldCheck className="w-2.5 h-2.5" /> {catalog.find((c) => c.key === p)?.label || p}
                    </Badge>
                  ))
                )}
              </div>
              <Button
                size="sm" variant="outline" className="border-border text-xs shrink-0"
                onClick={() => openEdit(a)}
                disabled={a.is_self}
                title={a.is_self ? "You cannot change your own permissions" : "Edit permissions"}
              >
                <Pencil className="w-3 h-3 mr-1" /> Edit
              </Button>
            </div>
          ))}
        </div>
      )}

      {/* Edit permissions dialog */}
      <Dialog open={editing !== null} onOpenChange={(v) => !v && setEditing(null)}>
        <DialogContent className="bg-card border-border max-w-md max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Edit Permissions</DialogTitle>
          </DialogHeader>
          {editing && (
            <div className="space-y-4 py-2">
              <p className="text-sm text-muted-foreground">{editing.email}</p>
              <PermissionChecklist
                catalog={catalog}
                selected={editPerms}
                fullAccess={editFullAccess}
                onToggleFull={setEditFullAccess}
                onTogglePerm={(key, v) => setEditPerms((prev) => v ? [...prev, key] : prev.filter((k) => k !== key))}
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
            <PermissionChecklist
              catalog={catalog}
              selected={newPerms}
              fullAccess={newFullAccess}
              onToggleFull={setNewFullAccess}
              onTogglePerm={(key, v) => setNewPerms((prev) => v ? [...prev, key] : prev.filter((k) => k !== key))}
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
