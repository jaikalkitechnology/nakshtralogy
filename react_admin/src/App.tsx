import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import { ThemeProvider } from "@/theme/ThemeProvider";
import AdminShell from "@/components/layout/AdminShell";
import AuthPage from "./pages/AuthPage";
import AdminPanel from "./pages/AdminPanel";
import DashboardOverview from "./pages/DashboardOverview";
import ComingSoon from "./pages/ComingSoon";
import NotFound from "./pages/NotFound";
import AdminFeatures from "./pages/admin/AdminFeatures";
import GoogleAuthSettings from "./pages/admin/GoogleAuthSettings";
import WebPushSettings from "./pages/admin/WebPushSettings";
import SystemMaintenance from "./pages/admin/SystemMaintenance";

const queryClient = new QueryClient();

function RequireAdmin({ children }: { children: JSX.Element }) {
  const { isAuthenticated, loading } = useAuth();
  if (loading) return <div className="grid min-h-screen place-items-center bg-background text-primary">Loading…</div>;
  if (!isAuthenticated) return <Navigate to="/auth" replace />;
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
              <Route path="/" element={<Navigate to="/admin/v2" replace />} />
              <Route path="/auth" element={<AuthPage />} />
              {/* New premium SaaS dashboard */}
              <Route path="/admin/v2" element={<RequireAdmin><AdminShell><DashboardOverview /></AdminShell></RequireAdmin>} />
              {/* Feature screens — migrated from the legacy AdminPanel into the premium shell.
                  Every handler / services/api.ts call is unchanged; only the chrome + routing changed. */}
              {[
                "users", "astrologers", "reviews", "kyc",
                "wallet", "transactions", "revenue",
                "pricing", "gifts", "api", "settings", "developers",
              ].map((seg) => (
                <Route
                  key={seg}
                  path={`/admin/v2/${seg}`}
                  element={<RequireAdmin><AdminShell><AdminFeatures /></AdminShell></RequireAdmin>}
                />
              ))}
              {/* Auth + Web Platform admin screens (Task 1.2 + 2.4) — standalone pages
                  writing to platform_settings via the existing admin settings API. */}
              <Route path="/admin/v2/google-auth" element={<RequireAdmin><AdminShell><GoogleAuthSettings /></AdminShell></RequireAdmin>} />
              <Route path="/admin/v2/web-push" element={<RequireAdmin><AdminShell><WebPushSettings /></AdminShell></RequireAdmin>} />
              <Route path="/admin/v2/system" element={<RequireAdmin><AdminShell><SystemMaintenance /></AdminShell></RequireAdmin>} />
              {/* Screens with no backend yet — clearly labelled "coming soon" rather than faked */}
              {["consultations", "notifications", "content", "audit-logs", "support-tickets", "analytics", "role-permissions"].map((seg) => (
                <Route
                  key={seg}
                  path={`/admin/v2/${seg}`}
                  element={<RequireAdmin><AdminShell><ComingSoon /></AdminShell></RequireAdmin>}
                />
              ))}
              <Route path="/admin/v2/*" element={<RequireAdmin><AdminShell><ComingSoon /></AdminShell></RequireAdmin>} />
              {/* Existing admin panel — preserved untouched, reachable from any "coming soon" screen */}
              <Route path="/admin" element={<AdminPanel />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </BrowserRouter>
        </TooltipProvider>
      </AuthProvider>
    </ThemeProvider>
  </QueryClientProvider>
);

export default App;
