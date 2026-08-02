import { useEffect, useRef, useState, type ReactNode } from "react";
import { motion } from "framer-motion";
import { TrendingUp, TrendingDown } from "lucide-react";
import { cn } from "@/lib/utils";
import Sparkline from "./Sparkline";

type Tone = "gold" | "green" | "purple" | "teal" | "amber" | "red";

const toneMap: Record<Tone, { text: string; bg: string; stroke: string }> = {
  gold: { text: "text-gold", bg: "bg-gold/15", stroke: "hsl(var(--gold))" },
  green: { text: "text-emerald-400", bg: "bg-emerald-500/15", stroke: "#4ecb8d" },
  purple: { text: "text-cosmic-light", bg: "bg-cosmic/15", stroke: "hsl(var(--cosmic))" },
  teal: { text: "text-cyan-400", bg: "bg-cyan-500/15", stroke: "#4fb0c6" },
  amber: { text: "text-amber-400", bg: "bg-amber-500/15", stroke: "#e8b547" },
  red: { text: "text-rose-400", bg: "bg-rose-500/15", stroke: "#e0607a" },
};

function useCountUp(target: number, ms = 900) {
  const [v, setV] = useState(0);
  const raf = useRef<number>();
  useEffect(() => {
    const start = performance.now();
    const tick = (now: number) => {
      const p = Math.min(1, (now - start) / ms);
      setV(target * (1 - Math.pow(1 - p, 3)));
      if (p < 1) raf.current = requestAnimationFrame(tick);
    };
    raf.current = requestAnimationFrame(tick);
    return () => { if (raf.current) cancelAnimationFrame(raf.current); };
  }, [target, ms]);
  return v;
}

interface StatCardProps {
  label: string;
  value: number;
  format?: (n: number) => string;
  prefix?: string;
  suffix?: string;
  icon: ReactNode;
  tone?: Tone;
  trend?: number;
  trendLabel?: string;
  spark?: number[];
  delay?: number;
}

export default function StatCard({
  label, value, format, prefix = "", suffix = "", icon, tone = "gold",
  trend, trendLabel, spark, delay = 0,
}: StatCardProps) {
  const animated = useCountUp(value);
  const t = toneMap[tone];
  const shown = format ? format(animated) : Math.round(animated).toLocaleString();
  const up = (trend ?? 0) >= 0;
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.35, delay }}
      className="glass card-gradient-border lift relative overflow-hidden rounded-[20px] p-4"
    >
      <div className="flex items-start justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">{label}</p>
          <p className="mt-1 text-2xl font-extrabold text-foreground">{prefix}{shown}{suffix}</p>
          {trend !== undefined && (
            <p className={cn("mt-1.5 flex items-center gap-1 text-[11.5px] font-bold", up ? "text-emerald-400" : "text-rose-400")}>
              {up ? <TrendingUp className="h-3.5 w-3.5" /> : <TrendingDown className="h-3.5 w-3.5" />}
              {Math.abs(trend)}% {trendLabel}
            </p>
          )}
        </div>
        <div className={cn("grid h-9 w-9 place-items-center rounded-xl", t.bg, t.text)}>{icon}</div>
      </div>
      {spark && <div className="absolute bottom-3 right-3 opacity-90"><Sparkline data={spark} color={t.stroke} /></div>}
    </motion.div>
  );
}
