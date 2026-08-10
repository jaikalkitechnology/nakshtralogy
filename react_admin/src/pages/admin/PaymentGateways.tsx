import { useCallback, useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { CreditCard, RefreshCw, Check } from "lucide-react";
import { adminPaymentGateways, adminPaymentGatewayUpdate } from "@/services/api";
import { toast } from "sonner";

interface Gateway {
  gateway: string;
  configured: boolean;
  enabled: boolean;
  public_key_set: boolean;
  fields: string[];
}

const META: Record<string, { label: string; note: string }> = {
  razorpay: { label: "Razorpay", note: "India + international cards/UPI. Fields: key_id, key_secret, webhook_secret. Webhook: /api/v1/payments/webhook/razorpay" },
  payu: { label: "PayU", note: "India + international. Fields: merchant_key, merchant_salt. Webhook/callback: /api/v1/payments/webhook/payu" },
  paypal: { label: "PayPal", note: "International only. Fields: client_id, client_secret, environment (sandbox|live), webhook_id. Webhook: /api/v1/payments/webhook/paypal" },
};

export default function PaymentGateways() {
  const [items, setItems] = useState<Gateway[]>([]);
  const [loading, setLoading] = useState(false);
  const [drafts, setDrafts] = useState<Record<string, Record<string, string>>>({});
  const [saving, setSaving] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    const r = await adminPaymentGateways();
    if (r.ok) setItems(r.data?.gateways ?? []);
    else if (r.status === 404) toast.error("Deploy the backend with payment gateways");
    setLoading(false);
  }, []);
  useEffect(() => { load(); }, [load]);

  const setField = (gw: string, key: string, val: string) =>
    setDrafts((d) => ({ ...d, [gw]: { ...(d[gw] || {}), [key]: val } }));

  const save = async (gw: Gateway, enabled?: boolean) => {
    setSaving(gw.gateway);
    const creds = drafts[gw.gateway] || {};
    const payload: any = {};
    if (Object.keys(creds).length) payload.creds = creds;
    if (enabled !== undefined) payload.enabled = enabled;
    const r = await adminPaymentGatewayUpdate(gw.gateway, payload);
    if (r.ok) {
      toast.success(`${META[gw.gateway]?.label || gw.gateway} updated`);
      setDrafts((d) => ({ ...d, [gw.gateway]: {} }));
      load();
    } else toast.error(r.data?.detail || "Save failed");
    setSaving(null);
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <CreditCard className="w-6 h-6 text-primary" /> Payment Gateways
          </h1>
          <p className="text-sm text-muted-foreground">Wallet-recharge credentials. India shows PayU + Razorpay; international also shows PayPal. Secrets are write-only — they are never displayed back.</p>
        </div>
        <Button variant="outline" size="sm" onClick={load} disabled={loading}><RefreshCw className={`w-4 h-4 ${loading ? "animate-spin" : ""}`} /></Button>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        {items.map((gw) => (
          <div key={gw.gateway} className="rounded-xl border border-border bg-card/60 p-5 space-y-3">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="font-display text-lg text-foreground">{META[gw.gateway]?.label || gw.gateway}</h3>
                <p className="text-[11px] text-muted-foreground max-w-sm">{META[gw.gateway]?.note}</p>
              </div>
              <div className="flex flex-col items-end gap-1">
                {gw.configured
                  ? <Badge className="bg-green-500/20 text-green-400 flex items-center gap-1"><Check className="w-3 h-3" /> configured</Badge>
                  : <Badge className="bg-muted text-muted-foreground">not configured</Badge>}
                <Badge className={gw.enabled ? "bg-primary/20 text-primary" : "bg-muted text-muted-foreground"}>{gw.enabled ? "enabled" : "disabled"}</Badge>
              </div>
            </div>
            <div className="space-y-2">
              {gw.fields.map((f) => (
                <div key={f} className="space-y-1">
                  <p className="text-[11px] font-semibold text-muted-foreground">{f}</p>
                  <Input
                    type={f.includes("secret") || f.includes("salt") ? "password" : "text"}
                    placeholder={gw.configured ? "•••••••• (leave blank to keep)" : `Enter ${f}`}
                    value={drafts[gw.gateway]?.[f] ?? ""}
                    onChange={(e) => setField(gw.gateway, f, e.target.value)}
                  />
                </div>
              ))}
            </div>
            <div className="flex items-center justify-between pt-1">
              <label className="flex items-center gap-2 text-sm text-foreground">
                <input type="checkbox" checked={gw.enabled} onChange={(e) => save(gw, e.target.checked)} />
                Enabled
              </label>
              <Button size="sm" onClick={() => save(gw)} disabled={saving === gw.gateway}>
                {saving === gw.gateway ? "Saving…" : "Save credentials"}
              </Button>
            </div>
          </div>
        ))}
        {items.length === 0 && !loading && <p className="text-muted-foreground">No gateways.</p>}
      </div>
    </div>
  );
}
