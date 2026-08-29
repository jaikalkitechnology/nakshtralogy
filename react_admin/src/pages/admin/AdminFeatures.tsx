import { useState, useEffect, useCallback } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useLocation, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import {
  Star, Search,
  Shield, Ban, CheckCircle, Eye, EyeOff,
  Video, Gift, Radio, RefreshCw, Plus, Pencil, Phone, MessageCircle,
  ChevronLeft, ChevronRight, PlusCircle, MinusCircle, Sparkles, X,
  FileText, Mail, Filter, Trash2, Database,
  Upload, Save, KeyRound, CreditCard, Send,
} from "lucide-react";
import DevelopersManager from "@/components/developers/DevelopersManager";

/** Compact display of a (possibly long/absent) FCM token with copy. */
function TokenRow({ label, value }: { label: string; value?: string | null }) {
  const has = !!(value && value.trim());
  return (
    <div className="flex items-center gap-2 text-xs">
      <span className="text-muted-foreground w-32 shrink-0">{label}:</span>
      {has ? (
        <>
          <code className="text-foreground/80 font-mono truncate flex-1" title={value!}>{value}</code>
          <Badge className="bg-green-500/20 text-green-400 shrink-0">registered</Badge>
          <button
            className="text-primary hover:underline shrink-0"
            onClick={() => navigator.clipboard?.writeText(value!)}
            title="Copy token"
          >copy</button>
        </>
      ) : (
        <Badge variant="outline" className="border-border text-muted-foreground">not registered</Badge>
      )}
    </div>
  );
}
import DeveloperAnalytics from "@/components/developers/DeveloperAnalytics";
import DeveloperPlans from "@/components/developers/DeveloperPlans";
import DataTable, { type DataTableColumn } from "@/components/premium/DataTable";
import {
  fetchAstrologers, fetchServicePricing, fetchGiftPricing,
  fetchAgoraConfigs, createAgoraConfig, updateAgoraConfig, deleteAgoraConfig,
  seedServicePricing, seedGiftPricing, seedOpen, updateServicePricing,
  createServicePricing, deleteServicePricing,
  fetchUsdPricingSettings, updateUsdPricingSettings, regenerateUsdPricing,
  createGiftPricing, updateGiftPricing, toggleGiftPricing, deleteGiftPricing,
  adminListUsers, adminAdjustWallet, adminToggleUser, adminGetUser,
  adminDeleteUser, adminCancelDeleteUser,
  adminListAstrologers, adminApproveAstrologer, adminRejectAstrologer,
  adminBlockAstrologer, adminSetCommission, adminAstrologerDetail, adminSendNotification,
  adminListKyc, adminApproveKyc, adminRejectKyc,
  adminListTransactions,
  adminListReviews, adminEditReview, adminToggleReviewVisibility, adminDeleteReview,
  adminListSettings, adminGetCategorySettings, adminUpsertSettings, adminUploadFcmFile,
  type WalletAction,
} from "@/services/api";
import KycFileView from "@/components/admin/KycFileView";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";

/** Summarise the backend's notify result ({push,email,in_app}) as a toast. */
function notifyToast(action: string, data: any) {
  const n = data?.notify || {};
  const sent = [n.push && "push", n.email && "email", n.in_app && "in-app"].filter(Boolean);
  toast.success(
    sent.length ? `${action} — notified via ${sent.join(", ")}` : `${action} — no device/email on file`,
  );
}
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

type Tab = "users" | "astrologers" | "reviews" | "kyc" | "wallet" | "pricing" | "agora" | "gifts" | "settings" | "developers";

// Maps the new premium-shell routes onto the existing (unchanged) feature
// sections below. Several nav destinations intentionally reuse the same
// underlying section (e.g. Wallet / Transactions / Revenue all render the
// existing wallet ledger + stats, since that's the one real data source).
const ROUTE_TAB: Record<string, Tab> = {
  "/admin/users": "users",
  "/admin/astrologers": "astrologers",
  "/admin/reviews": "reviews",
  "/admin/kyc": "kyc",
  "/admin/wallet": "wallet",
  "/admin/transactions": "wallet",
  "/admin/revenue": "wallet",
  "/admin/pricing": "pricing",
  "/admin/gifts": "gifts",
  "/admin/api": "agora",
  "/admin/settings": "settings",
  "/admin/developers": "developers",
};

/**
 * AdminFeatures — the existing admin feature set (Users, Astrologers,
 * Reviews, KYC, Wallet, Pricing, Gifts, Agora/API config, Settings,
 * Developers), restructured to live inside the premium AdminShell and be
 * addressable by real routes instead of internal tab-click state. Every
 * handler, dialog and services/api.ts call below is unchanged from the
 * original AdminPanel — only the outer chrome (sidebar/header) and the
 * tab-selection mechanism (route-driven instead of click-driven) changed.
 */
