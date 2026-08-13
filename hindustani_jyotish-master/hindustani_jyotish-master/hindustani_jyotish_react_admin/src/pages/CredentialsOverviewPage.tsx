import { useCallback, useEffect, useState, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { api } from '../api/client'
import { adminApi } from '../api/endpoints'
import type {
  AgoraDiagnoseResult,
  FirebaseServiceAccountStatus,
  GoogleAuthSettings,
  RazorpayDiagnoseResult,
  RazorpaySettings,
} from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

// One place to see every third-party credential the platform runs on, what is
// currently fed, and (where the backend offers a diagnose endpoint) whether it
// actually works right now. Each card loads independently so one failing
// fetch never blanks the rest of the page.

interface AgoraSettingRow {
  id: string
  app_name: string | null
  app_id: string
  app_certificate: string
  token_expire_seconds: number
  is_active: boolean
}

/** Coerce an API value that is *supposed* to be an array into one — an older
 * backend, an error envelope, or a `{items:[]}` wrapper must never reach a
 * `.find`/`.map`/`.length` call downstream and white-screen the card. */
function asArray<T>(value: unknown): T[] {
  return Array.isArray(value) ? (value as T[]) : []
}

/** Client-side mask for values the backend returns in full but that should
 * never sit fully readable on an overview screen (Agora certificate). */
function maskTail(value: string | null | undefined): string {
  if (!value) return '—'
  if (value.length <= 8) return '••••••'
  return `${value.slice(0, 4)}…${value.slice(-4)}`
}

function StatusPill({ configured }: { configured: boolean }) {
  return configured ? (
    <span className="shrink-0 rounded-full border border-emerald-500/20 bg-emerald-500/10 px-3 py-1 text-[10.5px] font-bold uppercase tracking-wide text-emerald-400">
      Configured
    </span>
  ) : (
    <span className="shrink-0 rounded-full border border-amber-500/20 bg-amber-500/10 px-3 py-1 text-[10.5px] font-bold uppercase tracking-wide text-amber-400">
      Not configured — using env/dev fallback
    </span>
  )
}

function ValueRow({ label, value, mono = true }: { label: string; value: ReactNode; mono?: boolean }) {
  return (
    <div>
      <div className="text-[10.5px] font-bold uppercase tracking-wide text-ivory-faint">{label}</div>
      <div className={`mt-1 break-all text-[12.5px] leading-relaxed text-ivory-dim ${mono ? 'font-mono' : ''}`}>
        {value ?? '—'}
      </div>
    </div>
  )
}

interface CredCardProps {
  title: string
  icon: string
  subtitle: string
  manageTo: string
  loading: boolean
  error: string | null
  onRetry: () => void
  pill?: ReactNode
  actions?: ReactNode
  children?: ReactNode
}

function CredCard({ title, icon, subtitle, manageTo, loading, error, onRetry, pill, actions, children }: CredCardProps) {
  return (
    <Card className="flex flex-col p-6">
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-center gap-3 min-w-0">
          <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl border border-border-soft bg-surface-1 text-[17px]">{icon}</div>
          <div className="min-w-0">
            <div className="text-[15px] font-semibold tracking-tight">{title}</div>
            <div className="mt-0.5 text-[11.5px] text-ivory-faint">{subtitle}</div>
          </div>
        </div>
        {!loading && !error && pill}
      </div>

      <div className="mt-5 flex-1 space-y-3.5">
        {loading && <div className="py-6 text-center text-[12.5px] text-ivory-faint">Loading…</div>}
        {!loading && error && (
          <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[12.5px] text-red-300">
            Failed to load: {error}{' '}
            <button onClick={onRetry} className="ml-1 font-bold underline underline-offset-2 hover:opacity-80">
              Retry
            </button>
          </div>
        )}
        {!loading && !error && children}
      </div>

      <div className="mt-5 flex flex-wrap items-center gap-2.5 border-t border-border-soft pt-4">
        {actions}
        <Link
          to={manageTo}
          className="ml-auto inline-flex h-9 items-center rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold no-underline hover:bg-surface-2 hover:no-underline transition-colors"
        >
          Manage →
        </Link>
      </div>
    </Card>
  )
}

// ── Google Login ──────────────────────────────────────────────────────

function GoogleCard() {
  const [data, setData] = useState<GoogleAuthSettings | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  const load = useCallback(async () => {
    setLoading(true)
    try {
      setData(await adminApi.getGoogleAuth())
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }, [])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  const extraClientIds = asArray<string>(data?.extra_client_ids)
  const configured = Boolean(
    data &&
      (data.user_android_client_id ||
        data.user_web_client_id ||
        data.astro_android_client_id ||
        data.astro_web_client_id ||
        extraClientIds.length > 0),
  )

  return (
    <CredCard
      title="Google Login"
      icon="🔑"
      subtitle="OAuth client IDs both apps sign in with (Android + Web, per app)"
      manageTo="/google-login"
      loading={loading}
      error={error}
      onRetry={() => void load()}
      pill={<StatusPill configured={configured} />}
      actions={
        <span className="text-[11.5px] leading-relaxed text-ivory-faint">
          No test needed — apps pick these up live via <span className="font-mono">/v1/public/app-config</span>.
        </span>
      }
    >
      <div className="grid grid-cols-2 gap-3.5">
        <ValueRow label="User — Android" value={data?.user_android_client_id || 'falls back to Web'} />
        <ValueRow label="User — Web" value={data?.user_web_client_id || '—'} />
        <ValueRow label="Astrologer — Android" value={data?.astro_android_client_id || 'falls back to Web'} />
        <ValueRow label="Astrologer — Web" value={data?.astro_web_client_id || '—'} />
      </div>
      <ValueRow
        label="Extra allowed client IDs"
        value={
          extraClientIds.length > 0 ? (
            <span className="space-y-1 block">
              {extraClientIds.map((id) => (
                <span key={id} className="block break-all">{id}</span>
              ))}
            </span>
          ) : (
            'None'
          )
        }
      />
    </CredCard>
  )
}

// ── Razorpay ──────────────────────────────────────────────────────────

function RazorpayCard() {
  const [data, setData] = useState<RazorpaySettings | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const [testing, setTesting] = useState(false)
  const [diag, setDiag] = useState<RazorpayDiagnoseResult | null>(null)
  const [diagError, setDiagError] = useState<string | null>(null)

  const load = useCallback(async () => {
    setLoading(true)
    try {
      setData(await adminApi.getRazorpay())
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }, [])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  async function test() {
    setTesting(true)
    setDiagError(null)
    try {
      setDiag(await adminApi.diagnoseRazorpay())
    } catch (e) {
      setDiag(null)
      setDiagError((e as Error).message)
    } finally {
      setTesting(false)
    }
  }

  const diagOk = Boolean(diag?.credentials_configured && diag.test_order_ok)

  return (
    <CredCard
      title="Razorpay"
      icon="💳"
      subtitle="Payment gateway for wallet recharges & orders"
      manageTo="/razorpay"
      loading={loading}
      error={error}
      onRetry={() => void load()}
      pill={<StatusPill configured={Boolean(data?.configured)} />}
      actions={
        <div className="flex flex-col gap-1">
          <button
            onClick={() => void test()}
            disabled={testing}
            className="h-9 self-start rounded-full bg-ivory px-4 text-[12px] font-bold text-bg-0 shadow-sm hover:opacity-90 disabled:opacity-50"
          >
            {testing ? 'Testing…' : 'Test now'}
          </button>
          <span className="text-[10.5px] text-ivory-faint">Creates a ₹1 test order at Razorpay — never captured, no money moves.</span>
        </div>
      }
    >
      <ValueRow label="Key ID" value={data?.configured ? data.key_id || '—' : 'Not set'} />
      <ValueRow label="Key secret" value={data?.configured ? data.key_secret_masked ?? 'Not set' : 'Not set'} />
      <ValueRow label="Webhook secret" value={data?.configured ? data.webhook_secret_masked ?? 'Not set' : 'Not set'} />

      {diagError && (
        <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[12.5px] text-red-300">
          Test failed: {diagError}
        </div>
      )}
      {diag && (
        <div
          className={`rounded-xl border px-4 py-3 text-[12.5px] leading-relaxed ${
            diagOk ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-red-500/20 bg-red-500/10 text-red-400'
          }`}
        >
          <b>{diagOk ? 'Working' : 'Problem'}</b> — {diag.diagnosis}
          {diag.source && <span className="mt-1 block text-[11px] opacity-80">Credential source: {diag.source}</span>}
        </div>
      )}
      {diag?.dev_mode && (
        <div className="rounded-xl border border-sky-500/20 bg-sky-500/10 px-4 py-3 text-[12px] leading-relaxed text-sky-400">
          PAYMENTS_DEV_MODE is on — with credentials configured, real orders are still created; dev mode only applies
          while nothing is configured.
        </div>
      )}
    </CredCard>
  )
}

// ── Agora ─────────────────────────────────────────────────────────────

function AgoraCard() {
  const [rows, setRows] = useState<AgoraSettingRow[]>([])
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const [testing, setTesting] = useState(false)
  const [diag, setDiag] = useState<AgoraDiagnoseResult | null>(null)
  const [diagError, setDiagError] = useState<string | null>(null)

  const load = useCallback(async () => {
    setLoading(true)
    try {
      // The backend is expected to return a bare array here, but an older
      // deployment, an error envelope, or a `{items:[]}` wrapper must never
      // reach `.find()` below and white-screen the card (this is exactly what
      // used to happen before this guard was added).
      const data = await api<unknown>('/admin/agora-settings')
      setRows(asArray<AgoraSettingRow>(data))
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }, [])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  async function test() {
    setTesting(true)
    setDiagError(null)
    try {
      setDiag(await adminApi.diagnoseAgora())
    } catch (e) {
      setDiag(null)
      setDiagError((e as Error).message)
    } finally {
      setTesting(false)
    }
  }

  const active = rows.find((r) => r.is_active) ?? null
  const diagOk = Boolean(diag && !diag.test_token_is_placeholder && diag.diagnosis.startsWith('OK'))

  return (
    <CredCard
      title="Agora"
      icon="🎙️"
      subtitle="Audio/video call & live-stream token credentials"
      manageTo="/agora"
      loading={loading}
      error={error}
      onRetry={() => void load()}
      pill={<StatusPill configured={active !== null} />}
      actions={
        <div className="flex flex-col gap-1">
          <button
            onClick={() => void test()}
            disabled={testing}
            className="h-9 self-start rounded-full bg-ivory px-4 text-[12px] font-bold text-bg-0 shadow-sm hover:opacity-90 disabled:opacity-50"
          >
            {testing ? 'Testing…' : 'Test now'}
          </button>
          <span className="text-[10.5px] text-ivory-faint">Mints a real test token with the active credentials.</span>
        </div>
      }
    >
      <ValueRow label="Active credential set" value={active ? active.app_name || 'Unnamed' : 'None active'} mono={false} />
      <ValueRow label="App ID" value={active ? active.app_id : '—'} />
      <ValueRow label="App certificate" value={active ? maskTail(active.app_certificate) : '—'} />
      <ValueRow label="Token expiry" value={active ? `${active.token_expire_seconds}s` : '—'} />

      {diagError && (
        <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[12.5px] text-red-300">
          Test failed: {diagError}
        </div>
      )}
      {diag && (
        <div
          className={`rounded-xl border px-4 py-3 text-[12.5px] leading-relaxed ${
            diagOk ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-red-500/20 bg-red-500/10 text-red-400'
          }`}
        >
          <b>{diagOk ? 'Working' : 'Problem'}</b> — {diag.diagnosis}
        </div>
      )}
    </CredCard>
  )
}

// ── Firebase Push ─────────────────────────────────────────────────────

function FirebaseCard() {
  const [data, setData] = useState<FirebaseServiceAccountStatus | null>(null)
  const [android, setAndroid] = useState<FirebaseServiceAccountStatus | null>(null)
  const [web, setWeb] = useState<FirebaseServiceAccountStatus | null>(null)
  const [userApp, setUserApp] = useState<FirebaseServiceAccountStatus | null>(null)
  const [astroApp, setAstroApp] = useState<FirebaseServiceAccountStatus | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)

  const load = useCallback(async () => {
    setLoading(true)
    try {
      const [shared, androidStatus, webStatus, userAppStatus, astroAppStatus] = await Promise.all([
        adminApi.firebaseServiceAccountStatus(),
        adminApi.firebasePlatformServiceAccountStatus('android'),
        adminApi.firebasePlatformServiceAccountStatus('web'),
        adminApi.firebaseAppServiceAccountStatus('user'),
        adminApi.firebaseAppServiceAccountStatus('astro'),
      ])
      setData(shared)
      setAndroid(androidStatus)
      setWeb(webStatus)
      setUserApp(userAppStatus)
      setAstroApp(astroAppStatus)
      setError(null)
    } catch (e) {
      setError((e as Error).message)
    } finally {
      setLoading(false)
    }
  }, [])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { void load() }, [load])

  return (
    <CredCard
      title="Firebase Push"
      icon="🔥"
      subtitle="Admin SDK service account for FCM notifications"
      manageTo="/firebase-config"
      loading={loading}
      error={error}
      onRetry={() => void load()}
      pill={<StatusPill configured={Boolean(data?.exists)} />}
      actions={
        <span className="text-[11.5px] leading-relaxed text-ivory-faint">
          Push sending {data?.push_enabled ? 'is enabled' : 'is disabled'} on the server (PUSH_ENABLED).
        </span>
      }
    >
      <ValueRow label="Firebase project (shared)" value={data?.project_id || '—'} />
      <ValueRow label="Service-account email (shared)" value={data?.client_email || '—'} />
      <div>
        <div className="text-[10.5px] font-bold uppercase tracking-wide text-ivory-faint">Per-app credentials</div>
        <div className="mt-1.5 flex flex-wrap gap-2">
          <span className={`rounded-full border px-3 py-1 text-[11px] font-bold ${userApp?.exists ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-border-soft bg-surface-1 text-ivory-faint'}`}>
            User {userApp?.exists ? 'dedicated' : 'shared'}
          </span>
          <span className={`rounded-full border px-3 py-1 text-[11px] font-bold ${astroApp?.exists ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-border-soft bg-surface-1 text-ivory-faint'}`}>
            Astro {astroApp?.exists ? 'dedicated' : 'shared'}
          </span>
        </div>
      </div>
      <div>
        <div className="text-[10.5px] font-bold uppercase tracking-wide text-ivory-faint">Per-platform credentials</div>
        <div className="mt-1.5 flex flex-wrap gap-2">
          <span className={`rounded-full border px-3 py-1 text-[11px] font-bold ${android?.exists ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-border-soft bg-surface-1 text-ivory-faint'}`}>
            Android {android?.exists ? 'dedicated' : 'shared'}
          </span>
          <span className={`rounded-full border px-3 py-1 text-[11px] font-bold ${web?.exists ? 'border-emerald-500/20 bg-emerald-500/10 text-emerald-400' : 'border-border-soft bg-surface-1 text-ivory-faint'}`}>
            Web {web?.exists ? 'dedicated' : 'shared'}
          </span>
        </div>
      </div>
    </CredCard>
  )
}

// ── Page ──────────────────────────────────────────────────────────────

export default function CredentialsOverviewPage() {
  return (
    <div className="space-y-6">
      <PageHeader
        title="Credentials Overview"
        subtitle="Every third-party credential the platform runs on — what is currently fed, and whether it works right now. Use the Manage links to change anything."
        icon={<span className="text-[18px]">🗝️</span>}
      />
      <div className="grid gap-5 xl:grid-cols-2">
        <GoogleCard />
        <RazorpayCard />
        <AgoraCard />
        <FirebaseCard />
      </div>
    </div>
  )
}
