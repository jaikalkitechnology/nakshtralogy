import type { ReactNode } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { Toaster } from "sonner";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import { ThemeProvider } from "@/theme/ThemeProvider";
import DevShell from "@/components/layout/DevShell";
import LoginPage from "@/pages/LoginPage";
import SignupPage from "@/pages/SignupPage";
import DashboardPage from "@/pages/DashboardPage";
import ApiKeysPage from "@/pages/ApiKeysPage";
import SubscriptionPage from "@/pages/SubscriptionPage";
import WalletPage from "@/pages/WalletPage";
import UsagePage from "@/pages/UsagePage";
import DocsPlaygroundPage from "@/pages/DocsPlaygroundPage";

const queryClient = new QueryClient();

function ProtectedLayout({ children }: { children: ReactNode }) {
  const { isAuthenticated, loading } = useAuth();
  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <p className="text-primary">Loading...</p>
      </div>
    );
  }
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  return <DevShell>{children}</DevShell>;
}

const AppRoutes = () => (
  <Routes>
    <Route path="/login" element={<LoginPage />} />
    <Route path="/signup" element={<SignupPage />} />
    <Route path="/dashboard" element={<ProtectedLayout><DashboardPage /></ProtectedLayout>} />
    <Route path="/keys" element={<ProtectedLayout><ApiKeysPage /></ProtectedLayout>} />
    <Route path="/subscription" element={<ProtectedLayout><SubscriptionPage /></ProtectedLayout>} />
    <Route path="/wallet" element={<ProtectedLayout><WalletPage /></ProtectedLayout>} />
    <Route path="/usage" element={<ProtectedLayout><UsagePage /></ProtectedLayout>} />
    <Route path="/docs" element={<ProtectedLayout><DocsPlaygroundPage /></ProtectedLayout>} />
    <Route path="/" element={<Navigate to="/dashboard" replace />} />
    <Route path="*" element={<Navigate to="/dashboard" replace />} />
  </Routes>
);

const App = () => (
  <QueryClientProvider client={queryClient}>
    <ThemeProvider>
      <Toaster position="top-right" richColors />
      <BrowserRouter>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </BrowserRouter>
    </ThemeProvider>
  </QueryClientProvider>
);

export default App;
