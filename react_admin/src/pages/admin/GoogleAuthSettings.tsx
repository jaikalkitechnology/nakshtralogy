import { useCallback, useEffect, useState } from "react";
import {
  KeyRound, Save, RefreshCw, Eye, EyeOff, Check, CheckCircle2, XCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  adminGetCategorySettings, adminUpsertSettings,
} from "@/services/api";

/**
 * GoogleAuthSettings — Task 1.2.
 *
 * View/edit the Google OAuth credentials for the User app and the Astrologer
 * app. Values are stored in `platform_settings` under the categories
 * `google_auth_user` / `google_auth_astro` and are read/written through the
 * SAME admin settings API the existing Settings screen uses
 * (adminGetCategorySettings / adminUpsertSettings). Secrets are masked and are
 * only re-sent when the admin actually types a new value (empty = keep
 * existing), matching the existing settings-screen behaviour.
 */

type Role = "user" | "astrologer";

interface FieldDef { key: string; label: string; secret?: boolean; placeholder?: string; }

const FIELDS: FieldDef[] = [
  { key: "client_id", label: "Client ID", placeholder: "xxxxxxxx.apps.googleusercontent.com" },
  { key: "client_secret", label: "Client Secret", secret: true },
  { key: "redirect_uri", label: "Redirect URI", placeholder: "https://api.nakshatralogy.com/api/v1/google/callback" },
  { key: "web_client_id", label: "Web Client ID", placeholder: "Web OAuth client (Flutter Web audience)" },
  { key: "android_client_id", label: "Android Client ID", placeholder: "Android OAuth client audience" },
  { key: "ios_client_id", label: "iOS Client ID", placeholder: "iOS OAuth client audience" },
  { key: "frontend_return_url", label: "Frontend Return URL", placeholder: "https://app.nakshatralogy.com/auth/callback" },
];

const CATEGORY: Record<Role, string> = {
  user: "google_auth_user",
  astrologer: "google_auth_astro",
};

// The single redirect URI that must be registered in the Google Cloud Console
// for the server-side redirect flow (identical for both roles).
const DEFAULT_REDIRECT_URI = "https://api.nakshatralogy.com/api/v1/google/callback";

export default function GoogleAuthSettings() {
  const [role, setRole] = useState<Role>("user");
  const [form, setForm] = useState<Record<string, string>>({});
  const [hasValue, setHasValue] = useState<Record<string, boolean>>({});
  const [showSecret, setShowSecret] = useState<Record<string, boolean>>({});
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);
  const [copied, setCopied] = useState(false);

  const category = CATEGORY[role];

  const load = useCallback(async () => {
    setLoading(true);
    setMsg(null);
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

  const configured = !!(form.client_id && form.client_id.trim());

  const save = async () => {
    setSaving(true);
    setMsg(null);
    try {
      const payload: Record<string, string> = {};
      FIELDS.forEach((f) => {
        const v = form[f.key] ?? "";
        // Never overwrite an existing secret with a blank field.
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

  const copyRedirect = async () => {
    try {
      await navigator.clipboard.writeText(DEFAULT_REDIRECT_URI);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {
      setCopied(false);
    }
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <KeyRound className="h-5 w-5 text-primary" />
          <h1 className="text-lg font-extrabold text-foreground">Google OAuth Credentials</h1>
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
        Credentials for the server-side Google sign-in flow. The backend reads these from
        <code className="mx-1 text-primary">platform_settings</code>
        so no secrets are hard-coded in the apps.
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

      {/* Redirect URI helper */}
      <div className="space-y-2 rounded-xl border border-border bg-muted/20 p-4">
        <p className="text-sm font-medium text-foreground">Redirect URI to register in Google Cloud Console</p>
        <p className="text-[11px] text-muted-foreground">
          Add this exact URI under APIs &amp; Services → Credentials → your OAuth client →
          Authorised redirect URIs (same value for both roles).
        </p>
        <div className="flex gap-1">
          <Input
            readOnly
            value={DEFAULT_REDIRECT_URI}
            className="border-border bg-muted font-mono text-xs"
            onFocus={(e) => e.currentTarget.select()}
          />
          <Button
            size="sm" variant="outline"
            className="h-9 shrink-0 border-primary text-primary"
            type="button"
            onClick={copyRedirect}
          >
            {copied ? <><Check className="mr-1 h-3 w-3" /> Copied</> : "Copy"}
          </Button>
        </div>
      </div>

      {/* Credential form */}
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

        <div className="flex items-center justify-between gap-2 border-t border-border pt-3">
          <span className={`text-xs ${msg ? (msg.ok ? "text-green-400" : "text-destructive") : "text-transparent"}`}>
            {msg?.text || "."}
          </span>
          <Button
            size="sm"
            onClick={save}
            disabled={saving || loading}
            className="gradient-gold text-primary-foreground"
          >
            <Save className="mr-1 h-3 w-3" /> {saving ? "Saving..." : "Save Credentials"}
          </Button>
        </div>
      </div>
    </div>
  );
}
