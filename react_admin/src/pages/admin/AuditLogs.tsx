import { useEffect, useState } from "react";
import { ScrollText, Search } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import DataTable, { type DataTableColumn } from "@/components/premium/DataTable";
import { adminListAuditLogs, adminListAuditActions } from "@/services/api";

const PAGE_SIZE = 25;

const ACTION_TONE = (action: string) => {
  if (action.includes("delete") || action.includes("reject") || action.includes("block")) return "bg-destructive/20 text-destructive";
  if (action.includes("approve") || action.includes("unblock") || action.includes("create")) return "bg-green-500/20 text-green-400";
  return "bg-primary/20 text-primary";
};

const columns: DataTableColumn<any>[] = [
  { key: "created_at", header: "When", sortable: true, minWidth: 140, render: (l) => (
    <span className="text-xs text-muted-foreground whitespace-nowrap">{l.created_at?.slice(0, 19).replace("T", " ") || "—"}</span>
  ) },
  { key: "admin_email", header: "Admin", sortable: true, hideBelow: "md", minWidth: 180, render: (l) => (
    <span className="truncate">{l.admin_email || "—"}</span>
  ) },
  { key: "action", header: "Action", sortable: true, minWidth: 160, render: (l) => (
    <Badge className={ACTION_TONE(l.action || "")}>{l.action}</Badge>
  ) },
  { key: "target_type", header: "Target", hideBelow: "lg", render: (l) => (
    <span className="capitalize text-xs">{l.target_type || "—"}</span>
  ) },
  { key: "target_label", header: "Target Detail", hideBelow: "lg", minWidth: 180, render: (l) => (
    <span className="text-xs text-foreground truncate">{l.target_label || l.target_id || "—"}</span>
  ) },
  { key: "detail", header: "Notes", minWidth: 200, render: (l) => (
    <span className="text-xs text-muted-foreground break-words">{l.detail || "—"}</span>
  ) },
];

export default function AuditLogs() {
  const [rows, setRows] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(false);
  const [adminEmail, setAdminEmail] = useState("");
  const [action, setAction] = useState("all");
  const [actions, setActions] = useState<string[]>([]);

  useEffect(() => {
    adminListAuditActions()
      .then((r) => setActions((r?.data ?? r)?.actions ?? []))
      .catch(() => setActions([]));
  }, []);

  useEffect(() => {
    let alive = true;
    setLoading(true);
    const params: Record<string, any> = { skip: page * PAGE_SIZE, limit: PAGE_SIZE };
    if (adminEmail) params.admin_email = adminEmail;
    if (action !== "all") params.action = action;
    adminListAuditLogs(params)
      .then((r) => {
        if (!alive) return;
        const d = r?.data ?? r;
        setRows(d?.logs ?? []);
        setTotal(d?.total ?? 0);
      })
      .catch(() => { if (alive) { setRows([]); setTotal(0); } })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [page, adminEmail, action]);

  useEffect(() => { setPage(0); }, [adminEmail, action]);

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <ScrollText className="w-5 h-5 text-primary" />
        <h1 className="text-xl font-display text-gold-gradient">Audit Logs</h1>
      </div>
      <p className="text-xs text-muted-foreground">
        A record of sensitive admin actions — approvals, blocks, deletions, wallet adjustments, and permission changes.
        Coverage is being extended over time; not every admin action is logged yet.
      </p>

      <div className="flex flex-col md:flex-row gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            value={adminEmail}
            onChange={(e) => setAdminEmail(e.target.value)}
            placeholder="Filter by admin email..."
            className="pl-10 bg-muted border-border"
          />
        </div>
        <Select value={action} onValueChange={setAction}>
          <SelectTrigger className="w-full md:w-56 bg-muted border-border">
            <SelectValue placeholder="Action" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Actions</SelectItem>
            {actions.map((a) => <SelectItem key={a} value={a}>{a}</SelectItem>)}
          </SelectContent>
        </Select>
      </div>

      <DataTable<any>
        columns={columns}
        data={rows}
        keyField={(l) => l.id}
        loading={loading}
        page={page}
        pageSize={PAGE_SIZE}
        total={total}
        onPageChange={setPage}
        hideExport={false}
        exportFileName="nakshtralogy-audit-logs"
        emptyTitle="No audit entries found"
        emptyMessage="Sensitive admin actions will appear here as they happen."
      />
    </div>
  );
}
