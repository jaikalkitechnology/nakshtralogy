import { useEffect, useState } from "react";
import { FileText, Search, User as UserIcon, Star } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import DataTable, { type DataTableColumn } from "@/components/premium/DataTable";
import { adminListKundliSubmissions, adminGetKundliSubmissionDetail } from "@/services/api";

const PAGE_SIZE = 20;
const DETAIL_PAGE_SIZE = 20;

const ROLE_TONE: Record<string, string> = {
  user: "bg-cyan-500/20 text-cyan-400",
  astrologer: "bg-primary/20 text-primary",
};

interface Submission {
  user_id: string;
  user_name: string | null;
  user_email: string | null;
  role: string;
  chart_count: number;
  latest_at: string | null;
}

interface ChartRecord {
  id: string;
  name: string;
  gender: string | null;
  dob: string;
  tob: string;
  place: string;
  category: string | null;
  is_primary: boolean;
  created_at: string | null;
}

const columns: DataTableColumn<Submission>[] = [
  { key: "user_name", header: "Submitter", sortable: true, minWidth: 180, render: (s) => (
    <div className="min-w-0 max-w-[220px] flex items-center gap-2">
      {s.role === "astrologer" ? <Star className="w-3.5 h-3.5 text-primary shrink-0" /> : <UserIcon className="w-3.5 h-3.5 text-cyan-400 shrink-0" />}
      <div className="min-w-0">
        <p className="font-medium text-foreground truncate">{s.user_name || "—"}</p>
        <p className="text-xs text-muted-foreground truncate">{s.user_email}</p>
      </div>
    </div>
  ) },
  { key: "role", header: "Role", align: "center", sortable: true, render: (s) => (
    <Badge className={`capitalize ${ROLE_TONE[s.role] || "bg-muted text-muted-foreground"}`}>{s.role}</Badge>
  ) },
  { key: "chart_count", header: "Data Records", align: "right", sortable: true, render: (s) => (
    <span className="font-semibold text-primary">{s.chart_count}</span>
  ) },
  { key: "latest_at", header: "Latest Submission", hideBelow: "md", render: (s) => s.latest_at?.slice(0, 16) || "—" },
];

const detailColumns: DataTableColumn<ChartRecord>[] = [
  { key: "name", header: "Person", sortable: true, minWidth: 160, render: (c) => (
    <div className="min-w-0 max-w-[200px]">
      <p className="font-medium text-foreground truncate">{c.name}{c.is_primary ? " ★" : ""}</p>
      <p className="text-xs text-muted-foreground capitalize">{c.category || "—"}</p>
    </div>
  ) },
  { key: "gender", header: "Gender", align: "center", hideBelow: "lg", render: (c) => c.gender || "—" },
  { key: "dob", header: "DOB", align: "center" },
  { key: "tob", header: "TOB", align: "center", hideBelow: "md" },
  { key: "place", header: "Place", hideBelow: "md" },
  { key: "created_at", header: "Submitted", hideBelow: "lg", render: (c) => c.created_at?.slice(0, 16) || "—" },
];

export default function KundliData() {
  const [rows, setRows] = useState<Submission[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");

  const [detail, setDetail] = useState<Submission | null>(null);
  const [detailRows, setDetailRows] = useState<ChartRecord[]>([]);
  const [detailTotal, setDetailTotal] = useState(0);
  const [detailPage, setDetailPage] = useState(0);
  const [detailLoading, setDetailLoading] = useState(false);

  useEffect(() => {
    let alive = true;
    setLoading(true);
    const params: Record<string, any> = { skip: page * PAGE_SIZE, limit: PAGE_SIZE };
    if (search) params.search = search;
    if (roleFilter !== "all") params.role = roleFilter;
    adminListKundliSubmissions(params)
      .then((r) => {
        if (!alive) return;
        const d = r?.data ?? r;
        setRows(d?.submissions ?? []);
        setTotal(d?.total ?? 0);
      })
      .catch(() => { if (alive) { setRows([]); setTotal(0); } })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [page, search, roleFilter]);

  // Any filter change should reset to page 0, not keep an out-of-range page.
  useEffect(() => { setPage(0); }, [search, roleFilter]);

  useEffect(() => {
    if (!detail) return;
    let alive = true;
    setDetailLoading(true);
    adminGetKundliSubmissionDetail(detail.user_id, { skip: detailPage * DETAIL_PAGE_SIZE, limit: DETAIL_PAGE_SIZE })
      .then((r) => {
        if (!alive) return;
        const d = r?.data ?? r;
        setDetailRows(d?.charts ?? []);
        setDetailTotal(d?.total ?? 0);
      })
      .catch(() => { if (alive) { setDetailRows([]); setDetailTotal(0); } })
      .finally(() => { if (alive) setDetailLoading(false); });
    return () => { alive = false; };
  }, [detail, detailPage]);

  const openDetail = (s: Submission) => {
    setDetailPage(0);
    setDetail(s);
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <FileText className="w-5 h-5 text-primary" />
        <h1 className="text-xl font-display text-gold-gradient">Kundli Data</h1>
      </div>
      <p className="text-sm text-muted-foreground -mt-2">
        How much birth-chart data each user and astrologer has submitted for Kundli/report generation —
        one record per person charted, not per account. Click a row to see the individual records.
      </p>

      <div className="flex flex-col md:flex-row gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by submitter name or email..."
            className="pl-10 bg-muted border-border"
          />
        </div>
        <Select value={roleFilter} onValueChange={setRoleFilter}>
          <SelectTrigger className="w-full md:w-44 bg-muted border-border">
            <SelectValue placeholder="Role" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Accounts</SelectItem>
            <SelectItem value="user">Users</SelectItem>
            <SelectItem value="astrologer">Astrologers</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable<Submission>
        columns={columns}
        data={rows}
        keyField={(s) => s.user_id}
        loading={loading}
        page={page}
        pageSize={PAGE_SIZE}
        total={total}
        onPageChange={setPage}
        onRowClick={openDetail}
        exportFileName="nakshtralogy-kundli-data"
        emptyTitle="No submitted data yet"
        emptyMessage="This tracks birth-chart data submitted for Kundli/report generation — rows appear here once a user or astrologer creates a chart."
      />

      <Dialog open={detail !== null} onOpenChange={(v) => !v && setDetail(null)}>
        <DialogContent className="bg-card border-border max-w-3xl max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {detail?.user_name || "—"}
              <span className="ml-2 text-sm font-normal text-muted-foreground">{detail?.user_email}</span>
            </DialogTitle>
          </DialogHeader>
          <DataTable<ChartRecord>
            columns={detailColumns}
            data={detailRows}
            keyField={(c) => c.id}
            loading={detailLoading}
            page={detailPage}
            pageSize={DETAIL_PAGE_SIZE}
            total={detailTotal}
            onPageChange={setDetailPage}
            hideExport
            emptyTitle="No records"
            emptyMessage="No chart data found for this account."
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
