import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  LayoutDashboard, Users, Star, MessageSquare, ShieldCheck, Wallet, CreditCard,
  Gift, Receipt, TrendingUp, Server, Code2, Bell, BarChart3, Settings,
  FolderKanban, ScrollText, LifeBuoy, Lock,
} from "lucide-react";
import {
  CommandDialog, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList, CommandShortcut,
} from "@/components/ui/command";

const DESTINATIONS = [
  { to: "/admin/v2", label: "Dashboard", icon: LayoutDashboard, group: "Navigate" },
  { to: "/admin/v2/users", label: "Users", icon: Users, group: "People" },
  { to: "/admin/v2/astrologers", label: "Astrologers", icon: Star, group: "People" },
  { to: "/admin/v2/consultations", label: "Consultations", icon: MessageSquare, group: "People" },
  { to: "/admin/v2/reviews", label: "Reviews", icon: Star, group: "People" },
  { to: "/admin/v2/kyc", label: "KYC Verification", icon: ShieldCheck, group: "People" },
  { to: "/admin/v2/wallet", label: "Wallet", icon: Wallet, group: "Finance" },
  { to: "/admin/v2/pricing", label: "Pricing Plans", icon: CreditCard, group: "Finance" },
  { to: "/admin/v2/gifts", label: "Gift Management", icon: Gift, group: "Finance" },
  { to: "/admin/v2/transactions", label: "Transactions", icon: Receipt, group: "Finance" },
  { to: "/admin/v2/revenue", label: "Revenue", icon: TrendingUp, group: "Finance" },
  { to: "/admin/v2/api", label: "API Management", icon: Server, group: "Platform" },
  { to: "/admin/v2/developers", label: "Developers", icon: Code2, group: "Platform" },
  { to: "/admin/v2/notifications", label: "Notifications", icon: Bell, group: "Platform" },
  { to: "/admin/v2/content", label: "Content Management", icon: FolderKanban, group: "Platform" },
  { to: "/admin/v2/audit-logs", label: "Audit Logs", icon: ScrollText, group: "Platform" },
  { to: "/admin/v2/support-tickets", label: "Support Tickets", icon: LifeBuoy, group: "Platform" },
  { to: "/admin/v2/analytics", label: "Analytics", icon: BarChart3, group: "Platform" },
  { to: "/admin/v2/role-permissions", label: "Role Permissions", icon: Lock, group: "Platform" },
  { to: "/admin/v2/settings", label: "Settings", icon: Settings, group: "Platform" },
];

const GROUPS = ["Navigate", "People", "Finance", "Platform"];

/** Global ⌘K / Ctrl+K command palette — jumps to any admin screen. */
export default function CommandPalette() {
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();

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
            {DESTINATIONS.filter((d) => d.group === group).map((d) => (
              <CommandItem key={d.to} value={d.label} onSelect={() => go(d.to)}>
                <d.icon className="mr-2 h-4 w-4" />
                <span>{d.label}</span>
                {d.to === "/admin/v2" && <CommandShortcut>⌘K</CommandShortcut>}
              </CommandItem>
            ))}
          </CommandGroup>
        ))}
      </CommandList>
    </CommandDialog>
  );
}
