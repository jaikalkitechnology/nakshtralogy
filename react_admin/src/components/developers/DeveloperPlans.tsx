import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Skeleton } from "@/components/ui/skeleton";
import { Settings2, Save, AlertTriangle } from "lucide-react";
import { adminListDeveloperPlans, adminUpdateDeveloperPlan } from "@/services/api";

interface Plan {
  id: string;
  code: string;
  name: string;
  price: number;
  currency: string;
  duration_days: number;
  tps_limit: number;
  products: string[];
  active: boolean;
}

export default function DeveloperPlans() {
  const [plans, setPlans] = useState<Plan[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [drafts, setDrafts] = useState<Record<string, Partial<Plan>>>({});
  const [saving, setSaving] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const { ok, data } = await adminListDeveloperPlans();
      if (!ok) throw new Error(data?.detail || "Failed to load plans");
      setPlans(data.plans || []);
    } catch (e: any) {
      setError(e?.message || "Something went wrong.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const draftFor = (plan: Plan): Plan => ({ ...plan, ...drafts[plan.id] });

  const setField = (planId: string, field: keyof Plan, value: any) => {
    setDrafts((d) => ({ ...d, [planId]: { ...d[planId], [field]: value } }));
  };

  const save = async (plan: Plan) => {
    setSaving(plan.id);
    const draft = draftFor(plan);
    const { ok, data } = await adminUpdateDeveloperPlan(plan.id, {
      name: draft.name,
      price: draft.price,
      tps_limit: draft.tps_limit,
      duration_days: draft.duration_days,
      active: draft.active,
    });
    setSaving(null);
    if (!ok) {
      alert(data?.detail || "Failed to update plan");
      return;
    }
    setDrafts((d) => { const next = { ...d }; delete next[plan.id]; return next; });
    load();
  };

  return (
    <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
      <CardHeader>
        <CardTitle className="flex items-center gap-2 text-lg">
          <Settings2 className="h-5 w-5 text-primary" /> Subscription Plans
        </CardTitle>
        <p className="text-sm text-muted-foreground">Manage price, rate limit and duration for the All-Access plan.</p>
      </CardHeader>
      <CardContent className="space-y-4">
        {error && (
          <div className="flex items-center justify-between rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
            <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
            <Button size="sm" variant="outline" onClick={load}>Retry</Button>
          </div>
        )}
        {loading ? (
          <div className="space-y-2">
            {Array.from({ length: 2 }).map((_, i) => <Skeleton key={i} className="h-24 w-full rounded-xl" />)}
          </div>
        ) : plans.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">
            No plans yet — run <code>POST /api/v1/admin/seed-api-plans</code> to seed the All-Access plan.
          </p>
        ) : (
          plans.map((plan) => {
            const draft = draftFor(plan);
            const dirty = !!drafts[plan.id];
            return (
              <div key={plan.id} className="rounded-xl border border-border/60 p-4">
                <div className="mb-3 flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span className="font-medium">{plan.code}</span>
                    <Badge variant="outline" className={plan.active ? "border-emerald-500/30 text-emerald-400" : "border-red-500/30 text-red-400"}>
                      {plan.active ? "active" : "inactive"}
                    </Badge>
                    <span className="text-xs text-muted-foreground">{plan.products.join(", ")}</span>
                  </div>
                  <Button size="sm" disabled={!dirty || saving === plan.id} onClick={() => save(plan)}>
                    <Save className="mr-1 h-3.5 w-3.5" /> {saving === plan.id ? "Saving..." : "Save"}
                  </Button>
                </div>
                <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
                  <div>
                    <Label className="text-xs">Name</Label>
                    <Input value={draft.name} onChange={(e) => setField(plan.id, "name", e.target.value)} />
                  </div>
                  <div>
                    <Label className="text-xs">Price ({plan.currency})</Label>
                    <Input type="number" value={draft.price} onChange={(e) => setField(plan.id, "price", parseFloat(e.target.value))} />
                  </div>
                  <div>
                    <Label className="text-xs">TPS limit</Label>
                    <Input type="number" value={draft.tps_limit} onChange={(e) => setField(plan.id, "tps_limit", parseInt(e.target.value, 10))} />
                  </div>
                  <div>
                    <Label className="text-xs">Duration (days)</Label>
                    <Input type="number" value={draft.duration_days} onChange={(e) => setField(plan.id, "duration_days", parseInt(e.target.value, 10))} />
                  </div>
                </div>
                <div className="mt-3 flex items-center gap-2">
                  <Switch checked={draft.active} onCheckedChange={(v) => setField(plan.id, "active", v)} />
                  <span className="text-sm text-muted-foreground">Plan active (visible to developers)</span>
                </div>
              </div>
            );
          })
        )}
      </CardContent>
    </Card>
  );
}
