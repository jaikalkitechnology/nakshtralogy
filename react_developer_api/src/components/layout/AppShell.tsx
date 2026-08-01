import { type ReactNode } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import {
  LayoutDashboard, KeyRound, CreditCard, Wallet, Activity, BookOpen, LogOut, Sparkles,
} from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/contexts/AuthContext";

const NAV_ITEMS = [
  { to: "/dashboard", label: "Overview", icon: LayoutDashboard },
  { to: "/keys", label: "API Keys", icon: KeyRound },
  { to: "/subscription", label: "Subscription", icon: CreditCard },
  { to: "/wallet", label: "Wallet", icon: Wallet },
  { to: "/usage", label: "Usage", icon: Activity },
  { to: "/docs", label: "API Docs & Playground", icon: BookOpen },
];

export default function AppShell({ children }: { children: ReactNode }) {
  const { developer, logout } = useAuth();
  const navigate = useNavigate();

  const isLowBalance = (developer?.wallet_balance ?? 0) < 500;
  const subExpiresAt = developer?.subscription?.expires_at ? new Date(developer.subscription.expires_at) : null;
  const daysToExpiry = subExpiresAt ? Math.ceil((subExpiresAt.getTime() - Date.now()) / 86400000) : null;

  return (
    <div className="min-h-screen bg-background text-foreground">
      <div className="flex min-h-screen">
        <aside className="hidden w-64 flex-col border-r border-border/60 bg-card/40 p-4 backdrop-blur md:flex">
          <div className="mb-8 flex items-center gap-2 px-2">
            <Sparkles className="h-6 w-6 text-primary" />
            <span className="font-semibold text-primary">Developer Portal</span>
          </div>
          <nav className="flex-1 space-y-1">
            {NAV_ITEMS.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm transition-all ${
                    isActive ? "bg-primary/10 font-medium text-primary" : "text-muted-foreground hover:bg-muted/50 hover:text-foreground"
                  }`
                }
              >
                <item.icon className="h-4 w-4" /> {item.label}
              </NavLink>
            ))}
          </nav>
          <Button
            variant="outline"
            className="mt-auto border-destructive/60 text-destructive"
            onClick={() => { logout(); navigate("/login"); }}
          >
            <LogOut className="mr-2 h-4 w-4" /> Logout
          </Button>
        </aside>

        <main className="flex-1 overflow-auto">
          <header className="flex flex-wrap items-center justify-between gap-2 border-b border-border/60 bg-card/20 px-4 py-3 backdrop-blur">
            <div>
              <p className="text-sm text-muted-foreground">Signed in as</p>
              <p className="font-medium">{developer?.profile?.company_name || developer?.name || developer?.email}</p>
            </div>
            <div className="flex items-center gap-2">
              {isLowBalance && (
                <Badge variant="outline" className="border-amber-500/40 text-amber-400">Low wallet balance</Badge>
              )}
              {daysToExpiry !== null && daysToExpiry <= 5 && (
                <Badge variant="outline" className="border-red-500/40 text-red-400">
                  Subscription expires in {Math.max(0, daysToExpiry)}d
                </Badge>
              )}
              <Badge className="bg-primary text-primary-foreground">₹{(developer?.wallet_balance ?? 0).toFixed(2)}</Badge>
            </div>
          </header>
          <div className="p-4 md:p-6">{children}</div>
        </main>
      </div>
    </div>
  );
}
