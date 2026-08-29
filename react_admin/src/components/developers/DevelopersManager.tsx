import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  Table, TableHeader, TableRow, TableHead, TableBody, TableCell,
} from "@/components/ui/table";
import {
  Tooltip, TooltipTrigger, TooltipContent, TooltipProvider,
} from "@/components/ui/tooltip";
import {
  AlertDialog, AlertDialogContent, AlertDialogHeader, AlertDialogTitle,
  AlertDialogDescription, AlertDialogFooter, AlertDialogCancel, AlertDialogAction,
} from "@/components/ui/alert-dialog";
import {
  Search, RefreshCw, Eye, Ban, PlayCircle, XCircle, Users2, AlertTriangle,
} from "lucide-react";
import { adminListDevelopers, adminUpdateDeveloperStatus } from "@/services/api";
import DeveloperDetail from "./DeveloperDetail";

interface DeveloperRow {
  id: string;
  email: string;
  name: string | null;
  phone: string | null;
  is_active: boolean;
  account_type: string | null;
  company_name: string | null;
  gst_number: string | null;
  kyc_status: string | null;
  status: string;
  wallet_balance: number;
  created_at: string | null;
}

const PAGE_SIZE = 10;

const statusBadgeClass: Record<string, string> = {
  active: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
  suspended: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  blocked: "bg-red-500/15 text-red-400 border-red-500/30",
};

const kycBadgeClass: Record<string, string> = {
  approved: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
  pending: "bg-amber-500/15 text-amber-400 border-amber-500/30",
  rejected: "bg-red-500/15 text-red-400 border-red-500/30",
};

