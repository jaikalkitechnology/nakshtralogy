import { useState, useEffect, useRef, type ReactNode, type CSSProperties } from "react";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  LayoutDashboard, Users, Star, MessageSquare, ShieldCheck, Wallet, CreditCard,
  Gift, Receipt, TrendingUp, Server, Code2, Bell, BarChart3, Settings, LogOut,
  Search, Sun, Moon, RefreshCw, Plus, PanelLeftClose, PanelLeft, Menu, MessagesSquare,
  ScrollText, LifeBuoy, Lock, KeyRound, Image as ImageIcon, Bot, Mail, ShieldAlert, Ticket, Banknote, Crown,
  UserCog, Inbox,
} from "lucide-react";
import { cn } from "@/lib/utils";
import { useTheme } from "@/theme/ThemeProvider";
import { useAuth } from "@/contexts/AuthContext";
import { adminDashboardSummary } from "@/services/api";
import StarField from "@/components/StarField";
import CommandPalette from "@/components/layout/CommandPalette";

interface NavItem { to: string; label: string; icon: typeof LayoutDashboard; }
interface NavGroup { heading?: string; items: NavItem[]; }

export const NAV: NavGroup[] = [
  { items: [{ to: "/admin", label: "Dashboard", icon: LayoutDashboard }] },
  { heading: "PEOPLE", items: [
    { to: "/admin/users", label: "Users", icon: Users },
    { to: "/admin/astrologers", label: "Astrologers", icon: Star },
    { to: "/admin/consultations", label: "Consultations", icon: MessageSquare },
    { to: "/admin/reviews", label: "Reviews", icon: Star },
    { to: "/admin/kyc", label: "KYC Verification", icon: ShieldCheck },
  ]},
  { heading: "FINANCE", items: [
    { to: "/admin/wallet", label: "Wallet", icon: Wallet },
    { to: "/admin/pricing", label: "Pricing Plans", icon: CreditCard },
    { to: "/admin/gifts", label: "Gift Management", icon: Gift },
    { to: "/admin/transactions", label: "Transactions", icon: Receipt },
    { to: "/admin/revenue", label: "Revenue", icon: TrendingUp },
  ]},
  { heading: "PLATFORM", items: [
    { to: "/admin/api", label: "API Management", icon: Server },
    { to: "/admin/developers", label: "Developers", icon: Code2 },
    { to: "/admin/notifications", label: "Notifications", icon: Bell },
    { to: "/admin/google-auth", label: "Google OAuth", icon: KeyRound },
    { to: "/admin/web-push", label: "Web Push", icon: Bell },
    { to: "/admin/fcm-logs", label: "FCM Logs", icon: ScrollText },
    { to: "/admin/comm-logs", label: "Communication Logs", icon: MessagesSquare },
    { to: "/admin/faq", label: "FAQ Management", icon: LifeBuoy },
    { to: "/admin/banners", label: "Banner Management", icon: ImageIcon },
    { to: "/admin/ai-agents", label: "AI Chat Agents", icon: Bot },
    { to: "/admin/coupons", label: "Coupons & Discounts", icon: Ticket },
    { to: "/admin/subscriptions", label: "NakshtralogyPlus", icon: Crown },
    { to: "/admin/payment-gateways", label: "Payment Gateways", icon: CreditCard },
    { to: "/admin/payments", label: "Payments & Webhooks", icon: Receipt },
    { to: "/admin/withdrawals", label: "Astrologer Payouts", icon: Banknote },
    { to: "/admin/audit-logs", label: "Audit Logs", icon: ScrollText },
    { to: "/admin/support-tickets", label: "Support Tickets", icon: LifeBuoy },
    { to: "/admin/queries", label: "Query Support", icon: Mail },
    { to: "/admin/chat-guard", label: "Chat Guard", icon: ShieldAlert },
    { to: "/admin/analytics", label: "Analytics", icon: BarChart3 },
    { to: "/admin/role-permissions", label: "Role Permissions", icon: Lock },
    { to: "/admin/system", label: "System & Maintenance", icon: Server },
    { to: "/admin/settings", label: "Settings", icon: Settings },
  ]},
];

// Restrictable pages for the Role Permissions page's "Page Access" checklist
// — every page except Dashboard, which every admin can always reach as a
// safe landing page regardless of scoping.
export const PAGE_CATALOG: { heading: string; items: { to: string; label: string }[] }[] = NAV
  .filter((g): g is NavGroup & { heading: string } => !!g.heading)
  .map((g) => ({ heading: g.heading, items: g.items.map((it) => ({ to: it.to, label: it.label })) }));

