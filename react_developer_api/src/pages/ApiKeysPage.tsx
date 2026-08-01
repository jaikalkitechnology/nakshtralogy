import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription,
} from "@/components/ui/dialog";
import { KeyRound, Plus, RotateCw, XCircle, Copy, Check } from "lucide-react";
import DataTable, { type DataTableColumn } from "@/components/DataTable";
import { listApiKeys, createApiKey, rotateApiKey, revokeApiKey } from "@/lib/api";

interface ApiKeyRow {
  id: string;
  key_prefix: string;
  mode: string;
  label: string | null;
  scopes: string[];
  status: string;
  last_used_at: string | null;
  created_at: string;
}

const PAGE_SIZE = 10;
const ALL_SCOPES = ["kundli", "specialist", "milan", "forecast"];

export default function ApiKeysPage() {
  const [rows, setRows] = useState<ApiKeyRow[]>([]);
  const [page, setPage] = useState(1);
  const [statusFilter, setStatusFilter] = useState("all");
  const [modeFilter, setModeFilter] = useState("all");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [newLabel, setNewLabel] = useState("");
  const [newMode, setNewMode] = useState<"live" | "test">("live");
  const [revealedSecret, setRevealedSecret] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const params: Record<string, any> = {};
      if (statusFilter !== "all") params.status = statusFilter;
      if (modeFilter !== "all") params.mode = modeFilter;
      const { ok, data } = await listApiKeys(params);
      if (!ok) throw new Error(data?.detail || "Failed to load API keys");
      setRows(data || []);
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, [statusFilter, modeFilter]);

  useEffect(() => { load(); }, [load]);

  const create = async () => {
    const { ok, data } = await createApiKey({ label: newLabel || undefined, mode: newMode, scopes: ALL_SCOPES });
    if (!ok) { alert(data?.detail || "Failed to create key"); return; }
    setCreateOpen(false);
    setNewLabel("");
    setRevealedSecret(data.api_key);
    load();
  };

  const rotate = async (id: string) => {
    const { ok, data } = await rotateApiKey(id);
    if (!ok) { alert(data?.detail || "Failed to rotate key"); return; }
    setRevealedSecret(data.api_key);
    load();
  };

  const revoke = async (id: string) => {
    if (!confirm("Revoke this key? Any integration using it will stop working immediately.")) return;
    await revokeApiKey(id);
    load();
  };

  const copySecret = () => {
    if (!revealedSecret) return;
    navigator.clipboard?.writeText(revealedSecret);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  const pageRows = rows.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);

  const columns: DataTableColumn<ApiKeyRow>[] = [
    { key: "label", header: "Label", render: (r) => r.label || "Untitled key" },
    { key: "key_prefix", header: "Key", render: (r) => <code className="text-xs">{r.key_prefix}...</code> },
    { key: "mode", header: "Mode", render: (r) => <Badge variant="outline" className="capitalize">{r.mode}</Badge> },
    { key: "scopes", header: "Scopes", render: (r) => <span className="text-xs text-muted-foreground">{r.scopes.join(", ")}</span> },
    {
      key: "status", header: "Status",
      render: (r) => (
        <Badge variant="outline" className={r.status === "active" ? "border-emerald-500/30 text-emerald-400" : "border-red-500/30 text-red-400"}>
          {r.status}
        </Badge>
      ),
    },
    { key: "last_used_at", header: "Last used", render: (r) => (r.last_used_at ? new Date(r.last_used_at).toLocaleString() : "Never") },
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <h1 className="text-xl font-semibold">API Keys</h1>
          <p className="text-sm text-muted-foreground">Create live/test keys, rotate or revoke them. Secrets are shown once.</p>
        </div>
        <Button onClick={() => setCreateOpen(true)}><Plus className="mr-1 h-4 w-4" /> New key</Button>
      </div>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="flex items-center gap-2 text-base"><KeyRound className="h-4 w-4 text-primary" /> Your keys</CardTitle>
          <div className="flex gap-2">
            <Select value={modeFilter} onValueChange={setModeFilter}>
              <SelectTrigger className="w-28"><SelectValue placeholder="Mode" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All modes</SelectItem>
                <SelectItem value="live">Live</SelectItem>
                <SelectItem value="test">Test</SelectItem>
              </SelectContent>
            </Select>
            <Select value={statusFilter} onValueChange={setStatusFilter}>
              <SelectTrigger className="w-32"><SelectValue placeholder="Status" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All statuses</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="revoked">Revoked</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardHeader>
        <CardContent>
          <DataTable
            columns={columns}
            rows={pageRows}
            rowKey={(r) => r.id}
            loading={loading}
            error={error}
            onRetry={load}
            emptyTitle="No API keys yet"
            emptyDescription="Create your first key to start calling the gateway."
            emptyAction={{ label: "Create a key", onClick: () => setCreateOpen(true) }}
            page={page}
            pageSize={PAGE_SIZE}
            total={rows.length}
            onPageChange={setPage}
            actions={(r) => (
              <div className="flex justify-end gap-1">
                <Button size="icon" variant="ghost" title="Rotate" onClick={() => rotate(r.id)}>
                  <RotateCw className="h-4 w-4" />
                </Button>
                {r.status === "active" && (
                  <Button size="icon" variant="ghost" title="Revoke" onClick={() => revoke(r.id)}>
                    <XCircle className="h-4 w-4 text-red-400" />
                  </Button>
                )}
              </div>
            )}
          />
        </CardContent>
      </Card>

      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent>
          <DialogHeader><DialogTitle>Create a new API key</DialogTitle></DialogHeader>
          <div className="space-y-3">
            <div className="space-y-1.5">
              <Label>Label (optional)</Label>
              <Input value={newLabel} onChange={(e) => setNewLabel(e.target.value)} placeholder="e.g. Production backend" />
            </div>
            <div className="space-y-1.5">
              <Label>Mode</Label>
              <Select value={newMode} onValueChange={(v) => setNewMode(v as "live" | "test")}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="live">Live</SelectItem>
                  <SelectItem value="test">Test</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button onClick={create}>Create key</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!revealedSecret} onOpenChange={(open) => !open && setRevealedSecret(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Your new API secret</DialogTitle>
            <DialogDescription>Copy it now — for security, it will never be shown again.</DialogDescription>
          </DialogHeader>
          <div className="flex items-center gap-2 rounded-lg bg-muted p-3">
            <code className="flex-1 break-all text-xs">{revealedSecret}</code>
            <Button size="icon" variant="ghost" onClick={copySecret}>
              {copied ? <Check className="h-4 w-4 text-emerald-400" /> : <Copy className="h-4 w-4" />}
            </Button>
          </div>
          <DialogFooter>
            <Button onClick={() => setRevealedSecret(null)}>Done</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
