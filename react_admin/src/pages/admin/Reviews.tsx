import { useEffect, useState } from "react";
import { Star, Search, EyeOff, Eye, Trash2, MessageCircle, Phone, Video, ClipboardList } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import DataTable, { type DataTableColumn } from "@/components/premium/DataTable";
import { adminListReviews, adminToggleReviewVisibility, adminDeleteReview } from "@/services/api";

const PAGE_SIZE = 20;

const TYPE_ICON: Record<string, any> = { chat: MessageCircle, voice: Phone, video: Video };

interface ReviewRow {
  id: string;             // "review:<uuid>" | "session:<uuid>"
  source: "review" | "session_review";
  user_name: string | null;
  user_email: string | null;
  astrologer_name: string | null;
  rating: number;
  comment: string | null;
  is_visible: boolean;
  created_at: string | null;
  updated_at: string | null;
  session_type: string | null;
}

function Stars({ n }: { n: number }) {
  return (
    <span className="inline-flex text-primary">
      {Array.from({ length: 5 }, (_, i) => (
        <Star key={i} className={`w-3.5 h-3.5 ${i < n ? "fill-current" : "text-muted-foreground"}`} />
      ))}
    </span>
  );
}

export default function Reviews() {
  const [rows, setRows] = useState<ReviewRow[]>([]);
  const [total, setTotal] = useState(0);
  const [avgRating, setAvgRating] = useState(0);
  const [distribution, setDistribution] = useState<Record<string, number>>({});
  const [page, setPage] = useState(0);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [ratingFilter, setRatingFilter] = useState("all");
  const [visibilityFilter, setVisibilityFilter] = useState("all");
  const [busyId, setBusyId] = useState<string | null>(null);
  const [reloadKey, setReloadKey] = useState(0);

  useEffect(() => {
    let alive = true;
    setLoading(true);
    const params: Record<string, any> = { skip: page * PAGE_SIZE, limit: PAGE_SIZE };
    if (search) params.search = search;
    if (ratingFilter !== "all") params.rating = ratingFilter;
    if (visibilityFilter !== "all") params.visibility = visibilityFilter;
    adminListReviews(params)
      .then((r) => {
        if (!alive) return;
        const d = r?.data ?? r;
        setRows(d?.reviews ?? []);
        setTotal(d?.total ?? 0);
        setAvgRating(d?.average_rating ?? 0);
        setDistribution(d?.distribution ?? {});
      })
      .catch(() => { if (alive) { setRows([]); setTotal(0); } })
      .finally(() => { if (alive) setLoading(false); });
    return () => { alive = false; };
  }, [page, search, ratingFilter, visibilityFilter, reloadKey]);

  // Any filter change should reset to page 0, not keep an out-of-range page.
  useEffect(() => { setPage(0); }, [search, ratingFilter, visibilityFilter]);

  const toggleVisibility = async (row: ReviewRow) => {
    setBusyId(row.id);
    try {
      await adminToggleReviewVisibility(row.id);
      setReloadKey((k) => k + 1);
    } finally {
      setBusyId(null);
    }
  };

  const deleteReview = async (row: ReviewRow) => {
    if (!window.confirm(`Permanently delete this review by ${row.user_name || "this user"}? This can't be undone.`)) return;
    setBusyId(row.id);
    try {
      await adminDeleteReview(row.id);
      setReloadKey((k) => k + 1);
    } finally {
      setBusyId(null);
    }
  };

  const maxBucket = Math.max(1, ...Object.values(distribution));

  const columns: DataTableColumn<ReviewRow>[] = [
    { key: "user_name", header: "Reviewer", sortable: true, minWidth: 160, render: (r) => (
      <div className="min-w-0 max-w-[180px]">
        <p className="font-medium text-foreground truncate">{r.user_name || "—"}</p>
        <p className="text-xs text-muted-foreground truncate">{r.user_email}</p>
      </div>
    ) },
    { key: "astrologer_name", header: "Astrologer", sortable: true, hideBelow: "md", minWidth: 150, render: (r) => (
      <span className="text-foreground truncate block max-w-[160px]">{r.astrologer_name || "—"}</span>
    ) },
    { key: "rating", header: "Rating", align: "center", sortable: true, render: (r) => <Stars n={r.rating} /> },
    { key: "comment", header: "Comment", minWidth: 220, render: (r) => (
      <p className="text-sm text-muted-foreground truncate max-w-[280px]" title={r.comment || ""}>
        {r.comment || <span className="italic">No comment</span>}
      </p>
    ) },
    { key: "session_type", header: "Via", align: "center", hideBelow: "lg", render: (r) => {
      if (!r.session_type) return <Badge variant="outline" className="border-border text-xs inline-flex items-center gap-1"><ClipboardList className="w-3 h-3" /> Consultation</Badge>;
      const Icon = TYPE_ICON[r.session_type] || MessageCircle;
      return <Badge variant="outline" className="border-border text-xs capitalize inline-flex items-center gap-1"><Icon className="w-3 h-3" /> {r.session_type}</Badge>;
    } },
    { key: "is_visible", header: "Status", align: "center", sortable: true, render: (r) => (
      <Badge className={r.is_visible ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>
        {r.is_visible ? "Visible" : "Blocked"}
      </Badge>
    ) },
    { key: "updated_at", header: "Date", hideBelow: "md", sortable: true, render: (r) => {
      const edited = !!r.updated_at && r.updated_at !== r.created_at;
      return (
        <div>
          <p>{(edited ? r.updated_at : r.created_at)?.slice(0, 16) || "—"}</p>
          {edited && <p className="text-xs text-muted-foreground">edited</p>}
        </div>
      );
    } },
    { key: "actions", header: "", align: "right", render: (r) => (
      <div className="flex items-center justify-end gap-1">
        <Button
          size="sm" variant="ghost" disabled={busyId === r.id}
          onClick={() => toggleVisibility(r)}
          title={r.is_visible ? "Block — hide from both apps" : "Unblock — make public again"}
        >
          {r.is_visible ? <EyeOff className="w-4 h-4 text-muted-foreground" /> : <Eye className="w-4 h-4 text-green-400" />}
        </Button>
        <Button size="sm" variant="ghost" disabled={busyId === r.id} onClick={() => deleteReview(r)} title="Delete permanently">
          <Trash2 className="w-4 h-4 text-destructive" />
        </Button>
      </div>
    ) },
  ];

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <Star className="w-5 h-5 text-primary" />
        <h1 className="text-xl font-display text-gold-gradient">Reviews</h1>
      </div>
      <p className="text-sm text-muted-foreground -mt-2">
        Every rating &amp; review left after a chat/voice/video session, across both apps. Blocking a review
        hides it from the astrologer's public profile and drops it out of their average rating immediately —
        it stays here, visible to admins, until unblocked or deleted.
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-[auto_1fr] gap-4 p-4 rounded-xl border border-border bg-card">
        <div className="flex flex-col items-center justify-center px-4">
          <span className="text-3xl font-bold text-primary">{avgRating.toFixed(1)}</span>
          <Stars n={Math.round(avgRating)} />
          <span className="text-xs text-muted-foreground mt-1">{total} total</span>
        </div>
        <div className="space-y-1.5 min-w-[200px]">
          {[5, 4, 3, 2, 1].map((star) => {
            const count = distribution[String(star)] ?? 0;
            return (
              <div key={star} className="flex items-center gap-2 text-xs">
                <span className="w-3 text-muted-foreground">{star}</span>
                <Star className="w-3 h-3 text-primary fill-current" />
                <div className="flex-1 h-2 rounded-full bg-muted overflow-hidden">
                  <div className="h-full bg-primary" style={{ width: `${(count / maxBucket) * 100}%` }} />
                </div>
                <span className="w-6 text-right text-muted-foreground">{count}</span>
              </div>
            );
          })}
        </div>
      </div>

      <div className="flex flex-col md:flex-row gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by reviewer, astrologer or comment..."
            className="pl-10 bg-muted border-border"
          />
        </div>
        <Select value={ratingFilter} onValueChange={setRatingFilter}>
          <SelectTrigger className="w-full md:w-36 bg-muted border-border">
            <SelectValue placeholder="Rating" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Ratings</SelectItem>
            {[5, 4, 3, 2, 1].map((n) => <SelectItem key={n} value={String(n)}>{n} star</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={visibilityFilter} onValueChange={setVisibilityFilter}>
          <SelectTrigger className="w-full md:w-40 bg-muted border-border">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="visible">Visible</SelectItem>
            <SelectItem value="hidden">Blocked</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <DataTable<ReviewRow>
        columns={columns}
        data={rows}
        keyField={(r) => r.id}
        loading={loading}
        page={page}
        pageSize={PAGE_SIZE}
        total={total}
        onPageChange={setPage}
        exportFileName="nakshtralogy-reviews"
        emptyTitle="No reviews found"
        emptyMessage="Reviews appear here once users rate astrologers after a completed session."
      />
    </div>
  );
}
