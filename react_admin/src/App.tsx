import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AuthProvider } from "@/contexts/AuthContext";
import Landing from "./pages/Landing";
import AuthPage from "./pages/AuthPage";
import UserDashboard from "./pages/UserDashboard";
import AstrologerDashboard from "./pages/AstrologerDashboard";
import AdminPanel from "./pages/AdminPanel";
import GoogleCallback from "./pages/GoogleCallback";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <AuthProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Landing />} />
            <Route path="/auth" element={<AuthPage />} />
            <Route path="/dashboard" element={<UserDashboard />} />
            <Route path="/astrologer" element={<AstrologerDashboard />} />
            <Route path="/admin" element={<AdminPanel />} />
            <Route path="/auth/google-success" element={<GoogleCallback />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </AuthProvider>
  </QueryClientProvider>
);

export default App;
