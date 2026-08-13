import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'
import ErrorBoundary from './ErrorBoundary'
import { useAuth } from '../auth/AuthContext'
import NotificationsBell from './NotificationsBell'
import ThemeSwitcher from './ThemeSwitcher'

interface NavItem { to: string; label: string; end?: boolean; icon: ReactNode; badge?: number }
interface NavGroup { heading: string; items: NavItem[] }

function I({ children }: { children: ReactNode }) {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      {children}
    </svg>
  )
}

const ICON = {
  dash: <I><rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/></I>,
  users: <I><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></I>,
  stars: <I><path d="M12 2l2.4 5.9L21 9.3l-5 4.8 1.2 6.9L12 17.8 6.8 21l1.2-6.9L3 9.3l6.6-1.4L12 2z"/></I>,
  charges: <I><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></I>,
  award: <I><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89L17 22l-5-3-5 3 1.523-9.11"/></I>,
  check: <I><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></I>,
  list: <I><path d="M8 6h13M8 12h13M8 18h13"/><path d="M3 6h.01M3 12h.01M3 18h.01"/></I>,
  wallet: <I><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M16 14a2 2 0 0 0 0 4h4v-4h-4z"/></I>,
  book: <I><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></I>,
  payout: <I><circle cx="12" cy="12" r="10"/><path d="M16 8h-6a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h6"/><path d="M12 8v8"/></I>,
  refund: <I><path d="M9 14L4 9l5-5"/><path d="M4 9h10.5A2.5 2.5 0 0 1 17 11.5v7.5"/><path d="M20 9v2"/><path d="M20 14v2"/><path d="M20 19v2"/></I>,
  video: <I><path d="M16 16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12z"/><path d="M18 9l4-2v10l-4-2"/></I>,
  chat: <I><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></I>,
  star: <I><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></I>,
  tag: <I><path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4"/><path d="M4 6a2 2 0 0 0-2 2c0 1.1.9 2 2 2h12v-4H4z"/><path d="M20 12a2 2 0 0 1-2 2H6a2 2 0 0 0-2 2c0 1.1.9 2 2 2h12v-4"/></I>,
  image: <I><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></I>,
  sparkles: <I><path d="M12 3l1.9 4.1L18 9l-4.1 1.9L12 15l-1.9-4.1L6 9l4.1-1.9L12 3z"/><path d="M19 13l1 2 2 1-2 1-1 2-1-2-2-1 2-1 1-2z"/><path d="M5 14l1 2 2 1-2 1-1 2-1-2-2-1 2-1 1-2z"/></I>,
  gift: <I><rect x="3" y="8" width="18" height="14" rx="1"/><path d="M12 8v14"/><path d="M19 8v-2a3 3 0 0 0-3-3H8a3 3 0 0 0-3 3v2"/><path d="M3 12h18"/></I>,
  clapper: <I><rect x="2" y="2" width="20" height="20" rx="2.15"/><path d="M7 2v5"/><path d="M17 2v5"/><path d="M2 12h20"/><path d="M2 7h5"/><path d="M2 17h5"/><path d="M17 12h5"/><path d="M17 17h5"/></I>,
  globe: <I><circle cx="12" cy="12" r="10"/><path d="M2 12h20"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></I>,
  mic: <I><path d="M12 2a3 3 0 0 0-3 3v6a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2"/><line x1="12" x2="12" y1="19" y2="22"/></I>,
  key: <I><circle cx="7.5" cy="7.5" r="5.5"/><path d="M21 2l-9.6 9.6"/><path d="M15.5 7.5h.01"/></I>,
  shield: <I><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></I>,
  phone: <I><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></I>,
  percent: <I><line x1="19" y1="5" x2="5" y2="19"/><circle cx="6.5" cy="6.5" r="2.5"/><circle cx="17.5" cy="17.5" r="2.5"/></I>,
  wrench: <I><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></I>,
  flame: <I><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></I>,
  menu: <I><line x1="4" y1="6" x2="20" y2="6"/><line x1="4" y1="12" x2="20" y2="12"/><line x1="4" y1="18" x2="20" y2="18"/></I>,
  bell: <I><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></I>,
  search: <I><circle cx="11" cy="11" r="7"/><path d="m21 21-3.5-3.5"/></I>,
  close: <I><path d="M18 6L6 18"/><path d="M6 6l12 12"/></I>,
  logout: <I><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></I>,
  chevron: <I><polyline points="15 18 9 12 15 6"/></I>,
  pencil: <I><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/></I>,
  collapse: <I><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M9 3v18"/><path d="M14 9l-3 3 3 3"/></I>,
  login: <I><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></I>,
  creds: <I><rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M5.5 16.5c.6-1.4 1.9-2.1 3.5-2.1s2.9.7 3.5 2.1"/><path d="M15 9h4"/><path d="M15 13h4"/></I>,
}

