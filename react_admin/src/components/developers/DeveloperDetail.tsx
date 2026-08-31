import { useState, useEffect, useCallback } from "react";
import {
  Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription,
} from "@/components/ui/sheet";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import {
  Table, TableHeader, TableRow, TableHead, TableBody, TableCell,
} from "@/components/ui/table";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  KeyRound, RotateCw, Ban, CheckCircle2, XCircle, Wallet as WalletIcon,
  CreditCard, Activity, ShieldCheck, ShieldAlert, ShieldX, AlertTriangle,
} from "lucide-react";
import {
  adminGetDeveloperDetail, adminUpdateDeveloperKyc, adminUpdateDeveloperStatus,
  adminListDeveloperKeys, adminRevokeDeveloperKey, adminRotateDeveloperKey,
  adminGetDeveloperSubscription, adminGrantDeveloperSubscription, adminCancelDeveloperSubscription,
  adminGetDeveloperWallet, adminAdjustDeveloperWallet,
  adminGetDeveloperUsage,
  type DeveloperWalletAction,
} from "@/services/api";

const PAGE_SIZE = 8;

interface Props {
  developerId: string;
  onClose: () => void;
  onChanged?: () => void;
}

export default function DeveloperDetail({ developerId, onClose, onChanged }: Props) {
  const [detail, setDetail] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [tab, setTab] = useState("overview");
  const [rotatedSecret, setRotatedSecret] = useState<string | null>(null);

  const loadDetail = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const { ok, data } = await adminGetDeveloperDetail(developerId);
      if (!ok) throw new Error(data?.detail || "Failed to load developer");
      setDetail(data);
    } catch (e: any) {
      setError(e?.message || "Something went wrong");
    } finally {
      setLoading(false);
    }
  }, [developerId]);

  useEffect(() => {
    loadDetail();
  }, [loadDetail]);

  const refreshAll = () => {
    loadDetail();
    onChanged?.();
  };

  const setStatus = async (status: string) => {
    await adminUpdateDeveloperStatus(developerId, status);
    refreshAll();
  };

  const setKyc = async (kyc_status: string) => {
    await adminUpdateDeveloperKyc(developerId, kyc_status);
    refreshAll();
  };

  return (
    <Sheet open onOpenChange={(open) => !open && onClose()}>
      <SheetContent side="right" className="w-full overflow-y-auto sm:max-w-2xl">
        <SheetHeader>
          <SheetTitle className="flex items-center gap-2">
            {detail?.company_name || detail?.name || "Developer"}
            {detail?.status && (
              <Badge variant="outline" className="capitalize">{detail.status}</Badge>
            )}
          </SheetTitle>
          <SheetDescription>{detail?.email}</SheetDescription>
        </SheetHeader>

        {loading ? (
          <div className="mt-6 space-y-2">
            {Array.from({ length: 5 }).map((_, i) => <Skeleton key={i} className="h-10 w-full rounded-lg" />)}
          </div>
        ) : error ? (
          <div className="mt-6 flex flex-wrap items-center justify-between gap-2 rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
            <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
            <Button size="sm" variant="outline" onClick={loadDetail}>Retry</Button>
          </div>
        ) : (
          <>
            <div className="mt-4 flex flex-wrap gap-2">
              <Button size="sm" variant="outline" onClick={() => setKyc("approved")}>
                <ShieldCheck className="mr-1 h-3.5 w-3.5" /> Approve KYC
              </Button>
              <Button size="sm" variant="outline" onClick={() => setKyc("rejected")}>
                <ShieldX className="mr-1 h-3.5 w-3.5" /> Reject KYC
              </Button>
              {detail?.status !== "active" ? (
                <Button size="sm" variant="outline" onClick={() => setStatus("active")}>
                  <CheckCircle2 className="mr-1 h-3.5 w-3.5 text-emerald-400" /> Activate
                </Button>
              ) : (
                <Button size="sm" variant="outline" onClick={() => setStatus("suspended")}>
                  <ShieldAlert className="mr-1 h-3.5 w-3.5 text-amber-400" /> Suspend
                </Button>
              )}
              <Button size="sm" variant="outline" onClick={() => setStatus("blocked")}>
                <Ban className="mr-1 h-3.5 w-3.5 text-red-400" /> Block
              </Button>
            </div>

            <Tabs value={tab} onValueChange={setTab} className="mt-6">
              <TabsList className="no-scrollbar flex w-full items-center justify-start gap-1 overflow-x-auto sm:grid sm:grid-cols-5 sm:overflow-visible">
                <TabsTrigger value="overview">Overview</TabsTrigger>
                <TabsTrigger value="keys">Keys</TabsTrigger>
                <TabsTrigger value="subscription">Plan</TabsTrigger>
                <TabsTrigger value="wallet">Wallet</TabsTrigger>
                <TabsTrigger value="usage">Usage</TabsTrigger>
              </TabsList>

              <TabsContent value="overview" className="mt-4 space-y-2 text-sm">
                <Row label="Account type" value={detail?.account_type} />
                <Row label="Company" value={detail?.company_name} />
                <Row label="GST number" value={detail?.gst_number} />
                <Row label="PAN" value={detail?.pan} />
                <Row label="Website" value={detail?.website} />
                <Row label="Contact" value={detail?.contact_name} />
                <Row label="Contact phone" value={detail?.contact_phone} />
                <Row label="Billing address" value={detail?.billing_address} />
                <Row label="KYC status" value={detail?.kyc_status} />
                <Row label="KYC note" value={detail?.kyc_note} />
                <Row label="Wallet balance" value={`₹${(detail?.wallet_balance ?? 0).toFixed(2)}`} />
                <Row label="Active keys" value={String(detail?.active_keys ?? 0)} />
                <Row label="Subscription" value={`${detail?.plan_code || "none"} (${detail?.subscription_status || "—"})`} />
                <Row label="Subscription expires" value={detail?.subscription_expires_at} />
              </TabsContent>

              <TabsContent value="keys" className="mt-4">
                <KeysPanel developerId={developerId} onSecret={setRotatedSecret} />
              </TabsContent>

              <TabsContent value="subscription" className="mt-4">
                <SubscriptionPanel developerId={developerId} onChanged={refreshAll} />
              </TabsContent>

              <TabsContent value="wallet" className="mt-4">
                <WalletPanel developerId={developerId} onChanged={refreshAll} />
              </TabsContent>

              <TabsContent value="usage" className="mt-4">
                <UsagePanel developerId={developerId} />
              </TabsContent>
            </Tabs>
          </>
        )}
      </SheetContent>

      <Dialog open={!!rotatedSecret} onOpenChange={(open) => !open && setRotatedSecret(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>New API secret (shown once)</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground">
            Relay this to the developer through a secure channel — it will never be shown again.
          </p>
          <code className="block rounded-lg bg-muted p-3 text-xs break-all">{rotatedSecret}</code>
          <DialogFooter>
            <Button onClick={() => setRotatedSecret(null)}>Done</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </Sheet>
  );
}

function Row({ label, value }: { label: string; value?: string | null }) {
  return (
    <div className="flex items-center justify-between border-b border-border/40 py-1.5">
      <span className="text-muted-foreground">{label}</span>
      <span className="font-medium">{value || "—"}</span>
    </div>
  );
}

// ── Keys tab ──────────────────────────────────────────────────────────

function KeysPanel({ developerId, onSecret }: { developerId: string; onSecret: (s: string) => void }) {
  const [keys, setKeys] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [skip, setSkip] = useState(0);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    const { ok, data } = await adminListDeveloperKeys(developerId, { skip, limit: PAGE_SIZE });
    if (ok) {
      setKeys(data.keys || []);
      setTotal(data.total || 0);
    }
    setLoading(false);
  }, [developerId, skip]);

  useEffect(() => { load(); }, [load]);

  const revoke = async (keyId: string) => {
    await adminRevokeDeveloperKey(developerId, keyId);
    load();
  };
  const rotate = async (keyId: string) => {
    const { ok, data } = await adminRotateDeveloperKey(developerId, keyId);
    if (ok) onSecret(data.api_key);
    load();
  };

  if (loading) return <Skeleton className="h-32 w-full rounded-lg" />;
  if (keys.length === 0) {
    return <div className="py-8 text-center text-sm text-muted-foreground">This developer has no API keys yet.</div>;
  }

  return (
    <div className="space-y-3">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Prefix</TableHead>
            <TableHead>Mode</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Last used</TableHead>
            <TableHead className="text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {keys.map((k) => (
            <TableRow key={k.id}>
              <TableCell className="font-mono text-xs">{k.key_prefix}...</TableCell>
              <TableCell className="capitalize">{k.mode}</TableCell>
              <TableCell><Badge variant="outline" className="capitalize">{k.status}</Badge></TableCell>
              <TableCell className="text-xs text-muted-foreground">{k.last_used_at ? new Date(k.last_used_at).toLocaleString() : "never"}</TableCell>
              <TableCell className="text-right">
                <div className="flex justify-end gap-1">
                  <Button size="icon" variant="ghost" title="Rotate" onClick={() => rotate(k.id)}>
                    <RotateCw className="h-4 w-4" />
                  </Button>
                  {k.status === "active" && (
                    <Button size="icon" variant="ghost" title="Revoke" onClick={() => revoke(k.id)}>
                      <XCircle className="h-4 w-4 text-red-400" />
                    </Button>
                  )}
                </div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
      <PagerFooter skip={skip} total={total} pageSize={PAGE_SIZE} onChange={setSkip} />
    </div>
  );
}

