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
  FileText, TrendingUp, Users as UsersIcon,
} from "lucide-react";
import {
  fetchAstroMeKycStatus, submitAstroKyc, fetchAstroMeStats,
  fetchAstroMeRecentRequests,
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
          <div className="p-4 space-y-6">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <p className="text-sm text-muted-foreground">Total Earnings</p>
              <p className="text-4xl font-display text-gold-gradient mt-2">
                ₹{stats ? stats.total_earning : "—"}
              </p>
              <div className="grid grid-cols-2 gap-2 mt-4 pt-4 border-t border-border">
                <div>
                  <p className="text-[10px] text-muted-foreground">Today</p>
                  <p className="text-sm font-semibold text-green-400">
                    ₹{stats ? stats.today_earning : "—"}
                  </p>
                </div>
                <div>
                  <p className="text-[10px] text-muted-foreground">Wallet Balance</p>
                  <p className="text-sm font-semibold text-primary">
                    ₹{stats ? stats.wallet_balance : "—"}
                  </p>
                </div>
              </div>
              <Button className="mt-4 gradient-gold text-primary-foreground w-full">Withdraw</Button>
            </div>

            {/* Recent completed sessions for earnings history */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Earnings History</h3>
              <div className="space-y-2">
                {recentRequests.filter((r: any) => r.status === "completed" && r.earning > 0).length === 0 && (
                  <p className="text-xs text-muted-foreground text-center py-4">No completed sessions yet</p>
                )}
                {recentRequests
                  .filter((r: any) => r.status === "completed" && r.earning > 0)
                  .map((t: any) => (
                    <div key={`earn-${t.type}-${t.id}`} className="bg-card/60 border border-border rounded-lg p-3 flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        {typeIcon(t.type)}
                        <div>
                          <p className="text-sm text-foreground">
                            {t.type === "chat" ? "Chat" : t.type === "voice" ? "Voice Call" : "Video Call"} — {t.user_name}
                          </p>
                          <p className="text-xs text-muted-foreground">
                            {Math.floor((t.duration_sec || 0) / 60)} min · {timeAgo(t.created_at)}
                          </p>
                        </div>
                      </div>
                      <span className="text-sm font-semibold text-green-400">+₹{t.earning}</span>
                    </div>
                  ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === "profile" && (
          <div className="p-4 space-y-4">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
              <div className="w-20 h-20 rounded-full bg-secondary mx-auto flex items-center justify-center text-3xl overflow-hidden">
                {user.avatar
                  ? <img src={user.avatar} alt="" className="w-full h-full object-cover" />
                  : "🔮"}
              </div>
              <h3 className="text-lg font-display text-foreground mt-3">{user.name}</h3>
              <p className="text-sm text-muted-foreground">{user.email}</p>
              {stats && (
                <div className="flex justify-center gap-4 mt-3 text-sm text-muted-foreground">
                  <span>⭐ {stats.rating.toFixed(1)}</span>
                  <span>{stats.total_consultations}+ sessions</span>
                  <span>{stats.commission_pct}% commission</span>
                </div>
              )}
              <Badge className="mt-3 bg-green-500/20 text-green-400">
                <Shield className="w-3 h-3 mr-1" /> KYC Verified
              </Badge>
            </div>
            <div className="space-y-2">
              {["Edit Profile", "Set Pricing", "Availability", "Languages", "Reviews", "Settings"].map((item) => (
                <div key={item} className="bg-card/60 border border-border rounded-lg p-3 flex items-center justify-between cursor-pointer hover:glow-gold transition-all">
                  <span className="text-sm text-foreground">{item}</span>
                  <span className="text-muted-foreground">›</span>
                </div>
              ))}
            </div>
            <Button variant="outline" className="w-full border-destructive text-destructive" onClick={() => { logout(); navigate("/"); }}>
              <LogOut className="w-4 h-4 mr-2" /> Logout
            </Button>
          </div>
        )}
      </main>

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