const NAV_GROUPS: NavGroup[] = [
  { heading: 'Overview', items: [{ to: '/', label: 'Dashboard', end: true, icon: ICON.dash }] },
  {
    heading: 'Users',
    items: [
      { to: '/customers', label: 'Customers', icon: ICON.users },
      { to: '/deleted-accounts', label: 'Deleted Accounts', icon: ICON.refund },
    ],
  },
  {
    heading: 'Astrologers',
    items: [
      { to: '/astrologers', label: 'All Astrologers', icon: ICON.stars },
      { to: '/charges', label: 'Pricing', icon: ICON.charges },
      { to: '/top', label: 'Top Rated', icon: ICON.award },
      { to: '/approval', label: 'KYC Queue', icon: ICON.check },
      { to: '/approval-status', label: 'KYC Status', icon: ICON.list },
      { to: '/profile-edits', label: 'Profile Edits', icon: ICON.pencil },
    ],
  },
  {
    heading: 'Finance',
    items: [
      { to: '/wallet', label: 'Wallet Overview', icon: ICON.wallet },
      { to: '/wallet-transactions', label: 'Transactions', icon: ICON.book },
      { to: '/wallet-ledger', label: 'Ledger', icon: ICON.book },
      { to: '/payouts', label: 'Payouts', icon: ICON.payout },
      { to: '/refunds', label: 'Refunds', icon: ICON.refund },
      { to: '/invoices', label: 'GST Invoices', icon: ICON.book },
      { to: '/tds', label: 'TDS & Challan', icon: ICON.book },
    ],
  },
  {
    heading: 'Sessions',
    items: [
      { to: '/sessions', label: 'Sessions', icon: ICON.video },
      { to: '/chat-rooms', label: 'Chat Rooms', icon: ICON.chat },
      { to: '/reviews', label: 'Reviews', icon: ICON.star },
      { to: '/broadcast', label: 'Broadcast', icon: ICON.bell },
    ],
  },
  {
    heading: 'Content',
    items: [
      { to: '/coupons', label: 'Coupons', icon: ICON.tag },
      { to: '/banners', label: 'Banners', icon: ICON.image },
      { to: '/cosmic-services', label: 'Cosmic Services', icon: ICON.sparkles },
      { to: '/live-gifts', label: 'Live Gifts', icon: ICON.gift },
      { to: '/promo-videos', label: 'Promo Videos', icon: ICON.clapper },
      { to: '/astrologer-videos', label: 'Astro Videos', icon: ICON.clapper },
    ],
  },
  {
    heading: 'Settings',
    items: [
      { to: '/credentials', label: 'Credentials', icon: ICON.creds },
      { to: '/social-links', label: 'Social Links', icon: ICON.globe },
      { to: '/privacy-policy', label: 'Privacy Policy', icon: ICON.shield },
      { to: '/support-contact', label: 'Helpline & Support', icon: ICON.phone },
      { to: '/agora', label: 'Agora', icon: ICON.mic },
      { to: '/razorpay', label: 'Razorpay', icon: ICON.key },
      { to: '/commission', label: 'Commission', icon: ICON.percent },
      { to: '/gst-settings', label: 'GST', icon: ICON.percent },
      { to: '/maintenance', label: 'Maintenance', icon: ICON.wrench },
      { to: '/schema-sync', label: 'Schema Sync', icon: ICON.collapse },
      { to: '/firebase-config', label: 'Firebase', icon: ICON.flame },
      { to: '/google-login', label: 'Google Login', icon: ICON.login },
    ],
  },
]

