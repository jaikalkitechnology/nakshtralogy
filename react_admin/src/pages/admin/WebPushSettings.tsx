import { useCallback, useEffect, useState } from "react";
import {
  Bell, Save, RefreshCw, Eye, EyeOff, Send, CheckCircle2, XCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  adminGetCategorySettings, adminUpsertSettings, adminSendTestWebPush,
} from "@/services/api";

/**
 * WebPushSettings — Task 2.4.
 *
 * Set the Web Push configuration (VAPID keypair + Firebase web config) for the
 * User app and the Astrologer app. Values persist in `platform_settings` under
 * the categories `webpush_user` / `webpush_astro` through the SAME admin
 * settings API used everywhere else (adminGetCategorySettings /
 * adminUpsertSettings). A "Send test web push" action calls the dedicated admin
 * test endpoint. Only the public keys are exposed to the web apps at runtime via
 * the backend's GET /config/webpush; the VAPID private key stays server-side and
 * is masked here.
 */

type Role = "user" | "astrologer";

interface FieldDef { key: string; label: string; secret?: boolean; placeholder?: string; }

const FIELDS: FieldDef[] = [
  { key: "vapid_public_key", label: "VAPID Public Key", placeholder: "BNc... (used by the browser to subscribe)" },
  { key: "vapid_private_key", label: "VAPID Private Key", secret: true },
  { key: "web_api_key", label: "Firebase Web API Key", placeholder: "AIza..." },
  { key: "web_app_id", label: "Firebase Web App ID", placeholder: "1:1234567890:web:abcdef" },
  { key: "web_project_id", label: "Firebase Project ID", placeholder: "nakshatralogy-user" },
  { key: "web_messaging_sender_id", label: "Messaging Sender ID", placeholder: "1234567890" },
  { key: "web_auth_domain", label: "Auth Domain", placeholder: "nakshatralogy-user.firebaseapp.com" },
];

const CATEGORY: Record<Role, string> = {
  user: "webpush_user",
  astrologer: "webpush_astro",
};

// Project slug for the dedicated admin webpush endpoints (mirrors FCM naming).
const PROJECT: Record<Role, "user" | "astro"> = {
  user: "user",
  astrologer: "astro",
};

