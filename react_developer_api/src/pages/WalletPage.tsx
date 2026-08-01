import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Wallet as WalletIcon, Plus } from "lucide-react";
import DataTable, { type DataTableColumn } from "@/components/DataTable";
import { getWalletBalance, rechargeWallet, listWalletTransactions } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";

interface Txn {
  id: string;
  txn_type: string;
  amount: number;
  balance_after: number;
  description: string | null;
  created_at: string | null;
}

const PAGE_SIZE = 10;

export default function WalletPage() {
  const { refresh } = useAuth();
  const [balance, setBalance] = useState(0);
  const [txns, setTxns] = useState<Txn[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [rechargeOpen, setRechargeOpen] = useState(false);
  const [amount, setAmount] = useState("500");
  const [recharging, setRecharging] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const [balRes, txnRes] = await Promise.all([
        getWalletBalance(),
        listWalletTransactions({ page, page_size: PAGE_SIZE }),
      ]);
      if (!balRes.ok) throw new Error(balRes.data?.detail || "Failed to load wallet");
      setBalance(balRes.data.balance);
      if (txnRes.ok) {
        setTxns(txnRes.data.transactions || []);
        setTotal(txnRes.data.total || 0);
      }
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, [page]);

  useEffect(() => { load(); }, [load]);

  const doRecharge = async () => {
    const amt = parseFloat(amount);
    if (!amt || amt <= 0) { alert("Enter a valid amount"); return; }
    setRecharging(true);
    const { ok, data } = await rechargeWallet(amt, "portal-recharge");
    setRecharging(false);
    if (!ok) { alert(data?.detail || "Recharge failed"); return; }
    setRechargeOpen(false);
    await load();
    await refresh();
  };

  const columns: DataTableColumn<Txn>[] = [
    { key: "txn_type", header: "Type", render: (t) => <span className="text-xs">{t.txn_type}</span> },
    { key: "amount", header: "Amount", align: "right", render: (t) => `₹${t.amount.toFixed(2)}` },
    { key: "balance_after", header: "Balance after", align: "right", render: (t) => `₹${t.balance_after.toFixed(2)}` },
    { key: "description", header: "Description", render: (t) => <span className="text-xs text-muted-foreground">{t.description || "—"}</span> },
    { key: "created_at", header: "Date", render: (t) => (t.created_at ? new Date(t.created_at).toLocaleString() : "—") },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Wallet</h1>
          <p className="text-sm text-muted-foreground">Fund your account to subscribe or renew All-Access.</p>
        </div>
        <Button onClick={() => setRechargeOpen(true)}><Plus className="mr-1 h-4 w-4" /> Recharge</Button>
      </div>

      <Card className="rounded-2xl border-border/60 bg-gradient-to-br from-card/80 to-card/40 backdrop-blur">
        <CardContent className="flex items-center gap-4 pt-6">
          <div className="rounded-2xl bg-primary/10 p-3"><WalletIcon className="h-8 w-8 text-primary" /></div>
          <div>
            <p className="text-sm text-muted-foreground">Available balance</p>
            <p className="text-3xl font-bold">₹{balance.toFixed(2)}</p>
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Transaction history</CardTitle></CardHeader>
        <CardContent>
          <DataTable
            columns={columns}
            rows={txns}
            rowKey={(t) => t.id}
            loading={loading}
            error={error}
            onRetry={load}
            emptyTitle="No transactions yet"
            emptyDescription="Recharge your wallet or subscribe to a plan to see activity here."
            page={page}
            pageSize={PAGE_SIZE}
            total={total}
            onPageChange={setPage}
          />
        </CardContent>
      </Card>

      <Dialog open={rechargeOpen} onOpenChange={setRechargeOpen}>
        <DialogContent>
          <DialogHeader><DialogTitle>Recharge wallet</DialogTitle></DialogHeader>
          <div className="space-y-1.5">
            <Label>Amount (₹)</Label>
            <Input type="number" value={amount} onChange={(e) => setAmount(e.target.value)} />
          </div>
          <p className="text-xs text-muted-foreground">
            This is a stub credit for development — a real payment gateway plugs in here later without changing this flow.
          </p>
          <DialogFooter>
            <Button onClick={doRecharge} disabled={recharging}>{recharging ? "Processing..." : "Recharge"}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
