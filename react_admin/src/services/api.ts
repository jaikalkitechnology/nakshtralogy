const BASE = "https://api.nakshatralogy.com/api/v1";

function getToken(): string | null {
  return localStorage.getItem("access_token");
}

function authHeaders(): Record<string, string> {
  const token = getToken();
  return {
    "Content-Type": "application/json",
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

async function request<T = any>(
  url: string,
  options: RequestInit = {}
): Promise<{ ok: boolean; status: number; data: T }> {
  const res = await fetch(`${BASE}${url}`, {
    ...options,
    headers: { ...authHeaders(), ...(options.headers as Record<string, string>) },
  });
  const data = await res.json().catch(() => ({}));
  return { ok: res.ok, status: res.status, data };
}

// ── Auth ─────────────────────────────────────────────────────────

// Admin-only login. This panel is exclusively for administrators.
export async function loginAdmin(email: string, password: string) {
  const res = await fetch(`${BASE}/admin/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("app_user", JSON.stringify(data.user));
  }
  return { ok: res.ok, status: res.status, data };
}

export function logoutUser() {
  localStorage.removeItem("access_token");
  localStorage.removeItem("refresh_token");
  localStorage.removeItem("app_user");
}

// keep backward compat alias
export const logoutAdmin = logoutUser;

export function getStoredUser() {
  const raw = localStorage.getItem("app_user");
  return raw ? JSON.parse(raw) : null;
}

// ── Users ────────────────────────────────────────────────────────

export async function adminListUsers(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/users?${qs}`);
}

export async function adminGetUser(userId: string) {
  return request(`/admin/users/${userId}`);
}

export async function adminEditUser(userId: string, data: any) {
  return request(`/admin/users/${userId}/edit`, { method: "PUT", body: JSON.stringify(data) });
}

export async function adminToggleUser(userId: string) {
  return request(`/admin/users/${userId}/toggle`, { method: "PATCH" });
}

export async function adminApproveProfile(userId: string) {
  return request(`/admin/users/${userId}/approve-profile`, { method: "PATCH" });
}

export async function adminVerifyUser(userId: string) {
  return request(`/admin/users/${userId}/verify`, { method: "PATCH" });
}

// ── Astrologers ──────────────────────────────────────────────────

export async function fetchAstrologers(skip = 0, limit = 50) {
  return request(`/astrologer/list?skip=${skip}&limit=${limit}`);
}

export async function adminListAstrologers(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/astrologers?${qs}`);
}

export async function adminEditAstrologer(profileId: string, data: any) {
  return request(`/admin/astrologers/${profileId}/edit`, { method: "PUT", body: JSON.stringify(data) });
}

// Full astrologer dossier: personal + professional info + KYC documents.
export async function adminAstrologerDetail(profileId: string) {
  return request(`/admin/astrologers/${profileId}/detail`);
}

// Send a custom push + in-app notification to one user/astrologer.
export async function adminSendNotification(userId: string, title: string, body: string) {
  return request(`/admin/notifications/send`, {
    method: "POST",
    body: JSON.stringify({ user_id: userId, title, body }),
  });
}

// FCM diagnostics (init state per project, web-push readiness, token counts).
export async function adminFcmDiagnostics() {
  return request(`/admin/fcm/diagnostics`);
}

// Recent FCM send attempts (real events + tests) with ok/error per attempt.
export async function adminFcmRecent() {
  return request(`/admin/fcm/recent`);
}

// Send a test push to a specific user's registered token(s) — returns diagnosis.
export async function adminFcmTestUser(userId: string) {
  return request(`/admin/fcm/test-user/${userId}`, { method: "POST" });
}

// Broadcast a notification to a segment (users | astrologers | all).
export async function adminBroadcastNotification(audience: string, title: string, body: string, activeOnly: boolean) {
  return request(`/admin/notifications/broadcast`, {
    method: "POST",
    body: JSON.stringify({ audience, title, body, active_only: activeOnly }),
  });
}

// Sent-notification campaign history with delivery reports.
export async function adminListCampaigns(limit = 50) {
  return request(`/admin/notifications/campaigns?limit=${limit}`);
}

/// Fetch an auth-protected media URL (e.g. a KYC file) as an object URL so it
/// can be shown in <img>/<iframe>. `path` may be a relative API path
/// (e.g. /api/v1/astrologer/me/kyc/file/...) or an absolute URL. Returns null
/// on failure. Callers should revokeObjectURL when done.
export async function fetchAuthedObjectUrl(
  path: string
): Promise<{ url: string; contentType: string } | null> {
  try {
    const token = getToken();
    const abs = path.startsWith("http")
      ? path
      : `https://api.nakshatralogy.com${path.startsWith("/") ? "" : "/"}${path}`;
    const res = await fetch(abs, {
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    });
    if (!res.ok) return null;
    const blob = await res.blob();
    return { url: URL.createObjectURL(blob), contentType: blob.type || "" };
  } catch {
    return null;
  }
}

export async function adminApproveAstrologer(profileId: string) {
  return request(`/admin/astrologers/${profileId}/approve`, { method: "PATCH" });
}

export async function adminRejectAstrologer(profileId: string, reason: string, sections?: string[]) {
  return request(`/admin/astrologers/${profileId}/reject`, {
    method: "PATCH",
    body: JSON.stringify({ reason, sections: sections ?? [] }),
  });
}

export async function adminSetCommission(profileId: string, commissionPct: number) {
  return request(`/admin/astrologers/${profileId}/commission?commission_pct=${commissionPct}`, {
    method: "PATCH",
  });
}

export async function adminBlockAstrologer(profileId: string) {
  return request(`/admin/astrologers/${profileId}/block`, { method: "PATCH" });
}

// ── Service Pricing ──────────────────────────────────────────────

export async function fetchServicePricing(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/service/pricing${qs ? `?${qs}` : ""}`);
}

export async function createServicePricing(data: any) {
  return request("/service/pricing", { method: "POST", body: JSON.stringify(data) });
}

export async function updateServicePricing(id: string, data: any) {
  return request(`/service/pricing/${id}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function deleteServicePricing(id: string) {
  return request(`/service/pricing/${id}`, { method: "DELETE" });
}

export async function seedServicePricing() {
  return request("/service/pricing/seed", { method: "POST" });
}

// ── USD pricing (international / store IAP tiers) ─────────────────

export async function fetchUsdPricingSettings() {
  return request("/service/pricing-settings/usd");
}

export async function updateUsdPricingSettings(data: { fx_rate_usd?: number; usd_multiplier?: number }) {
  return request("/service/pricing-settings/usd", { method: "PUT", body: JSON.stringify(data) });
}

/** Recompute price_usd + iap_product_id for every priced service from the rule.
 *  force=true also overwrites admin-overridden USD prices. */
export async function regenerateUsdPricing(force = false) {
  return request(`/service/pricing/regenerate-usd${force ? "?force=true" : ""}`, { method: "POST" });
}

// ── Gift Pricing ─────────────────────────────────────────────────

export async function fetchGiftPricing(includeInactive = false) {
  return request(`/comm/gifts${includeInactive ? "?include_inactive=true" : ""}`);
}

export async function createGiftPricing(data: any) {
  return request("/comm/gifts", { method: "POST", body: JSON.stringify(data) });
}

export async function updateGiftPricing(id: string, data: any) {
  return request(`/comm/gifts/${id}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function toggleGiftPricing(id: string) {
  return request(`/comm/gifts/${id}/toggle`, { method: "PATCH" });
}

export async function deleteGiftPricing(id: string) {
  return request(`/comm/gifts/${id}`, { method: "DELETE" });
}

export async function seedGiftPricing() {
  return request("/comm/gifts/seed", { method: "POST" });
}

// ── Agora Config ─────────────────────────────────────────────────

export async function fetchAgoraConfigs() {
  return request("/comm/agora-config");
}

export async function createAgoraConfig(data: any) {
  return request("/comm/agora-config", { method: "POST", body: JSON.stringify(data) });
}

export async function updateAgoraConfig(id: string, data: any) {
  return request(`/comm/agora-config/${id}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function deleteAgoraConfig(id: string) {
  return request(`/comm/agora-config/${id}`, { method: "DELETE" });
}

// ── Wallet / Transactions ────────────────────────────────────────

export async function adminWalletStats() {
  return request("/admin/wallet-stats");
}

export type WalletAction = "add_fund" | "remove_fund" | "bonus";

export async function adminAdjustWallet(
  userId: string,
  action: WalletAction,
  amount: number,
  reason: string,
) {
  return request(`/admin/wallet/${userId}/adjust`, {
    method: "POST",
    body: JSON.stringify({ action, amount, reason }),
  });
}

export async function adminListTransactions(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/transactions?${qs}`);
}

// ── Reviews ──────────────────────────────────────────────────────

export async function adminListReviews(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/reviews${qs ? `?${qs}` : ""}`);
}

export async function adminGetReview(reviewId: string) {
  return request(`/admin/reviews/${reviewId}`);
}

export async function adminEditReview(reviewId: string, data: any) {
  return request(`/admin/reviews/${reviewId}`, {
    method: "PUT",
    body: JSON.stringify(data),
  });
}

export async function adminToggleReviewVisibility(reviewId: string) {
  return request(`/admin/reviews/${reviewId}/toggle-visibility`, { method: "PATCH" });
}

export async function adminDeleteReview(reviewId: string) {
  return request(`/admin/reviews/${reviewId}`, { method: "DELETE" });
}

// ── Communication Logs (live · calls · chats · session reviews) ──────

export async function adminLogsLive(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/logs/live${qs ? `?${qs}` : ""}`);
}

export async function adminLogsLiveDetail(streamId: string) {
  return request(`/admin/logs/live/${streamId}`);
}

export async function adminLogsCalls(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/logs/calls${qs ? `?${qs}` : ""}`);
}

export async function adminLogsChats(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/logs/chats${qs ? `?${qs}` : ""}`);
}

export async function adminLogsChatTranscript(sessionId: string) {
  return request(`/admin/logs/chats/${sessionId}`);
}

export async function adminLogsSessionReviews(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/logs/session-reviews${qs ? `?${qs}` : ""}`);
}

// ── FAQ management ───────────────────────────────────────────────

export async function adminFaqList(audience?: string, lang?: string) {
  const p = new URLSearchParams();
  if (audience) p.set("audience", audience);
  if (lang) p.set("lang", lang);
  const qs = p.toString();
  return request(`/faq/admin${qs ? `?${qs}` : ""}`);
}
export async function adminFaqCreate(data: any) {
  return request(`/faq/admin`, { method: "POST", body: JSON.stringify(data) });
}
export async function adminFaqUpdate(id: string, data: any) {
  return request(`/faq/admin/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
export async function adminFaqDelete(id: string) {
  return request(`/faq/admin/${id}`, { method: "DELETE" });
}
export async function adminFaqSeed() {
  return request(`/faq/admin/seed`, { method: "POST" });
}

// ── Support tickets (helpdesk) ──────────────────────────────────

export async function adminSupportTickets(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/support/admin/tickets${qs ? `?${qs}` : ""}`);
}
export async function adminSupportTicketDetail(id: string) {
  return request(`/support/admin/tickets/${id}`);
}
export async function adminSupportReply(id: string, message: string, isInternal: boolean) {
  return request(`/support/admin/tickets/${id}/reply`, {
    method: "POST", body: JSON.stringify({ message, is_internal: isInternal }),
  });
}
export async function adminSupportStatus(id: string, status: string) {
  return request(`/support/admin/tickets/${id}/status`, {
    method: "PATCH", body: JSON.stringify({ status }),
  });
}

// ── Banners (home slider) ───────────────────────────────────────

export async function adminBannerList(audience?: string) {
  const qs = audience ? `?audience=${audience}` : "";
  return request(`/banners/admin${qs}`);
}
export async function adminBannerCreate(data: any) {
  return request(`/banners/admin`, { method: "POST", body: JSON.stringify(data) });
}
export async function adminBannerUpdate(id: string, data: any) {
  return request(`/banners/admin/${id}`, { method: "PUT", body: JSON.stringify(data) });
}
export async function adminBannerDelete(id: string) {
  return request(`/banners/admin/${id}`, { method: "DELETE" });
}
export async function adminBannerUpload(file: File): Promise<{ ok: boolean; media_url?: string; error?: string }> {
  const token = getToken();
  const fd = new FormData();
  fd.append("file", file);
  try {
    const res = await fetch(`${BASE}/banners/admin/upload`, {
      method: "POST",
      headers: { ...(token ? { Authorization: `Bearer ${token}` } : {}) },
      body: fd,
    });
    const data = await res.json().catch(() => ({}));
    return { ok: res.ok, media_url: data?.media_url, error: data?.detail };
  } catch (e: any) {
    return { ok: false, error: String(e) };
  }
}
// Absolute URL for a possibly-relative banner image path.
export function bannerImageSrc(url?: string) {
  if (!url) return "";
  if (url.startsWith("http")) return url;
  return `${BASE.replace(/\/api\/v1$/, "")}${url}`;
}

// ── AI agents (publish + pricing) ───────────────────────────────

export async function adminAiAgents() {
  return request(`/ai/admin/agents`);
}
export async function adminAiAgentUpdate(key: string, data: any) {
  return request(`/ai/admin/agents/${key}`, { method: "PUT", body: JSON.stringify(data) });
}

// ── KYC ──────────────────────────────────────────────────────────

export async function adminListKyc(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/kyc?${qs}`);
}

export async function adminApproveKyc(kycId: string) {
  return request(`/admin/kyc/${kycId}/approve`, { method: "PATCH" });
}

export async function adminRejectKyc(kycId: string, reason: string) {
  return request(`/admin/kyc/${kycId}/reject`, { method: "PATCH", body: JSON.stringify({ reason }) });
}

// ── Astrologer self-service (for astrologer dashboard) ──────────

export async function fetchAstroMeKycStatus() {
  return request("/astrologer/me/kyc-status");
}

export async function submitAstroKyc(data: {
  doc_type: string;
  doc_number?: string;
  front_url?: string;
  back_url?: string;
  selfie_url?: string;
}) {
  return request("/astrologer/me/kyc", {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export async function fetchAstroMeStats() {
  return request("/astrologer/me/stats");
}

export async function fetchAstroMeRecentRequests(limit = 10) {
  return request(`/astrologer/me/recent-requests?limit=${limit}`);
}

export async function fetchAstroMe() {
  return request("/astrologer/me");
}

export async function fetchAstroMeWallet() {
  return request("/astrologer/me/wallet");
}

export async function fetchAstroMeWalletTransactions(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/astrologer/me/wallet/transactions${qs ? `?${qs}` : ""}`);
}

