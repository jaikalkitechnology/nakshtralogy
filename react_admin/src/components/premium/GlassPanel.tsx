import { type ReactNode } from "react";
import { cn } from "@/lib/utils";

interface GlassPanelProps {
  children: ReactNode;
  className?: string;
  title?: string;
  action?: ReactNode;
}

/** Premium glass panel with an optional header row. */
export default function GlassPanel({ children, className, title, action }: GlassPanelProps) {
  return (
    <div className={cn("glass rounded-[20px] p-5", className)}>
      {(title || action) && (
        <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
          {title && <h3 className="text-[15px] font-bold text-foreground">{title}</h3>}
          {action}
        </div>
      )}
      {children}
    </div>
  );
}
