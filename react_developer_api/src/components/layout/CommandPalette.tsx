import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import {
  LayoutDashboard, KeyRound, CreditCard, Wallet, Activity, BookOpen, Search,
} from "lucide-react";

const DESTINATIONS = [
  { to: "/dashboard", label: "Overview", icon: LayoutDashboard },
  { to: "/keys", label: "API Keys", icon: KeyRound },
  { to: "/docs", label: "Docs & Playground", icon: BookOpen },
  { to: "/subscription", label: "Subscription", icon: CreditCard },
  { to: "/wallet", label: "Wallet", icon: Wallet },
  { to: "/usage", label: "Usage & Analytics", icon: Activity },
];

/**
 * Lightweight ⌘K / Ctrl+K command palette (no `cmdk` dependency — this app
 * doesn't have it installed and there's no npm/network here to add it).
 * Jumps to any Developer Portal screen; filters as you type.
 */
export default function CommandPalette() {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
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

  useEffect(() => { if (!open) setQuery(""); }, [open]);

  const results = useMemo(
    () => DESTINATIONS.filter((d) => d.label.toLowerCase().includes(query.toLowerCase())),
    [query],
  );

  const go = (to: string) => {
    setOpen(false);
    navigate(to);
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="max-w-md overflow-hidden p-0">
        <div className="flex items-center gap-2 border-b border-border/60 px-3">
          <Search className="h-4 w-4 shrink-0 text-muted-foreground" />
          <Input
            autoFocus
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Search endpoints, keys, invoices…"
            className="h-11 border-0 shadow-none focus-visible:ring-0"
          />
        </div>
        <div className="max-h-[300px] overflow-y-auto p-2">
          {results.length === 0 && <p className="py-6 text-center text-sm text-muted-foreground">No results found.</p>}
          {results.map((d) => (
            <button
              key={d.to}
              onClick={() => go(d.to)}
              className="flex w-full items-center gap-2.5 rounded-lg px-2.5 py-2 text-left text-sm text-foreground hover:bg-muted/60"
            >
              <d.icon className="h-4 w-4 text-primary" />
              {d.label}
            </button>
          ))}
        </div>
      </DialogContent>
    </Dialog>
  );
}