export async function requestAstroWithdrawal(data: {
  amount: number;
  bank_account_name?: string;
  bank_account_number?: string;
  bank_ifsc?: string;
  upi_id?: string;
  notes?: string;
}) {
  return request("/astrologer/me/wallet/withdraw", {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export async function fetchAstroMyWithdrawals(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/astrologer/me/withdrawals${qs ? `?${qs}` : ""}`);
}

export async function updateAstroProfile(data: any) {
  return request("/astrologer/me/profile", {
    method: "PUT",
    body: JSON.stringify(data),
  });
}

export async function updateAstroUserFields(data: any) {
  return request("/astrologer/me", {
    method: "PUT",
    body: JSON.stringify(data),
  });
}

// ── Current User — profile / wallet / orders / saved astrologers ────

export async function fetchMe() {
  return request("/user/me");
}

export async function updateMe(data: any) {
  return request("/user/me", { method: "PUT", body: JSON.stringify(data) });
}

export async function fetchMyWallet() {
  return request("/user/me/wallet");
}

export async function fetchMyWalletTransactions(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/user/me/wallet/transactions${qs ? `?${qs}` : ""}`);
}

export async function rechargeMyWallet(amount: number, note?: string, paymentRef?: string) {
  return request("/user/me/wallet/recharge", {
    method: "POST",
    body: JSON.stringify({ amount, note, payment_ref: paymentRef }),
  });
}

export async function fetchMyOrders(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/user/me/orders${qs ? `?${qs}` : ""}`);
}

export async function fetchMySavedAstrologers() {
  return request("/user/me/saved-astrologers");
}

export async function saveAstrologer(astrologerProfileId: string, note?: string) {
  return request("/user/me/saved-astrologers", {
    method: "POST",
    body: JSON.stringify({ astrologer_profile_id: astrologerProfileId, note }),
  });
}

export async function unsaveAstrologer(astrologerProfileId: string) {
  return request(`/user/me/saved-astrologers/${astrologerProfileId}`, { method: "DELETE" });
}

// ── Public Astrologer data (for user dashboard) ──────────────────

export async function fetchPublicAstrologers(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/astrologer/list${qs ? `?${qs}` : ""}`);
}

export async function fetchAstrologerDetail(id: string) {
  return request(`/astrologer/${id}`);
}

export async function fetchAstrologerReviews(id: string, limit = 10) {
  return request(`/astrologer/${id}/reviews?limit=${limit}`);
}

// ── Platform Settings ────────────────────────────────────────────

export async function adminListSettings() {
  return request("/admin/settings");
}

export async function adminGetCategorySettings(category: string, unmasked = false) {
  return request(`/admin/settings/${category}${unmasked ? "?unmasked=true" : ""}`);
}

export async function adminUpsertSettings(category: string, settings: Record<string, any>) {
  return request(`/admin/settings/${category}`, {
    method: "PUT",
    body: JSON.stringify({ settings }),
  });
}

export async function adminDeleteSetting(category: string, key: string) {
  return request(`/admin/settings/${category}/${key}`, { method: "DELETE" });
}

// ── Web Push (admin) — authWebPlatform/ Task 2.4 ─────────────────
// The VAPID + Firebase-web config itself is persisted through the generic
// platform-settings API above (categories `webpush_user` / `webpush_astro`),
// exactly like every other admin credential screen. This endpoint only fires a
// one-off "test" web-push against the currently-configured project so an admin
// can confirm delivery works. `project` is "user" | "astro" (mirrors the FCM
// upload project naming). Contract: POST /api/v1/admin/webpush/{project}/test.
export async function adminSendTestWebPush(project: "user" | "astro", token?: string) {
  return request(`/admin/webpush/${project}/test`, {
    method: "POST",
    body: JSON.stringify(token ? { token } : {}),
  });
}

// ── System / Maintenance (admin) ─────────────────────────────────
// Apply developer-side changes to a running deployment: additive schema sync
// (missing tables/columns from the models), idempotent seeders, and effective
// config view/reload. Backend: /api/v1/admin/system/*  (admin-only).
export async function adminSchemaDiff() {
  return request("/admin/system/schema/diff");
}

export async function adminSchemaSync(dryRun: boolean) {
  return request(`/admin/system/schema/sync?dry_run=${dryRun}`, { method: "POST" });
}

export async function adminSeedCatalog() {
  return request("/admin/system/seed/catalog");
}

export async function adminSeedRun(seeders: string[] | null, all: boolean) {
  return request("/admin/system/seed/run", {
    method: "POST",
    body: JSON.stringify({ seeders, all }),
  });
}

export async function adminGetSystemConfig() {
  return request("/admin/system/config");
}

export async function adminReloadConfig() {
  return request("/admin/system/config/reload", { method: "POST" });
}

export async function adminUploadFcmFile(project: "user" | "astro", file: File) {
  const token = localStorage.getItem("access_token");
  const fd = new FormData();
  fd.append("file", file);
  const res = await fetch(`https://api.nakshatralogy.com/api/v1/admin/settings/fcm/upload/${project}`, {
    method: "POST",
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: fd,
  });
  const data = await res.json().catch(() => ({}));
  return { ok: res.ok, status: res.status, data };
}

// ── Seed ─────────────────────────────────────────────────────────

export async function seedAll() {
  return request("/admin/seed", { method: "POST" });
}

export async function seedOpen() {
  const res = await fetch(`${BASE}/admin/seed-open`, { method: "POST" });
  return { ok: res.ok, status: res.status, data: await res.json() };
}


// ═══════════════════════════════════════════════════════════════════
//  COMMUNICATION — Chat, Call, Live Stream
// ═══════════════════════════════════════════════════════════════════

// ── Chat ──
export async function initiateChat(astrologerProfileId: string) {
  const res = await fetch(`${BASE}/comm/chat/initiate`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ astrologer_profile_id: astrologerProfileId }) });
  return res.json();
}
export async function chatAction(sessionId: string, action: string) {
  const res = await fetch(`${BASE}/comm/chat/${sessionId}/action`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ action }) });
  return res.json();
}
export async function getChatSession(sessionId: string) {
  const res = await fetch(`${BASE}/comm/chat/${sessionId}`, { headers: authHeaders() });
  return res.json();
}
export async function getChatMessages(sessionId: string, skip = 0, limit = 100) {
  const res = await fetch(`${BASE}/comm/chat/${sessionId}/messages?skip=${skip}&limit=${limit}`, { headers: authHeaders() });
  return res.json();
}
export async function getChatHistory(skip = 0, limit = 20) {
  const res = await fetch(`${BASE}/comm/chat/history?skip=${skip}&limit=${limit}`, { headers: authHeaders() });
  return res.json();
}
export async function sendChatMessage(sessionId: string, content: string) {
  const res = await fetch(`${BASE}/comm/chat/${sessionId}/message`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ content, message_type: "text" }) });
  return res.json();
}
export async function uploadChatFile(file: File) {
  const fd = new FormData(); fd.append("file", file);
  const token = localStorage.getItem("access_token");
  const res = await fetch(`${BASE}/comm/chat/upload`, { method: "POST", headers: token ? { Authorization: `Bearer ${token}` } : {}, body: fd });
  return res.json();
}

