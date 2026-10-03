import { useCallback, useEffect, useState } from "react";
import { Construction, Save, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  adminGetCategorySettings, adminUpsertSettings,
} from "@/services/api";

/**
 * Maintenance — admin-controlled "under maintenance" switch per app. Stored
 * in `platform_settings` under `maintenance_user` / `maintenance_astro`
 * (enabled, message), read by both Flutter apps (web + Android) via the
 * public `GET /config/maintenance?role=` endpoint on open and periodically
 * while running. When enabled, the app shows a full-screen "We'll be back
 * shortly" page instead of normal content.
 */

interface AppCardProps {
  role: "user" | "astrologer";
  title: string;
  description: string;
}

const DEFAULT_MESSAGE = "We'll be back shortly.";

function MaintenanceCard({ role, title, description }: AppCardProps) {
  const category = role === "user" ? "maintenance_user" : "maintenance_astro";

  const [enabled, setEnabled] = useState(false);
  const [message, setMessage] = useState(DEFAULT_MESSAGE);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);
  const [dirty, setDirty] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setMsg(null);
    try {
      const { ok, data } = await adminGetCategorySettings(category, true);
      if (ok) {
        const keys: any[] = data.keys || [];
        const enabledVal = keys.find((k) => k.key === "enabled")?.value;
        const messageVal = keys.find((k) => k.key === "message")?.value;
        setEnabled(String(enabledVal).trim().toLowerCase() === "true");
        setMessage(messageVal && String(messageVal).trim() ? messageVal : DEFAULT_MESSAGE);
      }
      setDirty(false);
    } catch {
      setMsg({ ok: false, text: "Failed to load." });
    } finally {
      setLoading(false);
    }
  }, [category]);

  useEffect(() => { load(); }, [load]);

  const save = async () => {
    setSaving(true);
    setMsg(null);
    try {
      const { ok, data } = await adminUpsertSettings(category, {
        enabled: enabled ? "true" : "false",
        message,
      });
      if (!ok) {
        setMsg({ ok: false, text: (data as any)?.detail || "Save failed." });
      } else {
        setMsg({ ok: true, text: "Saved." });
        setDirty(false);
      }
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-4 rounded-xl border border-border bg-card/60 p-5">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-base font-semibold text-foreground">{title}</h3>
          <p className="text-xs text-muted-foreground">{description}</p>
        </div>
        {loading ? (
          <Badge variant="outline" className="border-border text-muted-foreground">Loading…</Badge>
        ) : enabled ? (
          <Badge className="bg-destructive/20 text-destructive">Under maintenance</Badge>
        ) : (
          <Badge className="bg-green-500/20 text-green-400">Live</Badge>
        )}
      </div>

      <label className="flex items-center justify-between rounded-lg border border-border bg-muted/20 p-3 cursor-pointer">
        <div>
          <p className="text-sm font-medium text-foreground">Maintenance mode</p>
          <p className="text-xs text-muted-foreground">
            When on, the app shows the maintenance page instead of letting anyone in — including users already logged in.
          </p>
        </div>
        <Switch
          checked={enabled}
          onCheckedChange={(v) => { setEnabled(v); setDirty(true); }}
          disabled={loading}
        />
      </label>

      <div>
        <Label className="text-xs text-foreground/80">Message shown to users</Label>
        <Textarea
          value={message}
          onChange={(e) => { setMessage(e.target.value); setDirty(true); }}
          placeholder={DEFAULT_MESSAGE}
          disabled={loading}
          className="mt-1 min-h-[80px] border-border bg-muted text-sm"
        />
      </div>

      <div className="flex items-center justify-between gap-2 border-t border-border pt-3">
        <span className={`text-xs ${msg ? (msg.ok ? "text-green-400" : "text-destructive") : "text-transparent"}`}>
          {msg?.text || "."}
        </span>
        <Button
          size="sm"
          onClick={save}
          disabled={saving || loading || !dirty}
          className="gradient-gold text-primary-foreground"
        >
          <Save className="mr-1 h-3 w-3" /> {saving ? "Saving..." : "Save"}
        </Button>
      </div>
    </div>
  );
}

export default function Maintenance() {
  const [refreshKey, setRefreshKey] = useState(0);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Construction className="h-5 w-5 text-primary" />
          <h1 className="text-lg font-extrabold text-foreground">Maintenance Mode</h1>
        </div>
        <Button
          size="sm" variant="outline"
          className="h-8 border-border text-muted-foreground"
          onClick={() => setRefreshKey((k) => k + 1)}
        >
          <RefreshCw className="mr-1 h-3 w-3" /> Reload
        </Button>
      </div>

      <p className="text-xs text-muted-foreground">
        Toggle a full-screen "We'll be back shortly" page for the user app and/or the astrologer app —
        web and Android both check this on open and while running, so turning it on takes effect for everyone,
        logged in or not, without a new app release.
      </p>

      <div className="grid gap-4 lg:grid-cols-2" key={refreshKey}>
        <MaintenanceCard role="user" title="User App" description="nakshatralogy_user — web + Android" />
        <MaintenanceCard role="astrologer" title="Astrologer App" description="nakshatralogy_astro — web + Android" />
      </div>
    </div>
  );
}
