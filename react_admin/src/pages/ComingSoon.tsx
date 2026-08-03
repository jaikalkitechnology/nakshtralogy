import { Sparkles } from "lucide-react";
import { useLocation, useNavigate } from "react-router-dom";
import EmptyState from "@/components/premium/EmptyState";

export default function ComingSoon() {
  const loc = useLocation();
  const navigate = useNavigate();
  const name = loc.pathname.split("/").filter(Boolean).pop()?.replace(/-/g, " ") || "This screen";
  return (
    <div className="pt-10">
      <EmptyState
        icon={<Sparkles className="h-6 w-6" />}
        title={`${name[0]?.toUpperCase()}${name.slice(1)} — coming soon`}
        subtitle="This section is being built into the dashboard and will be available here shortly."
        action={
          <button onClick={() => navigate("/admin")} className="rounded-xl bg-gradient-to-br from-gold to-gold-light px-4 py-2 text-sm font-bold text-primary-foreground">
            Back to Dashboard
          </button>
        }
      />
    </div>
  );
}