function crumb(pathname: string) {
  const seg = pathname.replace("/admin", "").split("/").filter(Boolean);
  return seg.length ? seg[seg.length - 1].replace(/-/g, " ") : "Overview";
}

// Where each notification "kind" (from GET /admin/dashboard/summary) sends
// the admin when clicked, and which icon represents it.
const NOTIF_META: Record<string, { to: string; icon: typeof Bell }> = {
  astrologer_application: { to: "/admin/astrologers", icon: UserCog },
  withdrawal: { to: "/admin/withdrawals", icon: Banknote },
  support_ticket: { to: "/admin/support-tickets", icon: LifeBuoy },
};

// Compact "x min ago" from an ISO/`str(datetime)` timestamp (UTC).
function timeAgo(ts?: string | null): string {
  if (!ts) return "";
  const t = Date.parse(ts.replace(" ", "T") + (/[zZ]|[+-]\d\d:?\d\d$/.test(ts) ? "" : "Z"));
  if (isNaN(t)) return "";
  const secs = Math.max(0, Math.floor((Date.now() - t) / 1000));
  if (secs < 60) return "just now";
  const mins = Math.floor(secs / 60);
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  return `${Math.floor(hrs / 24)}d ago`;
}

export default function AdminShell({ children }: { children: ReactNode }) {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const { theme, toggle } = useTheme();
  const { user, logout } = useAuth();
  const loc = useLocation();
  const navigate = useNavigate();
  const width = collapsed ? 78 : 280;

  // Real admin alerts (pending astrologer applications, withdrawal
  // requests, support tickets) — same source as the Dashboard's "Alerts"
  // panel, so the bell badge and this panel never disagree with it.
  const [notifications, setNotifications] = useState<any[]>([]);
  const [notifOpen, setNotifOpen] = useState(false);
  const notifRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let alive = true;
    adminDashboardSummary()
      .then((r) => { if (alive) setNotifications((r?.data ?? r)?.notifications ?? []); })
      .catch(() => {});
    return () => { alive = false; };
  }, []);

  useEffect(() => {
    if (!notifOpen) return;
    const onOutside = (e: MouseEvent) => {
      if (notifRef.current && !notifRef.current.contains(e.target as Node)) setNotifOpen(false);
    };
    const onEscape = (e: KeyboardEvent) => { if (e.key === "Escape") setNotifOpen(false); };
    document.addEventListener("mousedown", onOutside);
    document.addEventListener("keydown", onEscape);
    return () => {
      document.removeEventListener("mousedown", onOutside);
      document.removeEventListener("keydown", onEscape);
    };
  }, [notifOpen]);

  // null allowedPages = every page visible (Super Admin default). A scoped
  // admin only sees Dashboard + whatever pages they were granted.
  const visibleNav = user?.allowedPages
    ? NAV
        .map((g) => ({ ...g, items: g.items.filter((it) => it.to === "/admin" || user.allowedPages!.includes(it.to)) }))
        .filter((g) => g.items.length > 0)
    : NAV;
  const isUnrestricted = !user?.permissions && !user?.allowedPages;

  const Sidebar = (
    <div className="flex h-full flex-col">
      {/* Logo (pinned top) */}
      <div className="flex flex-none items-center gap-3 px-4 py-5">
        <div className="grid h-10 w-10 flex-none place-items-center rounded-xl bg-gradient-to-br from-gold to-cosmic text-xl shadow-[0_0_22px_hsl(var(--gold)/0.4)]">✨</div>
        {!collapsed && <div><b className="text-[15px] font-extrabold text-foreground">Nakshtralogy</b><span className="block text-[11px] font-semibold text-muted-foreground">Admin Panel</span></div>}
      </div>

      {/* Nav (only this scrolls; invisible scrollbar) */}
      <nav className="no-scrollbar flex-1 overflow-y-auto px-3 py-1">
        {visibleNav.map((g, gi) => (
          <div key={gi}>
            {g.heading && !collapsed && <p className="px-3 pb-1.5 pt-3.5 text-[10px] font-bold tracking-[1.4px] text-muted-foreground/70">{g.heading}</p>}
            {g.heading && collapsed && gi > 0 && <div className="mx-auto my-2 h-px w-6 bg-border" />}
            {g.items.map((it) => (
              <NavLink
                key={it.to}
                to={it.to}
                end={it.to === "/admin"}
                onClick={() => setMobileOpen(false)}
                title={collapsed ? it.label : undefined}
                className={({ isActive }) =>
                  cn(
                    "mb-1 flex items-center gap-3 rounded-xl px-3 py-2.5 text-[13.5px] font-semibold transition-colors",
                    collapsed && "justify-center",
                    isActive
                      ? "bg-gradient-to-br from-gold to-gold-light text-primary-foreground active-glow"
                      : "text-muted-foreground hover:bg-cosmic/12 hover:text-foreground"
                  )
                }
              >
                <it.icon className="h-[17px] w-[17px] flex-none" />
                {!collapsed && <span className="truncate">{it.label}</span>}
              </NavLink>
            ))}
          </div>
        ))}
      </nav>

      {/* Profile / Logout (pinned bottom) */}
      <div className="flex-none border-t border-border/60 p-3">
        <div className={cn("flex items-center gap-2.5 rounded-xl bg-cosmic/10 p-2", collapsed && "justify-center")}>
          <div className="grid h-9 w-9 flex-none place-items-center rounded-full bg-gradient-to-br from-gold to-cosmic text-sm font-extrabold text-primary-foreground">
            {(user?.name || "A").slice(0, 1).toUpperCase()}
          </div>
          {!collapsed && <div className="min-w-0"><b className="block truncate text-[13px] text-foreground">{user?.name || "Admin"}</b><span className="text-[11px] text-muted-foreground">{isUnrestricted ? "Super Admin" : "Admin"}</span></div>}
        </div>
        <button
          onClick={logout}
          className={cn("mt-2 flex w-full items-center justify-center gap-2 rounded-xl border border-rose-500/40 py-2 text-[12.5px] font-semibold text-rose-400 transition-colors hover:bg-rose-500/10", collapsed && "px-0")}
        >
          <LogOut className="h-4 w-4" />{!collapsed && "Logout"}
        </button>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-background text-foreground">
      <StarField />
      <CommandPalette />

      {/* Desktop fixed sidebar */}
      <motion.aside
        animate={{ width }}
        transition={{ duration: 0.28, ease: "easeInOut" }}
        className="fixed left-0 top-0 z-30 hidden h-screen border-r border-border/60 bg-sidebar/90 backdrop-blur-xl md:block"
      >
        {Sidebar}
      </motion.aside>

      {/* Mobile off-canvas drawer + overlay */}
      <AnimatePresence>
        {mobileOpen && (
          <>
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
              onClick={() => setMobileOpen(false)} className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm md:hidden" />
            <motion.aside
              initial={{ x: -300 }} animate={{ x: 0 }} exit={{ x: -300 }} transition={{ duration: 0.28 }}
              drag="x" dragConstraints={{ left: -280, right: 0 }} dragElastic={0.05}
              onDragEnd={(_, info) => { if (info.offset.x < -70) setMobileOpen(false); }}
              className="fixed left-0 top-0 z-50 h-screen w-[280px] touch-pan-y border-r border-border/60 bg-sidebar md:hidden"
            >
              {Sidebar}
            </motion.aside>
          </>
        )}
      </AnimatePresence>

      {/* Main column — margin tracks the sidebar width on md+ only (mobile drawer is off-canvas) */}
      <div
        className="relative z-10 flex min-h-screen flex-col transition-[margin] duration-300 md:ml-[var(--sb)]"
        style={{ "--sb": `${width}px` } as CSSProperties}
      >
        {/* Sticky header */}
        <header className="sticky top-0 z-20 flex h-[66px] flex-none items-center gap-4 border-b border-border/60 bg-background/70 px-4 backdrop-blur-xl md:px-6">
          <button onClick={() => setMobileOpen(true)} aria-label="Open navigation menu" className="grid h-9 w-9 place-items-center rounded-lg text-muted-foreground md:hidden"><Menu className="h-5 w-5" /></button>
          <button onClick={() => setCollapsed((c) => !c)} className="hidden h-9 w-9 place-items-center rounded-lg text-muted-foreground hover:text-foreground md:grid" title="Collapse sidebar" aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}>
            {collapsed ? <PanelLeft className="h-[18px] w-[18px]" /> : <PanelLeftClose className="h-[18px] w-[18px]" />}
          </button>
          <div className="hidden text-[13px] font-semibold text-muted-foreground sm:block">Dashboard / <b className="capitalize text-foreground">{crumb(loc.pathname)}</b></div>

          <button
            onClick={() => window.dispatchEvent(new Event("nakshtralogy:open-search"))}
            title="Search (⌘K)"
            className="mx-auto hidden w-full max-w-md items-center gap-2.5 rounded-xl border border-border/70 bg-glass/40 px-3.5 py-2 text-left text-[13px] text-muted-foreground transition-colors hover:text-foreground lg:flex"
          >
            <Search className="h-[15px] w-[15px]" />
            <span className="truncate">Search users, transactions, astrologers, API keys…</span>
            <kbd className="ml-auto rounded bg-muted px-1.5 py-0.5 text-[10px]">⌘K</kbd>
          </button>

          <div className="ml-auto flex items-center gap-2.5">
            <div className="lg:hidden">
              <HeaderIcon onClick={() => window.dispatchEvent(new Event("nakshtralogy:open-search"))} title="Search (⌘K)">
                <Search className="h-[17px] w-[17px]" />
              </HeaderIcon>
            </div>
            <div ref={notifRef} className="relative">
              <HeaderIcon dot={notifications.length > 0} title="Notifications" onClick={() => setNotifOpen((v) => !v)}>
                <Bell className="h-[17px] w-[17px]" />
              </HeaderIcon>
              {notifOpen && (
                <div className="absolute right-0 top-11 z-30 w-80 max-w-[90vw] overflow-hidden rounded-xl border border-border/70 bg-card shadow-xl">
                  <div className="border-b border-border/60 px-3.5 py-2.5 text-[12.5px] font-bold text-foreground">Notifications</div>
                  <div className="max-h-80 overflow-y-auto">
                    {notifications.length === 0 ? (
                      <div className="flex flex-col items-center gap-1.5 py-8 text-muted-foreground">
                        <Inbox className="h-5 w-5" />
                        <p className="text-[12px]">Nothing needs attention.</p>
                      </div>
                    ) : (
                      notifications.map((n, i) => {
                        const meta = NOTIF_META[n.kind] || { to: "/admin", icon: Bell };
                        return (
                          <button
                            key={i}
                            onClick={() => { setNotifOpen(false); navigate(meta.to); }}
                            className="flex w-full items-start gap-2.5 border-b border-border/40 px-3.5 py-2.5 text-left last:border-0 hover:bg-muted/40"
                          >
                            <div className="mt-0.5 grid h-8 w-8 flex-none place-items-center rounded-lg bg-gold/10 text-gold">
                              <meta.icon className="h-4 w-4" />
                            </div>
                            <div className="min-w-0 flex-1">
                              <p className="truncate text-[12.5px] font-semibold text-foreground">{n.title}</p>
                              <p className="truncate text-[11.5px] text-muted-foreground">{n.meta}</p>
                            </div>
                            <span className="flex-none whitespace-nowrap text-[10.5px] text-muted-foreground">{timeAgo(n.created_at)}</span>
                          </button>
                        );
                      })
                    )}
                  </div>
                </div>
              )}
            </div>
            <HeaderIcon onClick={toggle} title={theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}>{theme === "dark" ? <Sun className="h-[17px] w-[17px]" /> : <Moon className="h-[17px] w-[17px]" />}</HeaderIcon>
            <HeaderIcon title="Refresh page data" onClick={() => window.location.reload()}><RefreshCw className="h-[17px] w-[17px]" /></HeaderIcon>
            <span className="hidden rounded-full border border-border/70 bg-gold/8 px-3 py-1.5 text-[11px] font-bold text-gold sm:inline">{isUnrestricted ? "SUPER ADMIN" : "ADMIN"}</span>
            <button title="Quick create" className="lift press flex items-center gap-1.5 rounded-xl bg-gradient-to-br from-gold to-gold-light px-3.5 py-2 text-[13px] font-extrabold text-primary-foreground shadow-[0_6px_18px_hsl(var(--gold)/0.3)]">
              <Plus className="h-[15px] w-[15px]" /><span className="hidden sm:inline">Create</span>
            </button>
          </div>
        </header>

        {/* Scrollable content (only this scrolls) — animated page transitions */}
        <main className="flex-1 p-4 md:p-6">
          <AnimatePresence mode="wait">
            <motion.div
              key={loc.pathname}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -8 }}
              transition={{ duration: 0.22, ease: "easeInOut" }}
            >
              {children}
            </motion.div>
          </AnimatePresence>
        </main>
      </div>

      {/* FAB */}
      <button title="Quick create" aria-label="Quick create" className="lift press fixed bottom-7 right-7 z-40 grid h-14 w-14 place-items-center rounded-[18px] bg-gradient-to-br from-gold to-gold-light text-primary-foreground shadow-[0_10px_30px_hsl(var(--gold)/0.45)]">
        <Plus className="h-6 w-6" />
      </button>
    </div>
  );
}

function HeaderIcon({ children, dot, onClick, title }: { children: ReactNode; dot?: boolean; onClick?: () => void; title?: string }) {
  return (
    <button onClick={onClick} title={title} aria-label={title} className="press relative grid h-9 w-9 place-items-center rounded-xl border border-border/70 bg-glass/40 text-muted-foreground transition-colors hover:text-foreground">
      {children}
      {dot && <span className="absolute right-2 top-2 h-1.5 w-1.5 rounded-full bg-rose-400 ring-2 ring-background" />}
    </button>
  );
}
