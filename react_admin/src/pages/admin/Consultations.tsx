import { useEffect, useState } from "react";
import { MessageSquare, Search, Phone, Video, MessageCircle } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import DataTable, { type DataTableColumn } from "@/components/premium/DataTable";
import { adminListConsultations } from "@/services/api";

const PAGE_SIZE = 20;

const STATUS_TONE: Record<string, string> = {
  completed: "bg-green-500/20 text-green-400",
  pending: "bg-yellow-500/20 text-yellow-400",
  ongoing: "bg-cyan-500/20 text-cyan-400",
  cancelled: "bg-destructive/20 text-destructive",
  expired: "bg-muted text-muted-foreground",
};

const TYPE_ICON: Record<string, any> = { chat: MessageCircle, call: Phone, video: Video };

const columns: DataTableColumn<any>[] = [
  { key: "user_name", header: "User", sortable: true, minWidth: 160, render: (c) => (
    <div className="min-w-0 max-w-[200px]">
      <p className="font-medium text-foreground truncate">{c.user_name || "—"}</p>
      <p className="text-xs text-muted-foreground truncate">{c.user_email}</p>
    </div>
  ) },
  { key: "astrologer_name", header: "Astrologer", sortable: true, hideBelow: "md", minWidth: 160, render: (c) => (
    <div className="min-w-0 max-w-[200px]">
      <p className="font-medium text-foreground truncate">{c.astrologer_name || "—"}</p>
      <p className="text-xs text-muted-foreground truncate">{c.astrologer_email}</p>
    </div>
  ) },
  { key: "session_type", header: "Type", align: "center", render: (c) => {
    const Icon = TYPE_ICON[c.session_type] || MessageCircle;
    return (
      <Badge variant="outline" className="border-border text-xs capitalize inline-flex items-center gap-1">
        <Icon className="w-3 h-3" /> {c.session_type}
      </Badge>
    );
  } },
  { key: "status", header: "Status", align: "center", sortable: true, render: (c) => (
    <Badge className={STATUS_TONE[c.status] || "bg-muted text-muted-foreground"}>{c.status}</Badge>
  ) },
  { key: "duration_min", header: "Duration", align: "center", hideBelow: "lg", render: (c) => c.duration_min != null ? `${c.duration_min} min` : "—" },
  { key: "total_amount", header: "Amount", align: "right", sortable: true, render: (c) => <span className="font-semibold text-primary">₹{c.total_amount}</span> },
  { key: "platform_commission", header: "Commission", align: "right", hideBelow: "lg", render: (c) => `₹${c.platform_commission}` },
  { key: "created_at", header: "Date", hideBelow: "md", render: (c) => c.created_at?.slice(0, 16) || "—" },
];

export default function Consultations() {
  const [rows, setRows] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [typeFilter, setTypeFilter] = useState("all");

  useEffect(() => {
    let alive = true;
    setLoading(true);
    const params: Record<string, any> = { skip: page * PAGE_SIZE, limit: PAGE_SIZE };
    if (search) params.search = search;
    if (statusFilter !== "all") params.status = statusFilter;
    if (typeFilter !== "all") params.session_type = typeFilter;
    adminListConsultations(params)
      .then((r) => {
        if (!alive) return;
        const d = r?.data ?? r;
        setRows(d?.consultations ?? []);
        setTotal(d?.total ?? 0);
      })
      .catch(() => { if (alive) { setRows([]); setTotal(0); } })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [page, search, statusFilter, typeFilter]);

  // Any filter change should reset to page 0, not keep an out-of-range page.
  useEffect(() => { setPage(0); }, [search, statusFilter, typeFilter]);

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <MessageSquare className="w-5 h-5 text-primary" />
        <h1 className="text-xl font-display text-gold-gradient">Consultations</h1>
      </div>

      <div className="flex flex-col md:flex-row gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by user or astrologer name/email..."
            className="pl-10 bg-muted border-border"
          />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full md:w-44 bg-muted border-border">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="ongoing">Ongoing</SelectItem>
            <SelectItem value="completed">Completed</SelectItem>
            <SelectItem value="cancelled">Cancelled</SelectItem>
            <SelectItem value="expired">Expired</SelectItem>
          </SelectContent>
        </Select>
        <Select value={typeFilter} onValueChange={setTypeFilter}>
          <SelectTrigger className="w-full md:w-40 bg-muted border-border">
            <SelectValue placeholder="Type" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Types</SelectItem>
            <SelectItem value="chat">Chat</SelectItem>
            <SelectItem value="call">Call</SelectItem>
            <SelectItem value="video">Video</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable<any>
        columns={columns}
        data={rows}
        keyField={(c) => c.id}
        loading={loading}
        page={page}
        pageSize={PAGE_SIZE}
        total={total}
        onPageChange={setPage}
        exportFileName="nakshtralogy-consultations"
        emptyTitle="No consultations found"
        emptyMessage="Adjust filters — sessions will appear here as users and astrologers connect."
      />
    </div>
  );
}