// ── Calls ──
export async function initiateCall(astrologerProfileId: string, callType: "voice" | "video") {
  const res = await fetch(`${BASE}/comm/call/initiate`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ astrologer_profile_id: astrologerProfileId, call_type: callType }) });
  return res.json();
}
export async function callAction(callId: string, action: string) {
  const res = await fetch(`${BASE}/comm/call/${callId}/action`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ action }) });
  return res.json();
}
export async function getCall(callId: string) {
  const res = await fetch(`${BASE}/comm/call/${callId}`, { headers: authHeaders() });
  return res.json();
}
export async function getCallHistory(skip = 0, limit = 20) {
  const res = await fetch(`${BASE}/comm/call/history?skip=${skip}&limit=${limit}`, { headers: authHeaders() });
  return res.json();
}

// ── Live Stream ──
export async function getActiveLiveStreams() {
  const res = await fetch(`${BASE}/comm/live/active`, { headers: authHeaders() });
  return res.json();
}
export async function createLiveStream(title: string, description?: string) {
  const res = await fetch(`${BASE}/comm/live/create`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ title, description }) });
  return res.json();
}
export async function startLiveStream(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/start`, { method: "POST", headers: authHeaders() });
  return res.json();
}
export async function endLiveStream(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/end`, { method: "POST", headers: authHeaders() });
  return res.json();
}
export async function joinLiveStream(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/join`, { method: "POST", headers: authHeaders() });
  return res.json();
}
export async function leaveLiveStream(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/leave`, { method: "POST", headers: authHeaders() });
  return res.json();
}
export async function sendLiveQuestion(streamId: string, question: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/question`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ question }) });
  return res.json();
}
export async function getLiveQuestions(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/questions`, { headers: authHeaders() });
  return res.json();
}
export async function getLiveViewers(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/viewers`, { headers: authHeaders() });
  return res.json();
}
export async function sendLiveGift(streamId: string, giftPricingId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/gift`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ gift_pricing_id: giftPricingId }) });
  return res.json();
}
export async function sendSuperChat(streamId: string, message: string, amount: number) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/super-chat`, { method: "POST", headers: authHeaders(), body: JSON.stringify({ message, amount }) });
  return res.json();
}
export async function getLiveSuperChats(streamId: string) {
  const res = await fetch(`${BASE}/comm/live/${streamId}/super-chats`, { headers: authHeaders() });
  return res.json();
}
export async function fetchGifts() {
  const res = await fetch(`${BASE}/comm/gifts`, { headers: authHeaders() });
  return res.json();
}

// ── WebSocket URL builders ──
export function getWsChatUrl(sessionId: string) {
  const token = localStorage.getItem("access_token");
  const wsBase = BASE.replace("https://", "wss://").replace("http://", "ws://").replace("/api/v1", "");
  return `${wsBase}/ws/chat/${sessionId}?token=${token}`;
}
export function getWsAstrologerUrl() {
  const token = localStorage.getItem("access_token");
  const wsBase = BASE.replace("https://", "wss://").replace("http://", "ws://").replace("/api/v1", "");
  return `${wsBase}/ws/astrologer?token=${token}`;
}

// ── Developer API Platform (Admin) — developerApiPlatform/ Phase 5 ────
// Superset control surface: everything a developer can do for themselves,
// an admin can do for ANY developer_id.

export type DeveloperWalletAction = "credit" | "debit" | "refund";

export async function adminListDevelopers(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/developers?${qs}`);
}

