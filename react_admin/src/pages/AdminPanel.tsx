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
  adminListAstrologers, adminApproveAstrologer, adminRejectAstrologer,
  adminBlockAstrologer, adminSetCommission,
  adminListKyc, adminApproveKyc, adminRejectKyc,
  adminListTransactions,
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

type Tab = "overview" | "users" | "astrologers" | "kyc" | "wallet" | "pricing" | "agora" | "gifts" | "settings";

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

  // ── Astrologer Management state ──────────────────────────────────
  const ASTRO_PAGE_SIZE = 10;
  const [astroPage, setAstroPage] = useState(0);
  const [astroTotal, setAstroTotal] = useState(0);
  const [astroFilter, setAstroFilter] = useState<string>("all"); // all | pending | approved | online
  const [astroSearch, setAstroSearch] = useState("");

  // Astrologer wallet dialog (reuses same walletDialog pattern)
  const [astroWalletDialog, setAstroWalletDialog] = useState<{
    open: boolean; astro: any; action: WalletAction;
  }>({ open: false, astro: null, action: "add_fund" });
  const [astroWalletAmount, setAstroWalletAmount] = useState<string>("");
  const [astroWalletReason, setAstroWalletReason] = useState<string>("");

  // Commission dialog
  const [commissionDialog, setCommissionDialog] = useState<{ open: boolean; astro: any }>({
    open: false, astro: null,
  });
  const [commissionValue, setCommissionValue] = useState<string>("");

  // Reject astrologer dialog
  const [rejectDialog, setRejectDialog] = useState<{ open: boolean; astro: any }>({
    open: false, astro: null,
  });
  const [rejectReason, setRejectReason] = useState<string>("");

  // Astrologer detail dialog
  const [astroDetail, setAstroDetail] = useState<any>(null);

  // ── Wallet Management state ──────────────────────────────────────
  const WALLET_PAGE_SIZE = 20;
  const [walletPage, setWalletPage] = useState(0);
  const [walletTotal, setWalletTotal] = useState(0);
  const [walletSummary, setWalletSummary] = useState<{
    total_credits: number; total_debits: number; net_flow: number;
  }>({ total_credits: 0, total_debits: 0, net_flow: 0 });
  const [walletFilterType, setWalletFilterType] = useState<string>("all");     // all | recharge | consultation_debit | consultation_credit | bonus | refund | withdrawal
  const [walletFilterRole, setWalletFilterRole] = useState<string>("all");     // all | user | astrologer | admin
  const [walletSearchTerm, setWalletSearchTerm] = useState<string>("");
  const [walletDateFrom, setWalletDateFrom] = useState<string>("");
  const [walletDateTo, setWalletDateTo] = useState<string>("");

  // ── KYC Management state ─────────────────────────────────────────
  const [kycDocs, setKycDocs] = useState<any[]>([]);
  const [kycTotal, setKycTotal] = useState(0);
  const [kycFilter, setKycFilter] = useState<string>("pending"); // all | pending | approved | rejected
  const KYC_PAGE_SIZE = 15;
  const [kycPage, setKycPage] = useState(0);

  // KYC reject dialog
  const [kycRejectDialog, setKycRejectDialog] = useState<{ open: boolean; kyc: any }>({
    open: false, kyc: null,
  });
  const [kycRejectReason, setKycRejectReason] = useState<string>("");

  // Redirect to /auth if not logged in — must use useEffect, NOT early return,
  // otherwise hook count changes between renders (violates Rules of Hooks)
  useEffect(() => {
    if (!user) navigate("/auth");
  }, [user, navigate]);

  const tabs = [
    { id: "overview" as Tab, icon: <BarChart3 className="w-5 h-5" />, label: "Overview" },
    { id: "users" as Tab, icon: <Users className="w-5 h-5" />, label: "Users" },
    { id: "astrologers" as Tab, icon: <Star className="w-5 h-5" />, label: "Astrologers" },
    { id: "kyc" as Tab, icon: <Shield className="w-5 h-5" />, label: "KYC" },
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
        const params: Record<string, any> = {
          skip: astroPage * ASTRO_PAGE_SIZE,
          limit: ASTRO_PAGE_SIZE,
        };
        if (astroSearch) params.search = astroSearch;
        if (astroFilter === "approved") params.approved_only = true;
        const { data } = await adminListAstrologers(params);
        let list = data.astrologers || [];
        // client-side filter for pending / online
        if (astroFilter === "pending") list = list.filter((a: any) => !a.is_approved);
        if (astroFilter === "online") list = list.filter((a: any) => a.is_online);
        setAstrologers(list);
        setAstroTotal(data.total || 0);
      }
      if (activeTab === "kyc") {
        const params: Record<string, any> = {
          skip: kycPage * KYC_PAGE_SIZE,
          limit: KYC_PAGE_SIZE,
        };
        if (kycFilter !== "all") params.status = kycFilter;
        const { data } = await adminListKyc(params);
        setKycDocs(data.documents || []);
        setKycTotal(data.total || 0);
      }
      if (activeTab === "wallet") {
        // totals card (all-time)
        const r = await fetch(`${BASE}/admin/wallet-stats`, { headers: authHeaders() });
        if (r.ok) setWalletStats(await r.json());

        // filtered statement
        const params: Record<string, any> = {
          skip: walletPage * WALLET_PAGE_SIZE,
          limit: WALLET_PAGE_SIZE,
        };
        if (walletFilterType !== "all") params.txn_type = walletFilterType;
        if (walletFilterRole !== "all") params.user_role = walletFilterRole;
        if (walletSearchTerm) params.search = walletSearchTerm;
        if (walletDateFrom) params.date_from = walletDateFrom;
        if (walletDateTo) params.date_to = walletDateTo;

        const { data } = await adminListTransactions(params);
        setTransactions(data.transactions || []);
        setWalletTotal(data.total || 0);
        setWalletSummary({
          total_credits: data.total_credits || 0,
          total_debits: data.total_debits || 0,
          net_flow: data.net_flow || 0,
        });
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
  }, [activeTab, searchQuery, userPage, userFilterStatus, userFilterRole,
      astroPage, astroFilter, astroSearch, kycPage, kycFilter,
      walletPage, walletFilterType, walletFilterRole, walletSearchTerm,
      walletDateFrom, walletDateTo]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // Reset page to 0 when filters change
  useEffect(() => { setUserPage(0); }, [userFilterStatus, userFilterRole, searchQuery]);
  useEffect(() => { setAstroPage(0); }, [astroFilter, astroSearch]);
  useEffect(() => { setKycPage(0); }, [kycFilter]);
  useEffect(() => { setWalletPage(0); },
    [walletFilterType, walletFilterRole, walletSearchTerm, walletDateFrom, walletDateTo]);

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
    await adminApproveAstrologer(profileId);
    fetchData();
  };

  const blockAstrologer = async (profileId: string) => {
    await adminBlockAstrologer(profileId);
    fetchData();
  };

  // ── Astrologer wallet dialog ─────────────────────────────────────
  const openAstroWalletDialog = (astro: any, action: WalletAction) => {
    setAstroWalletAmount("");
    setAstroWalletReason("");
    setAstroWalletDialog({ open: true, astro, action });
  };
  const closeAstroWalletDialog = () => {
    setAstroWalletDialog({ open: false, astro: null, action: "add_fund" });
    setAstroWalletAmount("");
    setAstroWalletReason("");
  };
  const submitAstroWallet = async () => {
    const amt = parseFloat(astroWalletAmount);
    if (!astroWalletDialog.astro || isNaN(amt) || amt <= 0) {
      alert("Enter a valid amount greater than 0"); return;
    }
    if (!astroWalletReason.trim()) {
      alert("Reason is required (creates statement entry)"); return;
    }
    const { ok, data } = await adminAdjustWallet(
      astroWalletDialog.astro.user_id,
      astroWalletDialog.action,
      amt,
      astroWalletReason.trim(),
    );
    if (!ok) {
      alert(data.detail || "Adjustment failed");
      return;
    }
    closeAstroWalletDialog();
    fetchData();
  };

  // ── Commission dialog ────────────────────────────────────────────
  const openCommissionDialog = (astro: any) => {
    setCommissionValue(String(astro.commission_pct || 30));
    setCommissionDialog({ open: true, astro });
  };
  const submitCommission = async () => {
    const pct = parseFloat(commissionValue);
    if (isNaN(pct) || pct < 0 || pct > 100) {
      alert("Commission must be between 0 and 100"); return;
    }
    await adminSetCommission(commissionDialog.astro.id, pct);
    setCommissionDialog({ open: false, astro: null });
    fetchData();
  };

  // ── Reject astrologer dialog ─────────────────────────────────────
  const openRejectDialog = (astro: any) => {
    setRejectReason("");
    setRejectDialog({ open: true, astro });
  };
  const submitReject = async () => {
    if (!rejectReason.trim()) { alert("Reason is required"); return; }
    const { ok, data } = await adminRejectAstrologer(rejectDialog.astro.id, rejectReason.trim());
    if (!ok) { alert(data.detail || "Reject failed"); return; }
    setRejectDialog({ open: false, astro: null });
    setRejectReason("");
    fetchData();
  };

  // ── KYC actions ──────────────────────────────────────────────────
  const approveKycDoc = async (kycId: string) => {
    await adminApproveKyc(kycId);
    fetchData();
  };
  const openKycRejectDialog = (kyc: any) => {
    setKycRejectReason("");
    setKycRejectDialog({ open: true, kyc });
  };
  const submitKycReject = async () => {
    if (!kycRejectReason.trim()) { alert("Reason is required"); return; }
    const { ok, data } = await adminRejectKyc(kycRejectDialog.kyc.id, kycRejectReason.trim());
    if (!ok) { alert(data.detail || "Reject failed"); return; }
    setKycRejectDialog({ open: false, kyc: null });
    setKycRejectReason("");
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

  if (!user) return null;

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
                {/* Filters */}
                <div className="flex flex-col md:flex-row gap-2">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <Input
                      value={astroSearch}
                      onChange={(e) => setAstroSearch(e.target.value)}
                      placeholder="Search by name or email..."
                      className="pl-10 bg-muted border-border"
                    />
                  </div>
                  <Select value={astroFilter} onValueChange={setAstroFilter}>
                    <SelectTrigger className="w-full md:w-48 bg-muted border-border">
                      <SelectValue placeholder="Status" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Astrologers</SelectItem>
                      <SelectItem value="pending">Pending Approval</SelectItem>
                      <SelectItem value="approved">Approved Only</SelectItem>
                      <SelectItem value="online">Online Now</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <p className="text-xs text-muted-foreground">
                  Showing {astrologers.length} of {astroTotal} astrologers
                  {astroFilter !== "all" && <> · Filter: <span className="text-primary">{astroFilter}</span></>}
                </p>

                {/* Pending approval banner */}
                {astroFilter === "pending" && astrologers.length > 0 && (
                  <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-3 flex items-center gap-2">
                    <Shield className="w-4 h-4 text-yellow-400" />
                    <p className="text-xs text-yellow-400">
                      {astrologers.length} astrologer{astrologers.length > 1 ? "s" : ""} awaiting approval. Astrologer will receive a push notification.
                    </p>
                  </div>
                )}

                {/* Astrologer cards */}
                <div className="grid md:grid-cols-2 gap-4">
                  {astrologers.length === 0 && (
                    <div className="col-span-2 p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                      No astrologers found for this filter.
                    </div>
                  )}
                  {astrologers.map((a: any) => (
                    <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4 space-y-3">
                      {/* Header */}
                      <div className="flex items-start gap-3">
                        <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl">🔮</div>
                        <div className="flex-1 min-w-0">
                          <h4 className="font-semibold text-foreground truncate">{a.display_name || "—"}</h4>
                          <p className="text-xs text-muted-foreground truncate">{a.email}</p>
                          {a.phone && <p className="text-xs text-muted-foreground truncate">{a.phone}</p>}
                          <p className="text-xs text-primary truncate">{(a.specializations || []).join(", ") || "No specialization"}</p>
                        </div>
                        <div className="flex flex-col items-end gap-1">
                          <Badge className={a.is_approved ? "bg-green-500/20 text-green-400" : "bg-yellow-500/20 text-yellow-400"}>
                            {a.is_approved ? "Approved" : "Pending"}
                          </Badge>
                          {a.is_online && <Badge className="bg-green-500/20 text-green-400 text-[10px]">Online</Badge>}
                          {!a.is_active && <Badge className="bg-destructive/20 text-destructive text-[10px]">Blocked</Badge>}
                        </div>
                      </div>

                      {/* Stats grid */}
                      <div className="grid grid-cols-4 gap-2 text-center">
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">⭐ {a.rating || 0}</p>
                          <p className="text-[10px] text-muted-foreground">Rating</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">{a.total_consultations || 0}</p>
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

                      {/* Rates */}
                      <div className="grid grid-cols-3 gap-1 text-center text-[10px] text-muted-foreground bg-muted/30 rounded-lg p-2">
                        <span><MessageCircle className="w-3 h-3 inline" /> ₹{a.rate_per_min_chat}/m Chat</span>
                        <span><Phone className="w-3 h-3 inline" /> ₹{a.rate_per_min_call}/m Call</span>
                        <span><Video className="w-3 h-3 inline" /> ₹{a.rate_per_min_video}/m Video</span>
                      </div>

                      {/* Primary action row: Approve/Reject (pending) or View/Commission */}
                      <div className="flex gap-2">
                        {!a.is_approved ? (
                          <>
                            <Button
                              size="sm"
                              className="flex-1 gradient-gold text-primary-foreground text-xs"
                              onClick={() => approveAstrologer(a.id)}
                              title="Approve (sends FCM notification)"
                            >
                              <CheckCircle className="w-3 h-3 mr-1" /> Approve
                            </Button>
                            <Button
                              size="sm" variant="outline"
                              className="flex-1 border-destructive text-destructive text-xs hover:bg-destructive/10"
                              onClick={() => openRejectDialog(a)}
                              title="Reject with reason (sends FCM notification)"
                            >
                              <X className="w-3 h-3 mr-1" /> Reject
                            </Button>
                          </>
                        ) : (
                          <>
                            <Button
                              size="sm" variant="outline"
                              className="flex-1 border-border text-xs"
                              onClick={() => setAstroDetail(a)}
                            >
                              <Eye className="w-3 h-3 mr-1" /> View
                            </Button>
                            <Button
                              size="sm" variant="outline"
                              className="flex-1 border-primary text-primary text-xs hover:bg-primary/10"
                              onClick={() => openCommissionDialog(a)}
                            >
                              <Pencil className="w-3 h-3 mr-1" /> Commission
                            </Button>
                          </>
                        )}
                      </div>

                      {/* Secondary actions: wallet controls + block */}
                      <div className="grid grid-cols-4 gap-1">
                        <Button
                          size="sm" variant="outline"
                          onClick={() => openAstroWalletDialog(a, "add_fund")}
                          className="h-7 text-[11px] border-green-500/50 text-green-400 hover:bg-green-500/10"
                          title="Add funds"
                        >
                          <PlusCircle className="w-3 h-3" />
                        </Button>
                        <Button
                          size="sm" variant="outline"
                          onClick={() => openAstroWalletDialog(a, "remove_fund")}
                          className="h-7 text-[11px] border-orange-500/50 text-orange-400 hover:bg-orange-500/10"
                          title="Remove funds"
                        >
                          <MinusCircle className="w-3 h-3" />
                        </Button>
                        <Button
                          size="sm" variant="outline"
                          onClick={() => openAstroWalletDialog(a, "bonus")}
                          className="h-7 text-[11px] border-primary/50 text-primary hover:bg-primary/10"
                          title="Bonus"
                        >
                          <Sparkles className="w-3 h-3" />
                        </Button>
                        <Button
                          size="sm" variant="outline"
                          onClick={() => blockAstrologer(a.id)}
                          className={`h-7 text-[11px] ${a.is_active ? "border-destructive text-destructive hover:bg-destructive/10" : "border-green-500 text-green-400 hover:bg-green-500/10"}`}
                          title={a.is_active ? "Block" : "Unblock"}
                        >
                          {a.is_active ? <Ban className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Pagination */}
                {astroTotal > ASTRO_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {astroPage + 1} of {Math.max(1, Math.ceil(astroTotal / ASTRO_PAGE_SIZE))}
                    </p>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" disabled={astroPage === 0}
                        onClick={() => setAstroPage((p) => Math.max(0, p - 1))}
                        className="h-8 border-border">
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button size="sm" variant="outline"
                        disabled={(astroPage + 1) * ASTRO_PAGE_SIZE >= astroTotal}
                        onClick={() => setAstroPage((p) => p + 1)}
                        className="h-8 border-border">
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* ══════ KYC MANAGEMENT ══════ */}
            {activeTab === "kyc" && (
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">KYC Verification</h2>
                  <Select value={kycFilter} onValueChange={setKycFilter}>
                    <SelectTrigger className="w-48 bg-muted border-border">
                      <SelectValue placeholder="Status" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All</SelectItem>
                      <SelectItem value="pending">Pending</SelectItem>
                      <SelectItem value="approved">Approved</SelectItem>
                      <SelectItem value="rejected">Rejected</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <p className="text-xs text-muted-foreground">{kycTotal} total KYC documents</p>

                {kycDocs.length === 0 && (
                  <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                    No KYC documents for this filter.
                  </div>
                )}

                <div className="space-y-3">
                  {kycDocs.map((k: any) => (
                    <div key={k.id} className="bg-card/60 border border-border rounded-xl p-4">
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex items-start gap-3 flex-1 min-w-0">
                          <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
                            <FileText className="w-5 h-5 text-primary" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2 flex-wrap">
                              <h4 className="font-semibold text-foreground truncate">{k.user_name || "—"}</h4>
                              <Badge variant="outline" className="border-border text-xs capitalize">{k.user_role}</Badge>
                              <Badge className={
                                k.status === "approved" ? "bg-green-500/20 text-green-400" :
                                k.status === "rejected" ? "bg-destructive/20 text-destructive" :
                                "bg-yellow-500/20 text-yellow-400"
                              }>
                                {k.status}
                              </Badge>
                            </div>
                            <p className="text-xs text-muted-foreground">{k.user_email}</p>
                            <div className="flex gap-4 mt-2 text-xs text-muted-foreground">
                              <span>Doc: <span className="text-foreground capitalize">{k.doc_type}</span></span>
                              {k.doc_number && <span>#{k.doc_number}</span>}
                              <span>{k.created_at?.slice(0, 16)}</span>
                            </div>
                            {k.rejection_reason && (
                              <p className="text-xs text-destructive mt-1">Rejected: {k.rejection_reason}</p>
                            )}
                            {/* Document images */}
                            <div className="flex gap-2 mt-2 flex-wrap">
                              {k.front_url && (
                                <a href={k.front_url} target="_blank" rel="noopener noreferrer" className="text-xs text-primary hover:underline">Front ↗</a>
                              )}
                              {k.back_url && (
                                <a href={k.back_url} target="_blank" rel="noopener noreferrer" className="text-xs text-primary hover:underline">Back ↗</a>
                              )}
                              {k.selfie_url && (
                                <a href={k.selfie_url} target="_blank" rel="noopener noreferrer" className="text-xs text-primary hover:underline">Selfie ↗</a>
                              )}
                            </div>
                          </div>
                        </div>
                        {k.status === "pending" && (
                          <div className="flex gap-1">
                            <Button
                              size="sm"
                              className="gradient-gold text-primary-foreground h-8 text-xs"
                              onClick={() => approveKycDoc(k.id)}
                            >
                              <CheckCircle className="w-3 h-3 mr-1" /> Approve
                            </Button>
                            <Button
                              size="sm" variant="outline"
                              className="border-destructive text-destructive h-8 text-xs hover:bg-destructive/10"
                              onClick={() => openKycRejectDialog(k)}
                            >
                              <X className="w-3 h-3 mr-1" /> Reject
                            </Button>
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>

                {/* KYC pagination */}
                {kycTotal > KYC_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {kycPage + 1} of {Math.max(1, Math.ceil(kycTotal / KYC_PAGE_SIZE))}
                    </p>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" disabled={kycPage === 0}
                        onClick={() => setKycPage((p) => Math.max(0, p - 1))} className="h-8 border-border">
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button size="sm" variant="outline"
                        disabled={(kycPage + 1) * KYC_PAGE_SIZE >= kycTotal}
                        onClick={() => setKycPage((p) => p + 1)} className="h-8 border-border">
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* ══════ Astrologer Wallet Dialog ══════ */}
            <Dialog open={astroWalletDialog.open} onOpenChange={(v) => !v && closeAstroWalletDialog()}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    {astroWalletDialog.action === "add_fund" && <><PlusCircle className="w-5 h-5 text-green-400" /> Add to Astrologer Wallet</>}
                    {astroWalletDialog.action === "remove_fund" && <><MinusCircle className="w-5 h-5 text-orange-400" /> Remove from Astrologer Wallet</>}
                    {astroWalletDialog.action === "bonus" && <><Sparkles className="w-5 h-5 text-primary" /> Bonus to Astrologer</>}
                  </DialogTitle>
                </DialogHeader>
                {astroWalletDialog.astro && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">🔮 {astroWalletDialog.astro.display_name}</p>
                      <p className="text-xs text-muted-foreground">{astroWalletDialog.astro.email}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Current balance: <span className="text-primary font-semibold">₹{astroWalletDialog.astro.wallet_balance}</span>
                      </p>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Amount (₹)</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={astroWalletAmount}
                        onChange={(e) => setAstroWalletAmount(e.target.value)}
                        placeholder="Enter amount"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80">Reason (creates statement)</Label>
                      <Textarea
                        value={astroWalletReason}
                        onChange={(e) => setAstroWalletReason(e.target.value)}
                        placeholder="Reason for this adjustment..."
                        className="bg-muted border-border mt-1 min-h-[80px]"
                      />
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={closeAstroWalletDialog}>Cancel</Button>
                  <Button onClick={submitAstroWallet} className="gradient-gold text-primary-foreground">
                    Confirm
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ Commission Dialog ══════ */}
            <Dialog open={commissionDialog.open} onOpenChange={(v) => !v && setCommissionDialog({ open: false, astro: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Pencil className="w-5 h-5 text-primary" /> Set Commission
                  </DialogTitle>
                </DialogHeader>
                {commissionDialog.astro && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">🔮 {commissionDialog.astro.display_name}</p>
                      <p className="text-xs text-muted-foreground">{commissionDialog.astro.email}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Current commission: <span className="text-primary font-semibold">{commissionDialog.astro.commission_pct}%</span>
                      </p>
                    </div>
                    <div>
                      <Label className="text-foreground/80">New Commission (%)</Label>
                      <Input
                        type="number" min="0" max="100" step="0.01"
                        value={commissionValue}
                        onChange={(e) => setCommissionValue(e.target.value)}
                        placeholder="0-100"
                        className="bg-muted border-border mt-1"
                      />
                      <p className="text-xs text-muted-foreground mt-1">
                        Platform takes this % from every consultation. Astrologer keeps the rest.
                      </p>
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setCommissionDialog({ open: false, astro: null })}>Cancel</Button>
                  <Button onClick={submitCommission} className="gradient-gold text-primary-foreground">
                    Update Commission
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ Reject Astrologer Dialog ══════ */}
            <Dialog open={rejectDialog.open} onOpenChange={(v) => !v && setRejectDialog({ open: false, astro: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2 text-destructive">
                    <X className="w-5 h-5" /> Reject Astrologer Application
                  </DialogTitle>
                </DialogHeader>
                {rejectDialog.astro && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">🔮 {rejectDialog.astro.display_name}</p>
                      <p className="text-xs text-muted-foreground">{rejectDialog.astro.email}</p>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Rejection Reason (sent via FCM)</Label>
                      <Textarea
                        value={rejectReason}
                        onChange={(e) => setRejectReason(e.target.value)}
                        placeholder="e.g. Incomplete profile, unclear certificate, invalid documents..."
                        className="bg-muted border-border mt-1 min-h-[100px]"
                      />
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setRejectDialog({ open: false, astro: null })}>Cancel</Button>
                  <Button onClick={submitReject} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                    Reject & Notify
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ KYC Reject Dialog ══════ */}
            <Dialog open={kycRejectDialog.open} onOpenChange={(v) => !v && setKycRejectDialog({ open: false, kyc: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2 text-destructive">
                    <X className="w-5 h-5" /> Reject KYC Document
                  </DialogTitle>
                </DialogHeader>
                {kycRejectDialog.kyc && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">{kycRejectDialog.kyc.user_name}</p>
                      <p className="text-xs text-muted-foreground">{kycRejectDialog.kyc.user_email}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Doc: <span className="text-foreground capitalize">{kycRejectDialog.kyc.doc_type}</span>
                        {kycRejectDialog.kyc.doc_number && <> · #{kycRejectDialog.kyc.doc_number}</>}
                      </p>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Rejection Reason (sent via FCM)</Label>
                      <Textarea
                        value={kycRejectReason}
                        onChange={(e) => setKycRejectReason(e.target.value)}
                        placeholder="e.g. Document is blurry, doesn't match name, expired..."
                        className="bg-muted border-border mt-1 min-h-[100px]"
                      />
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setKycRejectDialog({ open: false, kyc: null })}>Cancel</Button>
                  <Button onClick={submitKycReject} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                    Reject & Notify
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ Astrologer Detail Dialog ══════ */}
            <Dialog open={astroDetail !== null} onOpenChange={(v) => !v && setAstroDetail(null)}>
              <DialogContent className="bg-card border-border max-w-2xl max-h-[85vh] overflow-y-auto">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Star className="w-5 h-5 text-primary" /> Astrologer Details
                  </DialogTitle>
                </DialogHeader>
                {astroDetail && (
                  <div className="space-y-3 py-2 text-sm">
                    <div className="grid grid-cols-2 gap-3">
                      <div><span className="text-muted-foreground">Name:</span> <span className="text-foreground">{astroDetail.display_name}</span></div>
                      <div><span className="text-muted-foreground">Email:</span> <span className="text-foreground">{astroDetail.email}</span></div>
                      <div><span className="text-muted-foreground">Phone:</span> <span className="text-foreground">{astroDetail.phone || "—"}</span></div>
                      <div><span className="text-muted-foreground">Experience:</span> <span className="text-foreground">{astroDetail.experience_years} yrs</span></div>
                      <div><span className="text-muted-foreground">Qualification:</span> <span className="text-foreground">{astroDetail.qualification || "—"}</span></div>
                      <div><span className="text-muted-foreground">Commission:</span> <span className="text-primary font-semibold">{astroDetail.commission_pct}%</span></div>
                      <div><span className="text-muted-foreground">Rating:</span> <span className="text-foreground">⭐ {astroDetail.rating}</span></div>
                      <div><span className="text-muted-foreground">Reviews:</span> <span className="text-foreground">{astroDetail.total_reviews}</span></div>
                      <div><span className="text-muted-foreground">Sessions:</span> <span className="text-foreground">{astroDetail.total_consultations}</span></div>
                      <div><span className="text-muted-foreground">Minutes:</span> <span className="text-foreground">{astroDetail.total_minutes}</span></div>
                      <div><span className="text-muted-foreground">Wallet:</span> <span className="text-primary font-semibold">₹{astroDetail.wallet_balance}</span></div>
                      <div><span className="text-muted-foreground">Status:</span>
                        <Badge className={`ml-2 ${astroDetail.is_approved ? "bg-green-500/20 text-green-400" : "bg-yellow-500/20 text-yellow-400"}`}>
                          {astroDetail.is_approved ? "Approved" : "Pending"}
                        </Badge>
                      </div>
                    </div>
                    {astroDetail.bio && (
                      <div>
                        <p className="text-muted-foreground text-xs mb-1">Bio</p>
                        <p className="text-foreground text-xs bg-muted/30 rounded-lg p-3 border border-border">{astroDetail.bio}</p>
                      </div>
                    )}
                    <div className="grid grid-cols-3 gap-2">
                      <div className="bg-muted rounded-lg p-2 text-center">
                        <p className="text-[10px] text-muted-foreground">Chat</p>
                        <p className="text-sm font-semibold text-foreground">₹{astroDetail.rate_per_min_chat}/m</p>
                      </div>
                      <div className="bg-muted rounded-lg p-2 text-center">
                        <p className="text-[10px] text-muted-foreground">Call</p>
                        <p className="text-sm font-semibold text-foreground">₹{astroDetail.rate_per_min_call}/m</p>
                      </div>
                      <div className="bg-muted rounded-lg p-2 text-center">
                        <p className="text-[10px] text-muted-foreground">Video</p>
                        <p className="text-sm font-semibold text-foreground">₹{astroDetail.rate_per_min_video}/m</p>
                      </div>
                    </div>
                    {(astroDetail.languages || []).length > 0 && (
                      <div>
                        <p className="text-muted-foreground text-xs mb-1">Languages</p>
                        <div className="flex flex-wrap gap-1">
                          {astroDetail.languages.map((l: string) => (
                            <Badge key={l} variant="outline" className="border-border text-xs">{l}</Badge>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setAstroDetail(null)}>Close</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ WALLET — Full Statement ══════ */}
            {activeTab === "wallet" && (
              <div className="space-y-4">
                {/* Platform stats (all-time) */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                  <div className="bg-card/60 border border-border rounded-xl p-3 glow-gold">
                    <p className="text-xs text-muted-foreground">User Wallets</p>
                    <p className="text-xl font-display text-gold-gradient mt-1">
                      ₹{walletStats ? fmt(walletStats.total_user_wallets) : "—"}
                    </p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Astro Wallets</p>
                    <p className="text-xl font-display text-primary mt-1">
                      ₹{walletStats ? fmt(walletStats.total_astro_wallets) : "—"}
                    </p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Total Recharges</p>
                    <p className="text-xl font-display text-green-400 mt-1">
                      ₹{walletStats ? fmt(walletStats.total_recharges) : "—"}
                    </p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Platform Balance</p>
                    <p className="text-xl font-display text-cosmic-light mt-1">
                      ₹{walletStats ? fmt(walletStats.total_platform_balance) : "—"}
                    </p>
                  </div>
                </div>

                {/* Filters */}
                <div className="bg-card/40 border border-border rounded-xl p-3 space-y-3">
                  <div className="flex items-center gap-2">
                    <Filter className="w-4 h-4 text-primary" />
                    <h3 className="text-sm font-semibold text-primary">Statement Filters</h3>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-2">
                    {/* Search */}
                    <div className="relative lg:col-span-2">
                      <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        value={walletSearchTerm}
                        onChange={(e) => setWalletSearchTerm(e.target.value)}
                        placeholder="Search user name or email..."
                        className="pl-10 bg-muted border-border h-9"
                      />
                    </div>
                    {/* Transaction type */}
                    <Select value={walletFilterType} onValueChange={setWalletFilterType}>
                      <SelectTrigger className="bg-muted border-border h-9">
                        <SelectValue placeholder="Type" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Types</SelectItem>
                        <SelectItem value="recharge">Add Fund (Recharge)</SelectItem>
                        <SelectItem value="consultation_debit">Service Deduct</SelectItem>
                        <SelectItem value="consultation_credit">Commission Credit</SelectItem>
                        <SelectItem value="bonus">Admin Bonus</SelectItem>
                        <SelectItem value="refund">Refund</SelectItem>
                        <SelectItem value="withdrawal">Withdrawal</SelectItem>
                        <SelectItem value="ai_debit">AI Service</SelectItem>
                      </SelectContent>
                    </Select>
                    {/* Role */}
                    <Select value={walletFilterRole} onValueChange={setWalletFilterRole}>
                      <SelectTrigger className="bg-muted border-border h-9">
                        <SelectValue placeholder="Role" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Roles</SelectItem>
                        <SelectItem value="user">User</SelectItem>
                        <SelectItem value="astrologer">Astrologer</SelectItem>
                        <SelectItem value="admin">Admin</SelectItem>
                      </SelectContent>
                    </Select>
                    {/* Date range */}
                    <div className="grid grid-cols-2 gap-2 lg:col-span-1">
                      <Input
                        type="date"
                        value={walletDateFrom}
                        onChange={(e) => setWalletDateFrom(e.target.value)}
                        placeholder="From"
                        className="bg-muted border-border h-9 text-xs"
                      />
                      <Input
                        type="date"
                        value={walletDateTo}
                        onChange={(e) => setWalletDateTo(e.target.value)}
                        placeholder="To"
                        className="bg-muted border-border h-9 text-xs"
                      />
                    </div>
                  </div>
                  {(walletFilterType !== "all" || walletFilterRole !== "all" || walletSearchTerm || walletDateFrom || walletDateTo) && (
                    <Button
                      size="sm" variant="outline"
                      onClick={() => {
                        setWalletFilterType("all");
                        setWalletFilterRole("all");
                        setWalletSearchTerm("");
                        setWalletDateFrom("");
                        setWalletDateTo("");
                      }}
                      className="h-7 text-xs border-border"
                    >
                      <X className="w-3 h-3 mr-1" /> Clear filters
                    </Button>
                  )}
                </div>

                {/* Filtered summary */}
                <div className="grid grid-cols-3 gap-3">
                  <div className="bg-card/60 border border-green-500/30 rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Credits (filtered)</p>
                    <p className="text-lg font-semibold text-green-400 mt-1">
                      + ₹{fmt(walletSummary.total_credits)}
                    </p>
                  </div>
                  <div className="bg-card/60 border border-destructive/30 rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Debits (filtered)</p>
                    <p className="text-lg font-semibold text-destructive mt-1">
                      − ₹{fmt(walletSummary.total_debits)}
                    </p>
                  </div>
                  <div className={`bg-card/60 border rounded-xl p-3 ${walletSummary.net_flow >= 0 ? "border-primary/30" : "border-orange-500/30"}`}>
                    <p className="text-xs text-muted-foreground">Net flow</p>
                    <p className={`text-lg font-semibold mt-1 ${walletSummary.net_flow >= 0 ? "text-primary" : "text-orange-400"}`}>
                      {walletSummary.net_flow >= 0 ? "+" : ""}₹{fmt(walletSummary.net_flow)}
                    </p>
                  </div>
                </div>

                {/* Statement table */}
                <div className="bg-card/60 border border-border rounded-xl overflow-hidden">
                  <div className="flex items-center justify-between p-3 border-b border-border bg-muted/20">
                    <h3 className="text-sm font-semibold text-primary">
                      Wallet Statement · {walletTotal} entries
                    </h3>
                  </div>
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b border-border bg-muted/30">
                          <th className="text-left p-3 text-muted-foreground font-medium">Date</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">User</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Role</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Type</th>
                          <th className="text-left p-3 text-muted-foreground font-medium hidden md:table-cell">Description</th>
                          <th className="text-right p-3 text-muted-foreground font-medium">Amount</th>
                          <th className="text-right p-3 text-muted-foreground font-medium hidden lg:table-cell">Balance After</th>
                        </tr>
                      </thead>
                      <tbody>
                        {transactions.length === 0 && (
                          <tr>
                            <td colSpan={7} className="p-8 text-center text-muted-foreground text-sm">
                              No transactions match the current filters.
                            </td>
                          </tr>
                        )}
                        {transactions.map((t: any) => {
                          const isCredit = t.direction === "credit";
                          const labelClass =
                            t.txn_type === "recharge" ? "bg-green-500/20 text-green-400 border-green-500/30" :
                            t.txn_type === "bonus" ? "bg-primary/20 text-primary border-primary/30" :
                            t.txn_type === "consultation_credit" ? "bg-cosmic-light/20 text-cosmic-light border-cosmic-light/30" :
                            t.txn_type === "refund" ? "bg-blue-500/20 text-blue-400 border-blue-500/30" :
                            t.txn_type === "withdrawal" ? "bg-orange-500/20 text-orange-400 border-orange-500/30" :
                            "bg-destructive/20 text-destructive border-destructive/30";
                          return (
                            <tr key={t.id} className="border-b border-border last:border-0 hover:bg-muted/10">
                              <td className="p-3 text-muted-foreground text-xs whitespace-nowrap">
                                {t.created_at?.slice(0, 16) || "—"}
                              </td>
                              <td className="p-3">
                                <p className="text-foreground text-xs font-medium">{t.user_name || "—"}</p>
                                <p className="text-[10px] text-muted-foreground">{t.user_email}</p>
                              </td>
                              <td className="p-3">
                                <Badge
                                  variant="outline"
                                  className={`border-border text-[10px] capitalize ${
                                    t.user_role === "astrologer" ? "text-primary border-primary/30" :
                                    t.user_role === "admin" ? "text-yellow-400 border-yellow-500/30" :
                                    "text-muted-foreground"
                                  }`}
                                >
                                  {t.user_role}
                                </Badge>
                              </td>
                              <td className="p-3">
                                <Badge className={`text-[10px] border ${labelClass}`}>
                                  {t.label}
                                </Badge>
                              </td>
                              <td className="p-3 text-xs text-muted-foreground hidden md:table-cell max-w-[240px] truncate" title={t.description}>
                                {t.description || "—"}
                              </td>
                              <td className={`p-3 text-right font-semibold whitespace-nowrap ${isCredit ? "text-green-400" : "text-destructive"}`}>
                                {isCredit ? "+" : "−"}₹{fmt(t.amount)}
                              </td>
                              <td className="p-3 text-right text-primary text-xs hidden lg:table-cell whitespace-nowrap">
                                ₹{fmt(t.balance_after)}
                              </td>
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  </div>
                </div>

                {/* Pagination */}
                {walletTotal > WALLET_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {walletPage + 1} of {Math.max(1, Math.ceil(walletTotal / WALLET_PAGE_SIZE))}
                      · Showing {transactions.length} of {walletTotal}
                    </p>
                    <div className="flex gap-2">
                      <Button
                        size="sm" variant="outline"
                        disabled={walletPage === 0}
                        onClick={() => setWalletPage((p) => Math.max(0, p - 1))}
                        className="h-8 border-border"
                      >
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button
                        size="sm" variant="outline"
                        disabled={(walletPage + 1) * WALLET_PAGE_SIZE >= walletTotal}
                        onClick={() => setWalletPage((p) => p + 1)}
                        className="h-8 border-border"
                      >
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
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
