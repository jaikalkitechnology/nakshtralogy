import { type ReactNode } from "react";

export default function EmptyState({
  icon, title, subtitle, action,
}: { icon: ReactNode; title: string; subtitle?: string; action?: ReactNode }) {
  return (
    <div className="flex flex-col items-center justify-center rounded-[20px] border border-dashed border-border/70 bg-muted/20 px-6 py-12 text-center">
      <div className="mb-3 grid h-14 w-14 place-items-center rounded-2xl bg-gold/10 text-gold">{icon}</div>
      <p className="text-base font-semibold text-foreground">{title}</p>
      {subtitle && <p className="mt-1 max-w-sm text-sm text-muted-foreground">{subtitle}</p>}
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}
