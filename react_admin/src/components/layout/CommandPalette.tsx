import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  LayoutDashboard, Users, Star, MessageSquare, ShieldCheck, Wallet, CreditCard,
  Gift, Receipt, TrendingUp, Server, Code2, Bell, BarChart3, Settings,
  ScrollText, LifeBuoy, Lock, KeyRound, Construction,
} from "lucide-react";
import {
  CommandDialog, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList, CommandShortcut,
} from "@/components/ui/command";
import { useAuth } from "@/contexts/AuthContext";

const DESTINATIONS = [
  { to: "/admin", label: "Dashboard", icon: LayoutDashboard, group: "Navigate" },
  { to: "/admin/users", label: "Users", icon: Users, group: "People" },
  { to: "/admin/astrologers", label: "Astrologers", icon: Star, group: "People" },
  { to: "/admin/consultations", label: "Consultations", icon: MessageSquare, group: "People" },
  { to: "/admin/reviews", label: "Reviews", icon: Star, group: "People" },
  { to: "/admin/kyc", label: "KYC Verification", icon: ShieldCheck, group: "People" },
  { to: "/admin/wallet", label: "Wallet", icon: Wallet, group: "Finance" },
  { to: "/admin/pricing", label: "Pricing Plans", icon: CreditCard, group: "Finance" },
  { to: "/admin/gifts", label: "Gift Management", icon: Gift, group: "Finance" },
  { to: "/admin/transactions", label: "Transactions", icon: Receipt, group: "Finance" },
  { to: "/admin/revenue", label: "Revenue", icon: TrendingUp, group: "Finance" },
  { to: "/admin/api", label: "API Management", icon: Server, group: "Platform" },
  { to: "/admin/developers", label: "Developers", icon: Code2, group: "Platform" },
  { to: "/admin/notifications", label: "Notifications", icon: Bell, group: "Platform" },
  { to: "/admin/google-auth", label: "Google OAuth", icon: KeyRound, group: "Platform" },
  { to: "/admin/web-push", label: "Web Push", icon: Bell, group: "Platform" },
  { to: "/admin/system", label: "System & Maintenance", icon: Server, group: "Platform" },
  { to: "/admin/audit-logs", label: "Audit Logs", icon: ScrollText, group: "Platform" },
  { to: "/admin/support-tickets", label: "Support Tickets", icon: LifeBuoy, group: "Platform" },
  { to: "/admin/analytics", label: "Analytics", icon: BarChart3, group: "Platform" },
  { to: "/admin/role-permissions", label: "Role Permissions", icon: Lock, group: "Platform" },
  { to: "/admin/app-maintenance", label: "Maintenance Mode", icon: Construction, group: "Platform" },
  { to: "/admin/settings", label: "Settings", icon: Settings, group: "Platform" },
];

const GROUPS = ["Navigate", "People", "Finance", "Platform"];

/** Global ⌘K / Ctrl+K command palette — jumps to any admin screen. */
export default function CommandPalette() {
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();
  const { user } = useAuth();
  const destinations = user?.allowedPages
    ? DESTINATIONS.filter((d) => d.to === "/admin" || user.allowedPages!.includes(d.to))
    : DESTINATIONS;

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setOpen((v) => !v);
      }
    };
    const onOpenRequest = () => setOpen(true);
    document.addEventListener("keydown", onKeyDown);
    window.addEventListener("nakshtralogy:open-search", onOpenRequest);
    return () => {
      document.removeEventListener("keydown", onKeyDown);
      window.removeEventListener("nakshtralogy:open-search", onOpenRequest);
    };
  }, []);

  const go = (to: string) => {
    setOpen(false);
    navigate(to);
  };

  return (
    <CommandDialog open={open} onOpenChange={setOpen}>
      <CommandInput placeholder="Search users, transactions, astrologers, API keys, settings…" />
      <CommandList>
        <CommandEmpty>No results found.</CommandEmpty>
        {GROUPS.map((group) => (
          <CommandGroup key={group} heading={group}>
            {destinations.filter((d) => d.group === group).map((d) => (
              <CommandItem key={d.to} value={d.label} onSelect={() => go(d.to)}>
                <d.icon className="mr-2 h-4 w-4" />
                <span>{d.label}</span>
                {d.to === "/admin" && <CommandShortcut>⌘K</CommandShortcut>}
              </CommandItem>
            ))}
          </CommandGroup>
        ))}
      </CommandList>
    </CommandDialog>
  );
}