const AdminFeatures = () => {
  const { user, loading: authLoading, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const activeTab: Tab = ROUTE_TAB[location.pathname] || "users";
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
  const [userDeletionFilter, setUserDeletionFilter] = useState<string>("active"); // active | pending | deleted | all

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
  const [astroDeletionFilter, setAstroDeletionFilter] = useState<string>("active"); // active | pending | deleted | all
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
  const [rejectSections, setRejectSections] = useState<string[]>([]);

  // Astrologer detail dialog
  const [astroDetail, setAstroDetail] = useState<any>(null);

  // Send-notification dialog (works for a user OR an astrologer, by user id)
  const [notifDialog, setNotifDialog] = useState<{
    open: boolean; userId: string; name: string; title: string; body: string;
    sending: boolean; result: any;
  }>({ open: false, userId: "", name: "", title: "", body: "", sending: false, result: null });

  const openSendNotif = (userId: string, name: string) =>
    setNotifDialog({ open: true, userId, name, title: "", body: "", sending: false, result: null });

  const sendNotif = async () => {
    if (!notifDialog.title.trim() || !notifDialog.body.trim()) return;
    setNotifDialog((d) => ({ ...d, sending: true, result: null }));
    try {
      const { ok, data } = await adminSendNotification(notifDialog.userId, notifDialog.title.trim(), notifDialog.body.trim());
      setNotifDialog((d) => ({ ...d, sending: false, result: ok ? data : { error: "Send failed" } }));
    } catch (e: any) {
      setNotifDialog((d) => ({ ...d, sending: false, result: { error: String(e) } }));
    }
  };

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

  // KYC view-docs dialog (popup) — Front/Back/Selfie for one KYC row
  const [kycDocsDialog, setKycDocsDialog] = useState<{ open: boolean; kyc: any }>({
    open: false, kyc: null,
  });

  // ── Reviews Management state ─────────────────────────────────────
  const REVIEWS_PAGE_SIZE = 15;
  const [reviewsList, setReviewsList] = useState<any[]>([]);
  const [reviewsTotal, setReviewsTotal] = useState(0);
  const [reviewsPage, setReviewsPage] = useState(0);
  const [reviewsAverage, setReviewsAverage] = useState<number>(0);
  const [reviewsDistribution, setReviewsDistribution] = useState<Record<string, number>>({
    "1": 0, "2": 0, "3": 0, "4": 0, "5": 0,
  });
  const [reviewsFilterRating, setReviewsFilterRating] = useState<string>("all");
  const [reviewsFilterVisibility, setReviewsFilterVisibility] = useState<string>("all");
  const [reviewsSearch, setReviewsSearch] = useState("");
  const [reviewsDateFrom, setReviewsDateFrom] = useState("");
  const [reviewsDateTo, setReviewsDateTo] = useState("");

  const [reviewEditDialog, setReviewEditDialog] = useState<{ open: boolean; review: any }>({
    open: false, review: null,
  });
  const [reviewEditForm, setReviewEditForm] = useState<any>({
    rating: 5, comment: "", is_visible: true,
  });

  // ── Pricing Management state ─────────────────────────────────────
  const PRICING_PAGE_SIZE = 10;
  const [pricingPage, setPricingPage] = useState(0);
  const [pricingFilterCategory, setPricingFilterCategory] = useState<string>("all");
  const [pricingFilterStatus, setPricingFilterStatus] = useState<string>("all");
  const [pricingSearch, setPricingSearch] = useState("");

  const emptyPricingForm = {
    service_key: "", service_name: "", description: "", icon: "",
    category: "kundli", price: 0, original_price: 0,
    // USD (international / store IAP). Leave blank to auto-compute from the rule.
    price_usd: null as number | null, iap_product_id: "", price_usd_manual: false,
    is_free: false, sort_order: 0, features_json: [] as string[],
    engine_function: "", requires_birth_data: true, max_free_per_user: null as number | null,
  };

  // ── USD pricing settings (FX rate + multiplier) ──────────────────
  const [usdSettings, setUsdSettings] = useState<{ fx_rate_usd: number; usd_multiplier: number }>({
    fx_rate_usd: 83, usd_multiplier: 5,
  });
  const [usdRegenerating, setUsdRegenerating] = useState(false);
  const [pricingDialog, setPricingDialog] = useState<{ open: boolean; mode: "create" | "edit" }>({
    open: false, mode: "create",
  });
  const [pricingForm, setPricingForm] = useState<any>(emptyPricingForm);
  const [pricingFeaturesInput, setPricingFeaturesInput] = useState("");

  // ── Gift Management state ────────────────────────────────────────
  const GIFTS_PAGE_SIZE = 12;
  const [giftsPage, setGiftsPage] = useState(0);
  const [giftsFilterStatus, setGiftsFilterStatus] = useState<string>("all");
  const [giftsSearch, setGiftsSearch] = useState("");
  const [giftDialog, setGiftDialog] = useState<{ open: boolean; mode: "create" | "edit"; gift: any }>({
    open: false, mode: "create", gift: null,
  });
  const emptyGiftForm = { name: "", icon: "", price: 0, sort_order: 0, animation_url: "" };
  const [giftForm, setGiftForm] = useState<any>(emptyGiftForm);

  // ── Platform Settings state ──────────────────────────────────────
  const [settingsCategories, setSettingsCategories] = useState<any[]>([]);
  const [activeSettingsCategory, setActiveSettingsCategory] = useState<string>("google_auth_user");
  const [settingsForm, setSettingsForm] = useState<Record<string, string>>({});
  const [settingsLoaded, setSettingsLoaded] = useState<Record<string, any>>({});
  const [settingsSaving, setSettingsSaving] = useState(false);
  const [showSecretFor, setShowSecretFor] = useState<Record<string, boolean>>({});
  const [fcmUploading, setFcmUploading] = useState<"user" | "astro" | null>(null);
  const [fcmUploadMsg, setFcmUploadMsg] = useState<string>("");

  // ── Agora Config dialog ──────────────────────────────────────────
  const [agoraEditDialog, setAgoraEditDialog] = useState<{ open: boolean; config: any }>({
    open: false, config: null,
  });
  const [agoraEditForm, setAgoraEditForm] = useState<any>({
    label: "", app_id: "", app_certificate: "", is_active: false,
  });

  // Redirect to /auth if not logged in — wait for AuthProvider to finish
  // restoring session from localStorage (otherwise a reload flashes the
  // user back to /auth before the stored session is applied)
  useEffect(() => {
    if (!authLoading && !user) navigate("/auth");
  }, [authLoading, user, navigate]);

  const fetchData = useCallback(async () => {
    // Don't fetch while AuthProvider is still restoring session, or when
    // there's no logged-in user — otherwise every request would 401.
    if (authLoading || !user) return;
    setLoading(true);
    try {
      if (activeTab === "users") {
        const params: Record<string, any> = {
          skip: userPage * USERS_PAGE_SIZE,
          limit: USERS_PAGE_SIZE,
        };
        if (userFilterRole && userFilterRole !== "all") params.role = userFilterRole;
        if (userFilterStatus === "active") params.is_active = true;
        else if (userFilterStatus === "blocked") params.is_active = false;
        if (searchQuery) params.search = searchQuery;
        // Hide deleted/anonymized accounts unless the deletion filter opts in.
        params.deletion_status = userDeletionFilter;
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
        // Hide deleted/anonymized accounts unless the deletion filter opts in.
        params.deletion_status = astroDeletionFilter;
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
      if (activeTab === "reviews") {
        const params: Record<string, any> = {
          skip: reviewsPage * REVIEWS_PAGE_SIZE,
          limit: REVIEWS_PAGE_SIZE,
        };
        if (reviewsFilterRating !== "all") params.rating = Number(reviewsFilterRating);
        if (reviewsFilterVisibility !== "all") params.visibility = reviewsFilterVisibility;
        if (reviewsSearch) params.search = reviewsSearch;
        if (reviewsDateFrom) params.date_from = reviewsDateFrom;
        if (reviewsDateTo) params.date_to = reviewsDateTo;
        const { data } = await adminListReviews(params);
        setReviewsList(data.reviews || []);
        setReviewsTotal(data.total || 0);
        setReviewsAverage(data.average_rating || 0);
        setReviewsDistribution(data.distribution || { "1": 0, "2": 0, "3": 0, "4": 0, "5": 0 });
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
        const params: Record<string, any> = { include_inactive: true };
        if (pricingFilterCategory !== "all") params.category = pricingFilterCategory;
        if (pricingSearch) params.search = pricingSearch;
        const { data } = await fetchServicePricing(params);
        if (Array.isArray(data)) {
          let list = data;
          if (pricingFilterStatus === "active") list = list.filter((p: any) => p.is_active);
          else if (pricingFilterStatus === "inactive") list = list.filter((p: any) => !p.is_active);
          else if (pricingFilterStatus === "free") list = list.filter((p: any) => p.is_free || p.price === 0);
          else if (pricingFilterStatus === "paid") list = list.filter((p: any) => !p.is_free && p.price > 0);
          setPricing(list);
        }
      }
      if (activeTab === "gifts") {
        const { data } = await fetchGiftPricing(true); // include inactive for admin
        if (Array.isArray(data)) {
          let list = data;
          if (giftsFilterStatus === "active") list = list.filter((g: any) => g.is_active);
          else if (giftsFilterStatus === "inactive") list = list.filter((g: any) => !g.is_active);
          if (giftsSearch) {
            const q = giftsSearch.toLowerCase();
            list = list.filter((g: any) => (g.name || "").toLowerCase().includes(q));
          }
          setGifts(list);
        }
      }
      if (activeTab === "agora") {
        const { data } = await fetchAgoraConfigs();
        if (Array.isArray(data)) setAgoraConfigs(data);
      }
      if (activeTab === "settings") {
        const { data } = await adminListSettings();
        const cats = data.categories || [];
        setSettingsCategories(cats);
        // load unmasked values for the active category to populate the form
        const { ok, data: catData } = await adminGetCategorySettings(activeSettingsCategory, true);
        if (ok) {
          const form: Record<string, string> = {};
          (catData.keys || []).forEach((k: any) => { form[k.key] = k.value || ""; });
          setSettingsForm(form);
          setSettingsLoaded((prev) => ({ ...prev, [activeSettingsCategory]: catData }));
        }
      }
    } catch (e) { console.error(e); }
    setLoading(false);
  }, [authLoading, user,
      activeTab, searchQuery, userPage, userFilterStatus, userFilterRole, userDeletionFilter,
      astroPage, astroFilter, astroDeletionFilter, astroSearch, kycPage, kycFilter,
      walletPage, walletFilterType, walletFilterRole, walletSearchTerm,
      walletDateFrom, walletDateTo,
      pricingFilterCategory, pricingFilterStatus, pricingSearch,
      giftsFilterStatus, giftsSearch,
      reviewsPage, reviewsFilterRating, reviewsFilterVisibility,
      reviewsSearch, reviewsDateFrom, reviewsDateTo,
      activeSettingsCategory]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // Reset page to 0 when filters change
  useEffect(() => { setUserPage(0); }, [userFilterStatus, userFilterRole, userDeletionFilter, searchQuery]);
  useEffect(() => { setAstroPage(0); }, [astroFilter, astroDeletionFilter, astroSearch]);
  useEffect(() => { setKycPage(0); }, [kycFilter]);
  useEffect(() => { setWalletPage(0); },
    [walletFilterType, walletFilterRole, walletSearchTerm, walletDateFrom, walletDateTo]);
  useEffect(() => { setPricingPage(0); }, [pricingFilterCategory, pricingFilterStatus, pricingSearch]);
  // Load USD FX rate + multiplier when the pricing tab opens.
  useEffect(() => { if (activeTab === "pricing") loadUsdSettings(); /* eslint-disable-next-line */ }, [activeTab]);
  useEffect(() => { setGiftsPage(0); }, [giftsFilterStatus, giftsSearch]);
  useEffect(() => { setReviewsPage(0); },
    [reviewsFilterRating, reviewsFilterVisibility, reviewsSearch, reviewsDateFrom, reviewsDateTo]);

  const toggleUser = async (userId: string) => {
    await adminToggleUser(userId);
    fetchData();
  };

  // ── Account deletion (user / astrologer / developer) ────────────
  const deleteUserAccount = async (u: any, mode: "schedule" | "immediate") => {
    const label = u?.name || u?.email || "this account";
    const warn = mode === "immediate"
      ? `PERMANENTLY delete ${label} now? Personal data is erased immediately and cannot be recovered. Financial & counterparty records are kept anonymised.`
      : `Schedule ${label} for deletion? The account is locked now and purged after 30 days. It can be restored within the grace period.`;
    if (!window.confirm(warn)) return;
    try {
      await adminDeleteUser(u.id, mode);
      toast.success(mode === "immediate" ? "Account deleted" : "Account scheduled for deletion (30-day grace)");
      fetchData();
    } catch (e: any) {
      toast.error(e?.message || "Could not delete account");
    }
  };

  const cancelUserDeletion = async (u: any) => {
    try {
      await adminCancelDeleteUser(u.id);
      toast.success("Deletion cancelled — account restored");
      fetchData();
    } catch (e: any) {
      toast.error(e?.message || "Could not cancel deletion");
    }
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

  // Open the astrologer dossier: show the list row immediately, then enrich it
  // with full detail (personal/professional info + KYC documents).
  const openAstroDetail = async (a: any) => {
    setAstroDetail({ ...a });
    try {
      const { ok, data } = await adminAstrologerDetail(a.id);
      if (ok) {
        setAstroDetail({
          ...a,
          personal: data.personal,
          professional: data.professional,
          payout_kyc: data.payout_kyc || null,
          kyc_documents: data.kyc_documents || [],
        });
      }
    } catch {
      /* keep the row-only view on failure */
    }
  };

  const approveAstrologer = async (profileId: string) => {
    const { ok, data } = await adminApproveAstrologer(profileId);
    if (ok) notifyToast("Astrologer approved", data);
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
    // Build a human reason from the selected sections + optional note.
    const labels: Record<string, string> = {
      kyc: "KYC documents", personal: "Personal details", professional: "Professional details",
    };
    const sectionText = rejectSections.map((s) => labels[s]).filter(Boolean).join(", ");
    const reason = [
      sectionText ? `${sectionText} incorrect / need correction.` : "",
      rejectReason.trim(),
    ].filter(Boolean).join(" ");
    if (!reason) { alert("Select at least one section or write a reason"); return; }
    const { ok, data } = await adminRejectAstrologer(rejectDialog.astro.id, reason, rejectSections);
    if (!ok) { alert(data.detail || "Reject failed"); return; }
    notifyToast("Astrologer rejected", data);
    setRejectDialog({ open: false, astro: null });
    setRejectReason("");
    setRejectSections([]);
    fetchData();
  };

  // ── KYC actions ──────────────────────────────────────────────────
  const approveKycDoc = async (kycId: string) => {
    const { ok, data } = await adminApproveKyc(kycId);
    if (ok) notifyToast("KYC approved", data);
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
    notifyToast("KYC rejected", data);
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

  // ── USD pricing settings handlers ────────────────────────────────
  const loadUsdSettings = async () => {
    const { ok, data } = await fetchUsdPricingSettings();
    if (ok && data) {
      setUsdSettings({
        fx_rate_usd: Number(data.fx_rate_usd) || 83,
        usd_multiplier: Number(data.usd_multiplier) || 5,
      });
    }
  };

  const saveUsdSettings = async () => {
    await updateUsdPricingSettings({
      fx_rate_usd: Number(usdSettings.fx_rate_usd),
      usd_multiplier: Number(usdSettings.usd_multiplier),
    });
    await loadUsdSettings();
  };

  const handleRegenerateUsd = async (force = false) => {
    setUsdRegenerating(true);
    try {
      // persist the current FX/multiplier first, then regenerate every price.
      await saveUsdSettings();
      await regenerateUsdPricing(force);
      await fetchData();
    } finally {
      setUsdRegenerating(false);
    }
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

  // ── Pricing CRUD handlers ────────────────────────────────────────
  const openPricingCreate = () => {
    setPricingForm({ ...emptyPricingForm });
    setPricingFeaturesInput("");
    setPricingDialog({ open: true, mode: "create" });
  };
  const openPricingEdit = (p: any) => {
    setPricingForm({
      id: p.id,
      service_key: p.service_key,
      service_name: p.service_name,
      description: p.description || "",
      icon: p.icon || "",
      category: p.category || "kundli",
      price: Number(p.price) || 0,
      original_price: Number(p.original_price) || 0,
      is_free: !!p.is_free,
      is_active: p.is_active !== false,
      price_usd: p.price_usd != null ? Number(p.price_usd) : null,
      iap_product_id: p.iap_product_id || "",
      price_usd_manual: !!p.price_usd_manual,
      sort_order: p.sort_order || 0,
      features_json: p.features_json || [],
      engine_function: p.engine_function || "",
      requires_birth_data: p.requires_birth_data !== false,
      max_free_per_user: p.max_free_per_user || null,
    });
    setPricingFeaturesInput((p.features_json || []).join(", "));
    setPricingDialog({ open: true, mode: "edit" });
  };
  const submitPricing = async () => {
    if (!pricingForm.service_key.trim() || !pricingForm.service_name.trim()) {
      alert("service_key and service_name are required"); return;
    }
    const features = pricingFeaturesInput.split(",").map((s) => s.trim()).filter(Boolean);
    const payload: any = {
      service_key: pricingForm.service_key.trim(),
      service_name: pricingForm.service_name.trim(),
      description: pricingForm.description || null,
      icon: pricingForm.icon || null,
      category: pricingForm.category,
      price: Number(pricingForm.price),
      original_price: pricingForm.original_price ? Number(pricingForm.original_price) : null,
      is_free: !!pricingForm.is_free || Number(pricingForm.price) === 0,
      sort_order: Number(pricingForm.sort_order) || 0,
      features_json: features,
      engine_function: pricingForm.engine_function || null,
      requires_birth_data: !!pricingForm.requires_birth_data,
      max_free_per_user: pricingForm.max_free_per_user || null,
      // USD override — only send when set, so free/auto rows keep rule pricing.
      ...(pricingForm.price_usd != null ? { price_usd: Number(pricingForm.price_usd) } : {}),
      ...(pricingForm.iap_product_id ? { iap_product_id: pricingForm.iap_product_id } : {}),
      ...(pricingForm.price_usd_manual != null ? { price_usd_manual: !!pricingForm.price_usd_manual } : {}),
    };
    const { ok, data } =
      pricingDialog.mode === "create"
        ? await createServicePricing(payload)
        : await updateServicePricing(pricingForm.id, payload);
    if (!ok) { alert(data.detail || "Save failed"); return; }
    setPricingDialog({ open: false, mode: "create" });
    fetchData();
  };
  const deletePricing = async (p: any) => {
    if (!confirm(`Delete "${p.service_name}"? This cannot be undone.`)) return;
    const { ok, data } = await deleteServicePricing(p.id);
    if (!ok) { alert(data.detail || "Delete failed"); return; }
    fetchData();
  };
  const togglePricingActive = async (p: any) => {
    await updateServicePricing(p.id, { is_active: !p.is_active });
    fetchData();
  };

  // ── Gift CRUD handlers ───────────────────────────────────────────
  const openGiftCreate = () => {
    setGiftForm({ ...emptyGiftForm });
    setGiftDialog({ open: true, mode: "create", gift: null });
  };
  const openGiftEdit = (g: any) => {
    setGiftForm({
      name: g.name, icon: g.icon, price: Number(g.price),
      sort_order: g.sort_order || 0, animation_url: g.animation_url || "",
    });
    setGiftDialog({ open: true, mode: "edit", gift: g });
  };
  const submitGift = async () => {
    if (!giftForm.name.trim() || !giftForm.icon.trim()) {
      alert("Name and icon are required"); return;
    }
    if (!giftForm.price || Number(giftForm.price) <= 0) {
      alert("Price must be greater than 0"); return;
    }
    const payload = {
      name: giftForm.name.trim(),
      icon: giftForm.icon.trim(),
      price: Number(giftForm.price),
      sort_order: Number(giftForm.sort_order) || 0,
      animation_url: giftForm.animation_url || null,
    };
    const { ok, data } =
      giftDialog.mode === "create"
        ? await createGiftPricing(payload)
        : await updateGiftPricing(giftDialog.gift.id, payload);
    if (!ok) { alert(data.detail || "Save failed"); return; }
    setGiftDialog({ open: false, mode: "create", gift: null });
    fetchData();
  };
  const toggleGiftActive = async (g: any) => {
    const { ok, data } = await toggleGiftPricing(g.id);
    if (!ok) { alert(data.detail || "Toggle failed"); return; }
    fetchData();
  };
  const deleteGift = async (g: any) => {
    if (!confirm(`Delete gift "${g.name}"? This cannot be undone.`)) return;
    const { ok, data } = await deleteGiftPricing(g.id);
    if (!ok) { alert(data.detail || "Delete failed"); return; }
    fetchData();
  };

  // ── Agora CRUD handlers ──────────────────────────────────────────
  const openAgoraEdit = (c: any) => {
    setAgoraEditForm({
      label: c.label, app_id: c.app_id,
      app_certificate: "",  // don't pre-fill secret
      is_active: c.is_active,
    });
    setAgoraEditDialog({ open: true, config: c });
  };
  const submitAgoraEdit = async () => {
    if (!agoraEditDialog.config) return;
    const payload: any = {
      label: agoraEditForm.label,
      app_id: agoraEditForm.app_id,
      is_active: agoraEditForm.is_active,
    };
    if (agoraEditForm.app_certificate && agoraEditForm.app_certificate.trim()) {
      payload.app_certificate = agoraEditForm.app_certificate.trim();
    }
    const { ok, data } = await updateAgoraConfig(agoraEditDialog.config.id, payload);
    if (!ok) { alert(data.detail || "Update failed"); return; }
    setAgoraEditDialog({ open: false, config: null });
    fetchData();
  };
  const deleteAgora = async (c: any) => {
    if (c.is_active) { alert("Cannot delete the active config. Activate another one first."); return; }
    if (!confirm(`Delete Agora config "${c.label}"? This cannot be undone.`)) return;
    const { ok, data } = await deleteAgoraConfig(c.id);
    if (!ok) { alert(data.detail || "Delete failed"); return; }
    fetchData();
  };

  // ── Review handlers ──────────────────────────────────────────────
  const openReviewEdit = (r: any) => {
    setReviewEditForm({
      rating: r.rating,
      comment: r.comment || "",
      is_visible: r.is_visible,
    });
    setReviewEditDialog({ open: true, review: r });
  };
  const submitReviewEdit = async () => {
    if (!reviewEditDialog.review) return;
    const rating = Number(reviewEditForm.rating);
    if (!rating || rating < 1 || rating > 5) {
      alert("Rating must be between 1 and 5"); return;
    }
    const payload: any = {
      rating,
      comment: reviewEditForm.comment || null,
      is_visible: !!reviewEditForm.is_visible,
    };
    const { ok, data } = await adminEditReview(reviewEditDialog.review.id, payload);
    if (!ok) { alert(data.detail || "Save failed"); return; }
    setReviewEditDialog({ open: false, review: null });
    fetchData();
  };
  const toggleReviewVisibility = async (r: any) => {
    const { ok, data } = await adminToggleReviewVisibility(r.id);
    if (!ok) { alert(data.detail || "Toggle failed"); return; }
    fetchData();
  };
  const deleteReview = async (r: any) => {
    if (!confirm(`Delete this ${r.rating}-star review by ${r.user_name || "user"}? This cannot be undone.`)) return;
    const { ok, data } = await adminDeleteReview(r.id);
    if (!ok) { alert(data.detail || "Delete failed"); return; }
    fetchData();
  };

  const clearReviewsFilters = () => {
    setReviewsFilterRating("all");
    setReviewsFilterVisibility("all");
    setReviewsSearch("");
    setReviewsDateFrom("");
    setReviewsDateTo("");
  };

  // ── Settings handlers ────────────────────────────────────────────
  const switchSettingsCategory = async (cat: string) => {
    setActiveSettingsCategory(cat);
    setShowSecretFor({});
    setFcmUploadMsg("");
    const { ok, data } = await adminGetCategorySettings(cat, true);
    if (ok) {
      const form: Record<string, string> = {};
      (data.keys || []).forEach((k: any) => { form[k.key] = k.value || ""; });
      setSettingsForm(form);
      setSettingsLoaded((prev) => ({ ...prev, [cat]: data }));
    }
  };

  const saveSettings = async () => {
    setSettingsSaving(true);
    try {
      // don't send empty values for secret fields (preserves existing)
      const activeCatMeta = settingsLoaded[activeSettingsCategory];
      const secretKeys = new Set(
        (activeCatMeta?.keys || []).filter((k: any) => k.secret).map((k: any) => k.key),
      );
      const payload: Record<string, any> = {};
      Object.entries(settingsForm).forEach(([k, v]) => {
        if (secretKeys.has(k) && (!v || v.trim() === "")) return;
        payload[k] = v;
      });
      const { ok, data } = await adminUpsertSettings(activeSettingsCategory, payload);
      if (!ok) {
        alert(data.detail || "Save failed");
      } else {
        alert(`Saved ${data.updated_fields || 0} settings`);
        // refresh loaded data
        const fresh = await adminGetCategorySettings(activeSettingsCategory, true);
        if (fresh.ok) {
          const form: Record<string, string> = {};
          (fresh.data.keys || []).forEach((k: any) => { form[k.key] = k.value || ""; });
          setSettingsForm(form);
          setSettingsLoaded((prev) => ({ ...prev, [activeSettingsCategory]: fresh.data }));
        }
        fetchData();
      }
    } finally {
      setSettingsSaving(false);
    }
  };

  const uploadFcmJson = async (project: "user" | "astro", file: File) => {
    setFcmUploading(project);
    setFcmUploadMsg("");
    try {
      const { ok, data } = await adminUploadFcmFile(project, file);
      if (!ok) {
        setFcmUploadMsg(`❌ ${data.detail || "Upload failed"}`);
      } else {
        setFcmUploadMsg(`✅ ${data.message} · ${data.project_id}`);
        // refresh active category if it's the one we just uploaded
        if (activeSettingsCategory === `fcm_${project}`) {
          switchSettingsCategory(activeSettingsCategory);
        }
      }
    } finally {
      setFcmUploading(null);
    }
  };

  const fmt = (n: number) => new Intl.NumberFormat("en-IN").format(n);

  // ── DataTable column definitions (D.1/D.2/D.3 premium tables) ────
  // Render cells reuse the exact same handlers as before — no behavior change.
  const userColumns: DataTableColumn<any>[] = [
    { key: "name", header: "Name", sortable: true, render: (u) => (
      <span className="font-medium text-foreground inline-flex items-center gap-1.5">
        {u.name || "—"}
        {u.deleted_at && <Badge className="bg-destructive/20 text-destructive text-[10px]">deleted</Badge>}
        {!u.deleted_at && u.deletion_scheduled_at && <Badge className="bg-amber-500/20 text-amber-400 text-[10px]">deleting</Badge>}
      </span>
    ) },
    { key: "email", header: "Email", sortable: true, hideBelow: "md" },
    { key: "phone", header: "Phone", hideBelow: "lg", render: (u) => u.phone || "—" },
    { key: "role", header: "Role", sortable: true, render: (u) => <Badge variant="outline" className="border-border text-xs capitalize">{u.role}</Badge> },
    { key: "wallet_balance", header: "Balance", align: "right", sortable: true, render: (u) => <span className="font-semibold text-primary">₹{u.wallet_balance}</span> },
    { key: "is_active", header: "Status", align: "center", render: (u) => (
      u.deleted_at
        ? <Badge className="bg-destructive/20 text-destructive">deleted</Badge>
        : <Badge className={u.is_active ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>
            {u.is_active ? "active" : "blocked"}
          </Badge>
    ) },
    { key: "actions", header: "Actions", align: "center", className: "whitespace-nowrap", render: (u) => (
      <div className="flex gap-1 justify-center flex-wrap" onClick={(e) => e.stopPropagation()}>
        <Button size="sm" variant="outline" onClick={() => openUserDetail(u.id)} className="h-7 text-xs border-border" title="View details">
          <Eye className="w-3 h-3" />
        </Button>
        <Button size="sm" variant="outline" onClick={() => openWalletDialog(u, "add_fund")} className="h-7 text-xs border-green-500/50 text-green-400 hover:bg-green-500/10" title="Add funds">
          <PlusCircle className="w-3 h-3" />
        </Button>
        <Button size="sm" variant="outline" onClick={() => openWalletDialog(u, "remove_fund")} className="h-7 text-xs border-orange-500/50 text-orange-400 hover:bg-orange-500/10" title="Remove funds">
          <MinusCircle className="w-3 h-3" />
        </Button>
        <Button size="sm" variant="outline" onClick={() => openWalletDialog(u, "bonus")} className="h-7 text-xs border-primary/50 text-primary hover:bg-primary/10" title="Give bonus">
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
        {u.role !== "admin" && !u.deleted_at && (
          u.deletion_requested_at ? (
            <Button
              size="sm" variant="outline"
              onClick={() => cancelUserDeletion(u)}
              className="h-7 text-xs border-green-500/60 text-green-400 hover:bg-green-500/10"
              title={`Deletion scheduled${u.deletion_scheduled_at ? ` for ${new Date(u.deletion_scheduled_at).toLocaleDateString()}` : ""} — click to restore`}
            >
              <CheckCircle className="w-3 h-3" /> Restore
            </Button>
          ) : (
            <>
              <Button
                size="sm" variant="outline"
                onClick={() => deleteUserAccount(u, "schedule")}
                className="h-7 text-xs border-destructive/60 text-destructive hover:bg-destructive/10"
                title="Schedule deletion (30-day grace)"
              >
                <Trash2 className="w-3 h-3" />
              </Button>
              <Button
                size="sm" variant="outline"
                onClick={() => deleteUserAccount(u, "immediate")}
                className="h-7 text-xs border-destructive text-destructive hover:bg-destructive/20"
                title="Delete now (permanent)"
              >
                <Trash2 className="w-3 h-3" /> Now
              </Button>
            </>
          )
        )}
        {u.deleted_at && (
          <Badge className="bg-destructive/20 text-destructive text-[10px]">deleted</Badge>
        )}
      </div>
    ) },
  ];

  const pricingColumns: DataTableColumn<any>[] = [
    { key: "service_name", header: "Service", sortable: true, render: (p) => (
      <div className="flex items-center gap-2">
        <span className="text-lg">{p.icon}</span>
        <div>
          <p className="font-medium text-foreground">{p.service_name}</p>
          {p.description && <p className="text-[10px] text-muted-foreground truncate max-w-[200px]" title={p.description}>{p.description}</p>}
        </div>
      </div>
    ) },
    { key: "service_key", header: "Key", render: (p) => <code className="text-xs text-muted-foreground">{p.service_key}</code> },
    { key: "category", header: "Category", sortable: true, render: (p) => <Badge variant="outline" className="border-border text-xs capitalize">{p.category}</Badge> },
    { key: "price", header: "Price (₹)", align: "right", sortable: true, render: (p) => <span className="font-semibold text-primary">{p.is_free || p.price === 0 ? "FREE" : `₹${p.price}`}</span> },
    { key: "price_usd", header: "USD (IAP)", align: "right", hideBelow: "md", render: (p) => (
      p.is_free || p.price === 0
        ? <span className="text-xs text-muted-foreground">—</span>
        : <div className="flex flex-col items-end">
            <span className="font-semibold text-emerald-400">{p.price_usd != null ? `$${p.price_usd}` : "—"}</span>
            {p.iap_product_id && <span className="text-[9px] text-muted-foreground truncate max-w-[130px]" title={p.iap_product_id}>{p.iap_product_id}</span>}
            {p.price_usd_manual && <Badge className="bg-amber-500/20 text-amber-400 text-[8px] mt-0.5">manual</Badge>}
          </div>
    ) },
    { key: "original_price", header: "Original", align: "right", hideBelow: "lg", render: (p) => <span className="text-xs text-muted-foreground line-through">{p.original_price ? `₹${p.original_price}` : "—"}</span> },
    { key: "is_active", header: "Status", align: "center", render: (p) => <Badge className={p.is_active ? "bg-green-500/20 text-green-400" : "bg-muted text-muted-foreground"}>{p.is_active ? "Active" : "Inactive"}</Badge> },
    { key: "actions", header: "Actions", align: "center", render: (p) => (
      <div className="flex justify-center gap-1" onClick={(e) => e.stopPropagation()}>
        <Button size="sm" variant="outline" className="h-7 w-7 p-0 border-primary text-primary hover:bg-primary/10" onClick={() => openPricingEdit(p)} title="Edit">
          <Pencil className="w-3 h-3" />
        </Button>
        <Button size="sm" variant="outline" className={`h-7 w-7 p-0 ${p.is_active ? "border-muted-foreground text-muted-foreground" : "border-green-500 text-green-400"}`} onClick={() => togglePricingActive(p)} title={p.is_active ? "Deactivate" : "Activate"}>
          {p.is_active ? <Ban className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
        </Button>
        <Button size="sm" variant="outline" className="h-7 w-7 p-0 border-destructive text-destructive hover:bg-destructive/10" onClick={() => deletePricing(p)} title="Delete">
          <Trash2 className="w-3 h-3" />
        </Button>
      </div>
    ) },
  ];

  const walletColumns: DataTableColumn<any>[] = [
    { key: "created_at", header: "Date", sortable: true, className: "whitespace-nowrap text-xs text-muted-foreground", render: (t) => t.created_at?.slice(0, 16) || "—" },
    { key: "user_name", header: "User", sortable: true, render: (t) => (
      <div>
        <p className="text-xs font-medium text-foreground">{t.user_name || "—"}</p>
        <p className="text-[10px] text-muted-foreground">{t.user_email}</p>
      </div>
    ) },
    { key: "user_role", header: "Role", render: (t) => (
      <Badge variant="outline" className={`border-border text-[10px] capitalize ${t.user_role === "astrologer" ? "text-primary border-primary/30" : t.user_role === "admin" ? "text-yellow-400 border-yellow-500/30" : "text-muted-foreground"}`}>
        {t.user_role}
      </Badge>
    ) },
    { key: "label", header: "Type", render: (t) => {
      const labelClass =
        t.txn_type === "recharge" ? "bg-green-500/20 text-green-400 border-green-500/30" :
        t.txn_type === "bonus" ? "bg-primary/20 text-primary border-primary/30" :
        t.txn_type === "consultation_credit" ? "bg-cosmic-light/20 text-cosmic-light border-cosmic-light/30" :
        t.txn_type === "refund" ? "bg-blue-500/20 text-blue-400 border-blue-500/30" :
        t.txn_type === "withdrawal" ? "bg-orange-500/20 text-orange-400 border-orange-500/30" :
        "bg-destructive/20 text-destructive border-destructive/30";
      return <Badge className={`text-[10px] border ${labelClass}`}>{t.label}</Badge>;
    } },
    { key: "description", header: "Description", hideBelow: "md", className: "max-w-[240px] truncate text-xs text-muted-foreground", render: (t) => <span title={t.description}>{t.description || "—"}</span> },
    { key: "amount", header: "Amount", align: "right", sortable: true, className: "whitespace-nowrap", render: (t) => {
      const isCredit = t.direction === "credit";
      return <span className={`font-semibold ${isCredit ? "text-green-400" : "text-destructive"}`}>{isCredit ? "+" : "−"}₹{fmt(t.amount)}</span>;
    } },
    { key: "balance_after", header: "Balance After", align: "right", hideBelow: "lg", className: "whitespace-nowrap text-xs text-primary", render: (t) => `₹${fmt(t.balance_after)}` },
  ];

  // ── Pagination helpers for pricing/gifts ─────────────────────────
  const pricingPageSlice = pricing.slice(
    pricingPage * PRICING_PAGE_SIZE,
    pricingPage * PRICING_PAGE_SIZE + PRICING_PAGE_SIZE,
  );
  const giftsPageSlice = gifts.slice(
    giftsPage * GIFTS_PAGE_SIZE,
    giftsPage * GIFTS_PAGE_SIZE + GIFTS_PAGE_SIZE,
  );

  if (authLoading) {
    return (
      <div className="min-h-screen gradient-mystic flex items-center justify-center">
        <p className="text-primary">Loading...</p>
      </div>
    );
  }

  if (!user) return null;

  return (
    <div className="space-y-4">
      {/* Section header — sidebar/logout/theme live in AdminShell now */}
      <div className="flex items-center justify-between">
        <h1 className="text-lg font-extrabold capitalize text-foreground">
          {activeTab === "agora" ? "API / RTC Configuration" : activeTab}
        </h1>
        <Button size="sm" variant="outline" className="border-border text-muted-foreground h-8" onClick={fetchData} disabled={loading}>
          <RefreshCw className={`w-3 h-3 mr-1 ${loading ? "animate-spin" : ""}`} /> Refresh
        </Button>
      </div>

      <div>
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
                  <Select value={userDeletionFilter} onValueChange={setUserDeletionFilter}>
                    <SelectTrigger className="w-full md:w-44 bg-muted border-border">
                      <SelectValue placeholder="Deletion" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="active">Exclude deleted</SelectItem>
                      <SelectItem value="pending">Pending deletion</SelectItem>
                      <SelectItem value="deleted">Deleted only</SelectItem>
                      <SelectItem value="all">Include deleted</SelectItem>
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

                {/* Users — premium DataTable (sort/export/pagination), all existing actions preserved */}
                <DataTable<any>
                  columns={userColumns}
                  data={users}
                  keyField={(u) => u.id}
                  loading={loading}
                  page={userPage}
                  pageSize={USERS_PAGE_SIZE}
                  total={usersTotal}
                  onPageChange={setUserPage}
                  hideExport={false}
                  exportFileName="nakshtralogy-users"
                  emptyTitle="No users found"
                  emptyMessage="Adjust filters or run seed."
                />
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

                    {/* Push tokens + send notification */}
                    <div className="rounded-lg border border-border bg-muted/20 p-3 space-y-2">
                      <div className="flex items-center justify-between">
                        <h3 className="text-sm font-semibold text-primary">Push Notifications</h3>
                        <Button size="sm" onClick={() => openSendNotif(userDetail.id, userDetail.name || userDetail.email)}
                          className="h-7 text-xs">
                          <Send className="w-3.5 h-3.5 mr-1" /> Send Notification
                        </Button>
                      </div>
                      <TokenRow label="Native (Android/iOS)" value={userDetail.fcm_token} />
                      <TokenRow label="Web" value={userDetail.fcm_token_web} />
                    </div>

                    <div>
                      <h3 className="text-sm font-semibold text-primary mb-2">Wallet Statement (last 30)</h3>
                      <div className="bg-muted/30 rounded-lg border border-border max-h-72 overflow-auto">
                        {!userDetail.transactions?.length ? (
                          <p className="p-4 text-sm text-muted-foreground text-center">No transactions yet</p>
                        ) : (
                          <table className="w-full min-w-[520px] text-xs">
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
                  <Select value={astroDeletionFilter} onValueChange={setAstroDeletionFilter}>
                    <SelectTrigger className="w-full md:w-44 bg-muted border-border">
                      <SelectValue placeholder="Deletion" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="active">Exclude deleted</SelectItem>
                      <SelectItem value="pending">Pending deletion</SelectItem>
                      <SelectItem value="deleted">Deleted only</SelectItem>
                      <SelectItem value="all">Include deleted</SelectItem>
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
                          {a.deleted_at && <Badge className="bg-destructive/20 text-destructive text-[10px]">Deleted</Badge>}
                          {!a.deleted_at && a.deletion_scheduled_at && <Badge className="bg-amber-500/20 text-amber-400 text-[10px]">Deleting</Badge>}
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

                      {/* Primary action row: View/Approve/Reject (pending) or View/Commission */}
                      <div className="flex gap-2">
                        {!a.is_approved ? (
                          <>
                            <Button
                              size="sm" variant="outline"
                              className="flex-1 border-border text-xs"
                              onClick={() => openAstroDetail(a)}
                              title="View full profile & KYC documents before deciding"
                            >
                              <Eye className="w-3 h-3 mr-1" /> View
                            </Button>
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
                              onClick={() => openAstroDetail(a)}
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

                      {/* Account deletion (schedule / delete-now / restore) */}
                      {!a.deleted_at ? (
                        a.deletion_requested_at ? (
                          <Button
                            size="sm" variant="outline"
                            onClick={() => cancelUserDeletion({ id: a.user_id, name: a.display_name, email: a.email })}
                            className="h-7 text-[11px] w-full border-green-500/60 text-green-400 hover:bg-green-500/10"
                            title={`Deletion scheduled${a.deletion_scheduled_at ? ` for ${new Date(a.deletion_scheduled_at).toLocaleDateString()}` : ""} — click to restore`}
                          >
                            <CheckCircle className="w-3 h-3 mr-1" /> Restore account
                          </Button>
                        ) : (
                          <div className="grid grid-cols-2 gap-1">
                            <Button
                              size="sm" variant="outline"
                              onClick={() => deleteUserAccount({ id: a.user_id, name: a.display_name, email: a.email }, "schedule")}
                              className="h-7 text-[11px] border-destructive/60 text-destructive hover:bg-destructive/10"
                              title="Schedule deletion (30-day grace)"
                            >
                              <Trash2 className="w-3 h-3 mr-1" /> Delete
                            </Button>
                            <Button
                              size="sm" variant="outline"
                              onClick={() => deleteUserAccount({ id: a.user_id, name: a.display_name, email: a.email }, "immediate")}
                              className="h-7 text-[11px] border-destructive text-destructive hover:bg-destructive/20"
                              title="Delete now (permanent)"
                            >
                              <Trash2 className="w-3 h-3 mr-1" /> Delete now
                            </Button>
                          </div>
                        )
                      ) : (
                        <Badge className="bg-destructive/20 text-destructive text-[10px] w-full justify-center py-1">deleted</Badge>
                      )}
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
                          </div>
                        </div>
                        <div className="flex flex-col gap-1 items-end">
                          <Button
                            size="sm" variant="outline"
                            className="border-border h-8 text-xs whitespace-nowrap"
                            onClick={() => setKycDocsDialog({ open: true, kyc: k })}
                          >
                            <Eye className="w-3 h-3 mr-1" /> View Docs
                          </Button>
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

            {/* ══════ REVIEWS & RATINGS ══════ */}
            {activeTab === "reviews" && (
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Reviews & Ratings</h2>
                </div>

                {/* Summary cards */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                  <div className="bg-card/60 border border-border rounded-xl p-3 glow-gold">
                    <p className="text-xs text-muted-foreground">Average Rating</p>
                    <div className="flex items-center gap-1 mt-1">
                      <span className="text-2xl font-display text-gold-gradient">{reviewsAverage.toFixed(2)}</span>
                      <Star className="w-4 h-4 text-primary fill-primary" />
                    </div>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-3">
                    <p className="text-xs text-muted-foreground">Total Reviews</p>
                    <p className="text-2xl font-display text-foreground mt-1">{reviewsTotal}</p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-3 col-span-2">
                    <p className="text-xs text-muted-foreground mb-2">Rating Distribution</p>
                    <div className="space-y-1">
                      {[5, 4, 3, 2, 1].map((star) => {
                        const count = reviewsDistribution[String(star)] || 0;
                        const total = Object.values(reviewsDistribution).reduce((a, b) => a + b, 0);
                        const pct = total > 0 ? (count / total) * 100 : 0;
                        return (
                          <div key={star} className="flex items-center gap-2 text-[11px]">
                            <span className="text-muted-foreground w-4">{star}★</span>
                            <div className="flex-1 h-1.5 bg-muted rounded overflow-hidden">
                              <div
                                className="h-full bg-primary transition-all"
                                style={{ width: `${pct}%` }}
                              />
                            </div>
                            <span className="text-muted-foreground w-8 text-right">{count}</span>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                </div>

                {/* Filters */}
                <div className="bg-card/40 border border-border rounded-xl p-3 space-y-3">
                  <div className="flex items-center gap-2">
                    <Filter className="w-4 h-4 text-primary" />
                    <h3 className="text-sm font-semibold text-primary">Filters</h3>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-2">
                    <div className="relative lg:col-span-2">
                      <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        value={reviewsSearch}
                        onChange={(e) => setReviewsSearch(e.target.value)}
                        placeholder="Search user / astrologer / comment..."
                        className="pl-10 bg-muted border-border h-9"
                      />
                    </div>
                    <Select value={reviewsFilterRating} onValueChange={setReviewsFilterRating}>
                      <SelectTrigger className="bg-muted border-border h-9">
                        <SelectValue placeholder="Rating" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Ratings</SelectItem>
                        <SelectItem value="5">★★★★★ (5)</SelectItem>
                        <SelectItem value="4">★★★★ (4)</SelectItem>
                        <SelectItem value="3">★★★ (3)</SelectItem>
                        <SelectItem value="2">★★ (2)</SelectItem>
                        <SelectItem value="1">★ (1)</SelectItem>
                      </SelectContent>
                    </Select>
                    <Select value={reviewsFilterVisibility} onValueChange={setReviewsFilterVisibility}>
                      <SelectTrigger className="bg-muted border-border h-9">
                        <SelectValue placeholder="Visibility" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All</SelectItem>
                        <SelectItem value="visible">Visible</SelectItem>
                        <SelectItem value="hidden">Hidden</SelectItem>
                      </SelectContent>
                    </Select>
                    <div className="grid grid-cols-2 gap-2 lg:col-span-1">
                      <Input
                        type="date"
                        value={reviewsDateFrom}
                        onChange={(e) => setReviewsDateFrom(e.target.value)}
                        className="bg-muted border-border h-9 text-xs"
                      />
                      <Input
                        type="date"
                        value={reviewsDateTo}
                        onChange={(e) => setReviewsDateTo(e.target.value)}
                        className="bg-muted border-border h-9 text-xs"
                      />
                    </div>
                  </div>
                  {(reviewsFilterRating !== "all" || reviewsFilterVisibility !== "all" ||
                    reviewsSearch || reviewsDateFrom || reviewsDateTo) && (
                    <Button size="sm" variant="outline" onClick={clearReviewsFilters} className="h-7 text-xs border-border">
                      <X className="w-3 h-3 mr-1" /> Clear filters
                    </Button>
                  )}
                </div>

                <p className="text-xs text-muted-foreground">
                  Showing {reviewsList.length} of {reviewsTotal} reviews
                </p>

                {/* Review list */}
                <div className="space-y-3">
                  {reviewsList.length === 0 && (
                    <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                      No reviews match the current filters.
                    </div>
                  )}
                  {reviewsList.map((r: any) => (
                    <div key={r.id} className={`bg-card/60 border rounded-xl p-4 ${r.is_visible ? "border-border" : "border-border opacity-60"}`}>
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex items-start gap-3 flex-1 min-w-0">
                          <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center text-sm shrink-0">
                            {r.user_avatar ? "👤" : (r.user_name?.[0] || "?").toUpperCase()}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2 flex-wrap">
                              <p className="text-foreground font-medium text-sm">{r.user_name || "Anonymous"}</p>
                              <span className="text-xs text-muted-foreground">→</span>
                              <p className="text-primary text-sm font-medium">🔮 {r.astrologer_name}</p>
                              {!r.is_visible && <Badge className="bg-muted text-muted-foreground text-[10px]">Hidden</Badge>}
                            </div>
                            <div className="flex items-center gap-2 mt-1">
                              <div className="flex items-center">
                                {[1, 2, 3, 4, 5].map((i) => (
                                  <Star
                                    key={i}
                                    className={`w-3.5 h-3.5 ${i <= r.rating ? "text-primary fill-primary" : "text-muted-foreground"}`}
                                  />
                                ))}
                              </div>
                              <span className="text-[10px] text-muted-foreground">
                                {r.created_at?.slice(0, 16) || "—"}
                              </span>
                            </div>
                            {r.comment && (
                              <p className="text-sm text-foreground/80 mt-2 whitespace-pre-wrap">{r.comment}</p>
                            )}
                          </div>
                        </div>
                        <div className="flex flex-col gap-1">
                          <Button
                            size="sm" variant="outline"
                            className="h-7 w-7 p-0 border-primary text-primary hover:bg-primary/10"
                            onClick={() => openReviewEdit(r)}
                            title="Edit"
                          >
                            <Pencil className="w-3 h-3" />
                          </Button>
                          <Button
                            size="sm" variant="outline"
                            className={`h-7 w-7 p-0 ${r.is_visible ? "border-muted-foreground text-muted-foreground hover:bg-muted/20" : "border-green-500 text-green-400 hover:bg-green-500/10"}`}
                            onClick={() => toggleReviewVisibility(r)}
                            title={r.is_visible ? "Hide review" : "Show review"}
                          >
                            {r.is_visible ? <EyeOff className="w-3 h-3" /> : <Eye className="w-3 h-3" />}
                          </Button>
                          <Button
                            size="sm" variant="outline"
                            className="h-7 w-7 p-0 border-destructive text-destructive hover:bg-destructive/10"
                            onClick={() => deleteReview(r)}
                            title="Delete"
                          >
                            <Trash2 className="w-3 h-3" />
                          </Button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Pagination */}
                {reviewsTotal > REVIEWS_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {reviewsPage + 1} of {Math.max(1, Math.ceil(reviewsTotal / REVIEWS_PAGE_SIZE))}
                    </p>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" disabled={reviewsPage === 0}
                        onClick={() => setReviewsPage((p) => Math.max(0, p - 1))}
                        className="h-8 border-border">
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button size="sm" variant="outline"
                        disabled={(reviewsPage + 1) * REVIEWS_PAGE_SIZE >= reviewsTotal}
                        onClick={() => setReviewsPage((p) => p + 1)}
                        className="h-8 border-border">
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* ══════ Review Edit Dialog ══════ */}
            <Dialog open={reviewEditDialog.open} onOpenChange={(v) => !v && setReviewEditDialog({ open: false, review: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Pencil className="w-5 h-5 text-primary" /> Edit Review
                  </DialogTitle>
                </DialogHeader>
                {reviewEditDialog.review && (
                  <div className="space-y-3 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border text-xs">
                      <p className="text-foreground font-medium">{reviewEditDialog.review.user_name}</p>
                      <p className="text-muted-foreground">→ 🔮 {reviewEditDialog.review.astrologer_name}</p>
                      <p className="text-muted-foreground mt-1">{reviewEditDialog.review.created_at?.slice(0, 16)}</p>
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Rating</Label>
                      <div className="flex items-center gap-2 mt-2">
                        {[1, 2, 3, 4, 5].map((i) => (
                          <button
                            key={i}
                            type="button"
                            onClick={() => setReviewEditForm({ ...reviewEditForm, rating: i })}
                            className="transition-transform hover:scale-110"
                          >
                            <Star
                              className={`w-8 h-8 ${i <= reviewEditForm.rating ? "text-primary fill-primary" : "text-muted-foreground"}`}
                            />
                          </button>
                        ))}
                        <span className="text-sm text-muted-foreground ml-2">{reviewEditForm.rating} / 5</span>
                      </div>
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Comment</Label>
                      <Textarea
                        value={reviewEditForm.comment}
                        onChange={(e) => setReviewEditForm({ ...reviewEditForm, comment: e.target.value })}
                        placeholder="Review text..."
                        className="bg-muted border-border mt-1 min-h-[100px]"
                      />
                    </div>
                    <label className="flex items-center gap-2 text-xs text-foreground cursor-pointer">
                      <input
                        type="checkbox"
                        checked={reviewEditForm.is_visible}
                        onChange={(e) => setReviewEditForm({ ...reviewEditForm, is_visible: e.target.checked })}
                      />
                      Visible to users (counts toward astrologer rating)
                    </label>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setReviewEditDialog({ open: false, review: null })}>Cancel</Button>
                  <Button onClick={submitReviewEdit} className="gradient-gold text-primary-foreground">
                    Save Changes
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

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
                      <Label className="text-foreground/80">What needs correction?</Label>
                      <div className="mt-2 space-y-2">
                        {[
                          { key: "kyc", label: "KYC documents incorrect" },
                          { key: "personal", label: "Personal details incorrect" },
                          { key: "professional", label: "Professional details incorrect" },
                        ].map((s) => (
                          <label key={s.key} className="flex items-center gap-2 text-sm text-foreground cursor-pointer">
                            <input
                              type="checkbox"
                              checked={rejectSections.includes(s.key)}
                              onChange={(e) =>
                                setRejectSections((prev) =>
                                  e.target.checked ? [...prev, s.key] : prev.filter((x) => x !== s.key))
                              }
                            />
                            {s.label}
                          </label>
                        ))}
                      </div>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Additional note (optional)</Label>
                      <Textarea
                        value={rejectReason}
                        onChange={(e) => setRejectReason(e.target.value)}
                        placeholder="e.g. certificate is unclear, name mismatch on ID…"
                        className="bg-muted border-border mt-1 min-h-[80px]"
                      />
                      <p className="mt-1 text-xs text-muted-foreground">The astrologer is emailed + notified and can re-edit the flagged sections and resubmit.</p>
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => { setRejectDialog({ open: false, astro: null }); setRejectSections([]); }}>Cancel</Button>
                  <Button onClick={submitReject} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                    Reject & Notify
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ KYC View Docs Dialog (popup) ══════ */}
            <Dialog open={kycDocsDialog.open} onOpenChange={(v) => !v && setKycDocsDialog({ open: false, kyc: null })}>
              <DialogContent className="bg-card border-border sm:max-w-lg">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2 text-foreground">
                    <Eye className="w-5 h-5 text-primary" /> KYC Documents
                  </DialogTitle>
                </DialogHeader>
                {kycDocsDialog.kyc && (
                  <div className="space-y-4 py-2">
                    <div className="bg-muted/40 rounded-lg p-3 border border-border">
                      <p className="text-sm text-foreground font-medium">{kycDocsDialog.kyc.user_name}</p>
                      <p className="text-xs text-muted-foreground">{kycDocsDialog.kyc.user_email}</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Doc: <span className="text-foreground capitalize">{kycDocsDialog.kyc.doc_type}</span>
                        {kycDocsDialog.kyc.doc_number && <> · #{kycDocsDialog.kyc.doc_number}</>}
                      </p>
                    </div>
                    {/* Auth-protected paths — fetched with the admin token via
                        KycFileView rather than a plain link/tab-open. */}
                    <div className="grid grid-cols-3 gap-3">
                      <KycFileView label="Front" path={kycDocsDialog.kyc.front_url} />
                      <KycFileView label="Back" path={kycDocsDialog.kyc.back_url} />
                      <KycFileView label="Selfie" path={kycDocsDialog.kyc.selfie_url} />
                    </div>
                    {kycDocsDialog.kyc.rejection_reason && (
                      <p className="text-xs text-destructive">Rejected: {kycDocsDialog.kyc.rejection_reason}</p>
                    )}
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setKycDocsDialog({ open: false, kyc: null })}>
                    Close
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
                      <Label className="text-foreground/80">Common reasons</Label>
                      <div className="mt-2 flex flex-wrap gap-2">
                        {[
                          "Document is blurry / unclear",
                          "Name does not match profile",
                          "Document number unreadable",
                          "Document expired",
                          "Wrong document type uploaded",
                        ].map((r) => (
                          <button
                            key={r}
                            type="button"
                            onClick={() => setKycRejectReason((prev) => (prev.trim() ? prev.trim() + "; " + r : r))}
                            className="rounded-full border border-border px-3 py-1 text-xs text-muted-foreground hover:border-primary hover:text-primary"
                          >+ {r}</button>
                        ))}
                      </div>
                    </div>
                    <div>
                      <Label className="text-foreground/80">Rejection Reason (emailed + notified)</Label>
                      <Textarea
                        value={kycRejectReason}
                        onChange={(e) => setKycRejectReason(e.target.value)}
                        placeholder="Tap a common reason above or type here…"
                        className="bg-muted border-border mt-1 min-h-[90px]"
                      />
                      <p className="mt-1 text-xs text-muted-foreground">The astrologer can re-upload KYC after this.</p>
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

                    {/* Push tokens + send notification (astro) */}
                    <div className="rounded-lg border border-border bg-muted/20 p-3 space-y-2">
                      <div className="flex items-center justify-between">
                        <p className="text-sm font-semibold text-primary">Push Notifications</p>
                        <Button size="sm" className="h-7 text-xs"
                          onClick={() => openSendNotif(astroDetail.personal?.user_id || astroDetail.user_id, astroDetail.display_name || astroDetail.personal?.name || "")}>
                          <Send className="w-3.5 h-3.5 mr-1" /> Send Notification
                        </Button>
                      </div>
                      <TokenRow label="Native (Android/iOS)" value={astroDetail.personal?.fcm_token} />
                      <TokenRow label="Web" value={astroDetail.personal?.fcm_token_web} />
                    </div>

                    {/* Payout & tax KYC — PAN/GST + bank details for withdrawals (10% TDS vs PAN) */}
                    {astroDetail.payout_kyc && (
                      <div>
                        <p className="text-muted-foreground text-xs mb-2 flex items-center gap-1">
                          <FileText className="w-3.5 h-3.5" /> Payout & Tax Details
                          {astroDetail.payout_kyc.payout_ready
                            ? <Badge className="bg-green-500/20 text-green-400">payout ready</Badge>
                            : <Badge className="bg-yellow-500/20 text-yellow-400">incomplete</Badge>}
                        </p>
                        <div className="rounded-xl border border-border p-3 bg-muted/20 space-y-1.5 text-xs">
                          <div className="grid grid-cols-2 gap-x-4 gap-y-1">
                            <div><span className="text-muted-foreground">PAN:</span> <span className="font-mono text-foreground">{astroDetail.payout_kyc.pan_number || "—"}</span></div>
                            <div><span className="text-muted-foreground">Name (PAN):</span> <span className="text-foreground">{astroDetail.payout_kyc.pan_name || "—"}</span></div>
                            <div><span className="text-muted-foreground">GST:</span> <span className="font-mono text-foreground">{astroDetail.payout_kyc.gst_number || "—"}</span></div>
                            <div><span className="text-muted-foreground">A/C name:</span> <span className="text-foreground">{astroDetail.payout_kyc.bank_account_name || "—"}</span></div>
                            <div><span className="text-muted-foreground">A/C no.:</span> <span className="font-mono text-foreground">{astroDetail.payout_kyc.bank_account_number || "—"}</span></div>
                            <div><span className="text-muted-foreground">IFSC:</span> <span className="font-mono text-foreground">{astroDetail.payout_kyc.bank_ifsc || "—"}</span></div>
                          </div>
                          <div className="grid grid-cols-2 gap-2 pt-1">
                            <KycFileView label="PAN card" path={astroDetail.payout_kyc.pan_doc_url} />
                            <KycFileView label="Bank proof" path={astroDetail.payout_kyc.bank_proof_url} />
                          </div>
                        </div>
                      </div>
                    )}

                    {/* KYC documents — image / PDF viewers (admin-authorized) */}
                    <div>
                      <p className="text-muted-foreground text-xs mb-2 flex items-center gap-1">
                        <FileText className="w-3.5 h-3.5" /> KYC Documents
                      </p>
                      {astroDetail.kyc_documents === undefined ? (
                        <p className="text-xs text-muted-foreground">Loading documents…</p>
                      ) : (astroDetail.kyc_documents || []).length === 0 ? (
                        <p className="text-xs text-muted-foreground">No KYC submitted yet.</p>
                      ) : (
                        <div className="space-y-4">
                          {astroDetail.kyc_documents.map((k: any) => (
                            <div key={k.id} className="rounded-xl border border-border p-3 bg-muted/20">
                              <div className="flex items-center justify-between mb-2">
                                <div className="text-xs text-foreground">
                                  <span className="capitalize font-semibold">{k.doc_type}</span>
                                  {k.doc_number ? <span className="text-muted-foreground"> · {k.doc_number}</span> : null}
                                </div>
                                <Badge className={
                                  k.status === "approved" ? "bg-green-500/20 text-green-400"
                                    : k.status === "rejected" ? "bg-destructive/20 text-destructive"
                                    : "bg-yellow-500/20 text-yellow-400"
                                }>{k.status}</Badge>
                              </div>
                              <div className="grid grid-cols-3 gap-2">
                                <KycFileView label="Front" path={k.front_url} />
                                <KycFileView label="Back" path={k.back_url} />
                                <KycFileView label="Selfie" path={k.selfie_url} />
                              </div>
                              {k.rejection_reason ? (
                                <p className="text-[11px] text-destructive mt-2">Reason: {k.rejection_reason}</p>
                              ) : null}
                              {k.created_at ? (
                                <p className="text-[10px] text-muted-foreground mt-1">Submitted: {String(k.created_at).slice(0, 16)}</p>
                              ) : null}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}
                <DialogFooter>
                  <Button variant="outline" onClick={() => setAstroDetail(null)}>Close</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ Send Notification Dialog (user or astrologer) ══════ */}
            <Dialog open={notifDialog.open} onOpenChange={(v) => !v && setNotifDialog((d) => ({ ...d, open: false }))}>
              <DialogContent className="bg-card border-border max-w-md">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Send className="w-5 h-5 text-primary" /> Send Notification
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-3">
                  <p className="text-xs text-muted-foreground">To: <span className="text-foreground">{notifDialog.name}</span></p>
                  <div>
                    <Label className="text-xs">Title</Label>
                    <Input
                      value={notifDialog.title}
                      maxLength={80}
                      onChange={(e) => setNotifDialog((d) => ({ ...d, title: e.target.value }))}
                      placeholder="Notification title"
                      className="bg-muted/30 border-border"
                    />
                  </div>
                  <div>
                    <Label className="text-xs">Message</Label>
                    <Textarea
                      value={notifDialog.body}
                      maxLength={300}
                      rows={3}
                      onChange={(e) => setNotifDialog((d) => ({ ...d, body: e.target.value }))}
                      placeholder="Notification message"
                      className="bg-muted/30 border-border"
                    />
                  </div>
                  {notifDialog.result && (
                    <div className={`text-xs rounded-lg p-2 border ${notifDialog.result.error ? "border-destructive/40 bg-destructive/10 text-destructive" : notifDialog.result.push_delivered ? "border-green-500/40 bg-green-500/10 text-green-400" : "border-yellow-500/40 bg-yellow-500/10 text-yellow-400"}`}>
                      <p className="font-semibold">
                        {notifDialog.result.error
                          ? `Error: ${notifDialog.result.error}`
                          : notifDialog.result.push_delivered
                            ? "Delivered to device ✓ (and saved in-app)"
                            : (notifDialog.result.diagnosis || "Saved in-app. Push not delivered.")}
                      </p>
                      {!notifDialog.result.push_delivered && !notifDialog.result.error && (
                        notifDialog.result.expected_project === undefined ? (
                          <p className="mt-1 text-muted-foreground">
                            Backend is out of date (no diagnostics in response) — redeploy the API to
                            see the exact reason, or call GET /admin/fcm/diagnostics.
                          </p>
                        ) : (
                          <p className="mt-1 text-muted-foreground">
                            Firebase initialized: <b>{String(notifDialog.result.firebase_initialized)}</b>
                            {" · "}project loaded: <b>{notifDialog.result.firebase_project_loaded || "—"}</b>
                            {" · "}expected: <b>{notifDialog.result.expected_project}</b>
                          </p>
                        )
                      )}
                      {Array.isArray(notifDialog.result.results) && notifDialog.result.results.some((r: any) => !r.ok) && (
                        <ul className="mt-1 list-disc list-inside">
                          {notifDialog.result.results.filter((r: any) => !r.ok).map((r: any, i: number) => (
                            <li key={i} className="break-all">{r.target}: {r.error}</li>
                          ))}
                        </ul>
                      )}
                    </div>
                  )}
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setNotifDialog((d) => ({ ...d, open: false }))}>Close</Button>
                  <Button onClick={sendNotif} disabled={notifDialog.sending || !notifDialog.title.trim() || !notifDialog.body.trim()}>
                    {notifDialog.sending ? "Sending…" : "Send"}
                  </Button>
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

                {/* Statement — premium DataTable */}
                <DataTable<any>
                  title={`Wallet Statement · ${walletTotal} entries`}
                  columns={walletColumns}
                  data={transactions}
                  keyField={(t) => t.id}
                  loading={loading}
                  page={walletPage}
                  pageSize={WALLET_PAGE_SIZE}
                  total={walletTotal}
                  onPageChange={setWalletPage}
                  exportFileName="nakshtralogy-wallet-statement"
                  emptyTitle="No transactions"
                  emptyMessage="No transactions match the current filters."
                />
              </div>
            )}

            {/* ══════ PRICING ══════ */}
            {activeTab === "pricing" && (
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Service Pricing</h2>
                  <div className="flex gap-2">
                    <Button size="sm" onClick={handleSeedPricing} variant="outline" className="border-border text-muted-foreground">
                      <RefreshCw className="w-3 h-3 mr-1" /> Seed Defaults
                    </Button>
                    <Button size="sm" onClick={openPricingCreate} className="gradient-gold text-primary-foreground">
                      <Plus className="w-3 h-3 mr-1" /> Add Service
                    </Button>
                  </div>
                </div>

                {/* USD pricing rule: FX rate + multiplier + regenerate.
                    usd = round_to_tier(inr × multiplier ÷ fx_rate) → nearest IAP tier. */}
                <div className="flex flex-col md:flex-row md:items-end gap-3 p-3 rounded-lg border border-border bg-muted/40">
                  <div>
                    <Label className="text-foreground/80 text-xs">FX rate (₹ per $1)</Label>
                    <Input
                      type="number" min="1" step="0.01"
                      value={usdSettings.fx_rate_usd}
                      onChange={(e) => setUsdSettings({ ...usdSettings, fx_rate_usd: Number(e.target.value) })}
                      className="bg-muted border-border mt-1 w-32"
                    />
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">Multiplier (×INR)</Label>
                    <Input
                      type="number" min="0.1" step="0.1"
                      value={usdSettings.usd_multiplier}
                      onChange={(e) => setUsdSettings({ ...usdSettings, usd_multiplier: Number(e.target.value) })}
                      className="bg-muted border-border mt-1 w-32"
                    />
                  </div>
                  <div className="flex gap-2 md:ml-auto">
                    <Button size="sm" variant="outline" onClick={saveUsdSettings} className="border-primary text-primary">
                      Save FX
                    </Button>
                    <Button size="sm" onClick={() => handleRegenerateUsd(false)} disabled={usdRegenerating} className="gradient-gold text-primary-foreground">
                      <RefreshCw className={`w-3 h-3 mr-1 ${usdRegenerating ? "animate-spin" : ""}`} /> Regenerate USD
                    </Button>
                    <Button size="sm" variant="outline" onClick={() => handleRegenerateUsd(true)} disabled={usdRegenerating} className="border-destructive text-destructive" title="Overwrite manual overrides too">
                      Force all
                    </Button>
                  </div>
                </div>

                {/* Filters */}
                <div className="flex flex-col md:flex-row gap-2">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <Input
                      value={pricingSearch}
                      onChange={(e) => setPricingSearch(e.target.value)}
                      placeholder="Search by name or key..."
                      className="pl-10 bg-muted border-border"
                    />
                  </div>
                  <Select value={pricingFilterCategory} onValueChange={setPricingFilterCategory}>
                    <SelectTrigger className="w-full md:w-40 bg-muted border-border">
                      <SelectValue placeholder="Category" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Categories</SelectItem>
                      <SelectItem value="kundli">Kundli</SelectItem>
                      <SelectItem value="report">Report</SelectItem>
                      <SelectItem value="forecast">Forecast</SelectItem>
                      <SelectItem value="consultation">Consultation</SelectItem>
                      <SelectItem value="ai">AI</SelectItem>
                    </SelectContent>
                  </Select>
                  <Select value={pricingFilterStatus} onValueChange={setPricingFilterStatus}>
                    <SelectTrigger className="w-full md:w-40 bg-muted border-border">
                      <SelectValue placeholder="Status" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Status</SelectItem>
                      <SelectItem value="active">Active</SelectItem>
                      <SelectItem value="inactive">Inactive</SelectItem>
                      <SelectItem value="free">Free</SelectItem>
                      <SelectItem value="paid">Paid</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Pricing — premium DataTable */}
                <DataTable<any>
                  columns={pricingColumns}
                  data={pricingPageSlice}
                  keyField={(p) => p.id}
                  loading={loading}
                  page={pricingPage}
                  pageSize={PRICING_PAGE_SIZE}
                  total={pricing.length}
                  onPageChange={setPricingPage}
                  exportFileName="nakshtralogy-pricing"
                  emptyTitle="No services found"
                  emptyMessage='Click "Add Service" or "Seed Defaults".'
                />
              </div>
            )}

            {/* ══════ Pricing Create/Edit Dialog ══════ */}
            <Dialog open={pricingDialog.open} onOpenChange={(v) => !v && setPricingDialog({ open: false, mode: "create" })}>
              <DialogContent className="bg-card border-border max-w-2xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    {pricingDialog.mode === "create" ? <PlusCircle className="w-5 h-5 text-primary" /> : <Pencil className="w-5 h-5 text-primary" />}
                    {pricingDialog.mode === "create" ? "Add New Service" : "Edit Service"}
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-3 py-2">
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">Service Key *</Label>
                      <Input
                        value={pricingForm.service_key}
                        onChange={(e) => setPricingForm({ ...pricingForm, service_key: e.target.value })}
                        placeholder="e.g. birth_chart"
                        disabled={pricingDialog.mode === "edit"}
                        className="bg-muted border-border mt-1 text-xs"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Icon (emoji)</Label>
                      <Input
                        value={pricingForm.icon}
                        onChange={(e) => setPricingForm({ ...pricingForm, icon: e.target.value })}
                        placeholder="📜"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">Service Name *</Label>
                    <Input
                      value={pricingForm.service_name}
                      onChange={(e) => setPricingForm({ ...pricingForm, service_name: e.target.value })}
                      placeholder="Birth Chart (Janam Kundli)"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">Description</Label>
                    <Textarea
                      value={pricingForm.description}
                      onChange={(e) => setPricingForm({ ...pricingForm, description: e.target.value })}
                      placeholder="Short description..."
                      className="bg-muted border-border mt-1 min-h-[60px]"
                    />
                  </div>
                  <div className="grid grid-cols-3 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">Category</Label>
                      <Select value={pricingForm.category} onValueChange={(v) => setPricingForm({ ...pricingForm, category: v })}>
                        <SelectTrigger className="bg-muted border-border mt-1">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="kundli">Kundli</SelectItem>
                          <SelectItem value="report">Report</SelectItem>
                          <SelectItem value="forecast">Forecast</SelectItem>
                          <SelectItem value="consultation">Consultation</SelectItem>
                          <SelectItem value="ai">AI</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Price (₹)</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={pricingForm.price}
                        onChange={(e) => setPricingForm({ ...pricingForm, price: Number(e.target.value) })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Original Price</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={pricingForm.original_price}
                        onChange={(e) => setPricingForm({ ...pricingForm, original_price: Number(e.target.value) })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                  </div>
                  {/* USD / store IAP (international). Blank price_usd = auto from rule. */}
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">USD Price ($) — override</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={pricingForm.price_usd ?? ""}
                        placeholder="auto from rule"
                        onChange={(e) => setPricingForm({
                          ...pricingForm,
                          price_usd: e.target.value === "" ? null : Number(e.target.value),
                          price_usd_manual: e.target.value !== "",
                        })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">IAP Product ID</Label>
                      <Input
                        value={pricingForm.iap_product_id}
                        placeholder="com.nakshtralogy.iap..."
                        onChange={(e) => setPricingForm({ ...pricingForm, iap_product_id: e.target.value })}
                        className="bg-muted border-border mt-1 text-xs"
                      />
                    </div>
                  </div>
                  {pricingForm.price_usd_manual && (
                    <label className="flex items-center gap-2 text-xs text-amber-400">
                      <input
                        type="checkbox"
                        checked={pricingForm.price_usd_manual}
                        onChange={(e) => setPricingForm({ ...pricingForm, price_usd_manual: e.target.checked })}
                      />
                      Manual USD override (kept when regenerating from the rule)
                    </label>
                  )}
                  <div>
                    <Label className="text-foreground/80 text-xs">Features (comma separated)</Label>
                    <Input
                      value={pricingFeaturesInput}
                      onChange={(e) => setPricingFeaturesInput(e.target.value)}
                      placeholder="D1 Kundli, Nakshatra, Dignity"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  <div className="grid grid-cols-3 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">Engine Function</Label>
                      <Input
                        value={pricingForm.engine_function}
                        onChange={(e) => setPricingForm({ ...pricingForm, engine_function: e.target.value })}
                        placeholder="calculate_chart"
                        className="bg-muted border-border mt-1 text-xs"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Sort Order</Label>
                      <Input
                        type="number" min="0"
                        value={pricingForm.sort_order}
                        onChange={(e) => setPricingForm({ ...pricingForm, sort_order: Number(e.target.value) })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Max Free/User</Label>
                      <Input
                        type="number" min="0"
                        value={pricingForm.max_free_per_user || ""}
                        onChange={(e) => setPricingForm({ ...pricingForm, max_free_per_user: e.target.value ? Number(e.target.value) : null })}
                        placeholder="unlimited"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                  </div>
                  <div className="flex items-center gap-4 pt-2">
                    <label className="flex items-center gap-2 text-xs text-foreground cursor-pointer">
                      <input
                        type="checkbox"
                        checked={pricingForm.is_free}
                        onChange={(e) => setPricingForm({ ...pricingForm, is_free: e.target.checked })}
                      />
                      Is Free
                    </label>
                    <label className="flex items-center gap-2 text-xs text-foreground cursor-pointer">
                      <input
                        type="checkbox"
                        checked={pricingForm.requires_birth_data}
                        onChange={(e) => setPricingForm({ ...pricingForm, requires_birth_data: e.target.checked })}
                      />
                      Requires Birth Data
                    </label>
                    {pricingDialog.mode === "edit" && (
                      <label className="flex items-center gap-2 text-xs text-foreground cursor-pointer">
                        <input
                          type="checkbox"
                          checked={pricingForm.is_active}
                          onChange={(e) => setPricingForm({ ...pricingForm, is_active: e.target.checked })}
                        />
                        Is Active
                      </label>
                    )}
                  </div>
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setPricingDialog({ open: false, mode: "create" })}>Cancel</Button>
                  <Button onClick={submitPricing} className="gradient-gold text-primary-foreground">
                    {pricingDialog.mode === "create" ? "Create" : "Update"}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ GIFTS ══════ */}
            {activeTab === "gifts" && (
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h2 className="text-xl font-display text-gold-gradient">Gift Pricing (Live Stream)</h2>
                  <div className="flex gap-2">
                    <Button size="sm" onClick={handleSeedGifts} variant="outline" className="border-border text-muted-foreground">
                      <RefreshCw className="w-3 h-3 mr-1" /> Seed Defaults
                    </Button>
                    <Button size="sm" onClick={openGiftCreate} className="gradient-gold text-primary-foreground">
                      <Plus className="w-3 h-3 mr-1" /> Add Gift
                    </Button>
                  </div>
                </div>

                {/* Filters */}
                <div className="flex flex-col md:flex-row gap-2">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <Input
                      value={giftsSearch}
                      onChange={(e) => setGiftsSearch(e.target.value)}
                      placeholder="Search by name..."
                      className="pl-10 bg-muted border-border"
                    />
                  </div>
                  <Select value={giftsFilterStatus} onValueChange={setGiftsFilterStatus}>
                    <SelectTrigger className="w-full md:w-40 bg-muted border-border">
                      <SelectValue placeholder="Status" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All</SelectItem>
                      <SelectItem value="active">Active</SelectItem>
                      <SelectItem value="inactive">Inactive</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <p className="text-xs text-muted-foreground">
                  Showing {giftsPageSlice.length} of {gifts.length} gifts
                </p>

                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                  {giftsPageSlice.length === 0 && (
                    <div className="col-span-4 p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                      No gifts found.
                    </div>
                  )}
                  {giftsPageSlice.map((g: any) => (
                    <div
                      key={g.id}
                      className={`bg-card/60 border rounded-xl p-4 text-center relative ${g.is_active ? "border-border" : "border-border opacity-60"}`}
                    >
                      <span className="text-4xl">{g.icon}</span>
                      <h4 className="text-foreground font-semibold mt-2 text-sm">{g.name}</h4>
                      <p className="text-primary font-bold text-lg mt-1">₹{g.price}</p>
                      <p className="text-[10px] text-muted-foreground">Sort: {g.sort_order || 0}</p>
                      <Badge className={`mt-2 text-[10px] ${g.is_active ? "bg-green-500/20 text-green-400" : "bg-muted text-muted-foreground"}`}>
                        {g.is_active ? "Active" : "Inactive"}
                      </Badge>
                      <div className="flex justify-center gap-1 mt-3">
                        <Button
                          size="sm" variant="outline"
                          className="h-7 w-7 p-0 border-primary text-primary hover:bg-primary/10"
                          onClick={() => openGiftEdit(g)}
                          title="Edit"
                        >
                          <Pencil className="w-3 h-3" />
                        </Button>
                        <Button
                          size="sm" variant="outline"
                          className={`h-7 w-7 p-0 ${g.is_active ? "border-muted-foreground text-muted-foreground" : "border-green-500 text-green-400"}`}
                          onClick={() => toggleGiftActive(g)}
                          title={g.is_active ? "Deactivate" : "Activate"}
                        >
                          {g.is_active ? <Ban className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
                        </Button>
                        <Button
                          size="sm" variant="outline"
                          className="h-7 w-7 p-0 border-destructive text-destructive hover:bg-destructive/10"
                          onClick={() => deleteGift(g)}
                          title="Delete"
                        >
                          <Trash2 className="w-3 h-3" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Pagination */}
                {gifts.length > GIFTS_PAGE_SIZE && (
                  <div className="flex items-center justify-between pt-2">
                    <p className="text-xs text-muted-foreground">
                      Page {giftsPage + 1} of {Math.max(1, Math.ceil(gifts.length / GIFTS_PAGE_SIZE))}
                    </p>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" disabled={giftsPage === 0}
                        onClick={() => setGiftsPage((p) => Math.max(0, p - 1))}
                        className="h-8 border-border">
                        <ChevronLeft className="w-4 h-4" /> Prev
                      </Button>
                      <Button size="sm" variant="outline"
                        disabled={(giftsPage + 1) * GIFTS_PAGE_SIZE >= gifts.length}
                        onClick={() => setGiftsPage((p) => p + 1)}
                        className="h-8 border-border">
                        Next <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* ══════ Gift Create/Edit Dialog ══════ */}
            <Dialog open={giftDialog.open} onOpenChange={(v) => !v && setGiftDialog({ open: false, mode: "create", gift: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Gift className="w-5 h-5 text-primary" />
                    {giftDialog.mode === "create" ? "Add Gift" : "Edit Gift"}
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-3 py-2">
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">Name *</Label>
                      <Input
                        value={giftForm.name}
                        onChange={(e) => setGiftForm({ ...giftForm, name: e.target.value })}
                        placeholder="Rose"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Icon (emoji) *</Label>
                      <Input
                        value={giftForm.icon}
                        onChange={(e) => setGiftForm({ ...giftForm, icon: e.target.value })}
                        placeholder="🌹"
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className="text-foreground/80 text-xs">Price (₹) *</Label>
                      <Input
                        type="number" min="0" step="0.01"
                        value={giftForm.price}
                        onChange={(e) => setGiftForm({ ...giftForm, price: Number(e.target.value) })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                    <div>
                      <Label className="text-foreground/80 text-xs">Sort Order</Label>
                      <Input
                        type="number" min="0"
                        value={giftForm.sort_order}
                        onChange={(e) => setGiftForm({ ...giftForm, sort_order: Number(e.target.value) })}
                        className="bg-muted border-border mt-1"
                      />
                    </div>
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">Animation URL (optional)</Label>
                    <Input
                      value={giftForm.animation_url}
                      onChange={(e) => setGiftForm({ ...giftForm, animation_url: e.target.value })}
                      placeholder="Lottie/GIF URL"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  {/* Preview */}
                  {giftForm.icon && (
                    <div className="bg-muted/40 rounded-lg p-4 border border-border text-center">
                      <p className="text-[10px] text-muted-foreground mb-1">Preview</p>
                      <span className="text-4xl">{giftForm.icon}</span>
                      <p className="text-foreground font-semibold mt-1">{giftForm.name || "Gift Name"}</p>
                      <p className="text-primary font-bold">₹{giftForm.price || 0}</p>
                    </div>
                  )}
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setGiftDialog({ open: false, mode: "create", gift: null })}>Cancel</Button>
                  <Button onClick={submitGift} className="gradient-gold text-primary-foreground">
                    {giftDialog.mode === "create" ? "Create" : "Update"}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

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

                <p className="text-xs text-muted-foreground">{agoraConfigs.length} configs</p>

                <div className="space-y-3">
                  {agoraConfigs.length === 0 && (
                    <p className="text-muted-foreground text-sm p-6 text-center bg-card/60 border border-border rounded-xl">
                      No Agora configs yet. Click "Add Config" to create one.
                    </p>
                  )}
                  {agoraConfigs.map((c: any) => (
                    <div key={c.id} className={`bg-card/60 border rounded-xl p-4 ${c.is_active ? "border-primary glow-gold" : "border-border"}`}>
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap">
                            <h4 className="text-foreground font-semibold">{c.label}</h4>
                            {c.is_active && <Badge className="gradient-gold text-primary-foreground text-[10px]">ACTIVE</Badge>}
                          </div>
                          <p className="text-xs text-muted-foreground mt-1">
                            App ID: <code className="text-primary break-all">{c.app_id}</code>
                          </p>
                          <p className="text-xs text-muted-foreground">Created: {c.created_at?.slice(0, 10)}</p>
                        </div>
                        <div className="flex flex-col gap-2 items-end">
                          <div className="flex items-center gap-2">
                            <span className="text-xs text-muted-foreground">Active</span>
                            <Switch checked={c.is_active} onCheckedChange={(val) => toggleAgoraActive(c.id, val)} />
                          </div>
                          <div className="flex gap-1">
                            <Button
                              size="sm" variant="outline"
                              className="h-7 w-7 p-0 border-primary text-primary hover:bg-primary/10"
                              onClick={() => openAgoraEdit(c)}
                              title="Edit"
                            >
                              <Pencil className="w-3 h-3" />
                            </Button>
                            <Button
                              size="sm" variant="outline"
                              className="h-7 w-7 p-0 border-destructive text-destructive hover:bg-destructive/10"
                              onClick={() => deleteAgora(c)}
                              title={c.is_active ? "Cannot delete active config" : "Delete"}
                              disabled={c.is_active}
                            >
                              <Trash2 className="w-3 h-3" />
                            </Button>
                          </div>
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

            {/* ══════ Agora Edit Dialog ══════ */}
            <Dialog open={agoraEditDialog.open} onOpenChange={(v) => !v && setAgoraEditDialog({ open: false, config: null })}>
              <DialogContent className="bg-card border-border">
                <DialogHeader>
                  <DialogTitle className="flex items-center gap-2">
                    <Pencil className="w-5 h-5 text-primary" /> Edit Agora Config
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-3 py-2">
                  <div>
                    <Label className="text-foreground/80 text-xs">Label</Label>
                    <Input
                      value={agoraEditForm.label}
                      onChange={(e) => setAgoraEditForm({ ...agoraEditForm, label: e.target.value })}
                      placeholder="e.g. Production"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">App ID</Label>
                    <Input
                      value={agoraEditForm.app_id}
                      onChange={(e) => setAgoraEditForm({ ...agoraEditForm, app_id: e.target.value })}
                      placeholder="Your Agora App ID"
                      className="bg-muted border-border mt-1"
                    />
                  </div>
                  <div>
                    <Label className="text-foreground/80 text-xs">
                      App Certificate <span className="text-[10px]">(leave blank to keep existing)</span>
                    </Label>
                    <Input
                      value={agoraEditForm.app_certificate}
                      onChange={(e) => setAgoraEditForm({ ...agoraEditForm, app_certificate: e.target.value })}
                      placeholder="New certificate (optional)"
                      className="bg-muted border-border mt-1"
                      type="password"
                    />
                  </div>
                  <label className="flex items-center gap-2 text-xs text-foreground cursor-pointer">
                    <input
                      type="checkbox"
                      checked={agoraEditForm.is_active}
                      onChange={(e) => setAgoraEditForm({ ...agoraEditForm, is_active: e.target.checked })}
                    />
                    Set as Active (auto-deactivates all others)
                  </label>
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setAgoraEditDialog({ open: false, config: null })}>Cancel</Button>
                  <Button onClick={submitAgoraEdit} className="gradient-gold text-primary-foreground">
                    Save Changes
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            {/* ══════ SETTINGS ══════ */}
            {activeTab === "settings" && (
              <div className="space-y-4">
                <h2 className="text-xl font-display text-gold-gradient">Platform Settings</h2>

                {/* Demo data tools — moved here from the old Overview tab */}
                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-2 flex items-center gap-1.5">
                    <Database className="w-4 h-4" /> Demo Data Tools
                  </h3>
                  <p className="text-xs text-muted-foreground mb-3">
                    Seed sample pricing, gifts and other demo data for a fresh environment.
                  </p>
                  <div className="flex gap-2 flex-wrap">
                    <Button size="sm" onClick={handleSeedAll} className="gradient-gold text-primary-foreground">
                      <Plus className="w-3 h-3 mr-1" /> Seed All Demo Data
                    </Button>
                    <Button size="sm" variant="outline" onClick={handleSeedPricing} className="border-primary text-primary">Seed Pricing</Button>
                    <Button size="sm" variant="outline" onClick={handleSeedGifts} className="border-primary text-primary">Seed Gifts</Button>
                  </div>
                </div>

                {/* Category tabs */}
                <div className="flex flex-wrap gap-2">
                  {settingsCategories.map((cat: any) => {
                    const isActive = activeSettingsCategory === cat.category;
                    const icon =
                      cat.category.startsWith("google_auth") ? <KeyRound className="w-3 h-3" /> :
                      cat.category.startsWith("fcm") ? <Radio className="w-3 h-3" /> :
                      cat.category === "smtp" ? <Mail className="w-3 h-3" /> :
                      <CreditCard className="w-3 h-3" />;
                    return (
                      <button
                        key={cat.category}
                        onClick={() => switchSettingsCategory(cat.category)}
                        className={`px-3 py-2 rounded-lg text-xs font-medium transition-all flex items-center gap-1.5 ${
                          isActive
                            ? "bg-primary/20 text-primary border border-primary/40"
                            : "bg-card/60 text-muted-foreground border border-border hover:bg-muted/30"
                        }`}
                      >
                        {icon}
                        {cat.label}
                      </button>
                    );
                  })}
                </div>

                {/* Active category form */}
                {settingsCategories.length > 0 && (() => {
                  const activeCat = settingsCategories.find((c: any) => c.category === activeSettingsCategory);
                  if (!activeCat) return null;
                  const loadedCat = settingsLoaded[activeSettingsCategory];
                  const keys = loadedCat?.keys || activeCat.keys || [];
                  return (
                    <div className="bg-card/60 border border-border rounded-xl p-5 space-y-4">
                      <div>
                        <h3 className="text-lg font-semibold text-foreground">{activeCat.label}</h3>
                        <p className="text-xs text-muted-foreground mt-1">{activeCat.description}</p>
                      </div>

                      {/* FCM JSON upload — only for fcm_* categories */}
                      {activeSettingsCategory.startsWith("fcm_") && (
                        <div className="bg-muted/20 border border-border rounded-lg p-4 space-y-2">
                          <div className="flex items-center gap-2">
                            <Upload className="w-4 h-4 text-primary" />
                            <p className="text-sm text-foreground font-medium">Upload Service Account JSON</p>
                          </div>
                          <p className="text-[11px] text-muted-foreground">
                            Download from Firebase Console → Project Settings → Service Accounts → Generate New Private Key.
                            File will be saved to <code className="text-primary">credentials/firebase-{activeSettingsCategory.split("_")[1]}-sa.json</code>
                          </p>
                          <div className="flex items-center gap-2 pt-1">
                            <input
                              type="file"
                              accept=".json,application/json"
                              id={`fcm-upload-${activeSettingsCategory}`}
                              className="hidden"
                              onChange={(e) => {
                                const f = e.target.files?.[0];
                                if (f) {
                                  const project = activeSettingsCategory.split("_")[1] as "user" | "astro";
                                  uploadFcmJson(project, f);
                                }
                                e.target.value = "";
                              }}
                            />
                            <Button
                              size="sm"
                              variant="outline"
                              className="border-primary text-primary h-8"
                              onClick={() => document.getElementById(`fcm-upload-${activeSettingsCategory}`)?.click()}
                              disabled={fcmUploading !== null}
                            >
                              {fcmUploading === activeSettingsCategory.split("_")[1]
                                ? "Uploading..."
                                : <><Upload className="w-3 h-3 mr-1" /> Choose JSON File</>
                              }
                            </Button>
                            {fcmUploadMsg && (
                              <span className={`text-xs ${fcmUploadMsg.startsWith("✅") ? "text-green-400" : "text-destructive"}`}>
                                {fcmUploadMsg}
                              </span>
                            )}
                          </div>
                        </div>
                      )}

                      {/* Key-value form */}
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                        {keys.map((k: any) => {
                          const val = settingsForm[k.key] ?? "";
                          const isSecret = k.secret;
                          const isRevealed = showSecretFor[k.key] === true;
                          return (
                            <div key={k.key} className={k.key === "description" ? "md:col-span-2" : ""}>
                              <Label className="text-foreground/80 text-xs flex items-center gap-1">
                                {k.label}
                                {isSecret && <span className="text-[10px] text-destructive">(secret)</span>}
                                {k.has_value && (
                                  <Badge className="bg-green-500/20 text-green-400 text-[9px] ml-1">SET</Badge>
                                )}
                              </Label>
                              <div className="flex gap-1 mt-1">
                                <Input
                                  type={isSecret && !isRevealed ? "password" : "text"}
                                  value={val}
                                  onChange={(e) => setSettingsForm({ ...settingsForm, [k.key]: e.target.value })}
                                  placeholder={isSecret && k.has_value ? "••••••• (leave blank to keep existing)" : ""}
                                  className="bg-muted border-border text-xs"
                                />
                                {isSecret && (
                                  <Button
                                    size="sm" variant="outline"
                                    className="h-9 w-9 p-0 border-border"
                                    onClick={() => setShowSecretFor({ ...showSecretFor, [k.key]: !isRevealed })}
                                    type="button"
                                    title={isRevealed ? "Hide" : "Show"}
                                  >
                                    {isRevealed ? <EyeOff className="w-3 h-3" /> : <Eye className="w-3 h-3" />}
                                  </Button>
                                )}
                              </div>
                            </div>
                          );
                        })}
                      </div>

                      <div className="flex justify-end gap-2 pt-2 border-t border-border">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => switchSettingsCategory(activeSettingsCategory)}
                          className="border-border"
                        >
                          <RefreshCw className="w-3 h-3 mr-1" /> Reload
                        </Button>
                        <Button
                          size="sm"
                          onClick={saveSettings}
                          disabled={settingsSaving}
                          className="gradient-gold text-primary-foreground"
                        >
                          <Save className="w-3 h-3 mr-1" />
                          {settingsSaving ? "Saving..." : "Save Settings"}
                        </Button>
                      </div>
                    </div>
                  );
                })()}

                {settingsCategories.length === 0 && (
                  <div className="p-8 text-center text-muted-foreground bg-card/60 border border-border rounded-xl">
                    Loading settings...
                  </div>
                )}
              </div>
            )}

            {/* ══════ DEVELOPER API PLATFORM ══════ */}
            {activeTab === "developers" && (
              <div className="space-y-6">
                <DeveloperAnalytics />
                <DeveloperPlans />
                <DevelopersManager />
              </div>
            )}
      </div>
    </div>
  );
};

export default AdminFeatures;
