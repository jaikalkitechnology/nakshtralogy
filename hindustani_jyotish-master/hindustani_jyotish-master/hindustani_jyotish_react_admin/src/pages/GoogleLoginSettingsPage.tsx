import { useCallback, useEffect, useState } from 'react'
import { adminApi } from '../api/endpoints'
import type { GoogleAuthSettings } from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

const inputCls =
  'mt-2 h-11 w-full rounded-xl border border-border-soft bg-surface-1 px-4 font-mono text-[13px] outline-none focus:border-saffron shadow-sm'

type ClientIdField = 'user_android_client_id' | 'user_web_client_id' | 'astro_android_client_id' | 'astro_web_client_id'
type OriginField = 'user_web_origin' | 'astro_web_origin'

interface AppGroup {
  key: 'user' | 'astro'
  label: string
  androidField: ClientIdField
  webField: ClientIdField
  originField: OriginField
}

const APP_GROUPS: AppGroup[] = [
  { key: 'user', label: 'User app', androidField: 'user_android_client_id', webField: 'user_web_client_id', originField: 'user_web_origin' },
  { key: 'astro', label: 'Astrologer app', androidField: 'astro_android_client_id', webField: 'astro_web_client_id', originField: 'astro_web_origin' },
]

/** Small mono value box with a one-click "Copy" button — used for the
 *  "Authorized JavaScript origins" value Google Cloud console expects. */
function CopyBox({ value, placeholder }: { value: string; placeholder: string }) {
  const [copied, setCopied] = useState(false)
  const empty = value.trim() === ''
  return (
    <div className="mt-2 flex items-center gap-2">
      <div className={`h-11 flex-1 min-w-0 rounded-xl border border-border-soft bg-surface-1 px-4 flex items-center font-mono text-[13px] truncate ${empty ? 'text-ivory-faint italic' : ''}`}>
        {empty ? placeholder : value}
      </div>
      <button
        type="button"
        disabled={empty}
        onClick={() => {
          void navigator.clipboard.writeText(value)
          setCopied(true)
          setTimeout(() => setCopied(false), 1500)
        }}
        className="h-11 shrink-0 rounded-xl border border-border-soft bg-surface-1 px-4 text-[12px] font-bold hover:border-saffron disabled:opacity-40 shadow-sm"
      >
        {copied ? 'Copied ✓' : 'Copy'}
      </button>
    </div>
  )
}

