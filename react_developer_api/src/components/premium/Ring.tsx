interface RingProps {
  value: number; // 0..100
  label?: string;
  size?: number;
  color?: string;
  sub?: string;
}

export default function Ring({ value, label, size = 66, color = "#4ecb8d", sub }: RingProps) {
  const r = size / 2 - 6;
  const c = 2 * Math.PI * r;
  const pct = Math.max(0, Math.min(100, value));
  const off = c * (1 - pct / 100);
  return (
    <div className="flex flex-col items-center">
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="hsl(var(--gold) / 0.15)" strokeWidth={6} />
        <circle
          cx={size / 2} cy={size / 2} r={r} fill="none" stroke={color} strokeWidth={6}
          strokeLinecap="round" strokeDasharray={c} strokeDashoffset={off}
          transform={`rotate(-90 ${size / 2} ${size / 2})`}
          style={{ transition: "stroke-dashoffset 0.9s ease" }}
        />
        <text x="50%" y="52%" textAnchor="middle" dominantBaseline="middle" fill="hsl(var(--foreground))" fontSize={size * 0.21} fontWeight={700}>
          {sub ?? `${Math.round(pct)}%`}
        </text>
      </svg>
      {label && <span className="mt-1.5 text-[11px] text-muted-foreground">{label}</span>}
    </div>
  );
}
