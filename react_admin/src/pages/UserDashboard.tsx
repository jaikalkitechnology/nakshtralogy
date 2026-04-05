import { useState, useEffect, useCallback } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import StarField from "@/components/StarField";
import { zodiacSigns, chatEmojis } from "@/data/mockData";
import {
  fetchPublicAstrologers, fetchAstrologerDetail, fetchAstrologerReviews,
  fetchServicePricing, fetchMe, updateMe,
  fetchMyWallet, fetchMyWalletTransactions, rechargeMyWallet,
  fetchMyOrders, fetchMySavedAstrologers, saveAstrologer, unsaveAstrologer,
} from "@/services/api";
import { Label } from "@/components/ui/label";
import {
  Star, MessageCircle, Phone, Video, Wallet, LogOut, Search,
  User, Home, BookOpen, Clock, Settings, Send, Smile,
  ChevronRight, ChevronLeft, ArrowRight, Circle,
  Plus, Heart, HeartOff, Pencil, Package, Bookmark,
} from "lucide-react";

type Tab = "home" | "astrologers" | "services" | "chat" | "wallet" | "profile";

const UserDashboard = () => {
  const { user, loading: authLoading, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("home");
  const [searchQuery, setSearchQuery] = useState("");
  const [chatMessages, setChatMessages] = useState<{ text: string; fromUser: boolean; time: string }[]>([
    { text: "Namaste 🙏 How can I help you today?", fromUser: false, time: "10:00 AM" },
  ]);
  const [chatInput, setChatInput] = useState("");
  const [showEmoji, setShowEmoji] = useState(false);
  const [selectedAstrologer, setSelectedAstrologer] = useState<any>(null);

  // ── Live data ────────────────────────────────────────────────────
  const [topAstrologers, setTopAstrologers] = useState<any[]>([]);
  const [allAstrologers, setAllAstrologers] = useState<any[]>([]);
  const [services, setServices] = useState<any[]>([]);
  const [loadingAstros, setLoadingAstros] = useState(false);

  // Astrologer profile dialog
  const [profileDialog, setProfileDialog] = useState<{ open: boolean; astro: any }>({
    open: false, astro: null,
  });
  const [profileReviews, setProfileReviews] = useState<any[]>([]);
  const [profileLoading, setProfileLoading] = useState(false);

  // ── Wallet state ─────────────────────────────────────────────────
  const [walletData, setWalletData] = useState<any>(null);
  const [walletTxns, setWalletTxns] = useState<any[]>([]);
  const [walletTxnTotal, setWalletTxnTotal] = useState(0);
  const [walletTypeFilter, setWalletTypeFilter] = useState<string>("all");
  const [walletTxnPage, setWalletTxnPage] = useState(0);
  const WALLET_TXN_PAGE_SIZE = 10;
  const [rechargeDialog, setRechargeDialog] = useState(false);
  const [rechargeAmount, setRechargeAmount] = useState<string>("500");
  const [rechargeNote, setRechargeNote] = useState("");
  const [rechargeSubmitting, setRechargeSubmitting] = useState(false);

  // ── Profile state ────────────────────────────────────────────────
  const [meProfile, setMeProfile] = useState<any>(null);
  const [editProfileDialog, setEditProfileDialog] = useState(false);
  const [profileForm, setProfileForm] = useState<any>({
    name: "", phone: "", gender: "", dob: "", tob: "", birth_place: "",
  });
  const [profileSaving, setProfileSaving] = useState(false);

  // ── Orders state ─────────────────────────────────────────────────
  const [myOrders, setMyOrders] = useState<any[]>([]);
  const [myOrdersTotal, setMyOrdersTotal] = useState(0);

  // ── Saved astrologers state ──────────────────────────────────────
  const [savedAstros, setSavedAstros] = useState<any[]>([]);

  useEffect(() => {
    if (!authLoading && !user) navigate("/auth");
  }, [authLoading, user, navigate]);

  // Load home-tab data
  const loadData = useCallback(async () => {
    if (authLoading || !user) return;
    setLoadingAstros(true);
    try {
      // Top 10 astrologers (server orders online-first, then rating)
      const top = await fetchPublicAstrologers({ limit: 10 });
      if (Array.isArray(top.data)) setTopAstrologers(top.data);

      // Services list (all active)
      const svc = await fetchServicePricing();
      if (Array.isArray(svc.data)) setServices(svc.data);
    } catch (e) {
      console.error(e);
    }
    setLoadingAstros(false);
  }, [authLoading, user]);

  // Load full astrologer list for the Astrologers tab
  const loadAllAstrologers = useCallback(async () => {
    try {
      const res = await fetchPublicAstrologers({ limit: 100 });
      if (Array.isArray(res.data)) setAllAstrologers(res.data);
    } catch (e) { console.error(e); }
  }, []);

  useEffect(() => { loadData(); }, [loadData]);
  useEffect(() => {
    if (activeTab === "astrologers") loadAllAstrologers();
  }, [activeTab, loadAllAstrologers]);

  // Pre-load saved astrologer ids once so the Home slider & Astrologers
  // list can show the heart icon state without waiting for Profile tab.
  useEffect(() => {
    if (!authLoading && user) {
      fetchMySavedAstrologers().then(({ ok, data }) => {
        if (ok) setSavedAstros(data.saved || []);
      });
    }
  }, [authLoading, user]);

  // Open astrologer profile dialog
  const openAstrologerProfile = async (astroId: string) => {
    setProfileDialog({ open: true, astro: null });
    setProfileReviews([]);
    setProfileLoading(true);
    try {
      const [detail, reviews] = await Promise.all([
        fetchAstrologerDetail(astroId),
        fetchAstrologerReviews(astroId, 10),
      ]);
      if (detail.ok) setProfileDialog({ open: true, astro: detail.data });
      if (reviews.ok) setProfileReviews(reviews.data.reviews || []);
    } finally {
      setProfileLoading(false);
    }
  };

  const closeAstrologerProfile = () => {
    setProfileDialog({ open: false, astro: null });
    setProfileReviews([]);
  };

  // ── Wallet data loader ──────────────────────────────────────────
  const loadWallet = useCallback(async () => {
    const [walletRes, txnRes] = await Promise.all([
      fetchMyWallet(),
      fetchMyWalletTransactions({
        skip: walletTxnPage * WALLET_TXN_PAGE_SIZE,
        limit: WALLET_TXN_PAGE_SIZE,
        txn_type: walletTypeFilter,
      }),
    ]);
    if (walletRes.ok) setWalletData(walletRes.data);
    if (txnRes.ok) {
      setWalletTxns(txnRes.data.transactions || []);
      setWalletTxnTotal(txnRes.data.total || 0);
    }
  }, [walletTxnPage, walletTypeFilter]);

  // ── Profile / orders / saved astrologers loader ─────────────────
  const loadProfile = useCallback(async () => {
    const [meRes, ordersRes, savedRes] = await Promise.all([
      fetchMe(),
      fetchMyOrders({ limit: 20 }),
      fetchMySavedAstrologers(),
    ]);
    if (meRes.ok) {
      setMeProfile(meRes.data);
      setProfileForm({
        name: meRes.data.name || "",
        phone: meRes.data.phone || "",
        gender: meRes.data.gender || "",
        dob: meRes.data.dob || "",
        tob: meRes.data.tob || "",
        birth_place: meRes.data.birth_place || "",
      });
    }
    if (ordersRes.ok) {
      setMyOrders(ordersRes.data.orders || []);
      setMyOrdersTotal(ordersRes.data.total || 0);
    }
    if (savedRes.ok) setSavedAstros(savedRes.data.saved || []);
  }, []);

  useEffect(() => {
    if (activeTab === "wallet") loadWallet();
  }, [activeTab, loadWallet]);

  useEffect(() => {
    if (activeTab === "profile") loadProfile();
  }, [activeTab, loadProfile]);

  useEffect(() => { setWalletTxnPage(0); }, [walletTypeFilter]);

  // Set of saved astrologer profile ids for quick lookup
  const savedIdSet = new Set(savedAstros.map((s: any) => s.id));

  // ── Recharge handler ────────────────────────────────────────────
  const submitRecharge = async () => {
    const amt = parseFloat(rechargeAmount);
    if (isNaN(amt) || amt <= 0) {
      alert("Enter a valid amount greater than 0"); return;
    }
    setRechargeSubmitting(true);
    try {
      const { ok, data } = await rechargeMyWallet(amt, rechargeNote || undefined);
      if (!ok) {
        alert(data.detail || "Recharge failed");
      } else {
        setRechargeDialog(false);
        setRechargeAmount("500");
        setRechargeNote("");
        await loadWallet();
        alert(`✓ ₹${amt} added. New balance: ₹${data.balance}`);
      }
    } finally {
      setRechargeSubmitting(false);
    }
  };

  // ── Profile save handler ────────────────────────────────────────
  const submitProfile = async () => {
    setProfileSaving(true);
    try {
      const { ok, data } = await updateMe(profileForm);
      if (!ok) {
        alert(data.detail || "Update failed");
      } else {
        setEditProfileDialog(false);
        await loadProfile();
      }
    } finally {
      setProfileSaving(false);
    }
  };

  // ── Save / Unsave astrologer ────────────────────────────────────
  const toggleSaveAstrologer = async (astroId: string) => {
    if (savedIdSet.has(astroId)) {
      await unsaveAstrologer(astroId);
    } else {
      await saveAstrologer(astroId);
    }
    // Refresh saved list if profile tab, otherwise refetch
    const savedRes = await fetchMySavedAstrologers();
    if (savedRes.ok) setSavedAstros(savedRes.data.saved || []);
  };

  if (authLoading) {
    return (
      <div className="min-h-screen gradient-mystic flex items-center justify-center">
        <p className="text-primary">Loading...</p>
      </div>
    );
  }
  if (!user) return null;

  const sendMessage = () => {
    if (!chatInput.trim()) return;
    setChatMessages((prev) => [...prev, { text: chatInput, fromUser: true, time: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) }]);
    setChatInput("");
    setShowEmoji(false);
    setTimeout(() => {
      setChatMessages((prev) => [...prev, { text: "Thank you for your message. Let me check your chart... 🔮", fromUser: false, time: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) }]);
    }, 1500);
  };

  const tabs = [
    { id: "home" as Tab, icon: <Home className="w-5 h-5" />, label: "Home" },
    { id: "astrologers" as Tab, icon: <Star className="w-5 h-5" />, label: "Astrologers" },
    { id: "services" as Tab, icon: <BookOpen className="w-5 h-5" />, label: "Services" },
    { id: "chat" as Tab, icon: <MessageCircle className="w-5 h-5" />, label: "Chat" },
    { id: "wallet" as Tab, icon: <Wallet className="w-5 h-5" />, label: "Wallet" },
    { id: "profile" as Tab, icon: <User className="w-5 h-5" />, label: "Profile" },
  ];

  const filteredAstrologers = allAstrologers.filter((a: any) => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    const name = (a.display_name || "").toLowerCase();
    const specs = (a.specializations || []).join(" ").toLowerCase();
    return name.includes(q) || specs.includes(q);
  });

  const topOnline = topAstrologers.filter((a: any) => a.is_online).slice(0, 10);
  const topOffline = topAstrologers.filter((a: any) => !a.is_online).slice(0, 10);
  const topFeatured = [...topOnline, ...topOffline].slice(0, 10);

  return (
    <div className="min-h-screen gradient-mystic relative flex flex-col">
      <StarField />

      {/* Header */}
      <header className="relative z-10 flex items-center justify-between p-4 border-b border-border bg-card/50 backdrop-blur-lg">
        <div className="flex items-center gap-2">
          <span className="text-xl">✨</span>
          <span className="font-display text-gold-gradient text-lg">JyotishConnect</span>
        </div>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1 bg-secondary rounded-lg px-3 py-1.5">
            <Wallet className="w-4 h-4 text-primary" />
            <span className="text-sm font-semibold text-primary">₹{user.walletBalance}</span>
          </div>
          <button onClick={() => { logout(); navigate("/"); }} className="text-muted-foreground hover:text-foreground">
            <LogOut className="w-5 h-5" />
          </button>
        </div>
      </header>

      {/* Content */}
      <main className="relative z-10 flex-1 overflow-auto pb-20">
        {activeTab === "home" && (
          <div className="p-4 space-y-6">
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
              <h2 className="text-xl font-display text-foreground">Welcome, {user.name} 🙏</h2>
              <p className="text-muted-foreground text-sm mt-1">What does the cosmos say today?</p>
            </motion.div>

            {/* Daily Zodiac */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Your Zodiac</h3>
              <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-thin">
                {zodiacSigns.map((z) => (
                  <div key={z.name} className="min-w-[70px] bg-card/60 border border-border rounded-xl p-3 text-center flex-shrink-0 hover:glow-gold transition-all cursor-pointer">
                    <span className="text-2xl">{z.symbol}</span>
                    <p className="text-xs text-foreground mt-1">{z.name}</p>
                  </div>
                ))}
              </div>
            </div>

            {/* All Services — at center */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <h3 className="text-sm font-semibold text-primary">All Services</h3>
                <button
                  onClick={() => setActiveTab("services")}
                  className="text-xs text-primary hover:underline flex items-center gap-1"
                >
                  View All <ArrowRight className="w-3 h-3" />
                </button>
              </div>
              {services.length === 0 ? (
                <p className="text-xs text-muted-foreground text-center py-4">Loading services...</p>
              ) : (
                <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                  {services.slice(0, 6).map((s: any) => (
                    <div
                      key={s.id}
                      className="bg-card/60 border border-border rounded-xl p-4 hover:glow-gold transition-all cursor-pointer"
                    >
                      <span className="text-2xl">{s.icon}</span>
                      <h4 className="text-sm font-semibold text-foreground mt-2 line-clamp-1">{s.service_name}</h4>
                      <p className="text-xs text-muted-foreground mt-1 line-clamp-2">{s.description}</p>
                      <div className="flex items-center gap-2 mt-2">
                        {s.is_free || s.price === 0 ? (
                          <Badge className="bg-green-500/20 text-green-400 text-[10px]">FREE</Badge>
                        ) : (
                          <>
                            <span className="text-sm font-bold text-primary">₹{s.price}</span>
                            {s.original_price && s.original_price > s.price && (
                              <span className="text-[10px] text-muted-foreground line-through">₹{s.original_price}</span>
                            )}
                          </>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Top 10 Astrologers (online first) — bottom slider */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <div>
                  <h3 className="text-sm font-semibold text-primary">Top Astrologers</h3>
                  <p className="text-[10px] text-muted-foreground">Online experts ready for chat, call & video</p>
                </div>
                <button
                  onClick={() => setActiveTab("astrologers")}
                  className="text-xs text-primary hover:underline flex items-center gap-1"
                >
                  View All <ArrowRight className="w-3 h-3" />
                </button>
              </div>
              {loadingAstros ? (
                <p className="text-xs text-muted-foreground text-center py-4">Loading astrologers...</p>
              ) : topFeatured.length === 0 ? (
                <p className="text-xs text-muted-foreground text-center py-4">No astrologers available right now</p>
              ) : (
                <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-thin">
                  {topFeatured.map((a: any) => (
                    <div
                      key={a.id}
                      onClick={() => openAstrologerProfile(a.id)}
                      className="min-w-[190px] max-w-[190px] bg-card/60 border border-border rounded-xl p-3 flex-shrink-0 hover:glow-gold transition-all cursor-pointer relative"
                    >
                      {/* Online pulse */}
                      <div className="flex items-center justify-between mb-2">
                        {a.is_online ? (
                          <Badge className="bg-green-500/20 text-green-400 text-[9px] px-1.5 py-0">
                            <Circle className="w-1.5 h-1.5 fill-green-400 mr-1" /> Online
                          </Badge>
                        ) : a.is_busy ? (
                          <Badge className="bg-yellow-500/20 text-yellow-400 text-[9px] px-1.5 py-0">Busy</Badge>
                        ) : (
                          <Badge className="bg-muted text-muted-foreground text-[9px] px-1.5 py-0">Offline</Badge>
                        )}
                        <div className="flex items-center gap-0.5">
                          <Star className="w-3 h-3 text-primary fill-primary" />
                          <span className="text-[11px] text-foreground font-semibold">{(a.rating || 0).toFixed(1)}</span>
                        </div>
                      </div>

                      <div className="flex justify-center">
                        <div className="relative">
                          <div className="w-16 h-16 rounded-full bg-secondary flex items-center justify-center text-2xl border-2 border-primary/20">
                            {a.profile_image_url ? (
                              <img src={a.profile_image_url} alt={a.display_name} className="w-full h-full rounded-full object-cover" />
                            ) : "🔮"}
                          </div>
                          {a.is_online && (
                            <div className="absolute bottom-0 right-0 w-3.5 h-3.5 rounded-full bg-green-500 border-2 border-card" />
                          )}
                        </div>
                      </div>
                      <h4 className="text-xs font-semibold text-foreground mt-2 text-center line-clamp-1">
                        {a.display_name}
                      </h4>
                      <p className="text-[10px] text-primary mt-0.5 text-center line-clamp-1">
                        {(a.specializations || [])[0] || "Astrologer"}
                      </p>
                      <p className="text-[9px] text-muted-foreground text-center">
                        {a.experience_years || 0} yrs · {a.total_consultations || 0} sessions
                      </p>

                      {/* Mini rate row */}
                      <div className="grid grid-cols-3 gap-1 mt-2 pt-2 border-t border-border">
                        <div className="text-center">
                          <MessageCircle className="w-3 h-3 text-primary mx-auto" />
                          <p className="text-[9px] text-foreground mt-0.5">₹{a.rate_per_min_chat}/m</p>
                        </div>
                        <div className="text-center">
                          <Phone className="w-3 h-3 text-primary mx-auto" />
                          <p className="text-[9px] text-foreground mt-0.5">₹{a.rate_per_min_call}/m</p>
                        </div>
                        <div className="text-center">
                          <Video className="w-3 h-3 text-primary mx-auto" />
                          <p className="text-[9px] text-foreground mt-0.5">₹{a.rate_per_min_video}/m</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}

        {activeTab === "astrologers" && (
          <div className="p-4 space-y-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search astrologers by name or specialization..."
                className="pl-10 bg-muted border-border"
              />
            </div>
            <p className="text-xs text-muted-foreground">
              {filteredAstrologers.length} astrologers · online first
            </p>
            {filteredAstrologers.length === 0 && (
              <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                No astrologers found.
              </div>
            )}
            <div className="space-y-3">
              {filteredAstrologers.map((a: any) => (
                <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4">
                  <div
                    className="flex items-start gap-4 cursor-pointer"
                    onClick={() => openAstrologerProfile(a.id)}
                  >
                    <div className="relative">
                      <div className="w-14 h-14 rounded-full bg-secondary flex items-center justify-center text-2xl">
                        {a.profile_image_url
                          ? <img src={a.profile_image_url} alt={a.display_name} className="w-full h-full rounded-full object-cover" />
                          : "🔮"}
                      </div>
                      <div className={`absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full border-2 border-card ${
                        a.is_online && !a.is_busy ? "bg-green-500" :
                        a.is_busy ? "bg-yellow-500" : "bg-muted-foreground"
                      }`} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <h4 className="font-semibold text-foreground truncate">{a.display_name || "—"}</h4>
                        {a.is_online && !a.is_busy && (
                          <Badge className="bg-green-500/20 text-green-400 text-[9px]">Online</Badge>
                        )}
                        {a.is_busy && <Badge className="bg-yellow-500/20 text-yellow-400 text-[9px]">Busy</Badge>}
                      </div>
                      <p className="text-sm text-primary truncate">{(a.specializations || []).join(", ") || "Astrologer"}</p>
                      <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground flex-wrap">
                        <span className="flex items-center gap-0.5">
                          <Star className="w-3 h-3 text-primary fill-primary" /> {(a.rating || 0).toFixed(1)}
                          <span className="text-[10px]">({a.total_reviews || 0})</span>
                        </span>
                        <span>{a.experience_years || 0} yrs</span>
                        <span className="truncate">{(a.languages || []).join(", ")}</span>
                      </div>
                    </div>
                    <button
                      onClick={(e) => { e.stopPropagation(); toggleSaveAstrologer(a.id); }}
                      className={`transition-transform hover:scale-110 ${
                        savedIdSet.has(a.id) ? "text-destructive" : "text-muted-foreground"
                      }`}
                      title={savedIdSet.has(a.id) ? "Remove from saved" : "Save astrologer"}
                    >
                      <Heart className={`w-5 h-5 ${savedIdSet.has(a.id) ? "fill-destructive" : ""}`} />
                    </button>
                  </div>

                  {/* Rate card */}
                  <div className="grid grid-cols-3 gap-2 mt-3 bg-muted/30 rounded-lg p-2">
                    <div className="text-center">
                      <MessageCircle className="w-3.5 h-3.5 text-primary mx-auto" />
                      <p className="text-[10px] text-muted-foreground mt-1">Chat</p>
                      <p className="text-xs font-bold text-foreground">₹{a.rate_per_min_chat}/m</p>
                    </div>
                    <div className="text-center">
                      <Phone className="w-3.5 h-3.5 text-primary mx-auto" />
                      <p className="text-[10px] text-muted-foreground mt-1">Voice</p>
                      <p className="text-xs font-bold text-foreground">₹{a.rate_per_min_call}/m</p>
                    </div>
                    <div className="text-center">
                      <Video className="w-3.5 h-3.5 text-primary mx-auto" />
                      <p className="text-[10px] text-muted-foreground mt-1">Video</p>
                      <p className="text-xs font-bold text-foreground">₹{a.rate_per_min_video}/m</p>
                    </div>
                  </div>

                  {/* Action buttons */}
                  <div className="flex gap-2 mt-3">
                    <Button
                      size="sm"
                      className="flex-1 gradient-gold text-primary-foreground text-xs"
                      disabled={!a.is_online || a.is_busy}
                      onClick={() => { setSelectedAstrologer(a); setActiveTab("chat"); }}
                    >
                      <MessageCircle className="w-3 h-3 mr-1" /> Chat
                    </Button>
                    <Button
                      size="sm" variant="outline"
                      className="flex-1 border-primary text-primary text-xs"
                      disabled={!a.is_online || a.is_busy}
                    >
                      <Phone className="w-3 h-3 mr-1" /> Call
                    </Button>
                    <Button
                      size="sm" variant="outline"
                      className="flex-1 border-cosmic text-cosmic-light text-xs"
                      disabled={!a.is_online || a.is_busy}
                    >
                      <Video className="w-3 h-3 mr-1" /> Video
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === "services" && (
          <div className="p-4 space-y-4">
            <h2 className="text-xl font-display text-gold-gradient">Kundli Services</h2>
            {services.length === 0 ? (
              <p className="text-sm text-muted-foreground text-center py-6">Loading services...</p>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {services.map((s: any) => (
                  <div key={s.id} className="bg-card/60 border border-border rounded-xl p-5 hover:glow-gold transition-all cursor-pointer">
                    <div className="flex items-start gap-4">
                      <span className="text-3xl">{s.icon}</span>
                      <div className="flex-1">
                        <div className="flex items-center justify-between">
                          <h3 className="font-semibold text-foreground">{s.service_name}</h3>
                          <Badge variant="outline" className="text-[10px] capitalize border-border">
                            {s.category}
                          </Badge>
                        </div>
                        <p className="text-sm text-muted-foreground mt-1">{s.description}</p>
                        <div className="flex items-center gap-2 mt-2">
                          {s.is_free || s.price === 0 ? (
                            <Badge className="bg-green-500/20 text-green-400">FREE</Badge>
                          ) : (
                            <>
                              <Badge className="gradient-gold text-primary-foreground">₹{s.price}</Badge>
                              {s.original_price && s.original_price > s.price && (
                                <span className="text-xs text-muted-foreground line-through">₹{s.original_price}</span>
                              )}
                            </>
                          )}
                        </div>
                        {s.features_json && s.features_json.length > 0 && (
                          <div className="flex flex-wrap gap-1 mt-3">
                            {s.features_json.slice(0, 3).map((f: string) => (
                              <span key={f} className="text-[10px] text-primary bg-primary/10 border border-primary/20 rounded-full px-2 py-0.5">
                                {f}
                              </span>
                            ))}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {activeTab === "chat" && (
          <div className="flex flex-col h-[calc(100vh-8rem)]">
            {/* Chat Header */}
            <div className="p-3 border-b border-border bg-card/50 flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center text-lg">
                {selectedAstrologer?.profile_image_url
                  ? <img src={selectedAstrologer.profile_image_url} alt="" className="w-full h-full rounded-full object-cover" />
                  : "🔮"}
              </div>
              <div className="flex-1 min-w-0">
                <h4 className="text-sm font-semibold text-foreground truncate">
                  {selectedAstrologer?.display_name || selectedAstrologer?.name || "Select an astrologer"}
                </h4>
                <p className="text-xs text-primary">
                  {selectedAstrologer
                    ? `₹${selectedAstrologer.rate_per_min_chat || 0}/min • ${selectedAstrologer.is_online ? "Online" : "Offline"}`
                    : "Pick an astrologer from the list"}
                </p>
              </div>
              <div className="flex gap-2">
                <Button size="sm" variant="outline" className="border-primary text-primary h-8 w-8 p-0" disabled={!selectedAstrologer?.is_online}><Phone className="w-4 h-4" /></Button>
                <Button size="sm" variant="outline" className="border-cosmic text-cosmic-light h-8 w-8 p-0" disabled={!selectedAstrologer?.is_online}><Video className="w-4 h-4" /></Button>
              </div>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-auto p-4 space-y-3">
              {chatMessages.map((msg, i) => (
                <motion.div key={i} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className={`flex ${msg.fromUser ? "justify-end" : "justify-start"}`}>
                  <div className={`max-w-[75%] rounded-2xl px-4 py-2.5 ${msg.fromUser ? "gradient-gold text-primary-foreground rounded-br-sm" : "bg-card border border-border text-foreground rounded-bl-sm"}`}>
                    <p className="text-sm">{msg.text}</p>
                    <p className={`text-[10px] mt-1 ${msg.fromUser ? "text-primary-foreground/70" : "text-muted-foreground"}`}>{msg.time}</p>
                  </div>
                </motion.div>
              ))}
            </div>

            {/* Emoji Picker */}
            {showEmoji && (
              <div className="border-t border-border bg-card/90 p-3">
                <div className="flex flex-wrap gap-2">
                  {chatEmojis.map((e) => (
                    <button key={e} onClick={() => setChatInput((p) => p + e)} className="text-xl hover:scale-125 transition-transform">
                      {e}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Input */}
            <div className="p-3 border-t border-border bg-card/50 flex items-center gap-2">
              <button onClick={() => setShowEmoji(!showEmoji)} className="text-muted-foreground hover:text-primary">
                <Smile className="w-5 h-5" />
              </button>
              <Input value={chatInput} onChange={(e) => setChatInput(e.target.value)} placeholder="Type a message..." className="bg-muted border-border flex-1" onKeyDown={(e) => e.key === "Enter" && sendMessage()} />
              <Button size="sm" className="gradient-gold text-primary-foreground h-9 w-9 p-0" onClick={sendMessage}>
                <Send className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )}

        {activeTab === "wallet" && (
          <div className="p-4 space-y-4">
            {/* Balance card */}
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <p className="text-sm text-muted-foreground">Wallet Balance</p>
              <p className="text-4xl font-display text-gold-gradient mt-2">
                ₹{walletData ? walletData.balance : "..."}
              </p>
              <div className="flex gap-2 mt-4 justify-center">
                <Button
                  className="gradient-gold text-primary-foreground"
                  onClick={() => { setRechargeDialog(true); setRechargeAmount("500"); setRechargeNote(""); }}
                >
                  <Plus className="w-4 h-4 mr-1" /> Add Balance
                </Button>
              </div>
              {walletData && (
                <div className="grid grid-cols-2 gap-2 mt-4 pt-4 border-t border-border">
                  <div className="text-center">
                    <p className="text-[10px] text-muted-foreground">Total Credit</p>
                    <p className="text-sm font-semibold text-green-400">+₹{walletData.total_credit}</p>
                  </div>
                  <div className="text-center">
                    <p className="text-[10px] text-muted-foreground">Total Debit</p>
                    <p className="text-sm font-semibold text-destructive">−₹{walletData.total_debit}</p>
                  </div>
                </div>
              )}
            </div>

            {/* Quick recharge chips */}
            <div className="flex gap-2 overflow-x-auto scrollbar-thin">
              {[100, 500, 1000, 2000, 5000].map((amt) => (
                <button
                  key={amt}
                  onClick={() => { setRechargeAmount(String(amt)); setRechargeDialog(true); setRechargeNote(""); }}
                  className="flex-shrink-0 px-4 py-2 rounded-full text-xs bg-card/60 border border-border text-foreground hover:border-primary hover:text-primary transition-all"
                >
                  + ₹{amt}
                </button>
              ))}
            </div>

            {/* Statement header + filter */}
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-semibold text-primary">Wallet Statement</h3>
              <select
                value={walletTypeFilter}
                onChange={(e) => setWalletTypeFilter(e.target.value)}
                className="bg-muted border border-border rounded-lg text-xs px-2 py-1 text-foreground"
              >
                <option value="all">All types</option>
                <option value="recharge">Recharge</option>
                <option value="bonus">Bonus</option>
                <option value="consultation_debit">Service / Call</option>
                <option value="consultation_credit">Credit / Refund</option>
                <option value="refund">Refund</option>
              </select>
            </div>

            {/* Statement list */}
            <div className="space-y-2">
              {walletTxns.length === 0 && (
                <p className="text-xs text-muted-foreground text-center py-6">
                  No transactions yet. Recharge to get started.
                </p>
              )}
              {walletTxns.map((t: any) => (
                <div key={t.id} className="bg-card/60 border border-border rounded-lg p-3">
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <Badge
                          variant="outline"
                          className={`text-[9px] border ${
                            t.direction === "credit"
                              ? "border-green-500/30 text-green-400"
                              : "border-destructive/30 text-destructive"
                          }`}
                        >
                          {t.label}
                        </Badge>
                      </div>
                      <p className="text-xs text-foreground mt-1 truncate" title={t.description}>
                        {t.description || "—"}
                      </p>
                      <p className="text-[10px] text-muted-foreground mt-0.5">
                        {t.created_at?.slice(0, 16)}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className={`text-sm font-bold ${t.direction === "credit" ? "text-green-400" : "text-destructive"}`}>
                        {t.direction === "credit" ? "+" : "−"}₹{t.amount}
                      </p>
                      <p className="text-[10px] text-muted-foreground">
                        Bal: ₹{t.balance_after}
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Pagination */}
            {walletTxnTotal > WALLET_TXN_PAGE_SIZE && (
              <div className="flex items-center justify-between pt-2">
                <p className="text-xs text-muted-foreground">
                  Page {walletTxnPage + 1} of {Math.max(1, Math.ceil(walletTxnTotal / WALLET_TXN_PAGE_SIZE))}
                </p>
                <div className="flex gap-2">
                  <Button
                    size="sm" variant="outline"
                    disabled={walletTxnPage === 0}
                    onClick={() => setWalletTxnPage((p) => Math.max(0, p - 1))}
                    className="h-8 border-border"
                  >
                    <ChevronLeft className="w-4 h-4" /> Prev
                  </Button>
                  <Button
                    size="sm" variant="outline"
                    disabled={(walletTxnPage + 1) * WALLET_TXN_PAGE_SIZE >= walletTxnTotal}
                    onClick={() => setWalletTxnPage((p) => p + 1)}
                    className="h-8 border-border"
                  >
                    Next <ChevronRight className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            )}
          </div>
        )}

        {activeTab === "profile" && (
          <div className="p-4 space-y-4">
            {/* Profile card */}
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <div className="w-20 h-20 rounded-full bg-secondary mx-auto flex items-center justify-center text-3xl overflow-hidden">
                {meProfile?.avatar_url
                  ? <img src={meProfile.avatar_url} alt="" className="w-full h-full object-cover" />
                  : "🧑"}
              </div>
              <h3 className="text-lg font-display text-foreground mt-3">{meProfile?.name || user.name}</h3>
              <p className="text-sm text-muted-foreground">{meProfile?.email || user.email}</p>
              {meProfile?.phone && (
                <p className="text-xs text-muted-foreground mt-0.5">{meProfile.phone}</p>
              )}
              <Button
                size="sm" variant="outline"
                className="mt-4 border-primary text-primary"
                onClick={() => setEditProfileDialog(true)}
              >
                <Pencil className="w-3 h-3 mr-1" /> Edit Profile
              </Button>
            </div>

            {/* Birth details card */}
            {meProfile && (
              <div className="bg-card/60 border border-border rounded-xl p-4 space-y-2">
                <h3 className="text-sm font-semibold text-primary">Birth Details</h3>
                <div className="grid grid-cols-2 gap-2 text-xs">
                  <div>
                    <p className="text-muted-foreground">Gender</p>
                    <p className="text-foreground font-medium capitalize">{meProfile.gender || "—"}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Date of Birth</p>
                    <p className="text-foreground font-medium">{meProfile.dob || "—"}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Time of Birth</p>
                    <p className="text-foreground font-medium">{meProfile.tob || "—"}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Birth Place</p>
                    <p className="text-foreground font-medium truncate">{meProfile.birth_place || "—"}</p>
                  </div>
                </div>
              </div>
            )}

            {/* Saved Astrologers */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-semibold text-primary flex items-center gap-1">
                  <Bookmark className="w-3.5 h-3.5" /> Saved Astrologers ({savedAstros.length})
                </h3>
                {savedAstros.length > 0 && (
                  <button
                    onClick={() => setActiveTab("astrologers")}
                    className="text-[10px] text-primary hover:underline"
                  >
                    Browse more →
                  </button>
                )}
              </div>
              {savedAstros.length === 0 ? (
                <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
                  <Heart className="w-8 h-8 text-muted-foreground mx-auto mb-2" />
                  <p className="text-xs text-muted-foreground">No saved astrologers yet</p>
                  <button
                    onClick={() => setActiveTab("astrologers")}
                    className="text-xs text-primary hover:underline mt-2"
                  >
                    Explore astrologers →
                  </button>
                </div>
              ) : (
                <div className="space-y-2">
                  {savedAstros.map((a: any) => (
                    <div
                      key={a.saved_id}
                      className="bg-card/60 border border-border rounded-xl p-3 flex items-center gap-3 cursor-pointer hover:glow-gold transition-all"
                      onClick={() => openAstrologerProfile(a.id)}
                    >
                      <div className="relative">
                        <div className="w-11 h-11 rounded-full bg-secondary flex items-center justify-center text-lg overflow-hidden">
                          {a.profile_image_url
                            ? <img src={a.profile_image_url} alt="" className="w-full h-full object-cover" />
                            : "🔮"}
                        </div>
                        {a.is_online && !a.is_busy && (
                          <div className="absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 rounded-full bg-green-500 border-2 border-card" />
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-semibold text-foreground truncate">{a.display_name}</h4>
                        <p className="text-[10px] text-primary truncate">{(a.specializations || [])[0] || "Astrologer"}</p>
                        <div className="flex items-center gap-2 mt-0.5 text-[10px] text-muted-foreground">
                          <span className="flex items-center gap-0.5">
                            <Star className="w-2.5 h-2.5 text-primary fill-primary" /> {(a.rating || 0).toFixed(1)}
                          </span>
                          <span>₹{a.rate_per_min_chat}/m</span>
                        </div>
                      </div>
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          toggleSaveAstrologer(a.id);
                        }}
                        className="text-destructive hover:scale-110 transition-transform"
                        title="Remove from saved"
                      >
                        <Heart className="w-4 h-4 fill-destructive" />
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* My Orders */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-2 flex items-center gap-1">
                <Package className="w-3.5 h-3.5" /> My Orders ({myOrdersTotal})
              </h3>
              {myOrders.length === 0 ? (
                <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
                  <p className="text-xs text-muted-foreground">No orders yet</p>
                </div>
              ) : (
                <div className="space-y-2">
                  {myOrders.map((o: any) => (
                    <div key={o.id} className="bg-card/60 border border-border rounded-xl p-3 flex items-center gap-3">
                      <span className="text-2xl">{o.icon || "📜"}</span>
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-semibold text-foreground truncate">{o.service_name}</h4>
                        <p className="text-[10px] text-muted-foreground">{o.created_at?.slice(0, 10)}</p>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-bold text-primary">
                          {o.amount_paid > 0 ? `₹${o.amount_paid}` : "FREE"}
                        </p>
                        <Badge
                          className={`text-[9px] mt-0.5 ${
                            o.status === "completed"
                              ? "bg-green-500/20 text-green-400"
                              : o.status === "pending"
                              ? "bg-yellow-500/20 text-yellow-400"
                              : "bg-muted text-muted-foreground"
                          }`}
                        >
                          {o.status}
                        </Badge>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Logout */}
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

      {/* ══════ Astrologer Profile Dialog ══════ */}
      <Dialog open={profileDialog.open} onOpenChange={(v) => !v && closeAstrologerProfile()}>
        <DialogContent className="bg-card border-border max-w-lg max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Star className="w-5 h-5 text-primary fill-primary" /> Astrologer Profile
            </DialogTitle>
          </DialogHeader>
          {profileLoading && !profileDialog.astro ? (
            <div className="py-8 text-center text-muted-foreground">Loading profile...</div>
          ) : profileDialog.astro ? (
            <div className="space-y-4 py-2">
              {/* Header: avatar + name + status */}
              <div className="flex items-center gap-4">
                <div className="relative">
                  <div className="w-20 h-20 rounded-full bg-secondary flex items-center justify-center text-3xl border-2 border-primary/30">
                    {profileDialog.astro.profile_image_url
                      ? <img src={profileDialog.astro.profile_image_url} alt="" className="w-full h-full rounded-full object-cover" />
                      : "🔮"}
                  </div>
                  {profileDialog.astro.is_online && !profileDialog.astro.is_busy && (
                    <div className="absolute bottom-0 right-0 w-5 h-5 rounded-full bg-green-500 border-2 border-card" />
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <h3 className="text-lg font-semibold text-foreground">{profileDialog.astro.display_name}</h3>
                    {profileDialog.astro.is_online && !profileDialog.astro.is_busy && (
                      <Badge className="bg-green-500/20 text-green-400 text-[10px]">Online</Badge>
                    )}
                    {profileDialog.astro.is_busy && (
                      <Badge className="bg-yellow-500/20 text-yellow-400 text-[10px]">Busy</Badge>
                    )}
                  </div>
                  <p className="text-sm text-primary mt-0.5">{(profileDialog.astro.specializations || []).join(", ")}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <div className="flex items-center">
                      {[1, 2, 3, 4, 5].map((i) => (
                        <Star
                          key={i}
                          className={`w-3.5 h-3.5 ${i <= Math.round(profileDialog.astro.rating || 0) ? "text-primary fill-primary" : "text-muted-foreground"}`}
                        />
                      ))}
                    </div>
                    <span className="text-xs text-muted-foreground">
                      {(profileDialog.astro.rating || 0).toFixed(1)} ({profileDialog.astro.total_reviews || 0} reviews)
                    </span>
                  </div>
                </div>
              </div>

              {/* Stats */}
              <div className="grid grid-cols-3 gap-2">
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <p className="text-xs text-muted-foreground">Experience</p>
                  <p className="text-sm font-semibold text-foreground">{profileDialog.astro.experience_years || 0} yrs</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <p className="text-xs text-muted-foreground">Sessions</p>
                  <p className="text-sm font-semibold text-foreground">{profileDialog.astro.total_consultations || 0}</p>
                </div>
                <div className="bg-muted/30 rounded-lg p-3 text-center border border-border">
                  <p className="text-xs text-muted-foreground">Minutes</p>
                  <p className="text-sm font-semibold text-foreground">{profileDialog.astro.total_minutes || 0}</p>
                </div>
              </div>

              {/* Bio */}
              {profileDialog.astro.bio && (
                <div>
                  <p className="text-xs text-muted-foreground mb-1">About</p>
                  <p className="text-sm text-foreground/80 bg-muted/30 rounded-lg p-3 border border-border">
                    {profileDialog.astro.bio}
                  </p>
                </div>
              )}

              {/* Qualification */}
              {profileDialog.astro.qualification && (
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Qualification</p>
                  <p className="text-sm text-foreground">{profileDialog.astro.qualification}</p>
                </div>
              )}

              {/* Languages */}
              {(profileDialog.astro.languages || []).length > 0 && (
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Languages</p>
                  <div className="flex flex-wrap gap-1.5">
                    {profileDialog.astro.languages.map((l: string) => (
                      <Badge key={l} variant="outline" className="border-border text-xs">{l}</Badge>
                    ))}
                  </div>
                </div>
              )}

              {/* Rate card */}
              <div>
                <p className="text-xs text-muted-foreground mb-2">Rate Card</p>
                <div className="grid grid-cols-3 gap-2">
                  <div className="bg-card border border-primary/20 rounded-lg p-3 text-center">
                    <MessageCircle className="w-5 h-5 text-primary mx-auto" />
                    <p className="text-[10px] text-muted-foreground mt-1">Chat</p>
                    <p className="text-sm font-bold text-primary mt-0.5">₹{profileDialog.astro.rate_per_min_chat}/min</p>
                  </div>
                  <div className="bg-card border border-primary/20 rounded-lg p-3 text-center">
                    <Phone className="w-5 h-5 text-primary mx-auto" />
                    <p className="text-[10px] text-muted-foreground mt-1">Voice</p>
                    <p className="text-sm font-bold text-primary mt-0.5">₹{profileDialog.astro.rate_per_min_call}/min</p>
                  </div>
                  <div className="bg-card border border-primary/20 rounded-lg p-3 text-center">
                    <Video className="w-5 h-5 text-primary mx-auto" />
                    <p className="text-[10px] text-muted-foreground mt-1">Video</p>
                    <p className="text-sm font-bold text-primary mt-0.5">₹{profileDialog.astro.rate_per_min_video}/min</p>
                  </div>
                </div>
              </div>

              {/* Reviews */}
              <div>
                <p className="text-xs text-muted-foreground mb-2">
                  Reviews ({profileReviews.length > 0 ? profileReviews.length : 0})
                </p>
                {profileReviews.length === 0 ? (
                  <p className="text-xs text-muted-foreground text-center py-3 bg-muted/30 rounded-lg border border-border">
                    No reviews yet
                  </p>
                ) : (
                  <div className="space-y-2 max-h-56 overflow-y-auto">
                    {profileReviews.map((r: any) => (
                      <div key={r.id} className="bg-muted/30 rounded-lg p-3 border border-border">
                        <div className="flex items-center justify-between">
                          <p className="text-xs font-medium text-foreground">{r.user_name}</p>
                          <div className="flex items-center">
                            {[1, 2, 3, 4, 5].map((i) => (
                              <Star
                                key={i}
                                className={`w-3 h-3 ${i <= r.rating ? "text-primary fill-primary" : "text-muted-foreground"}`}
                              />
                            ))}
                          </div>
                        </div>
                        {r.comment && (
                          <p className="text-xs text-foreground/70 mt-1.5">{r.comment}</p>
                        )}
                        <p className="text-[10px] text-muted-foreground mt-1">
                          {r.created_at?.slice(0, 10) || ""}
                        </p>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* Save / Unsave toggle */}
              <div className="pt-2 border-t border-border">
                <Button
                  size="sm" variant="outline"
                  className={`w-full ${savedIdSet.has(profileDialog.astro.id) ? "border-destructive text-destructive" : "border-border"}`}
                  onClick={() => toggleSaveAstrologer(profileDialog.astro.id)}
                >
                  {savedIdSet.has(profileDialog.astro.id) ? (
                    <><Heart className="w-3.5 h-3.5 mr-1 fill-destructive" /> Saved</>
                  ) : (
                    <><Heart className="w-3.5 h-3.5 mr-1" /> Save Astrologer</>
                  )}
                </Button>
              </div>

              {/* Action buttons */}
              <div className="flex gap-2">
                <Button
                  size="sm"
                  className="flex-1 gradient-gold text-primary-foreground"
                  disabled={!profileDialog.astro.is_online || profileDialog.astro.is_busy}
                  onClick={() => {
                    setSelectedAstrologer(profileDialog.astro);
                    closeAstrologerProfile();
                    setActiveTab("chat");
                  }}
                >
                  <MessageCircle className="w-3.5 h-3.5 mr-1" /> Chat
                </Button>
                <Button
                  size="sm" variant="outline"
                  className="flex-1 border-primary text-primary"
                  disabled={!profileDialog.astro.is_online || profileDialog.astro.is_busy}
                >
                  <Phone className="w-3.5 h-3.5 mr-1" /> Call
                </Button>
                <Button
                  size="sm" variant="outline"
                  className="flex-1 border-cosmic text-cosmic-light"
                  disabled={!profileDialog.astro.is_online || profileDialog.astro.is_busy}
                >
                  <Video className="w-3.5 h-3.5 mr-1" /> Video
                </Button>
              </div>
            </div>
          ) : null}
        </DialogContent>
      </Dialog>

      {/* ══════ Wallet Recharge Dialog ══════ */}
      <Dialog open={rechargeDialog} onOpenChange={(v) => !v && setRechargeDialog(false)}>
        <DialogContent className="bg-card border-border">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="w-5 h-5 text-primary" /> Add Balance
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-3 py-2">
            <div className="bg-muted/30 border border-border rounded-lg p-3 text-center">
              <p className="text-xs text-muted-foreground">Current Balance</p>
              <p className="text-2xl font-display text-gold-gradient mt-1">
                ₹{walletData?.balance ?? 0}
              </p>
            </div>
            <div>
              <Label className="text-foreground/80 text-xs">Amount to Add (₹)</Label>
              <Input
                type="number" min="1" step="1"
                value={rechargeAmount}
                onChange={(e) => setRechargeAmount(e.target.value)}
                className="bg-muted border-border mt-1"
              />
            </div>
            <div className="flex gap-2 flex-wrap">
              {[100, 500, 1000, 2000, 5000].map((amt) => (
                <button
                  key={amt}
                  onClick={() => setRechargeAmount(String(amt))}
                  className={`px-3 py-1.5 rounded-full text-xs transition-all ${
                    rechargeAmount === String(amt)
                      ? "bg-primary text-primary-foreground"
                      : "bg-muted border border-border text-muted-foreground hover:border-primary"
                  }`}
                >
                  ₹{amt}
                </button>
              ))}
            </div>
            <div>
              <Label className="text-foreground/80 text-xs">Note (optional)</Label>
              <Input
                value={rechargeNote}
                onChange={(e) => setRechargeNote(e.target.value)}
                placeholder="e.g. monthly recharge"
                className="bg-muted border-border mt-1"
              />
            </div>
            <p className="text-[10px] text-muted-foreground">
              💳 In production this will redirect to Razorpay/Stripe. For testing, the
              amount is added directly to your wallet.
            </p>
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="outline" onClick={() => setRechargeDialog(false)}>Cancel</Button>
            <Button
              onClick={submitRecharge}
              disabled={rechargeSubmitting}
              className="gradient-gold text-primary-foreground"
            >
              {rechargeSubmitting ? "Adding..." : `Add ₹${rechargeAmount || 0}`}
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* ══════ Edit Profile Dialog ══════ */}
      <Dialog open={editProfileDialog} onOpenChange={(v) => !v && setEditProfileDialog(false)}>
        <DialogContent className="bg-card border-border max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Pencil className="w-5 h-5 text-primary" /> Edit Profile
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-3 py-2">
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
                placeholder="+91 98765 43210"
                className="bg-muted border-border mt-1"
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div>
                <Label className="text-foreground/80 text-xs">Gender</Label>
                <select
                  value={profileForm.gender}
                  onChange={(e) => setProfileForm({ ...profileForm, gender: e.target.value })}
                  className="w-full bg-muted border border-border rounded-lg mt-1 px-2 py-2 text-sm text-foreground"
                >
                  <option value="">—</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                  <option value="other">Other</option>
                </select>
              </div>
              <div>
                <Label className="text-foreground/80 text-xs">Date of Birth (DD/MM/YYYY)</Label>
                <Input
                  value={profileForm.dob}
                  onChange={(e) => setProfileForm({ ...profileForm, dob: e.target.value })}
                  placeholder="15/08/1992"
                  className="bg-muted border-border mt-1"
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div>
                <Label className="text-foreground/80 text-xs">Time of Birth (HH:MM)</Label>
                <Input
                  value={profileForm.tob}
                  onChange={(e) => setProfileForm({ ...profileForm, tob: e.target.value })}
                  placeholder="06:30"
                  className="bg-muted border-border mt-1"
                />
              </div>
              <div>
                <Label className="text-foreground/80 text-xs">Birth Place</Label>
                <Input
                  value={profileForm.birth_place}
                  onChange={(e) => setProfileForm({ ...profileForm, birth_place: e.target.value })}
                  placeholder="Delhi"
                  className="bg-muted border-border mt-1"
                />
              </div>
            </div>
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="outline" onClick={() => setEditProfileDialog(false)}>Cancel</Button>
            <Button
              onClick={submitProfile}
              disabled={profileSaving}
              className="gradient-gold text-primary-foreground"
            >
              {profileSaving ? "Saving..." : "Save Changes"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* Bottom Nav */}
      <nav className="fixed bottom-0 left-0 right-0 z-20 bg-card/90 backdrop-blur-lg border-t border-border">
        <div className="flex">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 flex flex-col items-center py-2.5 transition-colors ${activeTab === tab.id ? "text-primary" : "text-muted-foreground"}`}
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

export default UserDashboard;
