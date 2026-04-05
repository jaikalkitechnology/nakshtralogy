import { useState, useEffect, useCallback } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import StarField from "@/components/StarField";
import {
  Home, MessageCircle, Phone, Video, Wallet, User as UserIcon, LogOut, Clock,
  Star, CheckCircle, XCircle, Bell, Shield, AlertCircle, Hourglass,
  FileText, TrendingUp, Users as UsersIcon, Pencil, Download, ArrowUpRight,
  ArrowDownLeft, Banknote, Save, Info,
} from "lucide-react";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import {
  fetchAstroMeKycStatus, submitAstroKyc, fetchAstroMeStats,
  fetchAstroMeRecentRequests,
  fetchAstroMe, fetchAstroMeWallet, fetchAstroMeWalletTransactions,
  requestAstroWithdrawal, fetchAstroMyWithdrawals,
  updateAstroProfile, updateAstroUserFields,
} from "@/services/api";

type Tab = "home" | "requests" | "earnings" | "profile";
type KycStatus = "loading" | "none" | "pending" | "approved" | "rejected" | "error";

const AstrologerDashboard = () => {
  const { user, loading: authLoading, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("home");

  // KYC gating state
  const [kycStatus, setKycStatus] = useState<KycStatus>("loading");
  const [kycInfo, setKycInfo] = useState<any>(null);

  // Dashboard data
  const [stats, setStats] = useState<any>(null);
  const [recentRequests, setRecentRequests] = useState<any[]>([]);

  // Wallet / earnings tab state
  const [walletData, setWalletData] = useState<any>(null);
  const [walletTxns, setWalletTxns] = useState<any[]>([]);
  const [walletTxnTotal, setWalletTxnTotal] = useState(0);
  const [walletTxnKind, setWalletTxnKind] = useState<string>("all"); // all | earning | withdrawal
  const [walletTxnPage, setWalletTxnPage] = useState(0);
  const ASTRO_WALLET_PAGE_SIZE = 10;
  const [withdrawalHistory, setWithdrawalHistory] = useState<any[]>([]);

  // Withdraw dialog
  const [withdrawDialog, setWithdrawDialog] = useState(false);
  const [withdrawForm, setWithdrawForm] = useState({
    amount: "",
    upi_id: "",
    bank_account_name: "",
    bank_account_number: "",
    bank_ifsc: "",
    notes: "",
    use_bank: false,
  });
  const [withdrawSubmitting, setWithdrawSubmitting] = useState(false);
  const [withdrawError, setWithdrawError] = useState("");

  // Full profile + edit dialog
  const [astroMe, setAstroMe] = useState<any>(null);
  const [editProfileDialog, setEditProfileDialog] = useState(false);
  const [profileForm, setProfileForm] = useState<any>({
    name: "",
    phone: "",
    display_name: "",
    bio: "",
    experience_years: 0,
    languages: "",         // comma-separated string for editing
    specializations: "",
    qualification: "",
    profile_image_url: "",
    rate_per_min_chat: 0,
    rate_per_min_call: 0,
    rate_per_min_video: 0,
    rate_per_session_chat: 0,
    rate_per_session_call: 0,
    rate_per_session_video: 0,
    session_message_limit: 45,
    session_validity_hours: 24,
  });
  const [profileSaving, setProfileSaving] = useState(false);
  const [profileError, setProfileError] = useState("");

  // KYC submit form
  const [kycForm, setKycForm] = useState({
    doc_type: "aadhaar",
    doc_number: "",
    front_url: "",
    back_url: "",
    selfie_url: "",
  });
  const [kycSubmitting, setKycSubmitting] = useState(false);
  const [kycSubmitError, setKycSubmitError] = useState("");

  useEffect(() => {
    if (!authLoading && !user) navigate("/auth");
  }, [authLoading, user, navigate]);

  // Load KYC status on mount
  const loadKyc = useCallback(async () => {
    if (authLoading || !user) return;
    setKycStatus("loading");
    const { ok, data } = await fetchAstroMeKycStatus();
    if (!ok) {
      setKycStatus("error");
      return;
    }
    setKycInfo(data);
    setKycStatus(data.status || "none");
    if (data.status === "rejected" && data.doc_type) {
      setKycForm({
        doc_type: data.doc_type,
        doc_number: data.doc_number || "",
        front_url: data.front_url || "",
        back_url: data.back_url || "",
        selfie_url: data.selfie_url || "",
      });
    }
  }, [authLoading, user]);

  useEffect(() => { loadKyc(); }, [loadKyc]);

  // Load dashboard stats & recent requests only when KYC is approved
  const loadDashboard = useCallback(async () => {
    if (kycStatus !== "approved") return;
    const [statsRes, recentRes] = await Promise.all([
      fetchAstroMeStats(),
      fetchAstroMeRecentRequests(10),
    ]);
    if (statsRes.ok) setStats(statsRes.data);
    if (recentRes.ok) setRecentRequests(recentRes.data.items || []);
  }, [kycStatus]);

  useEffect(() => { loadDashboard(); }, [loadDashboard]);

  // ── Wallet data loader ─────────────────────────────────────────
  const loadWallet = useCallback(async () => {
    if (kycStatus !== "approved") return;
    const [walletRes, txnRes, whRes] = await Promise.all([
      fetchAstroMeWallet(),
      fetchAstroMeWalletTransactions({
        skip: walletTxnPage * ASTRO_WALLET_PAGE_SIZE,
        limit: ASTRO_WALLET_PAGE_SIZE,
        ...(walletTxnKind !== "all" ? { kind: walletTxnKind } : {}),
      }),
      fetchAstroMyWithdrawals({ limit: 10 }),
    ]);
    if (walletRes.ok) setWalletData(walletRes.data);
    if (txnRes.ok) {
      setWalletTxns(txnRes.data.transactions || []);
      setWalletTxnTotal(txnRes.data.total || 0);
    }
    if (whRes.ok) setWithdrawalHistory(whRes.data.withdrawals || []);
  }, [kycStatus, walletTxnPage, walletTxnKind]);

  useEffect(() => {
    if (activeTab === "earnings") loadWallet();
  }, [activeTab, loadWallet]);

  useEffect(() => { setWalletTxnPage(0); }, [walletTxnKind]);

  // ── Profile data loader ────────────────────────────────────────
  const loadAstroMe = useCallback(async () => {
    if (kycStatus !== "approved") return;
    const { ok, data } = await fetchAstroMe();
    if (ok) {
      setAstroMe(data);
      const p = data.profile || {};
      setProfileForm({
        name: data.name || "",
        phone: data.phone || "",
        display_name: p.display_name || "",
        bio: p.bio || "",
        experience_years: p.experience_years || 0,
        languages: (p.languages || []).join(", "),
        specializations: (p.specializations || []).join(", "),
        qualification: p.qualification || "",
        profile_image_url: p.profile_image_url || "",
        rate_per_min_chat: p.rate_per_min_chat || 0,
        rate_per_min_call: p.rate_per_min_call || 0,
        rate_per_min_video: p.rate_per_min_video || 0,
        rate_per_session_chat: p.rate_per_session_chat || 0,
        rate_per_session_call: p.rate_per_session_call || 0,
        rate_per_session_video: p.rate_per_session_video || 0,
        session_message_limit: p.session_message_limit || 45,
        session_validity_hours: p.session_validity_hours || 24,
      });
    }
  }, [kycStatus]);

  useEffect(() => {
    if (activeTab === "profile") loadAstroMe();
  }, [activeTab, loadAstroMe]);

  // ── Withdraw handler ───────────────────────────────────────────
  const openWithdrawDialog = () => {
    setWithdrawError("");
    setWithdrawForm({
      amount: "",
      upi_id: "",
      bank_account_name: "",
      bank_account_number: "",
      bank_ifsc: "",
      notes: "",
      use_bank: false,
    });
    setWithdrawDialog(true);
  };

  const submitWithdraw = async () => {
    setWithdrawError("");
    const amt = parseFloat(withdrawForm.amount);
    if (isNaN(amt) || amt <= 0) {
      setWithdrawError("Enter a valid amount"); return;
    }
    const minAmt = walletData?.withdrawal_config?.min_amount || 100;
    if (amt < minAmt) {
      setWithdrawError(`Minimum withdrawal amount is ₹${minAmt}`); return;
    }
    const withdrawable = walletData?.withdrawable || 0;
    if (amt > withdrawable) {
      setWithdrawError(`Only ₹${withdrawable} is withdrawable`); return;
    }
    if (walletData?.withdrawal_config?.require_bank) {
      if (!withdrawForm.upi_id && !(withdrawForm.bank_account_number && withdrawForm.bank_ifsc)) {
        setWithdrawError("Provide either UPI ID or full bank details"); return;
      }
    }
    setWithdrawSubmitting(true);
    try {
      const payload: any = {
        amount: amt,
        notes: withdrawForm.notes || undefined,
      };
      if (withdrawForm.upi_id) payload.upi_id = withdrawForm.upi_id;
      if (withdrawForm.use_bank) {
        payload.bank_account_name = withdrawForm.bank_account_name;
        payload.bank_account_number = withdrawForm.bank_account_number;
        payload.bank_ifsc = withdrawForm.bank_ifsc;
      }
      const { ok, data } = await requestAstroWithdrawal(payload);
      if (!ok) {
        setWithdrawError(data.detail || "Withdrawal failed");
      } else {
        setWithdrawDialog(false);
        await loadWallet();
        alert(`✓ ${data.message}`);
      }
    } finally {
      setWithdrawSubmitting(false);
    }
  };

  // ── Profile save handler ───────────────────────────────────────
  const submitProfile = async () => {
    setProfileError("");
    setProfileSaving(true);
    try {
      // 1. Update user-level fields (name, phone)
      if (profileForm.name || profileForm.phone) {
        const u = await updateAstroUserFields({
          name: profileForm.name,
          phone: profileForm.phone || null,
        });
        if (!u.ok) {
          setProfileError(u.data.detail || "User update failed");
          return;
        }
      }
      // 2. Update astrologer profile fields
      const payload: any = {
        display_name: profileForm.display_name,
        bio: profileForm.bio || null,
        experience_years: Number(profileForm.experience_years) || 0,
        languages: (profileForm.languages || "").split(",").map((s: string) => s.trim()).filter(Boolean),
        specializations: (profileForm.specializations || "").split(",").map((s: string) => s.trim()).filter(Boolean),
        qualification: profileForm.qualification || null,
        profile_image_url: profileForm.profile_image_url || null,
        rate_per_min_chat: Number(profileForm.rate_per_min_chat) || 0,
        rate_per_min_call: Number(profileForm.rate_per_min_call) || 0,
        rate_per_min_video: Number(profileForm.rate_per_min_video) || 0,
        rate_per_session_chat: Number(profileForm.rate_per_session_chat) || 0,
        rate_per_session_call: Number(profileForm.rate_per_session_call) || 0,
        rate_per_session_video: Number(profileForm.rate_per_session_video) || 0,
        session_message_limit: Number(profileForm.session_message_limit) || 45,
        session_validity_hours: Number(profileForm.session_validity_hours) || 24,
      };
      const p = await updateAstroProfile(payload);
      if (!p.ok) {
        setProfileError(p.data.detail || "Profile update failed");
        return;
      }
      setEditProfileDialog(false);
      await loadAstroMe();
      await loadDashboard();
    } finally {
      setProfileSaving(false);
    }
  };

  const submitKyc = async () => {
    setKycSubmitError("");
    if (!kycForm.doc_type || !kycForm.doc_number) {
      setKycSubmitError("Document type and number are required");
      return;
    }
    if (!kycForm.front_url) {
      setKycSubmitError("Front document image URL is required");
      return;
    }
    setKycSubmitting(true);
    try {
      const { ok, data } = await submitAstroKyc(kycForm);
      if (!ok) {
        setKycSubmitError(data.detail || "Submission failed");
      } else {
        await loadKyc();
      }
    } finally {
      setKycSubmitting(false);
    }
  };

  if (authLoading || kycStatus === "loading") {
    return (
      <div className="min-h-screen gradient-mystic flex items-center justify-center">
        <StarField />
        <p className="text-primary relative z-10">Loading...</p>
      </div>
    );
  }
  if (!user) return null;

  // ════════════════════════════════════════════════════════════════════
  //  KYC SUBMIT PAGE (status = none or rejected)
  // ════════════════════════════════════════════════════════════════════
  if (kycStatus === "none" || kycStatus === "rejected" || kycStatus === "error") {
    return (
      <div className="min-h-screen gradient-mystic relative flex flex-col">
        <StarField />
        <header className="relative z-10 flex items-center justify-between p-4 border-b border-border bg-card/50 backdrop-blur-lg">
          <div className="flex items-center gap-2">
            <span className="text-xl">🔮</span>
            <span className="font-display text-gold-gradient text-lg">Astrologer Panel</span>
          </div>
          <button onClick={() => { logout(); navigate("/"); }}>
            <LogOut className="w-5 h-5 text-muted-foreground" />
          </button>
        </header>

        <main className="relative z-10 flex-1 overflow-auto p-4">
          <div className="max-w-lg mx-auto space-y-4">
            {/* Banner */}
            <div className={`rounded-xl p-4 border ${
              kycStatus === "rejected"
                ? "bg-destructive/10 border-destructive/30"
                : "bg-primary/10 border-primary/30"
            }`}>
              <div className="flex items-start gap-3">
                {kycStatus === "rejected" ? (
                  <AlertCircle className="w-6 h-6 text-destructive shrink-0 mt-0.5" />
                ) : (
                  <Shield className="w-6 h-6 text-primary shrink-0 mt-0.5" />
                )}
                <div className="flex-1">
                  <h2 className="text-lg font-semibold text-foreground">
                    {kycStatus === "rejected" ? "KYC Rejected — Please Re-submit" : "KYC Verification Required"}
                  </h2>
                  <p className="text-xs text-muted-foreground mt-1">
                    {kycStatus === "rejected"
                      ? "Your previous submission was not accepted. Please fix the issues and re-submit."
                      : "Complete your KYC to unlock all features and start accepting consultations."}
                  </p>
                  {kycStatus === "rejected" && kycInfo?.rejection_reason && (
                    <div className="mt-2 p-2 bg-destructive/5 border border-destructive/20 rounded-lg">
                      <p className="text-xs text-destructive font-medium">Reason:</p>
                      <p className="text-xs text-foreground/80 mt-0.5">{kycInfo.rejection_reason}</p>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Form card */}
            <div className="bg-card/60 border border-border rounded-xl p-5 space-y-3">
              <h3 className="text-sm font-semibold text-primary flex items-center gap-2">
                <FileText className="w-4 h-4" /> Submit KYC Documents
              </h3>

              {kycSubmitError && (
                <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-2">
                  <p className="text-xs text-destructive">{kycSubmitError}</p>
                </div>
              )}

              <div>
                <Label className="text-foreground/80 text-xs">Document Type *</Label>
                <select
                  value={kycForm.doc_type}
                  onChange={(e) => setKycForm({ ...kycForm, doc_type: e.target.value })}
                  className="w-full bg-muted border border-border rounded-lg mt-1 px-3 py-2 text-sm text-foreground"
                >
                  <option value="aadhaar">Aadhaar Card</option>
                  <option value="pan">PAN Card</option>
                  <option value="passport">Passport</option>
                  <option value="license">Driving License</option>
                  <option value="certificate">Astrology Certificate</option>
                </select>
              </div>

              <div>
                <Label className="text-foreground/80 text-xs">Document Number *</Label>
                <Input
                  value={kycForm.doc_number}
                  onChange={(e) => setKycForm({ ...kycForm, doc_number: e.target.value })}
                  placeholder="Enter document number"
                  className="bg-muted border-border mt-1"
                />
              </div>

              <div>
                <Label className="text-foreground/80 text-xs">Front Image URL *</Label>
                <Input
                  value={kycForm.front_url}
                  onChange={(e) => setKycForm({ ...kycForm, front_url: e.target.value })}
                  placeholder="https://... (upload via your asset service)"
                  className="bg-muted border-border mt-1"
                />
              </div>

              <div>
                <Label className="text-foreground/80 text-xs">Back Image URL (optional)</Label>
                <Input
                  value={kycForm.back_url}
                  onChange={(e) => setKycForm({ ...kycForm, back_url: e.target.value })}
                  placeholder="https://..."
                  className="bg-muted border-border mt-1"
                />
              </div>

              <div>
                <Label className="text-foreground/80 text-xs">Selfie with Document (optional)</Label>
                <Input
                  value={kycForm.selfie_url}
                  onChange={(e) => setKycForm({ ...kycForm, selfie_url: e.target.value })}
                  placeholder="https://..."
                  className="bg-muted border-border mt-1"
                />
              </div>

              <Button
                onClick={submitKyc}
                disabled={kycSubmitting}
                className="w-full gradient-gold text-primary-foreground mt-2"
              >
                {kycSubmitting ? "Submitting..." : "Submit for Review"}
              </Button>

              <p className="text-[10px] text-muted-foreground text-center">
                Your documents are reviewed manually and usually take 24–48 hours. You'll
                receive a push notification when approved.
              </p>
            </div>
          </div>
        </main>
      </div>
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  KYC PENDING PAGE
  // ════════════════════════════════════════════════════════════════════
  if (kycStatus === "pending") {
    return (
      <div className="min-h-screen gradient-mystic relative flex flex-col">
        <StarField />
        <header className="relative z-10 flex items-center justify-between p-4 border-b border-border bg-card/50 backdrop-blur-lg">
          <div className="flex items-center gap-2">
            <span className="text-xl">🔮</span>
            <span className="font-display text-gold-gradient text-lg">Astrologer Panel</span>
          </div>
          <button onClick={() => { logout(); navigate("/"); }}>
            <LogOut className="w-5 h-5 text-muted-foreground" />
          </button>
        </header>

        <main className="relative z-10 flex-1 flex items-center justify-center p-4">
          <div className="max-w-md w-full bg-card/60 border border-primary/30 rounded-xl p-8 text-center glow-gold">
            <div className="w-16 h-16 rounded-full bg-primary/10 border border-primary/30 flex items-center justify-center mx-auto animate-pulse">
              <Hourglass className="w-8 h-8 text-primary" />
            </div>
            <h2 className="text-xl font-display text-gold-gradient mt-4">KYC Under Review</h2>
            <p className="text-sm text-muted-foreground mt-2">
              Hi <span className="text-foreground font-medium">{user.name}</span> 🙏
            </p>
            <p className="text-xs text-muted-foreground mt-2 leading-relaxed">
              Your KYC documents have been submitted successfully and are awaiting
              admin approval. This usually takes 24–48 hours. You'll receive a push
              notification once approved and can start accepting consultations.
            </p>

            {kycInfo && (
              <div className="mt-4 p-3 bg-muted/30 border border-border rounded-lg text-left text-xs space-y-1">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Document type:</span>
                  <span className="text-foreground capitalize">{kycInfo.doc_type}</span>
                </div>
                {kycInfo.doc_number && (
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Number:</span>
                    <span className="text-foreground">{kycInfo.doc_number}</span>
                  </div>
                )}
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Submitted:</span>
                  <span className="text-foreground">{kycInfo.submitted_at?.slice(0, 16) || "—"}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Status:</span>
                  <Badge className="bg-yellow-500/20 text-yellow-400 text-[9px]">Pending</Badge>
                </div>
              </div>
            )}

            <div className="flex gap-2 mt-6">
              <Button
                variant="outline"
                className="flex-1 border-border"
                onClick={loadKyc}
              >
                Refresh Status
              </Button>
              <Button
                variant="outline"
                className="flex-1 border-destructive text-destructive"
                onClick={() => { logout(); navigate("/"); }}
              >
                <LogOut className="w-4 h-4 mr-1" /> Logout
              </Button>
            </div>
          </div>
        </main>
      </div>
    );
  }

  // ════════════════════════════════════════════════════════════════════
  //  FULL APPROVED DASHBOARD
  // ════════════════════════════════════════════════════════════════════
  const tabs = [
    { id: "home" as Tab, icon: <Home className="w-5 h-5" />, label: "Home" },
    { id: "requests" as Tab, icon: <Bell className="w-5 h-5" />, label: "Requests" },
    { id: "earnings" as Tab, icon: <Wallet className="w-5 h-5" />, label: "Earnings" },
    { id: "profile" as Tab, icon: <UserIcon className="w-5 h-5" />, label: "Profile" },
  ];

  const typeIcon = (t: string) => {
    if (t === "chat") return <MessageCircle className="w-4 h-4 text-primary" />;
    if (t === "voice") return <Phone className="w-4 h-4 text-green-400" />;
    return <Video className="w-4 h-4 text-cosmic-light" />;
  };

  const statusBadge = (s: string) => {
    const map: Record<string, string> = {
      completed: "bg-green-500/20 text-green-400",
      active: "bg-primary/20 text-primary",
      ringing: "bg-yellow-500/20 text-yellow-400",
      waiting: "bg-yellow-500/20 text-yellow-400",
      missed: "bg-destructive/20 text-destructive",
      rejected: "bg-destructive/20 text-destructive",
      cancelled: "bg-muted text-muted-foreground",
      expired: "bg-muted text-muted-foreground",
    };
    return map[s] || "bg-muted text-muted-foreground";
  };

  const timeAgo = (iso: string | null | undefined) => {
    if (!iso) return "";
    const d = new Date(iso);
    const diff = (Date.now() - d.getTime()) / 1000;
    if (diff < 60) return "just now";
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    return `${Math.floor(diff / 86400)}d ago`;
  };

  return (
    <div className="min-h-screen gradient-mystic relative flex flex-col">
      <StarField />

      {/* Header */}
      <header className="relative z-10 flex items-center justify-between p-4 border-b border-border bg-card/50 backdrop-blur-lg">
        <div className="flex items-center gap-2">
          <span className="text-xl">🔮</span>
          <span className="font-display text-gold-gradient text-lg">Astrologer Panel</span>
        </div>
        <div className="flex items-center gap-3">
          {stats?.is_online ? (
            <Badge className="bg-green-500/20 text-green-400 border-green-500/30">Online</Badge>
          ) : (
            <Badge className="bg-muted text-muted-foreground">Offline</Badge>
          )}
          <button onClick={() => { logout(); navigate("/"); }}>
            <LogOut className="w-5 h-5 text-muted-foreground" />
          </button>
        </div>
      </header>

      <main className="relative z-10 flex-1 overflow-auto pb-20">
        {activeTab === "home" && (
          <div className="p-4 space-y-6">
            <div>
              <h2 className="text-xl font-display text-foreground">Namaste, {user.name} 🙏</h2>
              <p className="text-muted-foreground text-sm mt-1">Your dashboard overview</p>
            </div>

            {/* Top KPI grid — earnings + rating + reviews + sessions */}
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-card/60 border border-border rounded-xl p-4 glow-gold">
                <div className="flex items-center gap-2">
                  <TrendingUp className="w-4 h-4 text-primary" />
                  <span className="text-[10px] text-muted-foreground uppercase tracking-wide">Today's Earning</span>
                </div>
                <p className="text-2xl font-display text-gold-gradient mt-1">
                  ₹{stats ? stats.today_earning : "—"}
                </p>
                <p className="text-[10px] text-muted-foreground mt-1">
                  Total: ₹{stats ? stats.total_earning : "—"}
                </p>
              </div>

              <div className="bg-card/60 border border-border rounded-xl p-4">
                <div className="flex items-center gap-2">
                  <Wallet className="w-4 h-4 text-cosmic-light" />
                  <span className="text-[10px] text-muted-foreground uppercase tracking-wide">Wallet</span>
                </div>
                <p className="text-2xl font-display text-cosmic-light mt-1">
                  ₹{stats ? stats.wallet_balance : "—"}
                </p>
                <p className="text-[10px] text-muted-foreground mt-1">Withdrawable</p>
              </div>

              <div className="bg-card/60 border border-border rounded-xl p-4">
                <div className="flex items-center gap-2">
                  <Star className="w-4 h-4 text-primary fill-primary" />
                  <span className="text-[10px] text-muted-foreground uppercase tracking-wide">Rating</span>
                </div>
                <div className="flex items-baseline gap-1 mt-1">
                  <p className="text-2xl font-display text-foreground">
                    {stats ? stats.rating.toFixed(1) : "—"}
                  </p>
                  <span className="text-xs text-muted-foreground">/ 5</span>
                </div>
                <p className="text-[10px] text-muted-foreground mt-1">
                  {stats ? stats.total_reviews : 0} reviews
                </p>
              </div>

              <div className="bg-card/60 border border-border rounded-xl p-4">
                <div className="flex items-center gap-2">
                  <UsersIcon className="w-4 h-4 text-primary" />
                  <span className="text-[10px] text-muted-foreground uppercase tracking-wide">Sessions</span>
                </div>
                <p className="text-2xl font-display text-foreground mt-1">
                  {stats ? stats.total_consultations : "—"}
                </p>
                <p className="text-[10px] text-muted-foreground mt-1">
                  {stats ? stats.total_minutes : 0} min total
                </p>
              </div>
            </div>

            {/* Total request counts — chat / voice / video */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Total Requests</h3>
              <div className="grid grid-cols-3 gap-2">
                <div className="bg-card/60 border border-border rounded-xl p-3 text-center">
                  <MessageCircle className="w-5 h-5 text-primary mx-auto" />
                  <p className="text-lg font-display text-foreground mt-1">
                    {stats ? stats.requests.chat_total : 0}
                  </p>
                  <p className="text-[10px] text-muted-foreground">Chat</p>
                </div>
                <div className="bg-card/60 border border-border rounded-xl p-3 text-center">
                  <Phone className="w-5 h-5 text-green-400 mx-auto" />
                  <p className="text-lg font-display text-foreground mt-1">
                    {stats ? stats.requests.voice_total : 0}
                  </p>
                  <p className="text-[10px] text-muted-foreground">Voice Call</p>
                </div>
                <div className="bg-card/60 border border-border rounded-xl p-3 text-center">
                  <Video className="w-5 h-5 text-cosmic-light mx-auto" />
                  <p className="text-lg font-display text-foreground mt-1">
                    {stats ? stats.requests.video_total : 0}
                  </p>
                  <p className="text-[10px] text-muted-foreground">Video Call</p>
                </div>
              </div>
              {stats?.requests?.pending_total > 0 && (
                <div className="mt-2 bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-2 flex items-center gap-2">
                  <Bell className="w-4 h-4 text-yellow-400 animate-pulse" />
                  <p className="text-xs text-yellow-400">
                    {stats.requests.pending_total} pending request(s) waiting
                  </p>
                </div>
              )}
            </div>

            {/* Recent Requests from users — bottom */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <h3 className="text-sm font-semibold text-primary">Recent Requests</h3>
                <button
                  onClick={() => setActiveTab("requests")}
                  className="text-xs text-primary hover:underline"
                >
                  View all →
                </button>
              </div>
              {recentRequests.length === 0 ? (
                <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
                  <p className="text-xs text-muted-foreground">No requests yet</p>
                </div>
              ) : (
                <div className="space-y-2">
                  {recentRequests.slice(0, 6).map((r: any) => (
                    <div
                      key={`${r.type}-${r.id}`}
                      className="bg-card/60 border border-border rounded-xl p-3 flex items-center gap-3"
                    >
                      <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center text-lg overflow-hidden shrink-0">
                        {r.user_avatar
                          ? <img src={r.user_avatar} alt="" className="w-full h-full object-cover" />
                          : "🧑"}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-semibold text-foreground truncate">{r.user_name}</h4>
                        <div className="flex items-center gap-2 text-[11px] text-muted-foreground flex-wrap">
                          {typeIcon(r.type)}
                          <span className="capitalize">{r.type}</span>
                          <span>·</span>
                          <span>{timeAgo(r.created_at)}</span>
                        </div>
                      </div>
                      <div className="flex flex-col items-end gap-1">
                        <Badge className={`${statusBadge(r.status)} text-[9px] capitalize`}>{r.status}</Badge>
                        {r.earning > 0 && (
                          <span className="text-[10px] text-green-400 font-semibold">+₹{r.earning}</span>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}

        {activeTab === "requests" && (
          <div className="p-4 space-y-4">
            <h2 className="text-xl font-display text-gold-gradient">All Requests</h2>
            {recentRequests.length === 0 ? (
              <div className="bg-card/60 border border-border rounded-xl p-8 text-center">
                <p className="text-sm text-muted-foreground">No requests yet</p>
              </div>
            ) : (
              recentRequests.map((r: any) => (
                <div key={`${r.type}-${r.id}`} className="bg-card/60 border border-border rounded-xl p-4">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl overflow-hidden">
                      {r.user_avatar
                        ? <img src={r.user_avatar} alt="" className="w-full h-full object-cover" />
                        : "🧑"}
                    </div>
                    <div className="flex-1 min-w-0">
                      <h4 className="font-semibold text-foreground truncate">{r.user_name}</h4>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        {typeIcon(r.type)}
                        <span className="capitalize">{r.type} Request</span>
                      </div>
                      <p className="text-[10px] text-muted-foreground">{timeAgo(r.created_at)}</p>
                    </div>
                    <Badge className={`${statusBadge(r.status)} text-xs capitalize`}>{r.status}</Badge>
                  </div>
                  {r.status === "waiting" || r.status === "ringing" ? (
                    <div className="flex gap-2 mt-3">
                      <Button size="sm" className="flex-1 gradient-gold text-primary-foreground">
                        <CheckCircle className="w-3 h-3 mr-1" /> Accept
                      </Button>
                      <Button size="sm" variant="outline" className="flex-1 border-destructive text-destructive">
                        <XCircle className="w-3 h-3 mr-1" /> Decline
                      </Button>
                    </div>
                  ) : (
                    <div className="flex justify-between items-center mt-3 pt-3 border-t border-border text-xs text-muted-foreground">
                      <span>Duration: {Math.floor((r.duration_sec || 0) / 60)}m {(r.duration_sec || 0) % 60}s</span>
                      {r.earning > 0 && <span className="text-green-400 font-semibold">Earned ₹{r.earning}</span>}
                    </div>
                  )}
                </div>
              ))
            )}
          </div>
        )}

        {activeTab === "earnings" && (
          <div className="p-4 space-y-4">
            {/* Balance card */}
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <p className="text-xs text-muted-foreground">Current Balance</p>
              <p className="text-4xl font-display text-gold-gradient mt-1">
                ₹{walletData ? walletData.balance : "—"}
              </p>
              <div className="grid grid-cols-3 gap-2 mt-4 pt-4 border-t border-border">
                <div>
                  <p className="text-[10px] text-muted-foreground">Total Earned</p>
                  <p className="text-sm font-semibold text-green-400">
                    ₹{walletData ? walletData.total_earned : "—"}
                  </p>
                </div>
                <div>
                  <p className="text-[10px] text-muted-foreground">Withdrawn</p>
                  <p className="text-sm font-semibold text-destructive">
                    ₹{walletData ? walletData.total_withdrawn : "—"}
                  </p>
                </div>
                <div>
                  <p className="text-[10px] text-muted-foreground">Withdrawable</p>
                  <p className="text-sm font-semibold text-primary">
                    ₹{walletData ? walletData.withdrawable.toFixed(2) : "—"}
                  </p>
                </div>
              </div>
              {walletData?.pending_withdrawal > 0 && (
                <p className="text-[10px] text-yellow-400 mt-2">
                  ₹{walletData.pending_withdrawal} pending in withdrawal requests
                </p>
              )}
              <Button
                className="mt-4 gradient-gold text-primary-foreground w-full"
                onClick={openWithdrawDialog}
                disabled={!walletData || walletData.withdrawable <= 0}
              >
                <Download className="w-4 h-4 mr-1" /> Withdraw Funds
              </Button>
              {walletData?.withdrawal_config && (
                <p className="text-[10px] text-muted-foreground mt-2">
                  Min ₹{walletData.withdrawal_config.min_amount} · Processing: {walletData.withdrawal_config.processing_days} days
                </p>
              )}
            </div>

            {/* Statement filter */}
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-semibold text-primary">Wallet Statement</h3>
              <select
                value={walletTxnKind}
                onChange={(e) => setWalletTxnKind(e.target.value)}
                className="bg-muted border border-border rounded-lg text-xs px-2 py-1 text-foreground"
              >
                <option value="all">All</option>
                <option value="earning">Earnings</option>
                <option value="withdrawal">Withdrawals</option>
              </select>
            </div>

            {/* Statement list */}
            <div className="space-y-2">
              {walletTxns.length === 0 && (
                <p className="text-xs text-muted-foreground text-center py-6">
                  No transactions yet
                </p>
              )}
              {walletTxns.map((t: any) => (
                <div key={t.id} className="bg-card/60 border border-border rounded-lg p-3">
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex items-start gap-2 flex-1 min-w-0">
                      {t.direction === "credit" ? (
                        <ArrowDownLeft className="w-4 h-4 text-green-400 shrink-0 mt-0.5" />
                      ) : (
                        <ArrowUpRight className="w-4 h-4 text-destructive shrink-0 mt-0.5" />
                      )}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1">
                          <Badge variant="outline" className={`text-[9px] border ${
                            t.direction === "credit"
                              ? "border-green-500/30 text-green-400"
                              : "border-destructive/30 text-destructive"
                          }`}>{t.label}</Badge>
                        </div>
                        <p className="text-xs text-foreground mt-1 truncate" title={t.description}>
                          {t.description || "—"}
                        </p>
                        <p className="text-[10px] text-muted-foreground mt-0.5">
                          {t.created_at?.slice(0, 16)}
                        </p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className={`text-sm font-bold ${t.direction === "credit" ? "text-green-400" : "text-destructive"}`}>
                        {t.direction === "credit" ? "+" : "−"}₹{t.amount}
                      </p>
                      <p className="text-[10px] text-muted-foreground">Bal: ₹{t.balance_after}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Pagination */}
            {walletTxnTotal > ASTRO_WALLET_PAGE_SIZE && (
              <div className="flex items-center justify-between pt-2">
                <p className="text-xs text-muted-foreground">
                  Page {walletTxnPage + 1} of {Math.max(1, Math.ceil(walletTxnTotal / ASTRO_WALLET_PAGE_SIZE))}
                </p>
                <div className="flex gap-2">
                  <Button size="sm" variant="outline" disabled={walletTxnPage === 0}
                    onClick={() => setWalletTxnPage((p) => Math.max(0, p - 1))}
                    className="h-8 border-border">Prev</Button>
                  <Button size="sm" variant="outline"
                    disabled={(walletTxnPage + 1) * ASTRO_WALLET_PAGE_SIZE >= walletTxnTotal}
                    onClick={() => setWalletTxnPage((p) => p + 1)}
                    className="h-8 border-border">Next</Button>
                </div>
              </div>
            )}

            {/* Withdrawal requests history */}
            {withdrawalHistory.length > 0 && (
              <div>
                <h3 className="text-sm font-semibold text-primary mt-6 mb-2">Withdrawal Requests</h3>
                <div className="space-y-2">
                  {withdrawalHistory.map((w: any) => (
                    <div key={w.id} className="bg-card/60 border border-border rounded-lg p-3">
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-sm font-semibold text-foreground">₹{w.amount}</p>
                          <p className="text-[10px] text-muted-foreground">
                            {w.requested_at?.slice(0, 16)}
                            {w.upi_id && <> · UPI: {w.upi_id}</>}
                            {w.bank_account_number && <> · Bank: ••••{w.bank_account_number}</>}
                          </p>
                          {w.admin_note && (
                            <p className="text-[10px] text-yellow-400 mt-1">Note: {w.admin_note}</p>
                          )}
                        </div>
                        <Badge className={
                          w.status === "paid" ? "bg-green-500/20 text-green-400" :
                          w.status === "pending" ? "bg-yellow-500/20 text-yellow-400" :
                          w.status === "approved" ? "bg-primary/20 text-primary" :
                          "bg-destructive/20 text-destructive"
                        }>
                          {w.status}
                        </Badge>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {activeTab === "profile" && (
          <div className="p-4 space-y-4">
            {/* Profile header */}
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
              <div className="w-20 h-20 rounded-full bg-secondary mx-auto flex items-center justify-center text-3xl overflow-hidden">
                {astroMe?.profile?.profile_image_url
                  ? <img src={astroMe.profile.profile_image_url} alt="" className="w-full h-full object-cover" />
                  : "🔮"}
              </div>
              <h3 className="text-lg font-display text-foreground mt-3">
                {astroMe?.profile?.display_name || astroMe?.name || user.name}
              </h3>
              <p className="text-sm text-muted-foreground">{astroMe?.email || user.email}</p>
              {astroMe?.phone && <p className="text-xs text-muted-foreground">{astroMe.phone}</p>}
              {stats && (
                <div className="flex justify-center gap-4 mt-3 text-sm text-muted-foreground">
                  <span>⭐ {stats.rating.toFixed(1)}</span>
                  <span>{stats.total_consultations} sessions</span>
                  <span>{stats.commission_pct}% commission</span>
                </div>
              )}
              <Badge className="mt-3 bg-green-500/20 text-green-400">
                <Shield className="w-3 h-3 mr-1" /> KYC Verified
              </Badge>
              <Button
                className="mt-4 gradient-gold text-primary-foreground w-full"
                onClick={() => setEditProfileDialog(true)}
              >
                <Pencil className="w-3.5 h-3.5 mr-1" /> Edit Profile
              </Button>
            </div>

            {/* About */}
            {astroMe?.profile?.bio && (
              <div className="bg-card/60 border border-border rounded-xl p-4">
                <h3 className="text-sm font-semibold text-primary mb-2">About</h3>
                <p className="text-xs text-foreground/80 whitespace-pre-wrap">{astroMe.profile.bio}</p>
              </div>
            )}

            {/* Professional details */}
            <div className="bg-card/60 border border-border rounded-xl p-4 space-y-3">
              <h3 className="text-sm font-semibold text-primary">Professional Details</h3>
              <div className="grid grid-cols-2 gap-2 text-xs">
                <div>
                  <p className="text-muted-foreground">Experience</p>
                  <p className="text-foreground font-medium">{astroMe?.profile?.experience_years || 0} years</p>
                </div>
                <div>
                  <p className="text-muted-foreground">Qualification</p>
                  <p className="text-foreground font-medium truncate">{astroMe?.profile?.qualification || "—"}</p>
                </div>
                <div className="col-span-2">
                  <p className="text-muted-foreground">Specializations</p>
                  <div className="flex flex-wrap gap-1 mt-1">
                    {(astroMe?.profile?.specializations || []).length > 0
                      ? astroMe.profile.specializations.map((s: string) => (
                          <Badge key={s} variant="outline" className="border-border text-xs">{s}</Badge>
                        ))
                      : <span className="text-foreground/60">—</span>}
                  </div>
                </div>
                <div className="col-span-2">
                  <p className="text-muted-foreground">Languages</p>
                  <div className="flex flex-wrap gap-1 mt-1">
                    {(astroMe?.profile?.languages || []).length > 0
                      ? astroMe.profile.languages.map((l: string) => (
                          <Badge key={l} variant="outline" className="border-border text-xs">{l}</Badge>
                        ))
                      : <span className="text-foreground/60">—</span>}
                  </div>
                </div>
              </div>
            </div>

            {/* Per-minute rate card */}
            <div className="bg-card/60 border border-border rounded-xl p-4">
              <h3 className="text-sm font-semibold text-primary mb-2">Per-Minute Rates</h3>
              <div className="grid grid-cols-3 gap-2">
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <MessageCircle className="w-4 h-4 text-primary mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Chat</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_min_chat || 0}/m</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <Phone className="w-4 h-4 text-green-400 mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Voice</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_min_call || 0}/m</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <Video className="w-4 h-4 text-cosmic-light mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Video</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_min_video || 0}/m</p>
                </div>
              </div>
            </div>

            {/* Per-session rate card */}
            <div className="bg-card/60 border border-border rounded-xl p-4">
              <h3 className="text-sm font-semibold text-primary mb-2">Per-Session Rates</h3>
              <div className="grid grid-cols-3 gap-2">
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <MessageCircle className="w-4 h-4 text-primary mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Chat</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_session_chat || 0}</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <Phone className="w-4 h-4 text-green-400 mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Voice</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_session_call || 0}</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <Video className="w-4 h-4 text-cosmic-light mx-auto" />
                  <p className="text-[10px] text-muted-foreground mt-1">Video</p>
                  <p className="text-sm font-bold text-primary">₹{astroMe?.profile?.rate_per_session_video || 0}</p>
                </div>
              </div>
              <div className="mt-3 bg-primary/5 border border-primary/20 rounded-lg p-2 flex items-start gap-2">
                <Info className="w-3.5 h-3.5 text-primary shrink-0 mt-0.5" />
                <p className="text-[10px] text-muted-foreground">
                  1 chat session = <span className="text-foreground font-semibold">
                    {astroMe?.profile?.session_message_limit || 45} messages
                  </span> from user side, valid for <span className="text-foreground font-semibold">
                    {astroMe?.profile?.session_validity_hours || 24} hours
                  </span>, ends when user clicks end session.
                </p>
              </div>
            </div>

            <Button
              variant="outline"
              className="w-full border-destructive text-destructive"
              onClick={() => { logout(); navigate("/"); }}
            >
              <LogOut className="w-4 h-4 mr-2" /> Logout
            </Button>
          </div>
        )}
      </main>

      {/* ══════ Withdraw Dialog ══════ */}
      <Dialog open={withdrawDialog} onOpenChange={(v) => !v && setWithdrawDialog(false)}>
        <DialogContent className="bg-card border-border max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Download className="w-5 h-5 text-primary" /> Withdraw Funds
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-3 py-2">
            {walletData && (
              <div className="bg-muted/30 border border-border rounded-lg p-3 text-center">
                <p className="text-[10px] text-muted-foreground">Withdrawable Balance</p>
                <p className="text-2xl font-display text-gold-gradient mt-1">
                  ₹{walletData.withdrawable.toFixed(2)}
                </p>
                <p className="text-[10px] text-muted-foreground mt-1">
                  Min ₹{walletData.withdrawal_config.min_amount} · Max/day ₹{walletData.withdrawal_config.max_per_day}
                </p>
              </div>
            )}

            {withdrawError && (
              <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-2">
                <p className="text-xs text-destructive">{withdrawError}</p>
              </div>
            )}

            <div>
              <Label className="text-foreground/80 text-xs">Amount (₹) *</Label>
              <Input
                type="number"
                min="0"
                step="1"
                value={withdrawForm.amount}
                onChange={(e) => setWithdrawForm({ ...withdrawForm, amount: e.target.value })}
                placeholder="Enter amount"
                className="bg-muted border-border mt-1"
              />
            </div>

            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => setWithdrawForm({ ...withdrawForm, use_bank: false })}
                className={`flex-1 py-2 rounded-lg text-xs font-medium ${
                  !withdrawForm.use_bank ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground border border-border"
                }`}
              >
                UPI
              </button>
              <button
                type="button"
                onClick={() => setWithdrawForm({ ...withdrawForm, use_bank: true })}
                className={`flex-1 py-2 rounded-lg text-xs font-medium ${
                  withdrawForm.use_bank ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground border border-border"
                }`}
              >
                Bank Transfer
              </button>
            </div>

            {!withdrawForm.use_bank ? (
              <div>
                <Label className="text-foreground/80 text-xs">UPI ID *</Label>
                <Input
                  value={withdrawForm.upi_id}
                  onChange={(e) => setWithdrawForm({ ...withdrawForm, upi_id: e.target.value })}
                  placeholder="yourname@bank"
                  className="bg-muted border-border mt-1"
                />
              </div>
            ) : (
              <div className="space-y-2">
                <div>
                  <Label className="text-foreground/80 text-xs">Account Holder Name *</Label>
                  <Input
                    value={withdrawForm.bank_account_name}
                    onChange={(e) => setWithdrawForm({ ...withdrawForm, bank_account_name: e.target.value })}
                    placeholder="Full name"
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <Label className="text-foreground/80 text-xs">Account Number *</Label>
                    <Input
                      value={withdrawForm.bank_account_number}
                      onChange={(e) => setWithdrawForm({ ...withdrawForm, bank_account_number: e.target.value })}
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">IFSC *</Label>
                    <Input
                      value={withdrawForm.bank_ifsc}
                      onChange={(e) => setWithdrawForm({ ...withdrawForm, bank_ifsc: e.target.value })}
                      placeholder="HDFC0000123"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                </div>
              </div>
            )}

            <div>
              <Label className="text-foreground/80 text-xs">Note (optional)</Label>
              <Input
                value={withdrawForm.notes}
                onChange={(e) => setWithdrawForm({ ...withdrawForm, notes: e.target.value })}
                placeholder="e.g. monthly payout"
                className="bg-muted border-border mt-1"
              />
            </div>

            <p className="text-[10px] text-muted-foreground">
              Withdrawal requests are reviewed by admin and processed within{" "}
              {walletData?.withdrawal_config?.processing_days || 3} business days.
            </p>
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="outline" onClick={() => setWithdrawDialog(false)}>Cancel</Button>
            <Button
              onClick={submitWithdraw}
              disabled={withdrawSubmitting}
              className="gradient-gold text-primary-foreground"
            >
              {withdrawSubmitting ? "Submitting..." : "Request Withdrawal"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* ══════ Edit Profile Dialog ══════ */}
      <Dialog open={editProfileDialog} onOpenChange={(v) => !v && setEditProfileDialog(false)}>
        <DialogContent className="bg-card border-border max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Pencil className="w-5 h-5 text-primary" /> Edit Profile
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            {profileError && (
              <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-2">
                <p className="text-xs text-destructive">{profileError}</p>
              </div>
            )}

            {/* Personal */}
            <div>
              <h4 className="text-sm font-semibold text-primary mb-2">Personal Info</h4>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <Label className="text-foreground/80 text-xs">Full Name</Label>
                  <Input
                    value={profileForm.name}
                    onChange={(e) => setProfileForm({ ...profileForm, name: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs">Phone</Label>
                  <Input
                    value={profileForm.phone}
                    onChange={(e) => setProfileForm({ ...profileForm, phone: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs">Display Name</Label>
                  <Input
                    value={profileForm.display_name}
                    onChange={(e) => setProfileForm({ ...profileForm, display_name: e.target.value })}
                    placeholder="Shown to users"
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs">Profile Image URL</Label>
                  <Input
                    value={profileForm.profile_image_url}
                    onChange={(e) => setProfileForm({ ...profileForm, profile_image_url: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
              </div>
            </div>

            {/* Professional */}
            <div>
              <h4 className="text-sm font-semibold text-primary mb-2">Professional Info</h4>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <Label className="text-foreground/80 text-xs">Experience (years)</Label>
                  <Input
                    type="number" min="0"
                    value={profileForm.experience_years}
                    onChange={(e) => setProfileForm({ ...profileForm, experience_years: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs">Qualification</Label>
                  <Input
                    value={profileForm.qualification}
                    onChange={(e) => setProfileForm({ ...profileForm, qualification: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div className="col-span-2">
                  <Label className="text-foreground/80 text-xs">Languages (comma separated)</Label>
                  <Input
                    value={profileForm.languages}
                    onChange={(e) => setProfileForm({ ...profileForm, languages: e.target.value })}
                    placeholder="Hindi, English, Sanskrit"
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div className="col-span-2">
                  <Label className="text-foreground/80 text-xs">Specializations (comma separated)</Label>
                  <Input
                    value={profileForm.specializations}
                    onChange={(e) => setProfileForm({ ...profileForm, specializations: e.target.value })}
                    placeholder="Vedic Astrology, Kundli Matching, Numerology"
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div className="col-span-2">
                  <Label className="text-foreground/80 text-xs">Bio</Label>
                  <textarea
                    value={profileForm.bio}
                    onChange={(e) => setProfileForm({ ...profileForm, bio: e.target.value })}
                    rows={3}
                    className="w-full bg-muted border border-border rounded-lg mt-1 px-3 py-2 text-sm text-foreground"
                  />
                </div>
              </div>
            </div>

            {/* Per-minute rates */}
            <div>
              <h4 className="text-sm font-semibold text-primary mb-2">Per-Minute Rates (₹/min)</h4>
              <div className="grid grid-cols-3 gap-2">
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <MessageCircle className="w-3 h-3" /> Chat
                  </Label>
                  <Input
                    type="number" min="0" step="0.5"
                    value={profileForm.rate_per_min_chat}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_min_chat: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <Phone className="w-3 h-3" /> Voice
                  </Label>
                  <Input
                    type="number" min="0" step="0.5"
                    value={profileForm.rate_per_min_call}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_min_call: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <Video className="w-3 h-3" /> Video
                  </Label>
                  <Input
                    type="number" min="0" step="0.5"
                    value={profileForm.rate_per_min_video}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_min_video: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
              </div>
            </div>

            {/* Per-session rates */}
            <div>
              <h4 className="text-sm font-semibold text-primary mb-2">Per-Session Rates (₹/session)</h4>
              <p className="text-[10px] text-muted-foreground mb-2">
                Flat fee for 1 session. A chat session = N user messages, valid for X hours.
              </p>
              <div className="grid grid-cols-3 gap-2">
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <MessageCircle className="w-3 h-3" /> Chat
                  </Label>
                  <Input
                    type="number" min="0" step="1"
                    value={profileForm.rate_per_session_chat}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_session_chat: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <Phone className="w-3 h-3" /> Voice
                  </Label>
                  <Input
                    type="number" min="0" step="1"
                    value={profileForm.rate_per_session_call}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_session_call: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs flex items-center gap-1">
                    <Video className="w-3 h-3" /> Video
                  </Label>
                  <Input
                    type="number" min="0" step="1"
                    value={profileForm.rate_per_session_video}
                    onChange={(e) => setProfileForm({ ...profileForm, rate_per_session_video: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                </div>
              </div>
            </div>

            {/* Session limits */}
            <div>
              <h4 className="text-sm font-semibold text-primary mb-2">Chat Session Limits</h4>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <Label className="text-foreground/80 text-xs">User Message Limit</Label>
                  <Input
                    type="number" min="1" max="500"
                    value={profileForm.session_message_limit}
                    onChange={(e) => setProfileForm({ ...profileForm, session_message_limit: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                  <p className="text-[10px] text-muted-foreground mt-1">Default: 45 messages = 1 session</p>
                </div>
                <div>
                  <Label className="text-foreground/80 text-xs">Session Validity (hours)</Label>
                  <Input
                    type="number" min="1" max="168"
                    value={profileForm.session_validity_hours}
                    onChange={(e) => setProfileForm({ ...profileForm, session_validity_hours: e.target.value })}
                    className="bg-muted border-border mt-1"
                  />
                  <p className="text-[10px] text-muted-foreground mt-1">Default: 24 hours</p>
                </div>
              </div>
            </div>
          </div>
          <div className="flex justify-end gap-2 pt-2 border-t border-border">
            <Button variant="outline" onClick={() => setEditProfileDialog(false)}>Cancel</Button>
            <Button
              onClick={submitProfile}
              disabled={profileSaving}
              className="gradient-gold text-primary-foreground"
            >
              <Save className="w-3.5 h-3.5 mr-1" /> {profileSaving ? "Saving..." : "Save Changes"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      <nav className="fixed bottom-0 left-0 right-0 z-20 bg-card/90 backdrop-blur-lg border-t border-border">
        <div className="flex">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 flex flex-col items-center py-2.5 transition-colors ${
                activeTab === tab.id ? "text-primary" : "text-muted-foreground"
              }`}
            >
              {tab.icon}
              <span className="text-[10px] mt-0.5">{tab.label}</span>
            </button>
          ))}
        </div>
      </nav>
    </div>
  );
};

export default AstrologerDashboard;
