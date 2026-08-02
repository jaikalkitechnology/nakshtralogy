import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Skeleton } from "@/components/ui/skeleton";
import { CreditCard, ShieldCheck, AlertTriangle, RefreshCw, Download } from "lucide-react";
import { listPlans, getSubscription, subscribe, getUsageSummary } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";

export default function SubscriptionPage() {
  const { refresh } = useAuth();
  const [plans, setPlans] = useState<any[]>([]);
  const [sub, setSub] = useState<any>(null);
  const [usage, setUsage] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [autoRenew, setAutoRenew] = useState(false);
  const [subscribing, setSubscribing] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const [plansRes, subRes, usageRes] = await Promise.all([listPlans(), getSubscription(), getUsageSummary(30)]);
      if (!plansRes.ok) throw new Error(plansRes.data?.detail || "Failed to load plans");
      setPlans(plansRes.data || []);
      if (subRes.ok) {
        setSub(subRes.data);
        setAutoRenew(!!subRes.data?.auto_renew);
      } else {
        setSub(null);
      }
      if (usageRes.ok) setUsage(usageRes.data);
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const doSubscribe = async () => {
    setSubscribing(true);
    const { ok, data } = await subscribe("all_access", autoRenew);
    setSubscribing(false);
    if (!ok) { alert(data?.detail || "Subscription failed — check your wallet balance."); return; }
    await load();
    await refresh();
  };

  const isActive = sub?.status === "active";

  const downloadReceipt = () => {
    if (!sub) return;
    const lines = [
      "Nakshtralogy Developer Portal — Subscription Receipt",
      `Plan: ${sub.plan_name}`,
      `Status: ${sub.status}`,
      `TPS limit: ${sub.tps_limit} req/s`,
      `Started: ${new Date(sub.started_at).toLocaleString()}`,
      `Expires: ${new Date(sub.expires_at).toLocaleString()}`,
      `Auto-renew: ${sub.auto_renew ? "Yes" : "No"}`,
    ];
    const blob = new Blob([lines.join("\n")], { type: "text/plain;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `nakshtralogy-subscription-receipt-${sub.plan_name || "plan"}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Subscription</h1>
          <p className="text-sm text-muted-foreground">One All-Access plan covers Kundli, Special Reports, Kundli Milan and Today Forecast.</p>
        </div>
        <Button variant="outline" size="icon" onClick={load} title="Refresh"><RefreshCw className="h-4 w-4" /></Button>
      </div>

      {error && (
        <div className="flex items-center justify-between rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
          <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
          <Button size="sm" variant="outline" onClick={load}>Retry</Button>
        </div>
      )}

      {loading ? (
        <Skeleton className="h-48 w-full rounded-2xl" />
      ) : (
        <>
          <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle className="flex items-center gap-2 text-base">
                <ShieldCheck className="h-4 w-4 text-primary" /> Current status
              </CardTitle>
              {sub && (
                <Badge variant="outline" className={isActive ? "border-emerald-500/30 text-emerald-400" : "border-amber-500/30 text-amber-400"}>
                  {sub.status}
                </Badge>
              )}
            </CardHeader>
            <CardContent>
              {sub ? (
                <div className="space-y-3">
                  <div className="grid grid-cols-2 gap-4 text-sm md:grid-cols-4">
                    <div><p className="text-muted-foreground">Plan</p><p className="font-medium">{sub.plan_name}</p></div>
                    <div><p className="text-muted-foreground">TPS limit</p><p className="font-medium">{sub.tps_limit} req/s</p></div>
                    <div><p className="text-muted-foreground">Started</p><p className="font-medium">{new Date(sub.started_at).toLocaleDateString()}</p></div>
                    <div><p className="text-muted-foreground">Expires</p><p className="font-medium">{new Date(sub.expires_at).toLocaleDateString()}</p></div>
                  </div>
                  <div className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-border/60 bg-glass/30 px-3 py-2.5">
                    <p className="text-xs text-muted-foreground">
                      Calls this period (30d): <span className="font-semibold text-foreground">{usage?.kpis?.total_calls ?? 0}</span> — this plan is rate-limited to {sub.tps_limit} req/s with no monthly call cap.
                    </p>
                    <Button size="sm" variant="outline" onClick={downloadReceipt}><Download className="mr-1 h-3.5 w-3.5" /> Download receipt</Button>
                  </div>
                </div>
              ) : (
                <p className="text-sm text-muted-foreground">You do not have a subscription yet. Subscribe below to start calling the gateway.</p>
              )}
            </CardContent>
          </Card>

          {plans.map((plan) => (
            <Card key={plan.id} className="rounded-2xl border-border/60 bg-gradient-to-br from-card/80 to-card/40 backdrop-blur">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <CreditCard className="h-5 w-5 text-primary" /> {plan.name}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-baseline gap-2">
                  <span className="text-3xl font-bold">₹{plan.price}</span>
                  <span className="text-sm text-muted-foreground">/ {plan.duration_days} days</span>
                </div>
                <ul className="grid grid-cols-2 gap-2 text-sm text-muted-foreground">
                  {plan.products.map((p: string) => <li key={p} className="capitalize">✓ {p}</li>)}
                </ul>
                <p className="text-sm text-muted-foreground">Rate limit: <span className="font-medium text-foreground">{plan.tps_limit} request/second</span></p>
                <div className="flex items-center gap-2">
                  <Switch checked={autoRenew} onCheckedChange={setAutoRenew} />
                  <span className="text-sm text-muted-foreground">Auto-renew on expiry</span>
                </div>
                <Button className="w-full" onClick={doSubscribe} disabled={subscribing}>
                  {subscribing ? "Processing..." : isActive ? "Renew now" : "Subscribe (wallet-funded)"}
                </Button>
              </CardContent>
            </Card>
          ))}
        </>
      )}
    </div>
  );
}
