import { useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { ApiError } from '../api/client'

export default function LoginPage() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string|null>(null)
  const [busy, setBusy] = useState(false)
  const [showPw, setShowPw] = useState(false)

  async function handleSubmit(e: FormEvent){
    e.preventDefault()
    setError(null); setBusy(true)
    try{ await login(email,password); navigate('/') }
    catch(err){ setError(err instanceof ApiError ? err.message : 'Login failed') }
    finally{ setBusy(false) }
  }

  return (
    <div className="relative flex min-h-screen items-center justify-center overflow-hidden bg-bg-0 px-5 py-8 sm:px-6">
      <div className="w-full max-w-[420px] relative z-10">
        {/* Brand header */}
        <div className="mb-8 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <img src="/logo.png" alt="Hindustani Jyotish" className="h-10 w-10 rounded-xl object-cover" />
            <div>
              <div className="text-[15px] font-bold tracking-tight">Hindustani Jyotish</div>
              <div className="text-[10px] font-semibold uppercase tracking-wide text-ivory-faint">Admin Console</div>
            </div>
          </div>
          <span className="rounded-full bg-emerald-500/10 border border-emerald-500/20 px-2.5 py-1 text-[10px] font-bold uppercase text-emerald-400">Live</span>
        </div>

        {/* Login form card */}
        <div className="rounded-2xl border border-border-soft bg-surface-raised p-7 sm:p-8 shadow-[var(--shadow-2)]">
          <div className="flex items-start justify-between gap-3">
            <div>
              <h2 className="text-[22px] font-semibold tracking-tight leading-tight">Welcome back</h2>
              <p className="mt-2 text-[13.5px] leading-relaxed text-ivory-dim">Sign in to your administrator account. Secure, encrypted, JWT protected.</p>
            </div>
            <div className="hidden sm:grid h-10 w-10 place-items-center rounded-xl bg-surface-1 border border-border-soft text-[18px]">🔐</div>
          </div>

          {error && (
            <div className="mt-6 flex gap-2.5 rounded-xl border border-red-500/20 bg-red-500/10 px-4 py-3 text-[13px] text-red-400">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="mt-0.5 shrink-0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-7 space-y-5">
            <div>
              <label className="mb-2 block text-[11px] font-semibold uppercase tracking-wide text-ivory-faint">Email address</label>
              <div className="relative group">

                <input type="email" value={email} onChange={e=>setEmail(e.target.value)} placeholder="admin@hindustanijyotish.in" autoComplete="username" required
                  className="h-[44px] w-full rounded-lg border border-border-soft bg-surface-raised px-4 text-[14px] font-medium outline-none transition-all placeholder:text-ivory-faint focus:border-saffron focus:shadow-[0_0_0_3px_var(--color-saffron-soft)]"
                />
              </div>
            </div>

            <div>
              <label className="mb-2 block text-[11px] font-semibold uppercase tracking-wide text-ivory-faint">Password</label>
              <div className="relative group">

                <input type={showPw?'text':'password'} value={password} onChange={e=>setPassword(e.target.value)} placeholder="Enter your password" autoComplete="current-password" required
                  className="h-[44px] w-full rounded-lg border border-border-soft bg-surface-raised pl-4 pr-12 text-[14px] font-medium outline-none transition-all placeholder:text-ivory-faint focus:border-saffron focus:shadow-[0_0_0_3px_var(--color-saffron-soft)]"
                />
                <button type="button" onClick={()=>setShowPw(s=>!s)} className="absolute right-1.5 top-1/2 grid h-8 w-8 -translate-y-1/2 place-items-center rounded-full text-ivory-faint transition-colors hover:bg-surface-2 hover:text-ivory">
                  {showPw ? <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg> : <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>}
                </button>
              </div>
            </div>

            <button type="submit" disabled={busy} className="inline-flex h-[44px] w-full items-center justify-center gap-2 rounded-lg bg-saffron text-[14px] font-semibold text-white shadow-[var(--shadow-1)] transition-all hover:bg-saffron-bright hover:shadow-[var(--shadow-2)] disabled:opacity-60">
              {busy ? <><svg className="animate-spin" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg> Signing in…</> : <>Sign in <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg></>}
            </button>

            <div className="flex items-center justify-between text-[11px] text-ivory-faint">
              <span className="flex items-center gap-1.5"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg> JWT · encrypted session</span>
              <span>Need help? contact devops</span>
            </div>
          </form>
        </div>

        {/* Footer */}
        <div className="mt-6 flex items-center justify-center gap-2 text-[11px] text-ivory-faint">
          <span className="h-px w-8 bg-border-soft" />
          © {new Date().getFullYear()} Hindustani Jyotish · Secure Admin v2
          <span className="h-px w-8 bg-border-soft" />
        </div>
      </div>
    </div>
  )
}
