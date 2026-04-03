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

export async function loginAdmin(email: string, password: string) {
  // admin uses user router login (role is checked server-side by stored role)
  const res = await fetch(`${BASE}/user/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json();
  if (res.ok) {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("admin_user", JSON.stringify(data.user));
  }
  return { ok: res.ok, status: res.status, data };
}

export function logoutAdmin() {
  localStorage.removeItem("access_token");
  localStorage.removeItem("refresh_token");
  localStorage.removeItem("admin_user");
}

export function getStoredUser() {
  const raw = localStorage.getItem("admin_user");
  return raw ? JSON.parse(raw) : null;
}

// ── Users ────────────────────────────────────────────────────────

export async function fetchUsers(skip = 0, limit = 50) {
  return request(`/user/me`); // admin can list — we'll use a custom admin endpoint
}

// For admin, we need a listing endpoint. We'll call seed-open to get users
// In production, add GET /admin/users. For now, fetch from seed.
export async function adminListUsers(skip = 0, limit = 50) {
  return request(`/admin/users?skip=${skip}&limit=${limit}`);
}

export async function adminToggleUser(userId: string, isActive: boolean) {
  return request(`/admin/users/${userId}/toggle`, {
    method: "PATCH",
    body: JSON.stringify({ is_active: isActive }),
  });
}

// ── Astrologers ──────────────────────────────────────────────────

export async function fetchAstrologers(skip = 0, limit = 50) {
  return request(`/astrologer/list?skip=${skip}&limit=${limit}`);
}

export async function adminApproveAstrologer(profileId: string) {
  return request(`/admin/astrologers/${profileId}/approve`, { method: "PATCH" });
}

export async function adminBlockAstrologer(profileId: string) {
  return request(`/admin/astrologers/${profileId}/block`, { method: "PATCH" });
}

// ── Service Pricing ──────────────────────────────────────────────

export async function fetchServicePricing() {
  return request("/service/pricing");
}

export async function createServicePricing(data: any) {
  return request("/service/pricing", { method: "POST", body: JSON.stringify(data) });
}

export async function updateServicePricing(id: string, data: any) {
  return request(`/service/pricing/${id}`, { method: "PUT", body: JSON.stringify(data) });
}

export async function seedServicePricing() {
  return request("/service/pricing/seed", { method: "POST" });
}

// ── Gift Pricing ─────────────────────────────────────────────────

export async function fetchGiftPricing() {
  return request("/comm/gifts");
}

export async function createGiftPricing(data: any) {
  return request("/comm/gifts", { method: "POST", body: JSON.stringify(data) });
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

// ── Wallet / Transactions ────────────────────────────────────────

export async function adminWalletStats() {
  return request("/admin/wallet-stats");
}

// ── Seed ─────────────────────────────────────────────────────────

export async function seedAll() {
  return request("/admin/seed", { method: "POST" });
}

export async function seedOpen() {
  const res = await fetch(`${BASE}/admin/seed-open`, { method: "POST" });
  return { ok: res.ok, status: res.status, data: await res.json() };
}