export default function DevelopersManager() {
  const [rows, setRows] = useState<DeveloperRow[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [accountTypeFilter, setAccountTypeFilter] = useState("all");
  const [kycFilter, setKycFilter] = useState("all");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [detailId, setDetailId] = useState<string | null>(null);
  const [confirmAction, setConfirmAction] = useState<{ id: string; status: string } | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const params: Record<string, any> = { skip: page * PAGE_SIZE, limit: PAGE_SIZE };
      if (search.trim()) params.search = search.trim();
      if (statusFilter !== "all") params.status = statusFilter;
      if (accountTypeFilter !== "all") params.account_type = accountTypeFilter;
      if (kycFilter !== "all") params.kyc_status = kycFilter;
      const { ok, data } = await adminListDevelopers(params);
      if (!ok) throw new Error(data?.detail || "Failed to load developers");
      setRows(data.developers || []);
      setTotal(data.total || 0);
    } catch (e: any) {
      setError(e?.message || "Something went wrong while loading developers.");
    } finally {
      setLoading(false);
    }
  }, [page, search, statusFilter, accountTypeFilter, kycFilter]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const toggleSelectAll = () => {
    if (selectedIds.size === rows.length) setSelectedIds(new Set());
    else setSelectedIds(new Set(rows.map((r) => r.id)));
  };
  const toggleSelect = (id: string) => {
    const next = new Set(selectedIds);
    if (next.has(id)) next.delete(id);
    else next.add(id);
    setSelectedIds(next);
  };

  const applyStatus = async (id: string, status: string) => {
    await adminUpdateDeveloperStatus(id, status);
    setConfirmAction(null);
    fetchData();
  };

  const bulkSuspend = async () => {
    await Promise.all(Array.from(selectedIds).map((id) => adminUpdateDeveloperStatus(id, "suspended")));
    setSelectedIds(new Set());
    fetchData();
  };

  const clearFilters = () => {
    setSearch("");
    setStatusFilter("all");
    setAccountTypeFilter("all");
    setKycFilter("all");
    setPage(0);
  };

  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  const rangeStart = total === 0 ? 0 : page * PAGE_SIZE + 1;
  const rangeEnd = Math.min(total, (page + 1) * PAGE_SIZE);

  return (
    <div className="space-y-4">
      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <CardTitle className="flex items-center gap-2 text-lg">
              <Users2 className="h-5 w-5 text-primary" /> Developers
            </CardTitle>
            <p className="mt-1 text-sm text-muted-foreground">
              {total} total &middot; full control over accounts, KYC, keys, subscriptions &amp; wallets
            </p>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <div className="relative w-full sm:w-64">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search name, email, company..."
                value={search}
                onChange={(e) => {
                  setPage(0);
                  setSearch(e.target.value);
                }}
                className="w-full pl-8"
              />
            </div>
            <Select value={statusFilter} onValueChange={(v) => { setPage(0); setStatusFilter(v); }}>
              <SelectTrigger className="w-32"><SelectValue placeholder="Status" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All statuses</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="suspended">Suspended</SelectItem>
                <SelectItem value="blocked">Blocked</SelectItem>
              </SelectContent>
            </Select>
            <Select value={accountTypeFilter} onValueChange={(v) => { setPage(0); setAccountTypeFilter(v); }}>
              <SelectTrigger className="w-32"><SelectValue placeholder="Type" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All types</SelectItem>
                <SelectItem value="business">Business</SelectItem>
                <SelectItem value="individual">Individual</SelectItem>
              </SelectContent>
            </Select>
            <Select value={kycFilter} onValueChange={(v) => { setPage(0); setKycFilter(v); }}>
              <SelectTrigger className="w-32"><SelectValue placeholder="KYC" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All KYC</SelectItem>
                <SelectItem value="pending">Pending</SelectItem>
                <SelectItem value="approved">Approved</SelectItem>
                <SelectItem value="rejected">Rejected</SelectItem>
              </SelectContent>
            </Select>
            <Button variant="outline" size="icon" onClick={fetchData} title="Refresh">
              <RefreshCw className="h-4 w-4" />
            </Button>
          </div>
        </CardHeader>

        <CardContent>
          {selectedIds.size > 0 && (
            <div className="mb-3 flex flex-wrap items-center justify-between gap-2 rounded-lg border border-border/60 bg-muted/30 px-3 py-2">
              <span className="text-sm">{selectedIds.size} selected</span>
              <div className="flex flex-wrap gap-2">
                <Button size="sm" variant="outline" onClick={bulkSuspend}>
                  <Ban className="mr-1 h-3.5 w-3.5" /> Suspend selected
                </Button>
                <Button size="sm" variant="ghost" onClick={() => setSelectedIds(new Set())}>Clear</Button>
              </div>
            </div>
          )}

          {error && (
            <div className="mb-3 flex flex-wrap items-center justify-between gap-2 rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
              <span className="flex items-center gap-2"><AlertTriangle className="h-4 w-4" /> {error}</span>
              <Button size="sm" variant="outline" onClick={fetchData}>Retry</Button>
            </div>
          )}

          {loading ? (
            <div className="space-y-2">
              {Array.from({ length: 6 }).map((_, i) => (
                <Skeleton key={i} className="h-12 w-full rounded-lg" />
              ))}
            </div>
          ) : rows.length === 0 && !error ? (
            <div className="flex flex-col items-center justify-center gap-3 py-16 text-center">
              <Users2 className="h-10 w-10 text-muted-foreground/50" />
              <p className="text-muted-foreground">No developers match these filters yet.</p>
              <Button variant="outline" onClick={clearFilters}>Clear filters</Button>
            </div>
          ) : (
            <>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-8">
                      <input
                        type="checkbox"
                        checked={selectedIds.size === rows.length && rows.length > 0}
                        onChange={toggleSelectAll}
                        aria-label="Select all"
                      />
                    </TableHead>
                    <TableHead>Developer</TableHead>
                    <TableHead>Type</TableHead>
                    <TableHead>GST</TableHead>
                    <TableHead>KYC</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Wallet</TableHead>
                    <TableHead>Joined</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {rows.map((dev) => (
                    <TableRow key={dev.id}>
                      <TableCell>
                        <input
                          type="checkbox"
                          checked={selectedIds.has(dev.id)}
                          onChange={() => toggleSelect(dev.id)}
                          aria-label={`Select ${dev.email}`}
                        />
                      </TableCell>
                      <TableCell>
                        <div className="font-medium">{dev.company_name || dev.name || "—"}</div>
                        <div className="text-xs text-muted-foreground">{dev.email}</div>
                      </TableCell>
                      <TableCell className="capitalize">{dev.account_type || "—"}</TableCell>
                      <TableCell className="text-xs">{dev.gst_number || "—"}</TableCell>
                      <TableCell>
                        <Badge variant="outline" className={kycBadgeClass[dev.kyc_status || ""] || ""}>
                          {dev.kyc_status || "—"}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline" className={statusBadgeClass[dev.status] || ""}>
                          {dev.status}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">&#8377;{dev.wallet_balance.toFixed(2)}</TableCell>
                      <TableCell className="text-xs text-muted-foreground">
                        {dev.created_at ? new Date(dev.created_at).toLocaleDateString() : "—"}
                      </TableCell>
                      <TableCell className="text-right">
                        <TooltipProvider>
                          <div className="flex justify-end gap-1">
                            <Tooltip>
                              <TooltipTrigger asChild>
                                <Button size="icon" variant="ghost" onClick={() => setDetailId(dev.id)}>
                                  <Eye className="h-4 w-4" />
                                </Button>
                              </TooltipTrigger>
                              <TooltipContent>View details</TooltipContent>
                            </Tooltip>
                            {dev.status !== "active" ? (
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <Button size="icon" variant="ghost" onClick={() => applyStatus(dev.id, "active")}>
                                    <PlayCircle className="h-4 w-4 text-emerald-400" />
                                  </Button>
                                </TooltipTrigger>
                                <TooltipContent>Activate</TooltipContent>
                              </Tooltip>
                            ) : (
                              <Tooltip>
                                <TooltipTrigger asChild>
                                  <Button
                                    size="icon"
                                    variant="ghost"
                                    onClick={() => setConfirmAction({ id: dev.id, status: "suspended" })}
                                  >
                                    <Ban className="h-4 w-4 text-amber-400" />
                                  </Button>
                                </TooltipTrigger>
                                <TooltipContent>Suspend</TooltipContent>
                              </Tooltip>
                            )}
                            <Tooltip>
                              <TooltipTrigger asChild>
                                <Button
                                  size="icon"
                                  variant="ghost"
                                  onClick={() => setConfirmAction({ id: dev.id, status: "blocked" })}
                                >
                                  <XCircle className="h-4 w-4 text-red-400" />
                                </Button>
                              </TooltipTrigger>
                              <TooltipContent>Block</TooltipContent>
                            </Tooltip>
                          </div>
                        </TooltipProvider>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              <div className="flex items-center justify-between pt-4 text-sm text-muted-foreground">
                <span>Showing {rangeStart}-{rangeEnd} of {total}</span>
                <div className="flex items-center gap-2">
                  <Button size="sm" variant="outline" disabled={page === 0} onClick={() => setPage((p) => Math.max(0, p - 1))}>
                    Previous
                  </Button>
                  <span>Page {page + 1} of {totalPages}</span>
                  <Button
                    size="sm"
                    variant="outline"
                    disabled={page + 1 >= totalPages}
                    onClick={() => setPage((p) => p + 1)}
                  >
                    Next
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      <AlertDialog open={!!confirmAction} onOpenChange={(open) => !open && setConfirmAction(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>
              {confirmAction?.status === "blocked" ? "Block this developer?" : "Suspend this developer?"}
            </AlertDialogTitle>
            <AlertDialogDescription>
              {confirmAction?.status === "blocked"
                ? "The developer will lose all API access immediately. This can be reversed later."
                : "The developer's API keys will stop authenticating until reactivated."}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction onClick={() => confirmAction && applyStatus(confirmAction.id, confirmAction.status)}>
              Confirm
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {detailId && (
        <DeveloperDetail developerId={detailId} onClose={() => setDetailId(null)} onChanged={fetchData} />
      )}
    </div>
  );
}
