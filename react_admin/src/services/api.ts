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

export type LoginRole = "user" | "astrologer" | "admin";

export async function loginByRole(email: string, password: string, role: LoginRole) {
  // Each role has its own dedicated login endpoint
  const endpoint =
    role === "admin" ? "/admin/login" :
    role === "astrologer" ? "/astrologer/login" :
    "/user/login";
  const res = await fetch(`${BASE}${endpoint}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    const userData = role === "astrologer" ? data.user : data.user;
    localStorage.setItem("app_user", JSON.stringify(userData));
  }
  return { ok: res.ok, status: res.status, data };
}

export async function signupUser(name: string, email: string, password: string, phone?: string) {
  const res = await fetch(`${BASE}/user/signup`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, email, password, ...(phone ? { phone } : {}) }),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("app_user", JSON.stringify(data.user));
  }
  return { ok: res.ok, status: res.status, data };
}

export async function signupAstrologer(fields: {
  name: string; email: string; password: string; phone?: string;
  display_name?: string; experience_years?: number;
  languages?: string[]; specializations?: string[];
  qualification?: string; bio?: string;
}) {
  const res = await fetch(`${BASE}/astrologer/signup`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(fields),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("app_user", JSON.stringify(data.user));
  }
  return { ok: res.ok, status: res.status, data };
}

// Start Google OAuth flow by redirecting browser to Google consent URL.
// Backend builds the URL using credentials stored in platform_settings.
export async function startGoogleOAuth(role: "user" | "astrologer") {
  const res = await fetch(`${BASE}/google/login-url?role=${role}`);
  const data = await res.json();
  if (!res.ok || !data.url) {
    return { error: data.detail || "Failed to build Google OAuth URL" };
  }
  window.location.href = data.url;
  return { error: null };
}

// Save tokens + user data returned via Google OAuth callback query params.
export function saveGoogleOAuthSession(params: URLSearchParams) {
  const access = params.get("access_token");
  const refresh = params.get("refresh_token");
  if (!access || !refresh) return null;
  localStorage.setItem("access_token", access);
  localStorage.setItem("refresh_token", refresh);
  const user = {
    id: params.get("user_id") || "",
    name: params.get("name") || "",
    email: params.get("email") || "",
    role: params.get("role") || "user",
    wallet_balance: 0,
  };
  localStorage.setItem("app_user", JSON.stringify(user));
  return user;
}

export async function googleLoginByRole(idToken: string, role: LoginRole) {
  const endpoint = role === "astrologer" ? "/astrologer/google-login" : "/user/google-login";
  const res = await fetch(`${BASE}${endpoint}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id_token: idToken }),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("app_user", JSON.stringify(data.user));
  }
  return { ok: res.ok, status: res.status, data };
}

// keep backward compat alias
export const loginAdmin = (email: string, password: string) => loginByRole(email, password, "admin");

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

export async function adminApproveAstrologer(profileId: string) {
  return request(`/admin/astrologers/${profileId}/approve`, { method: "PATCH" });
}

export async function adminRejectAstrologer(profileId: string, reason: string) {
  return request(`/admin/astrologers/${profileId}/reject`, {
    method: "PATCH",
    body: JSON.stringify({ reason }),
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