function useActiveLabel() {
  const { pathname } = useLocation()
  for (const g of NAV_GROUPS) for (const i of g.items) if (i.end ? pathname===i.to : pathname.startsWith(i.to)) return { label: i.label, group: g.heading }
  return { label: 'Dashboard', group: 'Overview' }
}

export default function Layout() {
  const { admin, logout } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [collapsed, setCollapsed] = useState<boolean>(() => {
    try { return localStorage.getItem('hj_sidebar_collapsed') === '1' } catch { return false }
  })
  const [query, setQuery] = useState('')
  const [userMenu, setUserMenu] = useState(false)
  const searchRef = useRef<HTMLInputElement>(null)
  const userMenuRef = useRef<HTMLDivElement>(null)
  const topSearchRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key==='/' && !/^(INPUT|TEXTAREA|SELECT)$/i.test((e.target as HTMLElement)?.tagName)) { e.preventDefault(); (window.innerWidth >= 1024 ? topSearchRef : searchRef).current?.focus() }
      if (e.key==='Escape') { setDrawerOpen(false); setUserMenu(false) }
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase()==='k') { e.preventDefault(); searchRef.current?.focus() }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [])

  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => { setDrawerOpen(false); setUserMenu(false) }, [location.pathname])
  useEffect(() => { document.body.style.overflow = drawerOpen ? 'hidden' : ''; return () => { document.body.style.overflow='' } }, [drawerOpen])
  useEffect(() => {
    const handler = (e: MouseEvent) => { if (userMenuRef.current && !userMenuRef.current.contains(e.target as Node)) setUserMenu(false) }
    document.addEventListener('mousedown', handler); return () => document.removeEventListener('mousedown', handler)
  }, [])
  useEffect(() => { try { localStorage.setItem('hj_sidebar_collapsed', collapsed ? '1' : '0') } catch { /* storage unavailable */ } }, [collapsed])

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return NAV_GROUPS
    return NAV_GROUPS.map(g=>({...g, items: g.items.filter(i=>i.label.toLowerCase().includes(q) || g.heading.toLowerCase().includes(q))})).filter(g=>g.items.length>0)
  }, [query])

  const initials = (admin?.name||admin?.email||'A').split(/[\s@._-]+/).filter(Boolean).slice(0,2).map(w=>w[0].toUpperCase()).join('')||'A'
  const { label: activeLabel, group: activeGroup } = useActiveLabel()

  const sidebarWidth = collapsed ? 'lg:w-[78px]' : 'lg:w-[294px]'
  const mainPadding = collapsed ? 'lg:pl-[78px]' : 'lg:pl-[294px]'

  return (
    <div className="min-h-screen bg-bg-0 text-ivory selection:bg-saffron-soft antialiased">
      {/* Mobile scrim */}
      {drawerOpen && <div className="fixed inset-0 z-40 bg-slate-900/40 lg:hidden animate-fade-in" onClick={()=>setDrawerOpen(false)} />}

      {/* Sidebar - desktop & mobile. Always dark slate for contrast against the light canvas. */}
      <aside className={`fixed inset-y-0 left-0 z-50 flex w-[300px] flex-col border-r border-sidebar-border bg-sidebar text-sidebar-text ${sidebarWidth} transition-all duration-300 ease-[cubic-bezier(.32,.72,0,1)] ${drawerOpen ? 'translate-x-0 shadow-[16px_0_48px_rgba(15,23,42,0.35)]' : '-translate-x-full lg:translate-x-0'} `}>
        {/* Brand */}
        <div className="relative z-10 flex h-[60px] items-center gap-3 border-b border-sidebar-border px-4 shrink-0">
          <div className="flex items-center gap-3 min-w-0 flex-1">
            <img
              src="/logo.png"
              alt="Hindustani Jyotish"
              className="h-9 w-9 shrink-0 rounded-lg object-cover"
            />
            {!collapsed && (
              <div className="min-w-0">
                <div className="flex items-center gap-1.5 text-white">
                  <span className="text-[15px] font-bold tracking-tight leading-none">Hindustani</span>
                  <div className="text-[15px] font-bold tracking-tight leading-none">Jyotish</div>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Search in sidebar */}
        {!collapsed && (
          <div className="relative z-10 px-3 py-3">
            <div className="relative group">
              <input
                ref={searchRef}
                value={query}
                onChange={e=>setQuery(e.target.value)}
                placeholder="Search pages… ⌘K"
                className="h-[36px] w-full rounded-lg border border-white/10 bg-white/5 pl-4 pr-10 text-[13px] text-sidebar-text placeholder:text-sidebar-muted focus:border-saffron/50 focus:bg-white/10 outline-none transition-all"
              />
              {query && <button onClick={()=>setQuery('')} className="absolute right-2 top-1/2 -translate-y-1/2 grid h-6 w-6 place-items-center rounded-md bg-white/10 text-sidebar-muted hover:text-white">{ICON.close}</button>}
            </div>
          </div>
        )}

        {/* Collapsed search icon */}
        {collapsed && (
          <div className="relative z-10 p-3 hidden lg:block">
            <button onClick={()=>setCollapsed(false)} className="grid h-10 w-10 place-items-center rounded-lg bg-white/5 border border-white/10 text-sidebar-muted hover:text-white hover:border-white/20 transition-colors">
              {ICON.search}
            </button>
          </div>
        )}

        {/* Navigation */}
        <nav className="relative z-10 flex-1 overflow-y-auto px-2.5 pb-3 [scrollbar-width:thin] scrollbar-thin">
          {filtered.length===0 && !collapsed && <div className="px-3 py-10 text-center text-[13px] text-sidebar-muted">No results for “{query}”</div>}
          <div className="flex flex-col gap-5 py-1">
            {filtered.map(group=>(
              <div key={group.heading}>
                {!collapsed && <div className="mb-1.5 px-3 text-[10px] font-bold uppercase tracking-[0.14em] text-sidebar-heading">{group.heading}</div>}
                {collapsed && <div className="mx-3 my-2 h-px bg-white/10 hidden lg:block" />}
                <div className="flex flex-col gap-0.5">
                  {group.items.map(item=>(
                    <NavLink
                      key={item.to}
                      to={item.to}
                      end={item.end}
                      title={collapsed ? item.label : undefined}
                      className={({isActive})=>
                        `group relative flex items-center gap-3 rounded-lg px-3 py-2 text-[13px] font-medium no-underline hover:no-underline transition-colors ${
                          isActive
                            ? 'bg-saffron/15 text-white'
                            : 'text-sidebar-muted hover:bg-white/5 hover:text-white'
                        } ${collapsed ? 'lg:justify-center lg:px-2' : ''}`
                      }
                    >
                      {({isActive})=>(
                        <>
                          {isActive && !collapsed && <span className="absolute left-0 top-1/2 h-[18px] w-[3px] -translate-y-1/2 rounded-full bg-saffron" />}
                          <span className={`shrink-0 transition-colors ${isActive?'text-saffron':''}`}>{item.icon}</span>
                          {!collapsed && <span className="truncate">{item.label}</span>}
                          {/* Tooltip for collapsed */}
                          {collapsed && (
                            <span className="pointer-events-none absolute left-[calc(100%+12px)] top-1/2 hidden -translate-y-1/2 whitespace-nowrap rounded-lg border border-white/10 bg-sidebar-raised px-3 py-1.5 text-[12px] font-medium text-white shadow-xl lg:group-hover:block z-50">
                              {item.label}
                            </span>
                          )}
                        </>
                      )}
                    </NavLink>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </nav>

        {/* User footer */}
        <div className="relative z-10 border-t border-sidebar-border p-2.5">
          {!collapsed ? (
            <div className="flex items-center gap-3 rounded-lg bg-white/5 border border-white/10 p-2.5">
              <div className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-saffron text-[13px] font-bold text-white">{initials}</div>
              <div className="min-w-0 flex-1">
                <div className="truncate text-[12.5px] font-semibold leading-tight text-white">{admin?.name || admin?.email?.split('@')[0] || 'Admin'}</div>
                <div className="truncate text-[11px] text-sidebar-muted">{admin?.email}</div>
              </div>
              <button onClick={()=>{logout(); navigate('/login')}} className="grid h-8 w-8 place-items-center rounded-lg bg-white/5 border border-white/10 text-sidebar-muted hover:text-white hover:border-white/20 transition-colors" title="Sign out">{ICON.logout}</button>
            </div>
          ) : (
            <div className="hidden lg:flex flex-col items-center gap-2">
              <div className="grid h-9 w-9 place-items-center rounded-lg bg-saffron text-[13px] font-bold text-white">{initials}</div>
              <button onClick={()=>{logout(); navigate('/login')}} className="grid h-8 w-8 place-items-center rounded-lg bg-white/5 border border-white/10 text-sidebar-muted hover:text-white" title="Sign out">{ICON.logout}</button>
            </div>
          )}
        </div>
      </aside>

      {/* Main */}
      <div className={`transition-all duration-300 ${mainPadding}`}>
        {/* Topbar */}
        <header className="sticky top-0 z-30 flex h-[56px] items-center gap-3 border-b border-border-soft bg-bg-1 px-4 lg:px-6">
          <button onClick={()=>setDrawerOpen(true)} className="grid h-9 w-9 place-items-center rounded-lg bg-surface-1 border border-border-soft text-ivory-dim hover:text-ivory lg:hidden">{ICON.menu}</button>

          <div className="hidden lg:flex items-center gap-3 min-w-0 flex-1">
            <button onClick={()=>setCollapsed(v=>!v)} className="grid h-9 w-9 place-items-center rounded-lg bg-surface-1 border border-border-soft text-ivory-faint hover:text-ivory hover:border-border-mid lg:hidden xl:grid">
              {collapsed ? <span className="rotate-180">{ICON.chevron}</span> : ICON.collapse}
            </button>
            <div className="h-5 w-px bg-border-soft hidden xl:block" />
            <div className="min-w-0">
              <div className="flex items-center gap-2 text-[12px]">
                <span className="text-ivory-faint">{activeGroup}</span>
                <span className="text-ivory-faint/50">/</span>
                <span className="font-semibold text-ivory">{activeLabel}</span>
              </div>
              <div className="hidden lg:flex items-center gap-2 text-[11px] text-ivory-faint mt-0.5">
                <span className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse" />
                {new Date().toLocaleDateString('en-IN',{weekday:'short', day:'numeric', month:'short', year:'numeric'})}
              </div>
            </div>
          </div>

          {/* Mobile title */}
          <div className="lg:hidden min-w-0 flex-1">
            <div className="text-[11px] font-bold uppercase tracking-widest text-ivory-faint">{activeGroup}</div>
            <h1 className="text-[15px] font-semibold leading-none tracking-tight truncate">{activeLabel}</h1>
          </div>

          <div className="ml-auto flex items-center gap-1.5 sm:gap-2">
            {/* Global search - desktop */}


            <div className="hidden sm:flex items-center gap-1 rounded-lg border border-border-soft bg-surface-1 p-1">
              <ThemeSwitcher />
              <div className="h-5 w-px bg-border-soft" />
              <NotificationsBell />
            </div>

            <div className="flex sm:hidden items-center gap-1">
              <ThemeSwitcher />
              <NotificationsBell />
            </div>

            <div className="relative" ref={userMenuRef}>
              <button onClick={()=>setUserMenu(v=>!v)} className="group flex items-center gap-2 rounded-full border border-border-soft bg-surface-1 pl-1 pr-1 lg:pr-3 py-1 hover:border-border-mid transition-colors">
                <span className="grid h-8 w-8 place-items-center rounded-full bg-saffron text-[12px] font-bold text-white">{initials}</span>
                <span className="hidden lg:block text-left leading-tight">
                  <span className="block text-[12px] font-semibold truncate max-w-[120px]">{admin?.name || admin?.email?.split('@')[0]}</span>
                  <span className="block text-[10px] text-ivory-faint">Admin</span>
                </span>
                <span className="hidden lg:grid h-5 w-5 place-items-center rounded-full bg-surface-2 text-ivory-faint group-hover:text-ivory ml-1">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M6 9l6 6 6-6"/></svg>
                </span>
              </button>
              {userMenu && (
                <div className="absolute right-0 top-[calc(100%+10px)] w-[300px] overflow-hidden rounded-xl border border-border-soft bg-surface-raised shadow-[var(--shadow-3)] animate-pop-in z-50">
                  <div className="p-5">
                    <div className="flex items-center gap-3">
                      <div className="grid h-11 w-11 place-items-center rounded-lg bg-saffron text-[14px] font-bold text-white">{initials}</div>
                      <div className="min-w-0">
                        <div className="text-[14px] font-semibold truncate">{admin?.name || 'Administrator'}</div>
                        <div className="mt-0.5 truncate text-[12px] text-ivory-dim">{admin?.email}</div>
                        <div className="mt-2 inline-flex items-center gap-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide text-emerald-400">
                          <span className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse" /> Active session
                        </div>
                      </div>
                    </div>
                  </div>
                  <div className="p-2 border-t border-border-soft">
                    <button onClick={()=>{setUserMenu(false); navigate('/')}} className="flex w-full items-center gap-2.5 rounded-lg px-3 py-2.5 text-[13px] font-medium text-ivory-dim hover:bg-surface-1 hover:text-ivory transition-colors">
                      {ICON.dash} Dashboard
                    </button>
                    <button onClick={()=>{logout(); navigate('/login')}} className="flex w-full items-center gap-2.5 rounded-lg px-3 py-2.5 text-[13px] font-medium text-red-400 hover:bg-red-500/10 transition-colors">
                      {ICON.logout} Sign out
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </header>

        {/* Page content */}
        <main className="mx-auto w-full max-w-[1500px] px-4 py-5 sm:px-6 sm:py-7 lg:px-8">
          <div className="animate-fade-in">
            {/* Keyed by path so navigating away from a crashed page clears the
                error instead of leaving it stuck on every subsequent screen. */}
            <ErrorBoundary key={location.pathname}>
              <Outlet />
            </ErrorBoundary>
          </div>
        </main>

        {/* Footer quick */}
        <footer className="mx-auto max-w-[1500px] px-4 sm:px-6 lg:px-8 pb-8 pt-2">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-2 rounded-xl border border-border-soft bg-surface-raised px-4 py-3 text-[11px] text-ivory-faint">
            <span className="flex items-center gap-2"><span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" /> System operational · All services running</span>
            <span>© {new Date().getFullYear()} Hindustani Jyotish</span>
          </div>
        </footer>
      </div>
    </div>
  )
}
