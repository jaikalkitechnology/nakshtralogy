import type { ReactNode } from 'react'

// Shared page scaffolding: header row (icon tile + title/subtitle + right-side
// actions), the standard raised card, and a small stat card. Kept in line with
// the app's hand-rolled design tokens (surface-raised / border-soft / ivory-*).

interface PageHeaderProps {
  title: string
  subtitle?: string
  icon?: ReactNode
  actions?: ReactNode
}

export function PageHeader({ title, subtitle, icon, actions }: PageHeaderProps) {
  return (
    <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
      <div className="flex items-center gap-3.5">
        {icon && <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl border border-border-soft bg-surface-raised shadow-[var(--shadow-1)]">{icon}</div>}
        <div>
          <h1 className="text-[20px] font-semibold tracking-tight">{title}</h1>
          {subtitle && <p className="mt-0.5 max-w-[680px] text-[12.5px] leading-relaxed text-ivory-faint">{subtitle}</p>}
        </div>
      </div>
      {actions && <div className="flex flex-wrap items-center gap-2.5">{actions}</div>}
    </div>
  )
}

export function Card({ className = '', children }: { className?: string; children: ReactNode }) {
  return <div className={`rounded-[14px] border border-border-soft bg-surface-raised shadow-[var(--shadow-1)] ${className}`}>{children}</div>
}

const STAT_TINTS = {
  amber: 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  emerald: 'bg-emerald-500/10 border-emerald-500/20 text-emerald-400',
  violet: 'bg-violet-500/10 border-violet-500/20 text-violet-400',
  saffron: 'bg-saffron-soft border-saffron/20 text-saffron',
} as const

interface StatCardProps {
  label: string
  value: string
  icon?: ReactNode
  tint?: keyof typeof STAT_TINTS
  sub?: string
}

export function StatCard({ label, value, icon, tint = 'amber', sub }: StatCardProps) {
  return (
    <Card className="p-5">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="text-[11px] font-semibold uppercase tracking-wide text-ivory-faint">{label}</div>
          <div className="mt-1.5 truncate text-[24px] font-bold tracking-tight tabular-nums">{value}</div>
          {sub && <div className="mt-1 text-[11px] text-ivory-faint">{sub}</div>}
        </div>
        {icon && <div className={`grid h-10 w-10 shrink-0 place-items-center rounded-lg border text-[16px] ${STAT_TINTS[tint]}`}>{icon}</div>}
      </div>
    </Card>
  )
}
