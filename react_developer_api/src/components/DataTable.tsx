import type { ReactNode } from "react";
import {
  Table, TableHeader, TableRow, TableHead, TableBody, TableCell,
} from "@/components/ui/table";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import { ArrowUp, ArrowDown, AlertTriangle, Inbox } from "lucide-react";
import { cn } from "@/lib/utils";

export interface DataTableColumn<T> {
  key: string;
  header: string;
  render: (row: T) => ReactNode;
  sortable?: boolean;
  align?: "left" | "right" | "center";
  className?: string;
}

interface DataTableProps<T> {
  columns: DataTableColumn<T>[];
  rows: T[];
  rowKey: (row: T) => string;
  loading?: boolean;
  error?: string | null;
  onRetry?: () => void;
  emptyTitle?: string;
  emptyDescription?: string;
  emptyAction?: { label: string; onClick: () => void };
  actions?: (row: T) => ReactNode;
  page: number;
  pageSize: number;
  total: number;
  onPageChange: (page: number) => void;
  sortKey?: string;
  sortDir?: "asc" | "desc";
  onSortChange?: (key: string) => void;
}

/**
 * Reusable, premium-styled data table: server-side pagination (page +
 * page-size, total count + range), sortable columns, per-row action
 * buttons, and empty/loading/error states — used by every list screen in
 * the developer portal (keys, wallet ledger, usage logs, ...).
 */
export default function DataTable<T>({
  columns, rows, rowKey, loading, error, onRetry,
  emptyTitle = "Nothing here yet", emptyDescription, emptyAction,
  actions, page, pageSize, total, onPageChange, sortKey, sortDir, onSortChange,
}: DataTableProps<T>) {
  const totalPages = Math.max(1, Math.ceil(total / pageSize));
  const rangeStart = total === 0 ? 0 : (page - 1) * pageSize + 1;
  const rangeEnd = Math.min(total, page * pageSize);

  if (error) {
    return (
      <div className="flex items-center justify-between rounded-xl border border-red-500/30 bg-red-500/10 px-4 py-3 text-sm text-red-400">
        <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
        {onRetry && <Button size="sm" variant="outline" onClick={onRetry}>Retry</Button>}
      </div>
    );
  }

  if (loading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 5 }).map((_, i) => <Skeleton key={i} className="h-11 w-full rounded-lg" />)}
      </div>
    );
  }

  if (rows.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center gap-3 py-14 text-center">
        <Inbox className="h-9 w-9 text-muted-foreground/50" />
        <p className="text-sm font-medium text-foreground">{emptyTitle}</p>
        {emptyDescription && <p className="max-w-sm text-xs text-muted-foreground">{emptyDescription}</p>}
        {emptyAction && (
          <Button size="sm" variant="outline" onClick={emptyAction.onClick}>{emptyAction.label}</Button>
        )}
      </div>
    );
  }

  return (
    <div className="space-y-3">
      <Table>
        <TableHeader>
          <TableRow>
            {columns.map((col) => (
              <TableHead
                key={col.key}
                className={cn(
                  col.align === "right" && "text-right",
                  col.align === "center" && "text-center",
                  col.sortable && "cursor-pointer select-none",
                )}
                onClick={() => col.sortable && onSortChange?.(col.key)}
              >
                <span className="inline-flex items-center gap-1">
                  {col.header}
                  {col.sortable && sortKey === col.key && (sortDir === "asc" ? <ArrowUp className="h-3 w-3" /> : <ArrowDown className="h-3 w-3" />)}
                </span>
              </TableHead>
            ))}
            {actions && <TableHead className="text-right">Actions</TableHead>}
          </TableRow>
        </TableHeader>
        <TableBody>
          {rows.map((row) => (
            <TableRow key={rowKey(row)}>
              {columns.map((col) => (
                <TableCell
                  key={col.key}
                  className={cn(
                    col.align === "right" && "text-right",
                    col.align === "center" && "text-center",
                    col.className,
                  )}
                >
                  {col.render(row)}
                </TableCell>
              ))}
              {actions && <TableCell className="text-right">{actions(row)}</TableCell>}
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <div className="flex items-center justify-between pt-1 text-xs text-muted-foreground">
        <span>Showing {rangeStart}-{rangeEnd} of {total}</span>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="outline" disabled={page <= 1} onClick={() => onPageChange(page - 1)}>Previous</Button>
          <span>Page {page} of {totalPages}</span>
          <Button size="sm" variant="outline" disabled={page >= totalPages} onClick={() => onPageChange(page + 1)}>Next</Button>
        </div>
      </div>
    </div>
  );
}
