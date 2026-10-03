import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Navigate, Route, Routes, useLocation } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import { ThemeProvider } from "@/theme/ThemeProvider";
import AdminShell from "@/components/layout/AdminShell";
import AuthPage from "./pages/AuthPage";
import DashboardOverview from "./pages/DashboardOverview";
import ComingSoon from "./pages/ComingSoon";
import NotFound from "./pages/NotFound";
import AdminFeatures from "./pages/admin/AdminFeatures";
import GoogleAuthSettings from "./pages/admin/GoogleAuthSettings";
import WebPushSettings from "./pages/admin/WebPushSettings";
import SystemMaintenance from "./pages/admin/SystemMaintenance";
import FcmLogs from "./pages/admin/FcmLogs";
import NotificationsManager from "./pages/admin/NotificationsManager";
import CommunicationLogs from "./pages/admin/CommunicationLogs";
import FaqManager from "./pages/admin/FaqManager";
import SupportTickets from "./pages/admin/SupportTickets";
import BannerManager from "./pages/admin/BannerManager";
import AiAgentsManager from "./pages/admin/AiAgentsManager";
import ContactQueries from "./pages/admin/ContactQueries";
import ChatGuard from "./pages/admin/ChatGuard";
import CouponManager from "./pages/admin/CouponManager";
import PaymentGateways from "./pages/admin/PaymentGateways";
import Payments from "./pages/admin/Payments";
import Withdrawals from "./pages/admin/Withdrawals";
import Subscriptions from "./pages/admin/Subscriptions";
import Consultations from "./pages/admin/Consultations";
import KundliData from "./pages/admin/KundliData";
import Reviews from "./pages/admin/Reviews";
import Analytics from "./pages/admin/Analytics";
import AuditLogs from "./pages/admin/AuditLogs";
import RolePermissions from "./pages/admin/RolePermissions";
import Maintenance from "./pages/admin/Maintenance";

const queryClient = new QueryClient();

function RequireAdmin({ children }: { children: JSX.Element }) {
  const { isAuthenticated, loading, user } = useAuth();
  const location = useLocation();
  if (loading) return <div className="grid min-h-screen place-items-center bg-background text-primary">Loading…</div>;
  if (!isAuthenticated) return <Navigate to="/auth" replace />;
  // Page-level scoping for a restricted sub-admin (independent of the
  // action-level `permissions` they hold) — redirect away from any page not
  // in their allowed list. Dashboard is always reachable as a safe landing
  // page regardless of scoping.
  if (user?.allowedPages && location.pathname !== "/admin" && !user.allowedPages.includes(location.pathname)) {
    return <Navigate to="/admin" replace />;
  }
  return children;
}

const App = () => (
  <QueryClientProvider client={queryClient}>
    <ThemeProvider>
      <AuthProvider>
        <TooltipProvider>
          <Toaster />
          <Sonner />
          <BrowserRouter>
            <Routes>
              <Route path="/" element={<Navigate to="/admin" replace />} />
              <Route path="/auth" element={<AuthPage />} />
              {/* New premium SaaS dashboard */}
              <Route path="/admin" element={<RequireAdmin><AdminShell><DashboardOverview /></AdminShell></RequireAdmin>} />
              {/* Feature screens — the premium admin lives at /admin (the old /admin panel was removed).
                  Every handler / services/api.ts call is unchanged; only the chrome + routing changed. */}
              {[
                "users", "astrologers", "reviews", "kyc",
                "wallet", "transactions", "revenue",
                "pricing", "gifts", "api", "settings", "developers",
              ].map((seg) => (
                <Route
                  key={seg}
                  path={`/admin/${seg}`}
                  element={<RequireAdmin><AdminShell><AdminFeatures /></AdminShell></RequireAdmin>}
                />
              ))}
              {/* Auth + Web Platform admin screens (Task 1.2 + 2.4) — standalone pages
                  writing to platform_settings via the existing admin settings API. */}
              <Route path="/admin/google-auth" element={<RequireAdmin><AdminShell><GoogleAuthSettings /></AdminShell></RequireAdmin>} />
              <Route path="/admin/web-push" element={<RequireAdmin><AdminShell><WebPushSettings /></AdminShell></RequireAdmin>} />
              <Route path="/admin/fcm-logs" element={<RequireAdmin><AdminShell><FcmLogs /></AdminShell></RequireAdmin>} />
              <Route path="/admin/comm-logs" element={<RequireAdmin><AdminShell><CommunicationLogs /></AdminShell></RequireAdmin>} />
              <Route path="/admin/faq" element={<RequireAdmin><AdminShell><FaqManager /></AdminShell></RequireAdmin>} />
              <Route path="/admin/support-tickets" element={<RequireAdmin><AdminShell><SupportTickets /></AdminShell></RequireAdmin>} />
              <Route path="/admin/banners" element={<RequireAdmin><AdminShell><BannerManager /></AdminShell></RequireAdmin>} />
              <Route path="/admin/ai-agents" element={<RequireAdmin><AdminShell><AiAgentsManager /></AdminShell></RequireAdmin>} />
              <Route path="/admin/queries" element={<RequireAdmin><AdminShell><ContactQueries /></AdminShell></RequireAdmin>} />
              <Route path="/admin/chat-guard" element={<RequireAdmin><AdminShell><ChatGuard /></AdminShell></RequireAdmin>} />
              <Route path="/admin/coupons" element={<RequireAdmin><AdminShell><CouponManager /></AdminShell></RequireAdmin>} />
              <Route path="/admin/payment-gateways" element={<RequireAdmin><AdminShell><PaymentGateways /></AdminShell></RequireAdmin>} />
              <Route path="/admin/payments" element={<RequireAdmin><AdminShell><Payments /></AdminShell></RequireAdmin>} />
              <Route path="/admin/withdrawals" element={<RequireAdmin><AdminShell><Withdrawals /></AdminShell></RequireAdmin>} />
              <Route path="/admin/subscriptions" element={<RequireAdmin><AdminShell><Subscriptions /></AdminShell></RequireAdmin>} />
              <Route path="/admin/notifications" element={<RequireAdmin><AdminShell><NotificationsManager /></AdminShell></RequireAdmin>} />
              <Route path="/admin/system" element={<RequireAdmin><AdminShell><SystemMaintenance /></AdminShell></RequireAdmin>} />
              <Route path="/admin/consultations" element={<RequireAdmin><AdminShell><Consultations /></AdminShell></RequireAdmin>} />
              <Route path="/admin/kundli-data" element={<RequireAdmin><AdminShell><KundliData /></AdminShell></RequireAdmin>} />
              <Route path="/admin/reviews" element={<RequireAdmin><AdminShell><Reviews /></AdminShell></RequireAdmin>} />
              <Route path="/admin/analytics" element={<RequireAdmin><AdminShell><Analytics /></AdminShell></RequireAdmin>} />
              <Route path="/admin/audit-logs" element={<RequireAdmin><AdminShell><AuditLogs /></AdminShell></RequireAdmin>} />
              <Route path="/admin/role-permissions" element={<RequireAdmin><AdminShell><RolePermissions /></AdminShell></RequireAdmin>} />
              <Route path="/admin/app-maintenance" element={<RequireAdmin><AdminShell><Maintenance /></AdminShell></RequireAdmin>} />
              <Route path="/admin/*" element={<RequireAdmin><AdminShell><ComingSoon /></AdminShell></RequireAdmin>} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </BrowserRouter>
        </TooltipProvider>
      </AuthProvider>
    </ThemeProvider>
  </QueryClientProvider>
);

export default App;
