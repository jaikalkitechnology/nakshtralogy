import { Component, type ErrorInfo, type ReactNode } from 'react'

/**
 * Catches render/lifecycle exceptions so ONE broken page can never white-screen
 * the whole console.
 *
 * This exists because it actually happened: the Google Login page read fields
 * a slightly older backend doesn't return, `undefined.trim()` threw, and React
 * unmounted the entire tree — the admin just saw a blank dark page with no
 * indication of what went wrong or even that anything had. A visible error
 * (with the message, so it can be screenshotted) is always better than
 * nothing, and the sidebar stays usable so other pages remain reachable.
 */
interface Props { children: ReactNode }
interface State { error: Error | null }

export default class ErrorBoundary extends Component<Props, State> {
  state: State = { error: null }

  static getDerivedStateFromError(error: Error): State {
    return { error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    // Keep the stack in the console for debugging alongside the on-screen copy.
    console.error('[admin] page crashed:', error, info.componentStack)
  }

  render() {
    const { error } = this.state
    if (!error) return this.props.children
    return (
      <div className="p-6">
        <div className="max-w-[640px] rounded-2xl border border-red-500/20 bg-red-500/10 p-6">
          <h2 className="text-[15px] font-bold text-red-300">This page failed to load</h2>
          <p className="mt-2 text-[12px] text-ivory-dim leading-relaxed">
            Something in this screen threw an error. The rest of the console still
            works — use the sidebar to continue. If this page is expected to work,
            the most common cause is the backend running an older version than the
            admin panel; redeploying the backend usually resolves it.
          </p>
          <pre className="mt-4 overflow-x-auto rounded-xl border border-border-soft bg-surface-1 p-3 font-mono text-[11px] text-red-300">
            {error.message || String(error)}
          </pre>
          <button
            type="button"
            onClick={() => this.setState({ error: null })}
            className="mt-4 rounded-xl bg-ivory px-4 py-2 text-[12px] font-bold text-bg-0"
          >
            Try again
          </button>
        </div>
      </div>
    )
  }
}
