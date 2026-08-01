import { useEffect, useRef, useState, type ReactNode } from "react";
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

function useCountUp(target: number, durationMs = 800) {
  const [value, setValue] = useState(0);
  const frame = useRef<number>();
  useEffect(() => {
    const start = performance.now();
    const animate = (now: number) => {
      const progress = Math.min(1, (now - start) / durationMs);
      setValue(Math.round(target * progress));
      if (progress < 1) frame.current = requestAnimationFrame(animate);
    };
    frame.current = requestAnimationFrame(animate);
    return () => { if (frame.current) cancelAnimationFrame(frame.current); };
  }, [target, durationMs]);
  return value;
}

interface KpiCardProps {
  label: string;
  value: number;
  suffix?: string;
  prefix?: string;
  icon: ReactNode;
  tone?: "default" | "success" | "warning" | "danger";
}

const toneClass: Record<string, string> = {
  default: "text-primary",
  success: "text-emerald-400",
  warning: "text-amber-400",
  danger: "text-red-400",
};

export default function KpiCard({ label, value, suffix = "", prefix = "", icon, tone = "default" }: KpiCardProps) {
  const animated = useCountUp(value);
  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="rounded-2xl border border-border/60 bg-card/60 p-4 backdrop-blur transition-transform hover:-translate-y-0.5"
    >
      <div className={cn("mb-2 flex items-center justify-between", toneClass[tone])}>{icon}</div>
      <p className="text-2xl font-semibold text-foreground">
        {prefix}{animated.toLocaleString()}{suffix}
      </p>
      <p className="text-xs text-muted-foreground">{label}</p>
    </motion.div>
  );
}
