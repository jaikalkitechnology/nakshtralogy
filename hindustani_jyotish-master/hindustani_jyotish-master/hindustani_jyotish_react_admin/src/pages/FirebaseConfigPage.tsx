import { useCallback, useEffect, useState, type ChangeEvent } from 'react'
import { ApiError, downloadBlob } from '../api/client'
import { adminApi } from '../api/endpoints'
import type { FirebaseApp, FirebasePlatform, FirebaseServiceAccountStatus, FirebaseWebApp, FirebaseWebConfig, MaintenanceApp } from '../api/types'
import { PageHeader, Card } from '../components/ui/PageShell'

const CLIENT_APPS: { app:MaintenanceApp; label:string; desc:string }[]=[
  {app:'user',label:'User App',desc:'Customer Android/iOS build config — google-services.json / GoogleService-Info.plist'},
  {app:'astro',label:'Astrologer App',desc:'Astrologer Android/iOS build config — separate Firebase project possible'}
]

const APP_CARDS: { app:FirebaseApp; label:string; desc:string }[]=[
  {app:'user',label:'User App',desc:'Service account used to send push to the User app\'s device tokens'},
  {app:'astro',label:'Astrologer App',desc:'Service account used to send push to the Astrologer app\'s device tokens'},
]

const PLATFORM_CARDS: { platform:FirebasePlatform; label:string; desc:string }[]=[
  {platform:'android',label:'Android',desc:'Service account used to send push to Android device tokens'},
  {platform:'web',label:'Web',desc:'Service account used to send push to Web-app device tokens'},
]

export default function FirebaseConfigPage(){
  return (
    <div className="space-y-6">
      <PageHeader title="Firebase Config" subtitle="Manage push notification service account and per-app client configs. Service account enables server push, client configs bake into mobile builds." icon={<span className="text-[18px]">🔥</span>} />

      <ServiceAccountSection />

      <div>
        <h2 className="text-[15px] font-bold tracking-tight">Per-app service accounts</h2>
        <p className="mt-1 max-w-[70ch] text-[12px] text-ivory-faint">
          Each Flutter app has its own google-services.json, so its device tokens are minted by that app's Firebase
          project and can only be delivered through that project's credential — this is the <b>primary split</b>.
          Upload one per app when the User and Astrologer apps use different Firebase projects. Note that these are
          seeded automatically from the project's credentials on first startup, so they usually already show as
          configured.
        </p>
        <div className="mt-4 grid gap-5 md:grid-cols-2">
          {APP_CARDS.map(a=><AppServiceAccountSection key={a.app} app={a.app} label={a.label} desc={a.desc} />)}
        </div>
      </div>

      <div>
        <h2 className="text-[15px] font-bold tracking-tight">Per-platform service accounts</h2>
        <p className="mt-1 max-w-[70ch] text-[12px] text-ivory-faint">
          A finer-grained override, only needed when <b>one</b> app uses different Firebase projects for Android vs
          Web. Resolution order for a device token: app+platform → app → platform → shared. Otherwise the shared
          Service Account above (or the per-app credential above) already covers both platforms and nothing here
          needs to be set.
        </p>
        <div className="mt-4 grid gap-5 md:grid-cols-2">
          {PLATFORM_CARDS.map(p=><PlatformServiceAccountSection key={p.platform} platform={p.platform} label={p.label} desc={p.desc} />)}
        </div>
      </div>

      <WebConfigSection />

      <div>
        <h2 className="text-[15px] font-bold tracking-tight">Client Config</h2>
        <p className="mt-1 text-[12px] text-ivory-faint">Updates file used in next mobile build — does not push to installed apps. Download current to verify.</p>
        <div className="mt-4 grid gap-5 md:grid-cols-2">
          {CLIENT_APPS.map(a=><ClientSection key={a.app} app={a.app} label={a.label} desc={a.desc} />)}
        </div>
      </div>
    </div>
  )
}