// ── Subscription tab ────────────────────────────────────────────────

function SubscriptionPanel({ developerId, onChanged }: { developerId: string; onChanged: () => void }) {
  const [sub, setSub] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [days, setDays] = useState("30");
  const [reason, setReason] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    const { ok, data } = await adminGetDeveloperSubscription(developerId);
    if (ok) setSub(data.subscription);
    setLoading(false);
  }, [developerId]);

  useEffect(() => { load(); }, [load]);

  const grant = async () => {
    const d = parseInt(days, 10);
    if (!d || d <= 0) { alert("Enter a valid number of days"); return; }
    await adminGrantDeveloperSubscription(developerId, d, "all_access", sub?.auto_renew ?? false, reason || undefined);
    setReason("");
    load();
    onChanged();
  };
  const cancel = async () => {
    await adminCancelDeveloperSubscription(developerId);
    load();
    onChanged();
  };

  if (loading) return <Skeleton className="h-32 w-full rounded-lg" />;

  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-border/60 bg-muted/20 p-4">
        {sub ? (
          <div className="space-y-1.5 text-sm">
            <Row label="Plan" value={`${sub.plan_name} (${sub.plan_code})`} />
            <Row label="Status" value={sub.status} />
            <Row label="TPS limit" value={String(sub.tps_limit)} />
            <Row label="Started" value={new Date(sub.started_at).toLocaleString()} />
            <Row label="Expires" value={new Date(sub.expires_at).toLocaleString()} />
            <Row label="Auto renew" value={sub.auto_renew ? "Yes" : "No"} />
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">No subscription yet.</p>
        )}
      </div>

      <div className="space-y-2 rounded-xl border border-border/60 p-4">
        <Label htmlFor="grant-days">Grant / extend All-Access (admin override, no wallet debit)</Label>
        <div className="flex gap-2">
          <Input id="grant-days" type="number" min={1} value={days} onChange={(e) => setDays(e.target.value)} className="w-24" />
          <Input placeholder="Reason (optional)" value={reason} onChange={(e) => setReason(e.target.value)} className="flex-1" />
          <Button onClick={grant}><CreditCard className="mr-1 h-4 w-4" /> Grant</Button>
        </div>
        {sub?.status === "active" && (
          <Button variant="outline" size="sm" onClick={cancel}>Cancel current subscription</Button>
        )}
      </div>
    </div>
  );
}