export default function GoogleLoginSettingsPage(){
  const [current,setCurrent]=useState<GoogleAuthSettings|null>(null)
  const [error,setError]=useState<string|null>(null)
  const [saved,setSaved]=useState(false)
  const [saving,setSaving]=useState(false)

  const [userAndroid,setUserAndroid]=useState('')
  const [userWeb,setUserWeb]=useState('')
  const [astroAndroid,setAstroAndroid]=useState('')
  const [astroWeb,setAstroWeb]=useState('')
  const [userWebOrigin,setUserWebOrigin]=useState('')
  const [astroWebOrigin,setAstroWebOrigin]=useState('')
  const [extraIds,setExtraIds]=useState('')

  /** Coerce whatever the server returned into the full shape.
   *
   * A server older than the per-platform split has no `*_android_client_id`
   * keys at all, and reading `.trim()` off those `undefined`s threw — which
   * React surfaces as a completely BLANK page, not a friendly error. Never
   * let an API-shape difference white-screen the console. The `*_web_origin`
   * fields and the read-only `android_oauth_clients` / `javascript_origins` /
   * `redirect_uris_required` helpers are newer still — a deployed backend may
   * predate all of them, so every one of those is optional here too. */
  function normalise(s: Partial<GoogleAuthSettings> | null | undefined): GoogleAuthSettings {
    const str=(v: unknown)=> typeof v==='string' ? v : ''
    return {
      user_android_client_id: str(s?.user_android_client_id),
      user_web_client_id: str(s?.user_web_client_id),
      astro_android_client_id: str(s?.astro_android_client_id),
      astro_web_client_id: str(s?.astro_web_client_id),
      user_web_origin: str(s?.user_web_origin),
      astro_web_origin: str(s?.astro_web_origin),
      extra_client_ids: Array.isArray(s?.extra_client_ids)
        ? s.extra_client_ids.filter((v): v is string => typeof v==='string')
        : [],
      android_oauth_clients: s?.android_oauth_clients ? {
        user: { package_name: str(s.android_oauth_clients.user?.package_name), client_id: str(s.android_oauth_clients.user?.client_id) },
        astro: { package_name: str(s.android_oauth_clients.astro?.package_name), client_id: str(s.android_oauth_clients.astro?.client_id) },
      } : undefined,
      javascript_origins: s?.javascript_origins ? {
        user: str(s.javascript_origins.user),
        astro: str(s.javascript_origins.astro),
      } : undefined,
      redirect_uris_required: typeof s?.redirect_uris_required==='boolean' ? s.redirect_uris_required : undefined,
    }
  }

  function applyFromServer(raw: Partial<GoogleAuthSettings> | null | undefined){
    const s=normalise(raw)
    setCurrent(s)
    setUserAndroid(s.user_android_client_id)
    setUserWeb(s.user_web_client_id)
    setAstroAndroid(s.astro_android_client_id)
    setAstroWeb(s.astro_web_client_id)
    setUserWebOrigin(s.user_web_origin)
    setAstroWebOrigin(s.astro_web_origin)
    setExtraIds(s.extra_client_ids.join('\n'))
  }

  const load=useCallback(async()=>{
    try{
      const s=await adminApi.getGoogleAuth()
      applyFromServer(s); setError(null)
    }catch(e){ setError((e as Error).message) }
  },[])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function save(){
    setError(null); setSaved(false); setSaving(true)
    try{
      const s=await adminApi.saveGoogleAuth({
        user_android_client_id: userAndroid.trim(),
        user_web_client_id: userWeb.trim(),
        astro_android_client_id: astroAndroid.trim(),
        astro_web_client_id: astroWeb.trim(),
        user_web_origin: userWebOrigin.trim(),
        astro_web_origin: astroWebOrigin.trim(),
        extra_client_ids: extraIds.split('\n').map(l=>l.trim()).filter(Boolean),
      })
      applyFromServer(s); setSaved(true)
    }catch(e){ setError((e as Error).message) } finally{ setSaving(false) }
  }

  function appConfigured(g: AppGroup, s: GoogleAuthSettings): boolean {
    // Defensive `?? ''`: `current` is normalised above, but this must never
    // be the thing that white-screens the page again.
    return (s[g.androidField] ?? '').trim()!=='' || (s[g.webField] ?? '').trim()!==''
  }

  const values: Record<string, [string, (v:string)=>void]> = {
    user_android_client_id: [userAndroid, setUserAndroid],
    user_web_client_id: [userWeb, setUserWeb],
    astro_android_client_id: [astroAndroid, setAstroAndroid],
    astro_web_client_id: [astroWeb, setAstroWeb],
    user_web_origin: [userWebOrigin, setUserWebOrigin],
    astro_web_origin: [astroWebOrigin, setAstroWebOrigin],
  }

  return (
    <div className="max-w-[1200px] space-y-6">
      <PageHeader
        title="Google Login"
        subtitle="OAuth client IDs used for Google sign-in in the user and astrologer apps — one Android and one Web ID per app."
        icon={<span className="text-[18px]">🔐</span>}
      />

      {error && <div className="rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-300">{error}</div>}
      {saved && <div className="rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-4 py-3 text-[13px] text-emerald-400">✓ Saved — Google login client IDs updated.</div>}

      <div className="grid gap-6 xl:grid-cols-2 items-start">
      {APP_GROUPS.map(g=>{
        const configured = current ? appConfigured(g, current) : null
        return (
          <Card key={g.key} className="p-6 sm:p-7">
            <div className="flex items-center justify-between gap-3">
              <div>
                <div className="text-[15px] font-bold tracking-tight">{g.label}</div>
                <div className="text-[12px] text-ivory-faint mt-1">Google sign-in configuration source</div>
              </div>
              {configured !== null && (
                <span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${configured?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-amber-500/20 bg-amber-500/10 text-amber-400'}`}>
                  {configured?'configured':'env fallback'}
                </span>
              )}
            </div>

            {configured===false && (
              <div className="mt-4 rounded-xl border border-amber-500/20 bg-amber-500/10 px-4 py-3 text-[13px] text-amber-400">
                <b>Not configured yet</b> — this app will use the server environment fallback (<span className="font-mono">GOOGLE_CLIENT_IDS</span>).
              </div>
            )}

            <label className="mt-6 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">
              Android — OAuth Web application client ID
              <input
                value={values[g.androidField][0]}
                onChange={e=>values[g.androidField][1](e.target.value)}
                placeholder="Optional — falls back to the Web ID below when blank"
                className={inputCls}
              />
            </label>

            <label className="mt-5 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">
              Web — OAuth Web application client ID
              <input
                value={values[g.webField][0]}
                onChange={e=>values[g.webField][1](e.target.value)}
                placeholder="1234567890-….apps.googleusercontent.com"
                className={inputCls}
              />
            </label>

            <label className="mt-5 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">
              Web app URL
              <input
                value={values[g.originField][0]}
                onChange={e=>values[g.originField][1](e.target.value)}
                placeholder={`https://${g.key}.hindustanijyotish.com`}
                className={inputCls}
              />
            </label>
            <div className="mt-1.5 text-[11.5px] text-ivory-faint">Where this app's web build is hosted.</div>

            <div className="mt-5 rounded-xl border border-border-soft bg-surface-1 p-4">
              <div className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Register in Google Cloud Console</div>

              <div className="mt-3">
                <div className="text-[11px] font-semibold text-ivory-dim">Authorized JavaScript origins</div>
                <CopyBox value={current?.javascript_origins?.[g.key] ?? ''} placeholder="Enter the Web app URL above" />
                <div className="mt-1.5 max-w-[70ch] text-[11px] text-ivory-faint">You may also add <span className="font-mono">http://localhost:PORT</span> for local development.</div>
              </div>

              <div className="mt-4">
                <div className="text-[11px] font-semibold text-ivory-dim">
                  Authorized redirect URI <span className="font-normal text-ivory-faint">(optional)</span>
                </div>
                {/* The apps use Google Identity Services in its default popup
                    mode, which hands the credential back in-page and validates
                    the ORIGIN — no redirect happens, so Google never needs a
                    redirect URI. It is offered here anyway because the console
                    field invites one and adding it is harmless: this is the
                    value Google would POST the credential to if the flow were
                    ever switched to ux_mode:'redirect'. */}
                <CopyBox value={current?.javascript_origins?.[g.key] ?? ""} placeholder="Enter the Web app URL above" />
                <div className="mt-1.5 max-w-[70ch] text-[11px] text-ivory-faint leading-relaxed">
                  <b>Not required</b> — this app signs in with Google Identity Services in popup
                  mode, which returns the credential to the page and validates the origin above,
                  so no redirect ever happens. Adding it is harmless: paste this if the console
                  asks for one, or if the sign-in flow is ever switched to redirect mode.
                </div>
              </div>
            </div>

            <div className="mt-5 rounded-xl border border-border-soft bg-surface-1 p-4">
              <div className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">Android (for reference)</div>
              <div className="mt-2 font-mono text-[13px] break-all">{current?.android_oauth_clients?.[g.key]?.client_id || '—'}</div>
              <div className="mt-1 text-[11.5px] text-ivory-faint font-mono break-all">{current?.android_oauth_clients?.[g.key]?.package_name || '—'}</div>
              <div className="mt-2 max-w-[70ch] text-[11px] text-ivory-faint leading-relaxed">
                Matched automatically from google-services.json by package name + SHA-1. Do not paste this into the fields above — it is not a Web client and sign-in will fail.
              </div>
            </div>
          </Card>
        )
      })}
      </div>

      <Card className="max-w-[720px] p-6 sm:p-7">
        <label className="block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">
          Extra allowed client IDs <span className="normal-case font-medium text-ivory-faint">(one per line)</span>
          <textarea value={extraIds} onChange={e=>setExtraIds(e.target.value)} rows={4} placeholder={'Optional — additional client IDs whose Google ID tokens the backend should accept\n(e.g. an iOS client ID, or a legacy client kept working during a rotation)'} className="mt-2 w-full rounded-xl border border-border-soft bg-surface-1 px-4 py-3 font-mono text-[13px] leading-relaxed outline-none focus:border-saffron shadow-sm resize-y" />
        </label>

        <button disabled={saving} onClick={save} className="mt-6 h-11 w-full rounded-xl bg-ivory text-bg-0 px-6 text-[13px] font-bold hover:opacity-90 disabled:opacity-50 shadow-sm">{saving?'Saving…':'Save client IDs'}</button>

        <details className="mt-6 group/details rounded-xl border border-border-soft bg-surface-1">
          <summary className="flex list-none items-center justify-between gap-3 rounded-xl px-4 py-3 cursor-pointer select-none text-[11px] font-bold uppercase tracking-wide text-ivory-faint hover:text-ivory">
            <span>How this works</span>
            <span className="grid h-5 w-5 shrink-0 place-items-center rounded-full bg-surface-2 transition-transform group-open/details:rotate-180">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M6 9l6 6 6-6"/></svg>
            </span>
          </summary>
          <div className="max-w-[70ch] px-4 pb-4 text-[12px] text-ivory-dim leading-relaxed">
            <ul className="list-disc space-y-1.5 pl-4">
              <li>Both the Android and Web fields are OAuth <b>Web application</b> client IDs from Google Cloud console → APIs &amp; Services → Credentials.</li>
              <li>Android consumes its value as <span className="font-mono">serverClientId</span> — the actual Android OAuth client is matched via <span className="font-mono">google-services.json</span> (package name + SHA-1) and is never entered here.</li>
              <li>The Web client ID must have the site's URL listed under <b>Authorized JavaScript origins</b> in Google Cloud console — that's why it's usually a different client from Android's.</li>
              <li>Leaving the Android field blank makes it fall back to that app's Web ID, so existing single-client setups keep working unchanged.</li>
              <li>All configured IDs (both apps, both platforms, plus any extras below) are accepted as token audiences, so every platform can sign in simultaneously.</li>
              <li>Leave everything blank to fall back to the server's <span className="font-mono">GOOGLE_CLIENT_IDS</span> environment variable.</li>
            </ul>
          </div>
        </details>
      </Card>
    </div>
  )
}
