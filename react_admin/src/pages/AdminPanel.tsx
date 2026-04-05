import { useState, useEffect, useCallback } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import StarField from "@/components/StarField";
import {
  Users, Star, Wallet, Settings, LogOut, Search, BarChart3,
  Shield, Ban, CheckCircle, DollarSign, TrendingUp, Eye,
  Video, Gift, Radio, RefreshCw, Plus, Pencil, Phone, MessageCircle,
  ChevronLeft, ChevronRight, PlusCircle, MinusCircle, Sparkles, X,
  FileText, Mail, Filter,
} from "lucide-react";
import {
  fetchAstrologers, fetchServicePricing, fetchGiftPricing,
  fetchAgoraConfigs, createAgoraConfig, updateAgoraConfig,
  seedServicePricing, seedGiftPricing, seedOpen, updateServicePricing,
  adminListUsers, adminAdjustWallet, adminToggleUser, adminGetUser,
  type WalletAction,
} from "@/services/api";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";

const BASE = "https://api.nakshatralogy.com/api/v1";

function authHeaders() {
  const token = localStorage.getItem("access_token");
  return {
    "Content-Type": "application/json",
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

type Tab = "overview" | "users" | "astrologers" | "wallet" | "pricing" | "agora" | "gifts" | "settings";

const AdminPanel = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("overview");
  const [searchQuery, setSearchQuery] = useState("");

  // data states
  const [stats, setStats] = useState<any>(null);
  const [users, setUsers] = useState<any[]>([]);
  const [usersTotal, setUsersTotal] = useState(0);
  const [astrologers, setAstrologers] = useState<any[]>([]);
  const [walletStats, setWalletStats] = useState<any>(null);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [pricing, setPricing] = useState<any[]>([]);
  const [gifts, setGifts] = useState<any[]>([]);
  const [agoraConfigs, setAgoraConfigs] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  // agora form
  const [agoraForm, setAgoraForm] = useState({ label: "", app_id: "", app_certificate: "", is_active: true });
  const [showAgoraForm, setShowAgoraForm] = useState(false);

  // pricing edit
  const [editPricing, setEditPricing] = useState<any>(null);

  // ── User Management state ────────────────────────────────────────
  const USERS_PAGE_SIZE = 10;
  const [userPage, setUserPage] = useState(0);
  const [userFilterStatus, setUserFilterStatus] = useState<string>("all"); // all | active | blocked
  const [userFilterRole, setUserFilterRole] = useState<string>("user");    // user | astrologer | admin | all

  // Wallet action dialog
  const [walletDialog, setWalletDialog] = useState<{
    open: boolean; user: any; action: WalletAction;
  }>({ open: false, user: null, action: "add_fund" });
  const [walletAmount, setWalletAmount] = useState<string>("");
  const [walletReason, setWalletReason] = useState<string>("");
  const [walletSubmitting, setWalletSubmitting] = useState(false);

  // User detail dialog
  const [userDetail, setUserDetail] = useState<any>(null);
  const [userDetailLoading, setUserDetailLoading] = useState(false);

  if (!user) { navigate("/auth"); return null; }

  const tabs = [
    { id: "overview" as Tab, icon: <BarChart3 className="w-5 h-5" />, label: "Overview" },
    { id: "users" as Tab, icon: <Users className="w-5 h-5" />, label: "Users" },
    { id: "astrologers" as Tab, icon: <Star className="w-5 h-5" />, label: "Astrologers" },
    { id: "wallet" as Tab, icon: <Wallet className="w-5 h-5" />, label: "Wallet" },
    { id: "pricing" as Tab, icon: <DollarSign className="w-5 h-5" />, label: "Pricing" },
    { id: "gifts" as Tab, icon: <Gift className="w-5 h-5" />, label: "Gifts" },
    { id: "agora" as Tab, icon: <Video className="w-5 h-5" />, label: "Agora" },
    { id: "settings" as Tab, icon: <Settings className="w-5 h-5" />, label: "Settings" },
  ];

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      if (activeTab === "overview") {
        const r = await fetch(`${BASE}/admin/stats`, { headers: authHeaders() });
        if (r.ok) setStats(await r.json());
        const t = await fetch(`${BASE}/admin/transactions?limit=5`, { headers: authHeaders() });
        if (t.ok) { const d = await t.json(); setTransactions(d.transactions || []); }
      }
      if (activeTab === "users") {
        const params: Record<string, any> = {
          skip: userPage * USERS_PAGE_SIZE,
          limit: USERS_PAGE_SIZE,
        };
        if (userFilterRole && userFilterRole !== "all") params.role = userFilterRole;
        if (userFilterStatus === "active") params.is_active = true;
        else if (userFilterStatus === "blocked") params.is_active = false;
        if (searchQuery) params.search = searchQuery;
        const { data } = await adminListUsers(params);
        setUsers(data.users || []);
        setUsersTotal(data.total || 0);
      }
      if (activeTab === "astrologers") {
        const r = await fetch(`${BASE}/admin/astrologers?limit=100${searchQuery ? `&search=${searchQuery}` : ""}`, { headers: authHeaders() });
        if (r.ok) { const d = await r.json(); setAstrologers(d.astrologers || []); }
      }
      if (activeTab === "wallet") {
        const r = await fetch(`${BASE}/admin/wallet-stats`, { headers: authHeaders() });
        if (r.ok) setWalletStats(await r.json());
        const t = await fetch(`${BASE}/admin/transactions?limit=20`, { headers: authHeaders() });
        if (t.ok) { const d = await t.json(); setTransactions(d.transactions || []); }
      }
      if (activeTab === "pricing") {
        const { data } = await fetchServicePricing();
        if (Array.isArray(data)) setPricing(data);
      }
      if (activeTab === "gifts") {
        const { data } = await fetchGiftPricing();
        if (Array.isArray(data)) setGifts(data);
      }
      if (activeTab === "agora") {
        const { data } = await fetchAgoraConfigs();
        if (Array.isArray(data)) setAgoraConfigs(data);
      }
    } catch (e) { console.error(e); }
    setLoading(false);
  }, [activeTab, searchQuery, userPage, userFilterStatus, userFilterRole]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // Reset page to 0 when filters change
  useEffect(() => { setUserPage(0); }, [userFilterStatus, userFilterRole, searchQuery]);

  const toggleUser = async (userId: string) => {
    await adminToggleUser(userId);
    fetchData();
  };

  // ── Wallet action (add fund / remove fund / bonus) ─────────────
  const openWalletDialog = (u: any, action: WalletAction) => {
    setWalletAmount("");
    setWalletReason("");
    setWalletDialog({ open: true, user: u, action });
  };

  const closeWalletDialog = () => {
    setWalletDialog({ open: false, user: null, action: "add_fund" });
    setWalletAmount("");
    setWalletReason("");
  };

  const submitWalletAction = async () => {
    const amt = parseFloat(walletAmount);
    if (!walletDialog.user || isNaN(amt) || amt <= 0) {
      alert("Enter a valid amount greater than 0");
      return;
    }
    if (!walletReason.trim()) {
      alert("Reason is required (creates statement entry)");
      return;
    }
    setWalletSubmitting(true);
    try {
      const { ok, data } = await adminAdjustWallet(
        walletDialog.user.id,
        walletDialog.action,
        amt,
        walletReason.trim(),
      );
      if (!ok) {
        alert(data.detail || "Adjustment failed");
      } else {
        closeWalletDialog();
        fetchData();
      }
    } finally {
      setWalletSubmitting(false);
    }
  };

  const openUserDetail = async (userId: string) => {
    setUserDetailLoading(true);
    setUserDetail({ id: userId, _loading: true });
    try {
      const { ok, data } = await adminGetUser(userId);
      if (ok) setUserDetail(data);
      else setUserDetail(null);
    } finally {
      setUserDetailLoading(false);
    }
  };

  const approveAstrologer = async (profileId: string) => {
    await fetch(`${BASE}/admin/astrologers/${profileId}/approve`, { method: "PATCH", headers: authHeaders() });
    fetchData();
  };

  const blockAstrologer = async (profileId: string) => {
    await fetch(`${BASE}/admin/astrologers/${profileId}/block`, { method: "PATCH", headers: authHeaders() });
    fetchData();
  };

  const handleSeedPricing = async () => {
    await seedServicePricing();
    fetchData();
  };

  const handleSeedGifts = async () => {
    await seedGiftPricing();
    fetchData();
  };

  const handleSeedAll = async () => {
    await seedOpen();
    fetchData();
  };

  const saveAgoraConfig = async () => {
    await createAgoraConfig(agoraForm);
    setShowAgoraForm(false);
    setAgoraForm({ label: "", app_id: "", app_certificate: "", is_active: true });
    fetchData();
  };

  const toggleAgoraActive = async (id: string, isActive: boolean) => {
    await updateAgoraConfig(id, { is_active: isActive });
    fetchData();
  };

  const savePricingEdit = async () => {
    if (!editPricing) return;
    await updateServicePricing(editPricing.id, {
      price: editPricing.price,
      original_price: editPricing.original_price,
      is_free: editPricing.price === 0,
      is_active: editPricing.is_active,
    });
    setEditPricing(null);
    fetchData();
  };

  const fmt = (n: number) => new Intl.NumberFormat("en-IN").format(n);

  return (
    <div className="min-h-screen gradient-mystic relative">
      <StarField />
      <div className="relative z-10 flex min-h-screen">
        {/* Sidebar */}
        <aside className="hidden md:flex flex-col w-64 bg-card/50 backdrop-blur-lg border-r border-border p-4">
          <div className="flex items-center gap-2 mb-8">
            <Shield className="w-6 h-6 text-primary" />
            <span className="font-display text-gold-gradient text-lg">Admin Panel</span>
          </div>
          <nav className="space-y-1 flex-1">
            {tabs.map((tab) => (
              <button key={tab.id} onClick={() => { setActiveTab(tab.id); setSearchQuery(""); }}
                className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-all ${activeTab === tab.id ? "bg-primary/10 text-primary font-medium" : "text-muted-foreground hover:text-foreground hover:bg-muted/50"}`}>
                {tab.icon} {tab.label}
              </button>
            ))}
          </nav>
          <Button variant="outline" className="border-destructive text-destructive mt-auto" onClick={() => { logout(); navigate("/"); }}>
            <LogOut className="w-4 h-4 mr-2" /> Logout
          </Button>
        </aside>

        {/* Main */}
        <main className="flex-1 overflow-auto pb-20 md:pb-4">
          <header className="p-4 border-b border-border bg-card/30 backdrop-blur-sm flex items-center justify-between">
            <h1 className="text-lg font-display text-foreground capitalize">{activeTab}</h1>
            <div className="flex items-center gap-2">
              <Button size="sm" variant="outline" className="border-border text-muted-foreground h-8" onClick={fetchData} disabled={loading}>
                <RefreshCw className={`w-3 h-3 mr-1 ${loading ? "animate-spin" : ""}`} /> Refresh
              </Button>
              <Badge className="gradient-gold text-primary-foreground">Admin</Badge>
            </div>
          </header>

          <div className="p-4">
            {/* ══════ OVERVIEW ══════ */}
            {activeTab === "overview" && (
              <div className="space-y-6">
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {[
                    { label: "Total Users", value: stats?.total_users ?? "—", icon: <Users className="w-5 h-5" /> },
                    { label: "Astrologers", value: stats?.total_astrologers ?? "—", icon: <Star className="w-5 h-5" /> },
                    { label: "Revenue", value: stats ? `₹${fmt(stats.total_revenue)}` : "—", icon: <TrendingUp className="w-5 h-5" /> },
                    { label: "Active Sessions", value: stats?.active_sessions ?? "—", icon: <Eye className="w-5 h-5" /> },
                  ].map((s) => (
                    <div key={s.label} className="bg-card/60 border border-border rounded-xl p-4">
                      <div className="flex items-center justify-between mb-2"><span className="text-primary">{s.icon}</span></div>
                      <p className="text-xl font-semibold text-foreground">{s.value}</p>
                      <p className="text-xs text-muted-foreground">{s.label}</p>
                    </div>
                  ))}
                </div>
                <div className="flex gap-2">
                  <Button size="sm" onClick={handleSeedAll} className="gradient-gold text-primary-foreground">
                    <Plus className="w-3 h-3 mr-1" /> Seed All Demo Data
                  </Button>
                  <Button size="sm" variant="outline" onClick={handleSeedPricing} className="border-primary text-primary">Seed Pricing</Button>
                  <Button size="sm" variant="outline" onClick={handleSeedGifts} className="border-primary text-primary">Seed Gifts</Button>
                </div>
                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">Recent Transactions</h3>
                  <div className="space-y-2">
                    {transactions.length === 0 && <p className="text-sm text-muted-foreground">No transactions yet. Seed demo data to populate.</p>}
                    {transactions.map((t: any) => (
                      <div key={t.id} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                        <div>
                          <p className="text-sm text-foreground">{t.description || t.txn_type}</p>
                          <p className="text-xs text-muted-foreground">{t.user_name} • {t.created_at?.slice(0, 10)}</p>
                        </div>
                        <span className={`text-sm font-semibold ${t.txn_type?.includes("credit") || t.txn_type === "recharge" ? "text-green-400" : "text-destructive"}`}>
                          {t.txn_type?.includes("credit") || t.txn_type === "recharge" ? "+" : "-"}₹{t.amount}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* ══════ USERS ══════ */}
            {activeTab === "users" && (
              <div className="space-y-4">
                {/* Filters */}
                <div className="flex flex-col md:flex-row gap-2">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <Input
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      placeholder="Search by name, email, phone..."
                      className="pl-10 bg-muted border-border"
                    />
                  </div>
                  <Select value={userFilterRole} onValueChange={setUserFilterRole}>
                    <SelectTrigger className="w-full md:w-40 bg-muted border-border">
                      <SelectValue placeholder="Role" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Roles</SelectItem>
                      <SelectItem value="user">User</SelectItem>
                      <SelectItem value="astrologer">Astrologer</SelectItem>
                      <SelectItem value="admin">Admin</SelectItem>
                    </SelectContent>
                  </Select>
                  <Select value={userFilterStatus} onValueChange={setUserFilterStatus}>
                    <SelectTrigger className="w-full md:w-40 bg-muted border-border">
                      <SelectValue placeholder="Status" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Status</SelectItem>
                      <SelectItem value="active">Active</SelectItem>
                      <SelectItem value="blocked">Blocked</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Summary & Pagination info */}
                <div className="flex items-center justify-between">
                  <p className="text-xs text-muted-foreground">
                    Showing {users.length} of {usersTotal} users
                    {userFilterRole !== "all" && <> · Role: <span className="text-primary">{userFilterRole}</span></>}
                    {userFilterStatus !== "all" && <> · Status: <span className="text-primary">{userFilterStatus}</span></>}
                  </p>
                </div>

                {/* Users table */}
                <div className="bg-card/60 border border-border rounded-xl overflow-hidden">
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b border-border bg-muted/30">
                          <th className="text-left p-3 text-muted-foreground font-medium">Name</th>
                          <th className="text-left p-3 text-muted-foreground font-medium hidden md:table-cell">Email</th>
                          <th className="text-left p-3 text-muted-foreground font-medium hidden lg:table-cell">Phone</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Role</th>
                          <th className="text-right p-3 text-muted-foreground font-medium">Balance</th>
                          <th className="text-center p-3 text-muted-foreground font-medium">Status</th>
                          <th className="text-center p-3 text-muted-foreground font-medium">Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {users.length === 0 && (
                          <tr>
                            <td colSpan={7} className="p-8 text-center text-muted-foreground text-sm">
                              No users found. Adjust filters or run seed.
                            </td>
                          </tr>
                        )}
                        {users.map((u: any) => (
                          <tr key={u.id} className="border-b border-border last:border-0 hover:bg-muted/20">
                            <td className="p-3 text-foreground font-medium">{u.name || "—"}</td>
                            <td className="p-3 text-muted-foreground hidden md:table-cell">{u.email}</td>
                            <td className="p-3 text-muted-foreground hidden lg:table-cell">{u.phone || "—"}</td>
                            <td className="p-3">
                              <Badge variant="outline" className="border-border text-xs capitalize">
                                {u.role}
                              </Badge>
                            </td>
                            <td className="p-3 text-primary font-semibold text-right">₹{u.wallet_balance}</td>
                            <td className="p-3 text-center">
                              <Badge className={u.is_active ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>
                                {u.is_active ? "active" : "blocked"}
                              </Badge>
                            </td>
                            <td className="p-3">
                              <div className="flex gap-1 justify-center flex-wrap">
                                <Button
                                  size="sm" variant="outline"
                                  onClick={() => openUserDetail(u.id)}
                                  className="h-7 text-xs border-border"
                                  title="View details"
                                >
                                  <Eye className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="sm" variant="outline"
                                  onClick={() => openWalletDialog(u, "add_fund")}
                                  className="h-7 text-xs border-green-500/50 text-green-400 hover:bg-green-500/10"
                                  title="Add funds"
                                >
                                  <PlusCircle className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="sm" variant="outline"
                                  onClick={() => openWalletDialog(u, "remove_fund")}
                                  className="h-7 text-xs border-orange-500/50 text-orange-400 hover:bg-orange-500/10"
                                  title="Remove funds"
                                >
                                  <MinusCircle className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="sm" variant="outline"
                                  onClick={() => openWalletDialog(u, "bonus")}
                                  className="h-7 text-xs border-primary/50 text-primary hover:bg-primary/10"
                                  title="Give bonus"
                                >
                                  <Sparkles className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="sm" variant="outline"
                                  onClick={() => toggleUser(u.id)}
                                  className={`h-7 text-xs ${u.is_active ? "border-destructive text-destructive hover:bg-destructive/10" : "border-green-500 text-green-400 hover:bg-green-500/10"}`}
                                  title={u.is_active ? "Block user" : "Activate user"}
                                >
                                  {u.is_active ? <Ban className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
                                </Button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                {/* Pagination */}
                {usersTotal > USERS_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {userPage + 1} of {Math.max(1, Math.ceil(usersTotal / USERS_PAGE_SIZE))}
                    </p>
                    <div className="flex gap-2">
                      <Button
                        size="sm" variant="outline"
                        onClick={() => setUserPage((p) => Math.max(0, p - 1))}
                        disabled={userPage === 0}
                        className="h-8 border-border"
                      >
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button
                        size="sm" variant="outline"
                        onClick={() => setUserPage((p) => p + 1)}
                        disabled={(userPage + 1) * USERS_PAGE_SIZE >= usersTotal}
                        className="h-8 border-border"
                      >
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* ══════ Wallet Action Dialog ══════ */}
            <Dialog open={walletDialog.open} onOpenChange={(v) => !v && closeWalletDialog()}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    {walletDialog.action === "add_fund" && <><PlusCircle className="w-5 h-5 text-green-400" /> Add Funds</>}
                    {walletDialog.action === "remove_fund" && <><MinusCircle className="w-5 h-5 text-orange-400" /> Remove Funds</>}
                    {walletDialog.action === "bonus" && <><Sparkles className="w-5 h-5 text-primary" /> Give Bonus</>}
                  </DialogTitle>
                </DialogHeader>
                {walletDialog.user && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">{walletDialog.user.name || "—"}</p>
                      <p className="text-xs text-muted-foreground">{walletDialog.user.email}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Current balance: <span className="text-primary font-semibold">₹{walletDialog.user.wallet_balance}</span>
                      </p>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Amount (₹)</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={walletAmount}
                        onChange={(e) => setWalletAmount(e.target.value)}
                        placeholder="Enter amount"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80">Reason (creates statement entry)</Label>
                      <Textarea
                        value={walletReason}
                        onChange={(e) => setWalletReason(e.target.value)}
                        placeholder={
                          walletDialog.action === "add_fund" ? "e.g. Manual recharge - user paid via UPI" :
                          walletDialog.action === "remove_fund" ? "e.g. Refund reversal due to dispute" :
                          "e.g. Festival bonus / loyalty reward"
                        }
                        className="bg-muted border-border mt-1 min-h-[80px]"
                      />
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={closeWalletDialog} disabled={walletSubmitting}>
                    Cancel
                  </Button>
                  <Button
                    onClick={submitWalletAction}
                    disabled={walletSubmitting}
                    className="gradient-gold text-primary-foreground"
                  >
                    {walletSubmitting ? "Processing..." : `Confirm ${walletDialog.action.replace("_", " ")}`}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ User Detail Dialog ══════ */}
            <Dialog open={userDetail !== null} onOpenChange={(v) => !v && setUserDetail(null)}>
              <DialogContent className="bg-card border-border max-w-2xl max-h-[85vh] overflow-y-auto">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <FileText className="w-5 h-5 text-primary" /> User Details
                  </DialogTitle>
                </DialogHeader>
                {userDetailLoading || userDetail?._loading ? (
                  <div className="py-8 text-center text-muted-foreground">Loading...</div>
                ) : userDetail ? (
                  <div className="space-y-4 py-2">
                    <div className="grid grid-cols-2 gap-3 text-sm">
                      <div><span className="text-muted-foreground">Name:</span> <span className="text-foreground">{userDetail.name || "—"}</span></div>
                      <div><span className="text-muted-foreground">Role:</span> <span className="text-foreground capitalize">{userDetail.role}</span></div>
                      <div><span className="text-muted-foreground">Email:</span> <span className="text-foreground">{userDetail.email}</span></div>
                      <div><span className="text-muted-foreground">Phone:</span> <span className="text-foreground">{userDetail.phone || "—"}</span></div>
                      <div><span className="text-muted-foreground">DOB:</span> <span className="text-foreground">{userDetail.dob || "—"}</span></div>
                      <div><span className="text-muted-foreground">Birth Place:</span> <span className="text-foreground">{userDetail.birth_place || "—"}</span></div>
                      <div><span className="text-muted-foreground">Balance:</span> <span className="text-primary font-semibold">₹{userDetail.wallet_balance}</span></div>
                      <div><span className="text-muted-foreground">Status:</span> <Badge className={userDetail.is_active ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>{userDetail.is_active ? "active" : "blocked"}</Badge></div>
                      <div className="col-span-2"><span className="text-muted-foreground">Created:</span> <span className="text-foreground">{userDetail.created_at?.slice(0, 16) || "—"}</span></div>
                    </div>

                    <div>
                      <h3 className="text-sm font-semibold text-primary mb-2">Wallet Statement (last 30)</h3>
                      <div className="bg-muted/30 rounded-lg border border-border max-h-72 overflow-y-auto">
                        {!userDetail.transactions?.length ? (
                          <p className="p-4 text-sm text-muted-foreground text-center">No transactions yet</p>
                        ) : (
                          <table className="w-full text-xs">
                            <thead className="sticky top-0 bg-muted/80">
                              <tr className="border-b border-border">
                                <th className="text-left p-2 text-muted-foreground">Type</th>
                                <th className="text-left p-2 text-muted-foreground">Description</th>
                                <th className="text-right p-2 text-muted-foreground">Amount</th>
                                <th className="text-right p-2 text-muted-foreground">After</th>
                                <th className="text-left p-2 text-muted-foreground">Date</th>
                              </tr>
                            </thead>
                            <tbody>
                              {userDetail.transactions.map((t: any) => {
                                const isCredit = t.txn_type?.includes("credit") || t.txn_type === "recharge" || t.txn_type === "bonus";
                                return (
                                  <tr key={t.id} className="border-b border-border/50 last:border-0">
                                    <td className="p-2">
                                      <Badge variant="outline" className="border-border text-[10px] capitalize">
                                        {t.txn_type?.replace(/_/g, " ")}
                                      </Badge>
                                    </td>
                                    <td className="p-2 text-foreground text-[11px] max-w-[200px] truncate" title={t.description}>
                                      {t.description || "—"}
                                    </td>
                                    <td className={`p-2 text-right font-semibold ${isCredit ? "text-green-400" : "text-destructive"}`}>
                                      {isCredit ? "+" : "-"}₹{t.amount}
                                    </td>
                                    <td className="p-2 text-right text-primary">₹{t.balance_after}</td>
                                    <td className="p-2 text-muted-foreground text-[10px]">{t.created_at?.slice(0, 16) || "—"}</td>
                                  </tr>
                                );
                              })}
                            </tbody>
                          </table>
                        )}
                      </div>
                    </div>
                  </div>
                ) : null}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setUserDetail(null)}>Close</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ ASTROLOGERS ══════ */}
            {activeTab === "astrologers" && (
              <div className="space-y-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder="Search astrologers..."
                    className="pl-10 bg-muted border-border" onKeyDown={(e) => e.key === "Enter" && fetchData()} />
                </div>
                <div className="grid md:grid-cols-2 gap-4">
                  {astrologers.map((a: any) => (
                    <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl">🔮</div>
                        <div className="flex-1 min-w-0">
                          <h4 className="font-semibold text-foreground truncate">{a.display_name}</h4>
                          <p className="text-xs text-muted-foreground truncate">{a.email}</p>
                          <p className="text-xs text-primary">{(a.specializations || []).join(", ")}</p>
                        </div>
                        <div className="flex flex-col items-end gap-1">
                          <Badge className={a.is_approved ? "bg-green-500/20 text-green-400" : "bg-yellow-500/20 text-yellow-400"}>
                            {a.is_approved ? "Approved" : "Pending"}
                          </Badge>
                          {a.is_online && <Badge className="bg-green-500/20 text-green-400 text-[10px]">Online</Badge>}
                        </div>
                      </div>
                      <div className="grid grid-cols-4 gap-2 mt-3 text-center">
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">⭐ {a.rating}</p>
                          <p className="text-[10px] text-muted-foreground">Rating</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">{a.total_consultations}</p>
                          <p className="text-[10px] text-muted-foreground">Sessions</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">{a.commission_pct}%</p>
                          <p className="text-[10px] text-muted-foreground">Commission</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-primary">₹{a.wallet_balance}</p>
                          <p className="text-[10px] text-muted-foreground">Wallet</p>
                        </div>
                      </div>
                      <div className="grid grid-cols-3 gap-1 mt-2 text-center text-[10px] text-muted-foreground">
                        <span><MessageCircle className="w-3 h-3 inline" /> ₹{a.rate_per_min_chat}/m</span>
                        <span><Phone className="w-3 h-3 inline" /> ₹{a.rate_per_min_call}/m</span>
                        <span><Video className="w-3 h-3 inline" /> ₹{a.rate_per_min_video}/m</span>
                      </div>
                      <div className="flex gap-2 mt-3">
                        {!a.is_approved && (
                          <Button size="sm" className="flex-1 gradient-gold text-primary-foreground text-xs" onClick={() => approveAstrologer(a.id)}>
                            <CheckCircle className="w-3 h-3 mr-1" /> Approve
                          </Button>
                        )}
                        <Button size="sm" variant="outline" onClick={() => blockAstrologer(a.id)}
                          className={`flex-1 text-xs ${a.is_active ? "border-destructive text-destructive" : "border-green-500 text-green-400"}`}>
                          {a.is_active ? <><Ban className="w-3 h-3 mr-1" />Block</> : <><CheckCircle className="w-3 h-3 mr-1" />Unblock</>}
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* ══════ WALLET ══════ */}
            {activeTab === "wallet" && (
              <div className="space-y-6">
                <div className="grid md:grid-cols-3 gap-4">
                  {[
                    { label: "User Wallets", value: walletStats ? `₹${fmt(walletStats.total_user_wallets)}` : "—", cls: "glow-gold" },
                    { label: "Astrologer Wallets", value: walletStats ? `₹${fmt(walletStats.total_astro_wallets)}` : "—", cls: "" },
                    { label: "Total Recharges", value: walletStats ? `₹${fmt(walletStats.total_recharges)}` : "—", cls: "" },
                  ].map((s) => (
                    <div key={s.label} className={`bg-card/60 border border-border rounded-xl p-4 text-center ${s.cls}`}>
                      <p className="text-sm text-muted-foreground">{s.label}</p>
                      <p className="text-3xl font-display text-gold-gradient mt-2">{s.value}</p>
                    </div>
                  ))}
                </div>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="bg-card/60 border border-border rounded-xl p-4 text-center">
                    <p className="text-sm text-muted-foreground">Total Debits</p>
                    <p className="text-2xl font-semibold text-destructive mt-1">₹{walletStats ? fmt(walletStats.total_debits) : "—"}</p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-4 text-center">
                    <p className="text-sm text-muted-foreground">Total Credits</p>
                    <p className="text-2xl font-semibold text-green-400 mt-1">₹{walletStats ? fmt(walletStats.total_credits) : "—"}</p>
                  </div>
                </div>
                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">Recent Transactions</h3>
                  <div className="space-y-2">
                    {transactions.map((t: any) => (
                      <div key={t.id} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                        <div>
                          <p className="text-sm text-foreground">{t.description || t.txn_type}</p>
                          <p className="text-xs text-muted-foreground">{t.user_name} ({t.user_role}) • {t.created_at?.slice(0, 10)}</p>
                        </div>
                        <span className={`text-sm font-semibold ${t.txn_type?.includes("credit") || t.txn_type === "recharge" ? "text-green-400" : "text-destructive"}`}>
                          {t.txn_type?.includes("credit") || t.txn_type === "recharge" ? "+" : "-"}₹{t.amount}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* ══════ PRICING ══════ */}
            {activeTab === "pricing" && (
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Service Pricing</h2>
                  <Button size="sm" onClick={handleSeedPricing} variant="outline" className="border-primary text-primary">
                    <Plus className="w-3 h-3 mr-1" /> Seed Defaults
                  </Button>
                </div>
                {/* Edit modal */}
                {editPricing && (
                  <div className="bg-card/80 border border-primary rounded-xl p-4 space-y-3">
                    <h3 className="text-sm font-semibold text-primary">Editing: {editPricing.service_name}</h3>
                    <div className="grid grid-cols-3 gap-3">
                      <div>
                        <label className="text-xs text-muted-foreground">Price (₹)</label>
                        <Input type="number" value={editPricing.price} onChange={(e) => setEditPricing({ ...editPricing, price: Number(e.target.value) })} className="bg-muted border-border mt-1" />
                      </div>
                      <div>
                        <label className="text-xs text-muted-foreground">Original Price (₹)</label>
                        <Input type="number" value={editPricing.original_price || ""} onChange={(e) => setEditPricing({ ...editPricing, original_price: Number(e.target.value) || null })} className="bg-muted border-border mt-1" />
                      </div>
                      <div className="flex items-end gap-2">
                        <Button size="sm" className="gradient-gold text-primary-foreground" onClick={savePricingEdit}>Save</Button>
                        <Button size="sm" variant="outline" onClick={() => setEditPricing(null)}>Cancel</Button>
                      </div>
                    </div>
                  </div>
                )}
                <div className="bg-card/60 border border-border rounded-xl overflow-hidden">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b border-border">
                        <th className="text-left p-3 text-muted-foreground font-medium">Service</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Category</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Price</th>
                        <th className="text-left p-3 text-muted-foreground font-medium hidden md:table-cell">Original</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Status</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {pricing.map((p: any) => (
                        <tr key={p.id} className="border-b border-border last:border-0">
                          <td className="p-3 text-foreground">
                            <span className="mr-2">{p.icon}</span>{p.service_name}
                          </td>
                          <td className="p-3"><Badge variant="outline" className="border-border text-muted-foreground text-xs">{p.category}</Badge></td>
                          <td className="p-3 text-primary font-medium">{p.is_free ? "FREE" : `₹${p.price}`}</td>
                          <td className="p-3 text-muted-foreground hidden md:table-cell">{p.original_price ? `₹${p.original_price}` : "—"}</td>
                          <td className="p-3">
                            <Badge className={p.is_active ? "bg-green-500/20 text-green-400" : "bg-muted text-muted-foreground"}>
                              {p.is_active ? "Active" : "Inactive"}
                            </Badge>
                          </td>
                          <td className="p-3">
                            <Button size="sm" variant="outline" className="h-7 text-xs border-primary text-primary" onClick={() => setEditPricing({ ...p })}>
                              <Pencil className="w-3 h-3 mr-1" /> Edit
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* ══════ GIFTS ══════ */}
            {activeTab === "gifts" && (
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Gift Pricing (Live Stream)</h2>
                  <Button size="sm" onClick={handleSeedGifts} variant="outline" className="border-primary text-primary">
                    <Plus className="w-3 h-3 mr-1" /> Seed Defaults
                  </Button>
                </div>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                  {gifts.map((g: any) => (
                    <div key={g.id} className="bg-card/60 border border-border rounded-xl p-4 text-center">
                      <span className="text-4xl">{g.icon}</span>
                      <h4 className="text-foreground font-semibold mt-2">{g.name}</h4>
                      <p className="text-primary font-bold text-lg mt-1">₹{g.price}</p>
                      <Badge className={g.is_active ? "bg-green-500/20 text-green-400 mt-2" : "bg-muted text-muted-foreground mt-2"}>
                        {g.is_active ? "Active" : "Inactive"}
                      </Badge>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* ══════ AGORA ══════ */}
            {activeTab === "agora" && (
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Agora Configuration</h2>
                  <Button size="sm" className="gradient-gold text-primary-foreground" onClick={() => setShowAgoraForm(!showAgoraForm)}>
                    <Plus className="w-3 h-3 mr-1" /> Add Config
                  </Button>
                </div>

                {showAgoraForm && (
                  <div className="bg-card/60 border border-primary rounded-xl p-4 space-y-3">
                    <h3 className="text-sm font-semibold text-primary">New Agora Configuration</h3>
                    <div className="grid md:grid-cols-2 gap-3">
                      <div>
                        <label className="text-xs text-muted-foreground">Label</label>
                        <Input value={agoraForm.label} onChange={(e) => setAgoraForm({ ...agoraForm, label: e.target.value })}
                          placeholder="e.g. Production" className="bg-muted border-border mt-1" />
                      </div>
                      <div>
                        <label className="text-xs text-muted-foreground">App ID</label>
                        <Input value={agoraForm.app_id} onChange={(e) => setAgoraForm({ ...agoraForm, app_id: e.target.value })}
                          placeholder="Your Agora App ID" className="bg-muted border-border mt-1" />
                      </div>
                      <div>
                        <label className="text-xs text-muted-foreground">App Certificate</label>
                        <Input value={agoraForm.app_certificate} onChange={(e) => setAgoraForm({ ...agoraForm, app_certificate: e.target.value })}
                          placeholder="Your Agora App Certificate" className="bg-muted border-border mt-1" type="password" />
                      </div>
                      <div className="flex items-end gap-2">
                        <Button size="sm" className="gradient-gold text-primary-foreground" onClick={saveAgoraConfig}>Save</Button>
                        <Button size="sm" variant="outline" onClick={() => setShowAgoraForm(false)}>Cancel</Button>
                      </div>
                    </div>
                  </div>
                )}

                <div className="space-y-3">
                  {agoraConfigs.length === 0 && <p className="text-muted-foreground text-sm">No Agora configs yet. Add one or seed demo data.</p>}
                  {agoraConfigs.map((c: any) => (
                    <div key={c.id} className={`bg-card/60 border rounded-xl p-4 ${c.is_active ? "border-primary glow-gold" : "border-border"}`}>
                      <div className="flex items-center justify-between">
                        <div>
                          <h4 className="text-foreground font-semibold">{c.label}</h4>
                          <p className="text-xs text-muted-foreground mt-1">App ID: <code className="text-primary">{c.app_id}</code></p>
                          <p className="text-xs text-muted-foreground">Created: {c.created_at?.slice(0, 10)}</p>
                        </div>
                        <div className="flex items-center gap-3">
                          <div className="flex items-center gap-2">
                            <span className="text-xs text-muted-foreground">Active</span>
                            <Switch checked={c.is_active} onCheckedChange={(val) => toggleAgoraActive(c.id, val)} />
                          </div>
                          {c.is_active && <Badge className="gradient-gold text-primary-foreground">ACTIVE</Badge>}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">Agora Usage Info</h3>
                  <div className="space-y-2 text-sm text-muted-foreground">
                    <p>• Only ONE config can be active at a time</p>
                    <p>• Activating a config auto-deactivates all others</p>
                    <p>• Voice/Video calls and Live Streams use the active config</p>
                    <p>• Get credentials from <span className="text-primary">console.agora.io</span></p>
                  </div>
                </div>
              </div>
            )}

            {/* ══════ SETTINGS ══════ */}
            {activeTab === "settings" && (
              <div className="space-y-4">
                <h2 className="text-xl font-display text-gold-gradient">Platform Settings</h2>
                {[
                  { name: "General Settings", desc: "App name, logo, default commission %" },
                  { name: "Payment Gateway", desc: "Razorpay / Stripe configuration" },
                  { name: "Notification Settings", desc: "Firebase FCM push notification config" },
                  { name: "Content Management", desc: "Zodiac content, daily tips, banners" },
                  { name: "Report & Analytics", desc: "Revenue reports, user analytics" },
                  { name: "Support Tickets", desc: "View and manage user support requests" },
                ].map((item) => (
                  <div key={item.name} className="bg-card/60 border border-border rounded-lg p-4 flex items-center justify-between cursor-pointer hover:glow-gold transition-all">
                    <div>
                      <span className="text-foreground font-medium">{item.name}</span>
                      <p className="text-xs text-muted-foreground mt-0.5">{item.desc}</p>
                    </div>
                    <span className="text-muted-foreground">›</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </main>
      </div>

      {/* Mobile Nav */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-20 bg-card/90 backdrop-blur-lg border-t border-border">
        <div className="flex">
          {tabs.slice(0, 5).map((tab) => (
            <button key={tab.id} onClick={() => setActiveTab(tab.id)}
              className={`flex-1 flex flex-col items-center py-2.5 transition-colors ${activeTab === tab.id ? "text-primary" : "text-muted-foreground"}`}>
              {tab.icon}
              <span className="text-[10px] mt-0.5">{tab.label}</span>
            </button>
          ))}
        </div>
      </nav>
    </div>
  );
};

export default AdminPanel;
