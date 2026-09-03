import { useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import {
  Search, ChevronUp, ChevronDown, ChevronsUpDown, ChevronLeft, ChevronRight,
  Download, FileSpreadsheet, Loader2, AlertCircle, X, Inbox,
} from "lucide-react";
import { cn } from "@/lib/utils";
import EmptyState from "@/components/premium/EmptyState";

export interface DataTableColumn<T> {
  /** unique key, also used to read `row[key]` when no accessor/render is given */
  key: string;
  header: string;
  render?: (row: T) => ReactNode;
  /** raw value used for sorting/export; falls back to row[key] */
  accessor?: (row: T) => any;
  sortable?: boolean;
  width?: number;
  minWidth?: number;
  align?: "left" | "right" | "center";
  className?: string;
  /** hide on small screens */
  hideBelow?: "md" | "lg";
}

export interface DataTableBulkAction<T> {
  label: string;
  icon?: ReactNode;
  tone?: "default" | "danger";
  onClick: (rows: T[]) => void;
}

interface DataTableProps<T> {
  columns: DataTableColumn<T>[];
  data: T[];
  keyField: (row: T) => string;
  loading?: boolean;
  error?: string | null;
  onRetry?: () => void;

  searchable?: boolean;
  searchValue?: string;
  onSearchChange?: (v: string) => void;
  searchPlaceholder?: string;

  filters?: ReactNode;
  toolbarRight?: ReactNode;

  /** server-side pagination; omit to disable pagination controls */
  page?: number; // 0-indexed
  pageSize?: number;
  total?: number;
  onPageChange?: (page: number) => void;

  selectable?: boolean;
  bulkActions?: DataTableBulkAction<T>[];

  onRowClick?: (row: T) => void;
  exportFileName?: string;
  hideExport?: boolean;

  emptyTitle?: string;
  emptyMessage?: string;
  emptyIcon?: ReactNode;
  emptyAction?: ReactNode;

  title?: string;
  subtitle?: ReactNode;
  dense?: boolean;
}

function getVal<T>(row: T, col: DataTableColumn<T>): any {
  if (col.accessor) return col.accessor(row);
  return (row as any)?.[col.key];
}

function toCsvCell(v: any): string {
  const s = v === null || v === undefined ? "" : String(v);
  const needsQuoting = s.includes('"') || s.includes(",") || s.includes("\n");
  if (needsQuoting) return '"' + s.split('"').join('""') + '"';
  return s;
}

export default function DataTable<T>({
  columns, data, keyField, loading, error, onRetry,
  searchable, searchValue, onSearchChange, searchPlaceholder = "Search...",
  filters, toolbarRight,
  page, pageSize, total, onPageChange,
  selectable, bulkActions,
  onRowClick, exportFileName = "export", hideExport,
  emptyTitle = "No records found", emptyMessage = "Try adjusting your filters or search.", emptyIcon, emptyAction,
  title, subtitle, dense,
}: DataTableProps<T>) {
  const [internalSearch, setInternalSearch] = useState("");
  const [sortKey, setSortKey] = useState<string | null>(null);
  const [sortDir, setSortDir] = useState<"asc" | "desc">("asc");
  const [selected, setSelected] = useState<Record<string, boolean>>({});
  const [widths, setWidths] = useState<Record<string, number>>({});
  const dragRef = useRef<{ key: string; startX: number; startW: number } | null>(null);

  const search = searchValue !== undefined ? searchValue : internalSearch;
  const setSearch = onSearchChange || setInternalSearch;

  useEffect(() => {
    // clear stale selections when the dataset changes
    setSelected({});
  }, [data]);

  const filtered = useMemo(() => {
    if (onSearchChange || !search) return data; // server-side search already applied
    const q = search.toLowerCase();
    return data.filter((row) =>
      columns.some((c) => String(getVal(row, c) ?? "").toLowerCase().includes(q)),
    );
  }, [data, search, columns, onSearchChange]);

  const sorted = useMemo(() => {
    if (!sortKey) return filtered;
    const col = columns.find((c) => c.key === sortKey);
    if (!col) return filtered;
    const copy = [...filtered];
    copy.sort((a, b) => {
      const av = getVal(a, col);
      const bv = getVal(b, col);
      if (av === bv) return 0;
      const cmp = typeof av === "number" && typeof bv === "number" ? av - bv : String(av ?? "").localeCompare(String(bv ?? ""));
      return sortDir === "asc" ? cmp : -cmp;
    });
    return copy;
  }, [filtered, sortKey, sortDir, columns]);

  const toggleSort = (key: string) => {
    if (sortKey !== key) { setSortKey(key); setSortDir("asc"); return; }
    if (sortDir === "asc") { setSortDir("desc"); return; }
    setSortKey(null);
  };

  const selectedKeys = Object.keys(selected).filter((k) => selected[k]);
  const selectedRows = sorted.filter((r) => selected[keyField(r)]);
  const allChecked = sorted.length > 0 && selectedKeys.length === sorted.length;
  const someChecked = selectedKeys.length > 0 && !allChecked;

  const toggleAll = () => {
    if (allChecked) { setSelected({}); return; }
    const next: Record<string, boolean> = {};
    sorted.forEach((r) => { next[keyField(r)] = true; });
    setSelected(next);
  };

  const exportRows = (rows: T[], fmt: "csv" | "xls") => {
    const headers = columns.map((c) => c.header);
    const lines = [headers.map(toCsvCell).join(",")];
    rows.forEach((row) => {
      lines.push(columns.map((c) => toCsvCell(getVal(row, c))).join(","));
    });
    if (fmt === "csv") {
      const blob = new Blob([lines.join("\n")], { type: "text/csv;charset=utf-8;" });
      downloadBlob(blob, `${exportFileName}.csv`);
    } else {
      // Lightweight "Excel" export: an HTML table that Excel opens natively — no xlsx dependency needed.
      const tableHtml = `
        <table>
          <thead><tr>${headers.map((h) => `<th>${h}</th>`).join("")}</tr></thead>
          <tbody>${rows.map((row) => `<tr>${columns.map((c) => `<td>${String(getVal(row, c) ?? "")}</td>`).join("")}</tr>`).join("")}</tbody>
        </table>`;
      const blob = new Blob(
        [`<html xmlns:x="urn:schemas-microsoft-com:office:excel"><head><meta charset="utf-8"></head><body>${tableHtml}</body></html>`],
        { type: "application/vnd.ms-excel" },
      );
      downloadBlob(blob, `${exportFileName}.xls`);
    }
  };

  const startResize = (key: string, startW: number) => (e: React.MouseEvent) => {
    dragRef.current = { key, startX: e.clientX, startW };
    const onMove = (ev: MouseEvent) => {
      if (!dragRef.current) return;
      const delta = ev.clientX - dragRef.current.startX;
      const col = columns.find((c) => c.key === dragRef.current!.key);
      const min = col?.minWidth ?? 80;
      setWidths((w) => ({ ...w, [dragRef.current!.key]: Math.max(min, dragRef.current!.startW + delta) }));
    };
    const onUp = () => {
      dragRef.current = null;
      window.removeEventListener("mousemove", onMove);
      window.removeEventListener("mouseup", onUp);
    };
    window.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
  };

  const isServerPaged = page !== undefined && pageSize !== undefined && total !== undefined && !!onPageChange;
  const totalPages = isServerPaged ? Math.max(1, Math.ceil((total as number) / (pageSize as number))) : 1;

  return (
    <div className="glass rounded-[20px] overflow-hidden">
      {/* Toolbar */}
      {(title || searchable || filters || toolbarRight || !hideExport) && (
        <div className="flex flex-wrap items-center gap-2.5 border-b border-border/60 p-3.5">
          {title && (
            <div className="mr-auto">
              <h3 className="text-[14px] font-bold text-foreground">{title}</h3>
              {subtitle && <div className="text-[11.5px] text-muted-foreground">{subtitle}</div>}
            </div>
          )}
          {searchable && (
            <div className={cn("relative", !title && "mr-auto", "min-w-[180px] flex-1 max-w-xs")}>
              <Search className="absolute left-3 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground" />
              <input
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder={searchPlaceholder}
                className="h-9 w-full rounded-xl border border-border/70 bg-glass/40 pl-8 pr-3 text-[12.5px] text-foreground outline-none placeholder:text-muted-foreground focus:border-gold/50"
              />
            </div>
          )}
          {filters}
          {toolbarRight}
          {!hideExport && (
            <div className="flex items-center gap-1.5">
              <button
                onClick={() => exportRows(selectedRows.length ? selectedRows : sorted, "csv")}
                title="Export CSV"
                className="flex h-9 items-center gap-1.5 rounded-xl border border-border/70 bg-glass/40 px-2.5 text-[12px] font-semibold text-muted-foreground hover:text-foreground"
              >
                <Download className="h-3.5 w-3.5" /> CSV
              </button>
              <button
                onClick={() => exportRows(selectedRows.length ? selectedRows : sorted, "xls")}
                title="Export Excel"
                className="flex h-9 items-center gap-1.5 rounded-xl border border-border/70 bg-glass/40 px-2.5 text-[12px] font-semibold text-muted-foreground hover:text-foreground"
              >
                <FileSpreadsheet className="h-3.5 w-3.5" /> Excel
              </button>
            </div>
          )}
        </div>
      )}

      {/* Bulk actions bar */}
      {selectable && selectedKeys.length > 0 && bulkActions && bulkActions.length > 0 && (
        <div className="flex items-center gap-2 border-b border-gold/20 bg-gold/8 px-3.5 py-2">
          <span className="text-[12px] font-semibold text-gold">{selectedKeys.length} selected</span>
          <div className="ml-auto flex items-center gap-2">
            {bulkActions.map((a) => (
              <button
                key={a.label}
                onClick={() => a.onClick(selectedRows)}
                className={cn(
                  "flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-[12px] font-semibold",
                  a.tone === "danger" ? "border border-rose-500/40 text-rose-400 hover:bg-rose-500/10" : "border border-border/70 text-foreground hover:bg-muted/40",
                )}
              >
                {a.icon}{a.label}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Table */}
      <div className="max-h-[560px] overflow-auto thin-scrollbar">
        <table className="w-full min-w-max border-collapse text-[13px]">
          <thead className="sticky top-0 z-10 bg-card/95 backdrop-blur">
            <tr className="border-b border-border/70">
              {selectable && (
                <th className="w-10 p-3">
                  <input
                    type="checkbox"
                    checked={allChecked}
                    ref={(el) => { if (el) el.indeterminate = someChecked; }}
                    onChange={toggleAll}
                    className="h-3.5 w-3.5 accent-gold"
                  />
                </th>
              )}
              {columns.map((c) => (
                <th
                  key={c.key}
                  style={{ width: widths[c.key] ?? c.width, minWidth: c.minWidth ?? 80 }}
                  className={cn(
                    "relative select-none whitespace-nowrap p-3 text-left text-[11px] font-bold uppercase tracking-wide text-muted-foreground",
                    c.align === "right" && "text-right",
                    c.align === "center" && "text-center",
                    c.hideBelow === "md" && "hidden md:table-cell",
                    c.hideBelow === "lg" && "hidden lg:table-cell",
                  )}
                >
                  <button
                    type="button"
                    disabled={!c.sortable}
                    onClick={() => c.sortable && toggleSort(c.key)}
                    className={cn("inline-flex items-center gap-1", c.sortable && "cursor-pointer hover:text-foreground")}
                  >
                    {c.header}
                    {c.sortable && (
                      sortKey === c.key
                        ? (sortDir === "asc" ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />)
                        : <ChevronsUpDown className="h-3 w-3 opacity-40" />
                    )}
                  </button>
                  <span
                    onMouseDown={startResize(c.key, widths[c.key] ?? c.width ?? 160)}
                    className="absolute right-0 top-0 h-full w-1.5 cursor-col-resize"
                  />
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading && (
              <tr>
                <td colSpan={columns.length + (selectable ? 1 : 0)} className="p-10 text-center text-muted-foreground">
                  <Loader2 className="mx-auto mb-2 h-5 w-5 animate-spin text-gold" />
                  Loading…
                </td>
              </tr>
            )}
            {!loading && error && (
              <tr>
                <td colSpan={columns.length + (selectable ? 1 : 0)} className="p-10 text-center">
                  <AlertCircle className="mx-auto mb-2 h-5 w-5 text-rose-400" />
                  <p className="text-[13px] text-rose-400">{error}</p>
                  {onRetry && (
                    <button onClick={onRetry} className="mt-2 rounded-lg border border-border/70 px-3 py-1.5 text-[12px] text-foreground">Retry</button>
                  )}
                </td>
              </tr>
            )}
            {!loading && !error && sorted.length === 0 && (
              <tr>
                <td colSpan={columns.length + (selectable ? 1 : 0)} className="p-0">
                  <EmptyState icon={emptyIcon ?? <Inbox className="h-6 w-6" />} title={emptyTitle} subtitle={emptyMessage} action={emptyAction} />
                </td>
              </tr>
            )}
            {!loading && !error && sorted.map((row) => {
              const k = keyField(row);
              return (
                <tr
                  key={k}
                  onClick={() => onRowClick?.(row)}
                  className={cn(
                    "border-b border-border/40 last:border-0 transition-colors hover:bg-muted/20",
                    onRowClick && "cursor-pointer",
                    dense ? "text-[12.5px]" : "",
                  )}
                >
                  {selectable && (
                    <td className="w-10 p-3" onClick={(e) => e.stopPropagation()}>
                      <input
                        type="checkbox"
                        checked={!!selected[k]}
                        onChange={(e) => setSelected((s) => ({ ...s, [k]: e.target.checked }))}
                        className="h-3.5 w-3.5 accent-gold"
                      />
                    </td>
                  )}
                  {columns.map((c) => (
                    <td
                      key={c.key}
                      style={{ width: widths[c.key] ?? c.width }}
                      className={cn(
                        "p-3 align-top text-foreground",
                        c.align === "right" && "text-right",
                        c.align === "center" && "text-center",
                        c.hideBelow === "md" && "hidden md:table-cell",
                        c.hideBelow === "lg" && "hidden lg:table-cell",
                        c.className,
                      )}
                    >
                      {c.render ? c.render(row) : String(getVal(row, c) ?? "—")}
                    </td>
                  ))}
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {isServerPaged && (total as number) > 0 && (
        <div className="flex items-center justify-between border-t border-border/60 px-3.5 py-2.5">
          <p className="text-[11.5px] text-muted-foreground">
            Page {(page as number) + 1} of {totalPages} · {total} total
          </p>
          <div className="flex gap-1.5">
            <button
              disabled={(page as number) === 0}
              onClick={() => onPageChange!(Math.max(0, (page as number) - 1))}
              className="flex h-8 items-center gap-1 rounded-lg border border-border/70 px-2.5 text-[12px] text-foreground disabled:opacity-40"
            >
              <ChevronLeft className="h-3.5 w-3.5" /> Prev
            </button>
            <button
              disabled={((page as number) + 1) >= totalPages}
              onClick={() => onPageChange!((page as number) + 1)}
              className="flex h-8 items-center gap-1 rounded-lg border border-border/70 px-2.5 text-[12px] text-foreground disabled:opacity-40"
            >
              Next <ChevronRight className="h-3.5 w-3.5" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function downloadBlob(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

export function ToolbarSelect({
  value, onChange, options, className,
}: { value: string; onChange: (v: string) => void; options: { value: string; label: string }[]; className?: string }) {
  return (
    <select
      value={value}
      onChange={(e) => onChange(e.target.value)}
      className={cn(
        "h-9 rounded-xl border border-border/70 bg-glass/40 px-2.5 text-[12.5px] text-foreground outline-none focus:border-gold/50",
        className,
      )}
    >
      {options.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
    </select>
  );
}

export function ClearFiltersButton({ onClick }: { onClick: () => void }) {
  return (
    <button onClick={onClick} className="flex h-9 items-center gap-1.5 rounded-xl border border-border/70 px-2.5 text-[12px] font-semibold text-muted-foreground hover:text-foreground">
      <X className="h-3.5 w-3.5" /> Clear
    </button>
  );
}