export async function adminGetDeveloperDetail(developerId: string) {
  return request(`/admin/developers/${developerId}`);
}

export async function adminUpdateDeveloperStatus(developerId: string, status: string, note?: string) {
  return request(`/admin/developers/${developerId}/status`, {
    method: "PATCH",
    body: JSON.stringify({ status, note }),
  });
}

export async function adminUpdateDeveloperKyc(developerId: string, kycStatus: string, note?: string) {
  return request(`/admin/developers/${developerId}/kyc`, {
    method: "PATCH",
    body: JSON.stringify({ kyc_status: kycStatus, note }),
  });
}

export async function adminListDeveloperKeys(developerId: string, params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/developers/${developerId}/keys?${qs}`);
}

export async function adminRevokeDeveloperKey(developerId: string, keyId: string) {
  return request(`/admin/developers/${developerId}/keys/${keyId}/revoke`, { method: "PATCH" });
}

export async function adminRotateDeveloperKey(developerId: string, keyId: string) {
  return request(`/admin/developers/${developerId}/keys/${keyId}/rotate`, { method: "POST" });
}

export async function adminGetDeveloperSubscription(developerId: string) {
  return request(`/admin/developers/${developerId}/subscription`);
}

export async function adminGrantDeveloperSubscription(
  developerId: string,
  days: number,
  planCode = "all_access",
  autoRenew = false,
  reason?: string,
) {
  return request(`/admin/developers/${developerId}/subscription/grant`, {
    method: "POST",
    body: JSON.stringify({ plan_code: planCode, days, auto_renew: autoRenew, reason }),
  });
}

export async function adminCancelDeveloperSubscription(developerId: string) {
  return request(`/admin/developers/${developerId}/subscription/cancel`, { method: "POST" });
}

export async function adminGetDeveloperWallet(developerId: string, params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/developers/${developerId}/wallet?${qs}`);
}

export async function adminAdjustDeveloperWallet(
  developerId: string,
  action: DeveloperWalletAction,
  amount: number,
  reason: string,
) {
  return request(`/admin/developers/${developerId}/wallet/adjust`, {
    method: "POST",
    body: JSON.stringify({ action, amount, reason }),
  });
}

export async function adminGetDeveloperUsage(developerId: string, params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/admin/developers/${developerId}/usage?${qs}`);
}

export async function adminListDeveloperPlans() {
  return request(`/admin/developer-plans`);
}

export async function adminUpdateDeveloperPlan(planId: string, data: Record<string, any>) {
  return request(`/admin/developer-plans/${planId}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function adminDeveloperAnalyticsOverview(days = 30) {
  return request(`/admin/developer-analytics/overview?days=${days}`);
}