// ── Wallet tab ───────────────────────────────────────────────────────

function WalletPanel({ developerId, onChanged }: { developerId: string; onChanged: () => void }) {
  const [wallet, setWallet] = useState<{ balance: number; currency: string; total: number; transactions: any[] } | null>(null);
  const [skip, setSkip] = useState(0);
  const [loading, setLoading] = useState(true);
  const [action, setAction] = useState<DeveloperWalletAction>("credit");
  const [amount, setAmount] = useState("");
  const [reason, setReason] = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    const { ok, data } = await adminGetDeveloperWallet(developerId, { skip, limit: PAGE_SIZE });
    if (ok) setWallet(data);
    setLoading(false);
  }, [developerId, skip]);

  useEffect(() => { load(); }, [load]);

  const submit = async () => {
    const amt = parseFloat(amount);
    if (!amt || amt <= 0) { alert("Enter a valid amount"); return; }
    if (!reason.trim()) { alert("Reason is required (creates a ledger entry)"); return; }
    const { ok, data } = await adminAdjustDeveloperWallet(developerId, action, amt, reason.trim());
    if (!ok) { alert(data?.detail || "Adjustment failed"); return; }
    setAmount("");
    setReason("");
    load();
    onChanged();
  };

  if (loading && !wallet) return <Skeleton className="h-32 w-full rounded-lg" />;

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-3 rounded-xl border border-border/60 bg-muted/20 p-4">
        <WalletIcon className="h-6 w-6 text-primary" />
        <div>
          <div className="text-xs text-muted-foreground">Wallet balance</div>
          <div className="text-2xl font-semibold">₹{(wallet?.balance ?? 0).toFixed(2)}</div>
        </div>
      </div>

      <div className="space-y-2 rounded-xl border border-border/60 p-4">
        <Label>Adjust wallet</Label>
        <div className="flex flex-wrap gap-2">
          <Select value={action} onValueChange={(v) => setAction(v as DeveloperWalletAction)}>
            <SelectTrigger className="w-28"><SelectValue /></SelectTrigger>
            <SelectContent>
              <SelectItem value="credit">Credit</SelectItem>
              <SelectItem value="debit">Debit</SelectItem>
              <SelectItem value="refund">Refund</SelectItem>
            </SelectContent>
          </Select>
          <Input type="number" placeholder="Amount" value={amount} onChange={(e) => setAmount(e.target.value)} className="w-32" />
          <Input placeholder="Reason" value={reason} onChange={(e) => setReason(e.target.value)} className="flex-1" />
          <Button onClick={submit}>Apply</Button>
        </div>
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Type</TableHead>
            <TableHead className="text-right">Amount</TableHead>
            <TableHead className="text-right">Balance after</TableHead>
            <TableHead>Description</TableHead>
            <TableHead>Date</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {(wallet?.transactions || []).length === 0 ? (
            <TableRow><TableCell colSpan={5} className="py-6 text-center text-sm text-muted-foreground">No transactions yet.</TableCell></TableRow>
          ) : (
            wallet!.transactions.map((t) => (
              <TableRow key={t.id}>
                <TableCell className="text-xs">{t.txn_type}</TableCell>
                <TableCell className="text-right">₹{t.amount.toFixed(2)}</TableCell>
                <TableCell className="text-right">₹{t.balance_after.toFixed(2)}</TableCell>
                <TableCell className="max-w-[200px] truncate text-xs" title={t.description}>{t.description}</TableCell>
                <TableCell className="text-xs text-muted-foreground">{t.created_at ? new Date(t.created_at).toLocaleString() : "—"}</TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
      <PagerFooter skip={skip} total={wallet?.total || 0} pageSize={PAGE_SIZE} onChange={setSkip} />
    </div>
  );
}

// ── Usage tab ────────────────────────────────────────────────────────

function UsagePanel({ developerId }: { developerId: string }) {
  const [logs, setLogs] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [skip, setSkip] = useState(0);
  const [product, setProduct] = useState("all");
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    const params: Record<string, any> = { skip, limit: PAGE_SIZE };
    if (product !== "all") params.product = product;
    const { ok, data } = await adminGetDeveloperUsage(developerId, params);
    if (ok) {
      setLogs(data.logs || []);
      setTotal(data.total || 0);
    }
    setLoading(false);
  }, [developerId, skip, product]);

  useEffect(() => { load(); }, [load]);

  return (
    <div className="space-y-3">
      <Select value={product} onValueChange={(v) => { setSkip(0); setProduct(v); }}>
        <SelectTrigger className="w-40"><SelectValue placeholder="Product" /></SelectTrigger>
        <SelectContent>
          <SelectItem value="all">All products</SelectItem>
          <SelectItem value="kundli">Kundli</SelectItem>
          <SelectItem value="reports">Special Reports</SelectItem>
          <SelectItem value="rashi">Rashi</SelectItem>
          <SelectItem value="forecast">Today Forecast</SelectItem>
          <SelectItem value="specialist">Special Reports (legacy)</SelectItem>
          <SelectItem value="milan">Kundli Milan (legacy)</SelectItem>
        </SelectContent>
      </Select>

      {loading ? (
        <Skeleton className="h-32 w-full rounded-lg" />
      ) : logs.length === 0 ? (
        <div className="flex flex-col items-center gap-2 py-10 text-center">
          <Activity className="h-8 w-8 text-muted-foreground/50" />
          <p className="text-sm text-muted-foreground">No API calls logged yet.</p>
        </div>
      ) : (
        <>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Product</TableHead>
                <TableHead>Endpoint</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Latency</TableHead>
                <TableHead>Date</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {logs.map((l) => (
                <TableRow key={l.id}>
                  <TableCell className="capitalize">{l.product}</TableCell>
                  <TableCell className="font-mono text-xs">{l.endpoint}</TableCell>
                  <TableCell>
                    <Badge variant="outline" className={l.http_status >= 400 ? "border-red-500/30 text-red-400" : "border-emerald-500/30 text-emerald-400"}>
                      {l.http_status}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right text-xs">{l.latency_ms ? `${l.latency_ms}ms` : "—"}</TableCell>
                  <TableCell className="text-xs text-muted-foreground">{l.created_at ? new Date(l.created_at).toLocaleString() : "—"}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          <PagerFooter skip={skip} total={total} pageSize={PAGE_SIZE} onChange={setSkip} />
        </>
      )}
    </div>
  );
}

// ── Shared pager ─────────────────────────────────────────────────────

function PagerFooter({ skip, total, pageSize, onChange }: { skip: number; total: number; pageSize: number; onChange: (skip: number) => void }) {
  const page = Math.floor(skip / pageSize) + 1;
  const totalPages = Math.max(1, Math.ceil(total / pageSize));
  const rangeStart = total === 0 ? 0 : skip + 1;
  const rangeEnd = Math.min(total, skip + pageSize);
  return (
    <div className="flex items-center justify-between text-xs text-muted-foreground">
      <span>Showing {rangeStart}-{rangeEnd} of {total}</span>
      <div className="flex items-center gap-2">
        <Button size="sm" variant="outline" disabled={skip === 0} onClick={() => onChange(Math.max(0, skip - pageSize))}>Previous</Button>
        <span>Page {page} of {totalPages}</span>
        <Button size="sm" variant="outline" disabled={skip + pageSize >= total} onClick={() => onChange(skip + pageSize)}>Next</Button>
      </div>
    </div>
  );
}
