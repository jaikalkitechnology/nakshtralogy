import { cn } from "@/lib/utils";

type Status = "ok" | "warn" | "down";

const dot: Record<Status, string> = {
  ok: "bg-emerald-400",
  warn: "bg-amber-400",
  down: "bg-rose-400",
};

export default function StatusRow({ name, status, meta }: { name: string; status: Status; meta?: string }) {
  return (
    <div className="flex items-center justify-between border-b border-border/40 py-2.5 text-sm last:border-0">
      <span className="flex items-center gap-2.5">
        <span className={cn("h-2.5 w-2.5 rounded-full", dot[status], status === "ok" && "animate-pulse-glow")} />
        {name}
      </span>
      {meta && <span className="text-[11px] text-muted-foreground">{meta}</span>}
    </div>
  );
}