function ServiceAccountSection(){
  const [status,setStatus]=useState<FirebaseServiceAccountStatus|null>(null)
  const [error,setError]=useState<string|null>(null)
  const [uploading,setUploading]=useState(false)
  const [success,setSuccess]=useState<string|null>(null)

  const load=useCallback(async()=>{ try{ setStatus(await adminApi.firebaseServiceAccountStatus()); setError(null) } catch(e){ setError((e as Error).message) } },[])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function handleFile(e:ChangeEvent<HTMLInputElement>){
    const file=e.target.files?.[0]; if(!file) return
    setUploading(true); setError(null); setSuccess(null)
    try{ const s=await adminApi.uploadFirebaseServiceAccount(file); setSuccess(`Uploaded — project "${s.project_id ?? '?'}" (${s.client_email ?? '?'})`); await load() }
    catch(err){ setError((err as Error).message) } finally{ setUploading(false); e.target.value='' }
  }

  const configured=status?.exists ?? null

  return (
    <Card className="p-6 max-w-[640px]">
      <div className="flex items-center justify-between"><h2 className="text-[15px] font-bold">Service Account</h2><span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${configured?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-red-500/20 bg-red-500/10 text-red-400'}`}>{configured?'configured':'not configured'}</span></div>
      <p className="mt-2 text-[12px] text-ivory-dim leading-relaxed">Server credential for push notifications. Private key never displayed after upload. Used for FCM server sends.</p>
      {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2.5 text-[12px] text-red-300">{error}</div>}
      {success && <div className="mt-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-3 py-2.5 text-[12px] text-emerald-400">{success}</div>}
      {configured && status && (
        <div className="mt-4 grid gap-2 rounded-xl border border-border-soft bg-surface-1 p-4 text-[12px]">
          <div className="flex justify-between"><span className="text-ivory-faint">Project ID</span><span className="font-mono font-bold">{status.project_id}</span></div>
          <div className="flex justify-between"><span className="text-ivory-faint">Client email</span><span className="font-mono truncate max-w-[180px]">{status.client_email}</span></div>
          <div className="flex justify-between"><span className="text-ivory-faint">Push enabled</span><span className={`rounded-full px-2 py-0.5 text-[11px] font-bold border ${status.push_enabled ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' : 'bg-surface-2 text-ivory-faint border-border-soft'}`}>{String(status.push_enabled)}</span></div>
        </div>
      )}
      <label className="mt-5 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{configured?'Replace JSON — upload new service account':'Upload JSON service account'}<input type="file" accept="application/json,.json" onChange={handleFile} disabled={uploading} className="mt-2 block w-full rounded-xl border border-border-soft bg-surface-1 p-3 text-[12px] file:mr-3 file:rounded-full file:border-0 file:bg-ivory file:text-bg-0 file:px-4 file:py-1 file:text-[12px] file:font-bold" /></label>
      {uploading && <span className="mt-2 block text-[11px] text-ivory-faint">Uploading and validating…</span>}
    </Card>
  )
}

function PlatformServiceAccountSection({platform,label,desc}:{platform:FirebasePlatform; label:string; desc:string}){
  const [status,setStatus]=useState<FirebaseServiceAccountStatus|null>(null)
  const [error,setError]=useState<string|null>(null)
  const [uploading,setUploading]=useState(false)
  const [removing,setRemoving]=useState(false)
  const [success,setSuccess]=useState<string|null>(null)

  const load=useCallback(async()=>{
    try{ setStatus(await adminApi.firebasePlatformServiceAccountStatus(platform)); setError(null) }
    catch(e){ setError((e as Error).message) }
  },[platform])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function handleFile(e:ChangeEvent<HTMLInputElement>){
    const file=e.target.files?.[0]; if(!file) return
    setUploading(true); setError(null); setSuccess(null)
    try{ const s=await adminApi.uploadFirebasePlatformServiceAccount(platform, file); setSuccess(`Uploaded — project "${s.project_id ?? '?'}" (${s.client_email ?? '?'})`); await load() }
    catch(err){ setError((err as Error).message) } finally{ setUploading(false); e.target.value='' }
  }

  async function handleRemove(){
    setRemoving(true); setError(null); setSuccess(null)
    try{ await adminApi.deleteFirebasePlatformServiceAccount(platform); setSuccess('Removed — this platform now uses the shared credential.'); await load() }
    catch(err){ setError((err as Error).message) } finally{ setRemoving(false) }
  }

  const dedicated=status?.exists ?? null

  return (
    <Card className="p-6">
      <div className="flex items-center justify-between"><h3 className="text-[14px] font-bold">{label}</h3><span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${dedicated?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-amber-500/20 bg-amber-500/10 text-amber-400'}`}>{dedicated?'dedicated credential':'using shared credential'}</span></div>
      <p className="mt-2 text-[12px] leading-relaxed text-ivory-faint">{desc}</p>
      {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[12px] text-red-300">{error}</div>}
      {success && <div className="mt-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-3 py-2 text-[12px] text-emerald-400">{success}</div>}
      {dedicated && status && (
        <div className="mt-4 grid gap-2 rounded-xl border border-border-soft bg-surface-1 p-4 text-[12px]">
          <div className="flex justify-between"><span className="text-ivory-faint">Project ID</span><span className="font-mono font-bold">{status.project_id}</span></div>
          <div className="flex justify-between"><span className="text-ivory-faint">Client email</span><span className="font-mono truncate max-w-[180px]">{status.client_email}</span></div>
        </div>
      )}
      <label className="mt-4 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{dedicated?'Replace JSON — upload new service account':'Upload JSON service account'}<input type="file" accept="application/json,.json" onChange={handleFile} disabled={uploading||removing} className="mt-2 block w-full rounded-xl border border-border-soft bg-surface-1 p-3 text-[12px] file:mr-3 file:rounded-full file:border-0 file:bg-ivory file:text-bg-0 file:px-4 file:py-1 file:text-[12px] file:font-bold" /></label>
      {uploading && <span className="mt-2 block text-[11px] text-ivory-faint">Uploading and validating…</span>}
      {dedicated && (
        <button onClick={()=>void handleRemove()} disabled={removing||uploading} className="mt-4 h-9 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2 disabled:opacity-50">
          {removing?'Removing…':'Remove — revert to shared credential'}
        </button>
      )}
    </Card>
  )
}

function AppServiceAccountSection({app,label,desc}:{app:FirebaseApp; label:string; desc:string}){
  const [status,setStatus]=useState<FirebaseServiceAccountStatus|null>(null)
  const [error,setError]=useState<string|null>(null)
  const [uploading,setUploading]=useState(false)
  const [removing,setRemoving]=useState(false)
  const [success,setSuccess]=useState<string|null>(null)

  const load=useCallback(async()=>{
    try{ setStatus(await adminApi.firebaseAppServiceAccountStatus(app)); setError(null) }
    catch(e){ setError((e as Error).message) }
  },[app])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function handleFile(e:ChangeEvent<HTMLInputElement>){
    const file=e.target.files?.[0]; if(!file) return
    setUploading(true); setError(null); setSuccess(null)
    try{ const s=await adminApi.uploadFirebaseAppServiceAccount(app, file); setSuccess(`Uploaded — project "${s.project_id ?? '?'}" (${s.client_email ?? '?'})`); await load() }
    catch(err){ setError((err as Error).message) } finally{ setUploading(false); e.target.value='' }
  }

  async function handleRemove(){
    setRemoving(true); setError(null); setSuccess(null)
    try{ await adminApi.deleteFirebaseAppServiceAccount(app); setSuccess('Removed — this app now uses the shared credential.'); await load() }
    catch(err){ setError((err as Error).message) } finally{ setRemoving(false) }
  }

  const dedicated=status?.exists ?? null

  return (
    <Card className="p-6">
      <div className="flex items-center justify-between"><h3 className="text-[14px] font-bold">{label}</h3><span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${dedicated?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-amber-500/20 bg-amber-500/10 text-amber-400'}`}>{dedicated?'dedicated credential':'using shared credential'}</span></div>
      <p className="mt-2 text-[12px] leading-relaxed text-ivory-faint">{desc}</p>
      {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[12px] text-red-300">{error}</div>}
      {success && <div className="mt-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-3 py-2 text-[12px] text-emerald-400">{success}</div>}
      {dedicated && status && (
        <div className="mt-4 grid gap-2 rounded-xl border border-border-soft bg-surface-1 p-4 text-[12px]">
          <div className="flex justify-between"><span className="text-ivory-faint">Project ID</span><span className="font-mono font-bold">{status.project_id}</span></div>
          <div className="flex justify-between"><span className="text-ivory-faint">Client email</span><span className="font-mono truncate max-w-[180px]">{status.client_email}</span></div>
        </div>
      )}
      <label className="mt-4 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{dedicated?'Replace JSON — upload new service account':'Upload JSON service account'}<input type="file" accept="application/json,.json" onChange={handleFile} disabled={uploading||removing} className="mt-2 block w-full rounded-xl border border-border-soft bg-surface-1 p-3 text-[12px] file:mr-3 file:rounded-full file:border-0 file:bg-ivory file:text-bg-0 file:px-4 file:py-1 file:text-[12px] file:font-bold" /></label>
      {uploading && <span className="mt-2 block text-[11px] text-ivory-faint">Uploading and validating…</span>}
      {dedicated && (
        <button onClick={()=>void handleRemove()} disabled={removing||uploading} className="mt-4 h-9 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2 disabled:opacity-50">
          {removing?'Removing…':'Remove — revert to shared credential'}
        </button>
      )}
    </Card>
  )
}

// ── Firebase WEB app config ──────────────────────────────────────────
// Android/iOS builds read the baked-in google-services.json; the WEB builds
// can't — Firebase.initializeApp() on web needs explicit options, which both
// Flutter web apps fetch live from /v1/public/app-config at startup. Saving
// here therefore takes effect on the next web page load, with no rebuild.
//
// The GET seeds these fields from the credentials already shipped inside the
// apps, so this form arrives PREFILLED with the currently-effective values
// rather than empty.
const WEB_FIELDS: { key: keyof FirebaseWebApp; label: string; placeholder: string; hint?: string }[] = [
  { key:'api_key', label:'Web API key', placeholder:'AIza…' },
  { key:'app_id', label:'Web app ID', placeholder:'1:892936615659:web:…', hint:'Firebase console → Project settings → Your apps → Add app → Web' },
  { key:'project_id', label:'Project ID', placeholder:'my-project' },
  { key:'messaging_sender_id', label:'Messaging sender ID', placeholder:'892936615659' },
  { key:'auth_domain', label:'Auth domain', placeholder:'my-project.firebaseapp.com' },
  { key:'storage_bucket', label:'Storage bucket', placeholder:'my-project.appspot.com' },
  { key:'measurement_id', label:'Measurement ID (optional)', placeholder:'G-XXXXXXX' },
  { key:'vapid_key', label:'Web Push VAPID key', placeholder:'B…', hint:'Firebase console → Cloud Messaging → Web Push certificates' },
]

const WEB_APPS: { app:'user'|'astro'; label:string }[] = [
  { app:'user', label:'User App' },
  { app:'astro', label:'Astrologer App' },
]

function WebConfigSection(){
  const [cfg,setCfg]=useState<FirebaseWebConfig|null>(null)
  const [tab,setTab]=useState<'user'|'astro'>('user')
  const [error,setError]=useState<string|null>(null)
  const [success,setSuccess]=useState<string|null>(null)
  const [saving,setSaving]=useState(false)

  const load=useCallback(async()=>{
    try{ setCfg(await adminApi.getFirebaseWebConfig()); setError(null) }
    catch(e){
      // A bare "Not Found" here means the SERVER predates this endpoint, not
      // that the config is missing — say so instead of showing a raw 404 that
      // reads like a broken page.
      if(e instanceof ApiError && e.status===404){
        setError('This server does not have the Web App Config endpoint yet — redeploy the backend to manage these values here.')
      } else setError((e as Error).message)
    }
  },[])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  function setField(app:'user'|'astro', key:keyof FirebaseWebApp, value:string){
    setCfg(prev=> prev ? {...prev, [app]: {...prev[app], [key]: value}} : prev)
    setSuccess(null)
  }

  async function save(){
    if(!cfg) return
    setSaving(true); setError(null); setSuccess(null)
    try{ setCfg(await adminApi.saveFirebaseWebConfig(cfg)); setSuccess('Saved — takes effect on the next web app load.') }
    catch(e){ setError((e as Error).message) } finally{ setSaving(false) }
  }

  const active = cfg?.[tab] ?? null
  // Web init needs exactly these two; everything else has a usable default.
  const ready = !!(active?.api_key && active?.app_id)

  return (
    <Card className="p-6">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-[15px] font-bold">Web App Config</h2>
        {active && (
          <span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${ready?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-amber-500/20 bg-amber-500/10 text-amber-400'}`}>
            {ready?'ready for web':'web app ID missing'}
          </span>
        )}
      </div>

      <details className="mt-3 group/details rounded-xl border border-border-soft bg-surface-1">
        <summary className="flex list-none items-center justify-between gap-3 rounded-xl px-4 py-3 cursor-pointer select-none text-[11px] font-bold uppercase tracking-wide text-ivory-faint hover:text-ivory">
          <span>How this works</span>
          <span className="grid h-5 w-5 shrink-0 place-items-center rounded-full bg-surface-2 transition-transform group-open/details:rotate-180">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M6 9l6 6 6-6"/></svg>
          </span>
        </summary>
        <div className="max-w-[70ch] px-4 pb-4">
          <p className="text-[12px] text-ivory-dim leading-relaxed">
            Mobile builds read the baked-in google-services.json below. The <span className="font-bold">web</span> builds instead read this config live at startup, so saving here applies on the next page load — no rebuild. These are public browser values, not secrets.
          </p>
          <p className="mt-2 rounded-xl border border-border-soft bg-surface-raised px-3 py-2.5 text-[12px] text-ivory-dim leading-relaxed">
            <b>This is not the service account.</b> Two different Firebase files do two different jobs:
            this section holds the <b>public web config</b> the browser uses to <b>receive</b> push
            (API key, Web app ID, VAPID key), while the <b>Service Account JSON</b> (private key) above
            is what the <b>server</b> uses to <b>send</b> push. Both are needed for web notifications.
          </p>
        </div>
      </details>

      <div className="mt-4 flex gap-2">
        {WEB_APPS.map(a=>(
          <button key={a.app} type="button" onClick={()=>{setTab(a.app); setSuccess(null)}}
            className={`rounded-lg px-3 py-1.5 text-[12px] font-bold border transition-colors ${tab===a.app?'border-ivory/20 bg-ivory text-bg-0':'border-border-soft bg-surface-1 text-ivory-faint hover:text-ivory'}`}>
            {a.label}
          </button>
        ))}
      </div>

      {error && <div className="mt-4 max-w-[70ch] rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2.5 text-[12px] text-red-300">{error}</div>}
      {success && <div className="mt-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-3 py-2.5 text-[12px] text-emerald-400">{success}</div>}

      {!cfg && !error && <div className="mt-4 text-[12px] text-ivory-faint">Loading…</div>}

      {active && (
        <>
          {!ready && (
            <div className="mt-4 max-w-[70ch] rounded-xl border border-amber-500/20 bg-amber-500/10 px-3 py-2.5 text-[12px] text-amber-300">
              Register a Web app in Firebase console → Project settings → Your apps → Add app → Web, then paste its <span className="font-mono">appId</span> (1:…:web:…) below. Until then this app's web build runs without Firebase (push disabled); mobile is unaffected.
            </div>
          )}
          <div className="mt-4 grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {WEB_FIELDS.map(f=>(
              <label key={f.key} className="block">
                <span className="text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{f.label}</span>
                <input
                  value={active[f.key] ?? ''}
                  placeholder={f.placeholder}
                  onChange={e=>setField(tab,f.key,e.target.value)}
                  className="mt-1.5 w-full rounded-xl border border-border-soft bg-surface-1 px-3 py-2.5 font-mono text-[12px] outline-none focus:border-saffron"
                />
                {f.hint && <span className="mt-1 block text-[11px] text-ivory-faint">{f.hint}</span>}
              </label>
            ))}
          </div>
          <button type="button" onClick={()=>void save()} disabled={saving}
            className="mt-5 rounded-xl bg-ivory px-4 py-2.5 text-[12px] font-bold text-bg-0 disabled:opacity-50">
            {saving?'Saving…':'Save web config'}
          </button>
        </>
      )}
    </Card>
  )
}

function ClientSection({app,label,desc}:{app:MaintenanceApp; label:string; desc:string}){
  const [configured,setConfigured]=useState<boolean|null>(null)
  const [filename,setFilename]=useState<string|null>(null)
  const [blob,setBlob]=useState<Blob|null>(null)
  const [error,setError]=useState<string|null>(null)
  const [uploading,setUploading]=useState(false)
  const [success,setSuccess]=useState<string|null>(null)

  const load=useCallback(async()=>{
    try{ const {blob: b, filename: fname}=await adminApi.downloadFirebaseClientConfig(app); setConfigured(true); setBlob(b); setFilename(fname ?? `${app}-google-services.json`); setError(null) }
    catch(e){ if(e instanceof ApiError && e.status===404){ setConfigured(false); setBlob(null); setFilename(null); setError(null) } else setError((e as Error).message) }
  },[app])
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(()=>{ void load() },[load])

  async function handleFile(e:ChangeEvent<HTMLInputElement>){
    const file=e.target.files?.[0]; if(!file) return
    setUploading(true); setError(null); setSuccess(null)
    try{ const r=await adminApi.uploadFirebaseClientConfig(app,file); setSuccess(r.project_id ? `Uploaded — project "${r.project_id}"` : 'Uploaded.'); await load() }
    catch(err){ setError((err as Error).message) } finally{ setUploading(false); e.target.value='' }
  }

  return (
    <Card className="p-6">
      <div className="flex items-center justify-between"><h3 className="text-[14px] font-bold">{label}</h3><span className={`rounded-full border px-3 py-1 text-[11px] font-bold uppercase ${configured?'border-emerald-500/20 bg-emerald-500/10 text-emerald-400':'border-red-500/20 bg-red-500/10 text-red-400'}`}>{configured?'configured':'not configured'}</span></div>
      <p className="mt-2 text-[12px] leading-relaxed text-ivory-faint">{desc}</p>
      {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 px-3 py-2 text-[12px] text-red-300">{error}</div>}
      {success && <div className="mt-4 rounded-xl border border-emerald-500/20 bg-emerald-500/10 px-3 py-2 text-[12px] text-emerald-400">{success}</div>}
      {configured && <button onClick={()=> blob && downloadBlob(blob, filename ?? `${app}-google-services.json`)} className="mt-4 h-9 rounded-full border border-border-soft bg-surface-1 px-4 text-[12px] font-semibold hover:bg-surface-2">Download current config</button>}
      <label className="mt-4 block text-[11px] font-bold uppercase tracking-wide text-ivory-faint">{configured?'Replace file':'Upload file'}<input type="file" onChange={handleFile} disabled={uploading} className="mt-2 block w-full rounded-xl border border-border-soft bg-surface-1 p-3 text-[12px] file:mr-3 file:rounded-full file:border-0 file:bg-ivory file:text-bg-0 file:px-4 file:py-1 file:text-[12px] file:font-bold" /></label>
      {uploading && <span className="mt-2 block text-[11px] text-ivory-faint">Uploading…</span>}
    </Card>
  )
}