export default function WebPushSettings() {
  const [role, setRole] = useState<Role>("user");
  const [form, setForm] = useState<Record<string, string>>({});
  const [hasValue, setHasValue] = useState<Record<string, boolean>>({});
  const [showSecret, setShowSecret] = useState<Record<string, boolean>>({});
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [testing, setTesting] = useState(false);
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);
  const [testMsg, setTestMsg] = useState<{ ok: boolean; text: string } | null>(null);

  const category = CATEGORY[role];

  const load = useCallback(async () => {
    setLoading(true);
    setMsg(null);
    setTestMsg(null);
    setShowSecret({});
    try {
      const { ok, data } = await adminGetCategorySettings(category, true);
      const nextForm: Record<string, string> = {};
      const nextHas: Record<string, boolean> = {};
      if (ok) {
        (data.keys || []).forEach((k: any) => {
          nextForm[k.key] = k.value || "";
          nextHas[k.key] = !!k.has_value || !!(k.value && String(k.value).length > 0);
        });
      }
      setForm(nextForm);
      setHasValue(nextHas);
    } catch (e) {
      setMsg({ ok: false, text: "Failed to load settings." });
    } finally {
      setLoading(false);
    }
  }, [category]);

  useEffect(() => { load(); }, [load]);

  const configured = !!(form.vapid_public_key && form.vapid_public_key.trim()
    && form.web_api_key && form.web_api_key.trim());

  const save = async () => {
    setSaving(true);
    setMsg(null);
    try {
      const payload: Record<string, string> = {};
      FIELDS.forEach((f) => {
        const v = form[f.key] ?? "";
        if (f.secret && (!v || v.trim() === "")) return;
        payload[f.key] = v;
      });
      const { ok, data } = await adminUpsertSettings(category, payload);
      if (!ok) {
        setMsg({ ok: false, text: (data as any)?.detail || "Save failed." });
      } else {
        setMsg({ ok: true, text: `Saved ${(data as any)?.updated_fields ?? Object.keys(payload).length} field(s).` });
        await load();
      }
    } finally {
      setSaving(false);
    }
  };

  const sendTest = async () => {
    setTesting(true);
    setTestMsg(null);
    try {
      const { ok, data } = await adminSendTestWebPush(PROJECT[role]);
      if (!ok) {
        setTestMsg({ ok: false, text: (data as any)?.detail || "Test push failed." });
      } else {
        setTestMsg({ ok: true, text: (data as any)?.message || "Test web push sent." });
      }
    } catch (e) {
      setTestMsg({ ok: false, text: "Test push request failed." });
    } finally {
      setTesting(false);
    }
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Bell className="h-5 w-5 text-primary" />
          <h1 className="text-lg font-extrabold text-foreground">Web Push Configuration</h1>
        </div>
        <Button
          size="sm" variant="outline"
          className="h-8 border-border text-muted-foreground"
          onClick={load} disabled={loading}
        >
          <RefreshCw className={`mr-1 h-3 w-3 ${loading ? "animate-spin" : ""}`} /> Reload
        </Button>
      </div>

      <p className="text-xs text-muted-foreground">
        VAPID keys + Firebase web config used by the Flutter Web apps for browser push
        notifications. Public keys are served to the apps via
        <code className="mx-1 text-primary">GET /config/webpush</code>; the VAPID private key
        stays server-side.
      </p>

      {/* Role selector */}
      <div className="flex flex-wrap gap-2">
        {(["user", "astrologer"] as Role[]).map((r) => {
          const active = role === r;
          return (
            <button
              key={r}
              onClick={() => setRole(r)}
              className={`flex items-center gap-1.5 rounded-lg px-3 py-2 text-xs font-medium capitalize transition-all ${
                active
                  ? "border border-primary/40 bg-primary/20 text-primary"
                  : "border border-border bg-card/60 text-muted-foreground hover:bg-muted/30"
              }`}
            >
              {r === "user" ? "User App" : "Astrologer App"}
            </button>
          );
        })}
      </div>

      {/* Config form */}
      <div className="space-y-4 rounded-xl border border-border bg-card/60 p-5">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-semibold capitalize text-foreground">
            {role === "user" ? "User App" : "Astrologer App"} — {category}
          </h3>
          {configured ? (
            <Badge className="flex items-center gap-1 bg-green-500/20 text-green-400">
              <CheckCircle2 className="h-3 w-3" /> Configured
            </Badge>
          ) : (
            <Badge className="flex items-center gap-1 bg-destructive/20 text-destructive">
              <XCircle className="h-3 w-3" /> Not configured
            </Badge>
          )}
        </div>

        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          {FIELDS.map((f) => {
            const val = form[f.key] ?? "";
            const revealed = showSecret[f.key] === true;
            return (
              <div key={f.key}>
                <Label className="flex items-center gap-1 text-xs text-foreground/80">
                  {f.label}
                  {f.secret && <span className="text-[10px] text-destructive">(secret)</span>}
                  {hasValue[f.key] && <Badge className="ml-1 bg-green-500/20 text-[9px] text-green-400">SET</Badge>}
                </Label>
                <div className="mt-1 flex gap-1">
                  <Input
                    type={f.secret && !revealed ? "password" : "text"}
                    value={val}
                    onChange={(e) => setForm({ ...form, [f.key]: e.target.value })}
                    placeholder={f.secret && hasValue[f.key] ? "••••••• (leave blank to keep existing)" : (f.placeholder || "")}
                    className="border-border bg-muted text-xs"
                  />
                  {f.secret && (
                    <Button
                      size="sm" variant="outline"
                      className="h-9 w-9 shrink-0 border-border p-0"
                      type="button"
                      onClick={() => setShowSecret({ ...showSecret, [f.key]: !revealed })}
                      title={revealed ? "Hide" : "Show"}
                    >
                      {revealed ? <EyeOff className="h-3 w-3" /> : <Eye className="h-3 w-3" />}
                    </Button>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        <div className="flex flex-wrap items-center justify-between gap-2 border-t border-border pt-3">
          <div className="flex flex-col gap-0.5">
            {msg && <span className={`text-xs ${msg.ok ? "text-green-400" : "text-destructive"}`}>{msg.text}</span>}
            {testMsg && <span className={`text-xs ${testMsg.ok ? "text-green-400" : "text-destructive"}`}>{testMsg.text}</span>}
          </div>
          <div className="flex gap-2">
            <Button
              size="sm" variant="outline"
              className="border-primary text-primary"
              onClick={sendTest}
              disabled={testing || saving || !configured}
              title={!configured ? "Save a VAPID public key + Firebase config first" : "Send a test web push to this project"}
            >
              <Send className="mr-1 h-3 w-3" /> {testing ? "Sending..." : "Send Test Push"}
            </Button>
            <Button
              size="sm"
              onClick={save}
              disabled={saving || loading}
              className="gradient-gold text-primary-foreground"
            >
              <Save className="mr-1 h-3 w-3" /> {saving ? "Saving..." : "Save Config"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
