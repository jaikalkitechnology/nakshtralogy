import { api, apiDownload, apiUpload, downloadBlob } from './client'
import type { KycDocSet } from '../components/KycDocs'
import type {
  AdminStats,
  AgoraDiagnoseResult,
  Astrologer,
  AstrologerDetail,
  AstrologerEditInput,
  AstrologerOption,
  AuthResponse,
  ChatTranscript,
  CustomerDetail,
  CustomerEditInput,
  CustomerRow,
  DeletedAccount,
  DeletedAccountType,
  FirebaseApp,
  FirebaseClientConfigResult,
  FirebasePlatform,
  FirebaseServiceAccountStatus,
  FirebaseWebConfig,
  GoogleAuthSettings,
  KYCReviewItem,
  KYCStatus,
  MaintenanceApp,
  MaintenanceSetting,
  ProfileEditRequest,
  ProfileEditStatus,
  RazorpayDiagnoseResult,
  RazorpaySettings,
  RazorpaySettingsInput,
  SchemaApplyResult,
  SchemaDiff,
  SchemaSyncLogEntry,
  UploadResponse,
} from './types'

/**
 * KYC action routes are centralised here so they can be adjusted in one place
 * if the backend contract differs. The primary contract is the dedicated
 * `/kyc/approve` + `/kyc/reject` routes landing in parallel; if those 404 the
 * legacy `/approve` + `/reject` routes on the astrologer are used as fallback.
 */
export const KYC_ROUTES = {
  approve: (id: string) => `/admin/astrologers/${id}/kyc/approve`,
  reject: (id: string) => `/admin/astrologers/${id}/kyc/reject`,
  approveFallback: (id: string) => `/admin/astrologers/${id}/approve`,
  rejectFallback: (id: string) => `/admin/astrologers/${id}/reject`,
}

async function kycAction(
  primary: string,
  fallback: string,
  body: Record<string, unknown>,
): Promise<Astrologer> {
  try {
    return await api<Astrologer>(primary, { method: 'POST', body })
  } catch (e) {
    // If the dedicated KYC route is not present (404/405), fall back to the
    // legacy astrologer approve/reject route with the same payload.
    const status = (e as { status?: number }).status
    if (status === 404 || status === 405) {
      return api<Astrologer>(fallback, { method: 'POST', body })
    }
    throw e
  }
}

export const adminApi = {
  login: (email: string, password: string) =>
    api<AuthResponse>('/admin/login', { method: 'POST', body: { email, password }, auth: false }),

  stats: () => api<AdminStats>('/admin/stats'),

  listAstrologers: (kycStatus?: KYCStatus) =>
    api<KYCReviewItem[]>(
      `/admin/astrologers${kycStatus ? `?kyc_status=${kycStatus}` : ''}`,
    ),

  approve: (id: string, notes?: string) =>
    kycAction(KYC_ROUTES.approve(id), KYC_ROUTES.approveFallback(id), { reason: notes, notes }),

  reject: (id: string, notes?: string) =>
    kycAction(KYC_ROUTES.reject(id), KYC_ROUTES.rejectFallback(id), { reason: notes, notes }),

  refund: (consultationId: string, amount: string | null, reason: string | null) =>
    api(`/admin/consultations/${consultationId}/refund`, {
      method: 'POST',
      body: { amount: amount || null, reason },
    }),

  creditWallet: (customerId: string, amount: number, note?: string) =>
    api(`/admin/customers/${customerId}/wallet`, {
      method: 'POST',
      body: { amount, note: note || null },
    }),

  // Credit an astrologer's withdrawable balance (admin goodwill/correction;
  // pushes the astrologer a notification).
  creditAstrologerWallet: (astrologerId: string, amount: number, note?: string) =>
    api<{ astrologer_id: string; available_balance: string }>(
      `/admin/astrologers/${astrologerId}/wallet`,
      { method: 'POST', body: { amount, note: note || null } },
    ),

  // Review moderation (reviews live on the consultation row; deleting
  // clears rating+text, never the consultation itself).
  editReview: (consultationId: string, body: { rating?: number; review?: string | null }) =>
    api<{ id: string; rating: number; review: string | null }>(
      `/admin/reviews/${consultationId}`, { method: 'PATCH', body },
    ),
  deleteReview: (consultationId: string) =>
    api<void>(`/admin/reviews/${consultationId}`, { method: 'DELETE' }),

  // Customer edit / hard delete.
  editCustomer: (id: string, body: CustomerEditInput) =>
    api<CustomerRow>(`/admin/customers/${id}`, { method: 'PATCH', body }),
  deleteCustomer: (id: string) =>
    api<void>(`/admin/customers/${id}`, { method: 'DELETE' }),

  // Astrologer edit / hard delete.
  editAstrologer: (id: string, body: AstrologerEditInput) =>
    api<Astrologer>(`/admin/astrologers/${id}`, { method: 'PATCH', body }),
  deleteAstrologer: (id: string) =>
    api<void>(`/admin/astrologers/${id}`, { method: 'DELETE' }),

  // Account-deletion management (soft-delete + anonymise; restore within N
  // days). Self-service deletes from the apps land here as anonymised shells;
  // force-delete lets an admin trigger the same soft-delete, bypassing the
  // self-delete guards.
  listDeletedAccounts: (type: DeletedAccountType = 'all') =>
    api<DeletedAccount[]>(`/admin/deleted-accounts?type=${type}`),
  forceDeleteCustomer: (id: string) =>
    api<DeletedAccount>(`/admin/customers/${id}/force-delete`, { method: 'POST' }),
  restoreCustomer: (id: string) =>
    api<CustomerRow>(`/admin/customers/${id}/restore`, { method: 'POST' }),
  forceDeleteAstrologer: (id: string) =>
    api<DeletedAccount>(`/admin/astrologers/${id}/force-delete`, { method: 'POST' }),
  restoreAstrologer: (id: string) =>
    api<{ id: string; name: string | null }>(`/admin/astrologers/${id}/restore`, { method: 'POST' }),
  // Replace one KYC document (photo/pan/aadhaar/aadhaar_back/bank_proof/
  // certificate) for an astrologer; returns the full refreshed doc URL set.
  uploadAstrologerKycDoc: (id: string, docType: string, file: File) =>
    apiUpload<KycDocSet>(`/admin/astrologers/${id}/kyc/documents`, file, { doc_type: docType }),

  // Full-details drill-downs (used by the DetailDrawer row-click experience).
  customerDetail: (id: string) => api<CustomerDetail>(`/admin/customers/${id}/detail`),
  astrologerDetail: (id: string) => api<AstrologerDetail>(`/admin/astrologers/${id}/detail`),

  // Full chat transcript (used by the Chat Message Rooms row-click experience).
  chatTranscript: (consultationId: string) =>
    api<ChatTranscript>(`/admin/chat-rooms/${consultationId}/messages`),

  // Razorpay payment gateway credentials (secrets masked on read).
  getRazorpay: () => api<RazorpaySettings>('/admin/razorpay-settings'),
  saveRazorpay: (body: RazorpaySettingsInput) =>
    api<RazorpaySettings>('/admin/razorpay-settings', { method: 'PUT', body }),

  // Google login OAuth Web client IDs (served live to the apps via
  // /public/app-config; blank values fall back to GOOGLE_CLIENT_IDS env).
  getGoogleAuth: () => api<GoogleAuthSettings>('/admin/settings/google-auth'),
  saveGoogleAuth: (value: GoogleAuthSettings) =>
    api<GoogleAuthSettings>('/admin/settings/google-auth', { method: 'PUT', body: { value } }),

  // "Test connection" diagnostics — mint a real token / place a real (never
  // charged) test order to confirm the stored credentials actually work.
  diagnoseAgora: () => api<AgoraDiagnoseResult>('/admin/agora-settings/diagnose'),
  diagnoseRazorpay: () => api<RazorpayDiagnoseResult>('/admin/razorpay-settings/diagnose'),

  // Per-app maintenance mode.
  getMaintenance: (app: MaintenanceApp) => api<MaintenanceSetting>(`/admin/settings/maintenance/${app}`),
  setMaintenance: (app: MaintenanceApp, value: MaintenanceSetting) =>
    api<MaintenanceSetting>(`/admin/settings/maintenance/${app}`, { method: 'PUT', body: { value } }),

  // Database schema auto-sync ("auto mode"). Additive-only: create missing
  // tables + add missing NULL-able columns from the models. Never drops.
  // Backend: /admin/system/schema/*  (admin-only).
  schemaDiff: () => api<{ status: string; data: SchemaDiff }>('/admin/system/schema/diff'),
  schemaSync: (dryRun: boolean) =>
    api<{ status: string; data: SchemaApplyResult }>(
      `/admin/system/schema/sync?dry_run=${dryRun}`, { method: 'POST' },
    ),
  schemaAutoGet: () => api<{ status: string; data: { enabled: boolean } }>('/admin/system/schema/auto'),
  schemaAutoSet: (enabled: boolean) =>
    api<{ status: string; data: { enabled: boolean } }>(
      '/admin/system/schema/auto', { method: 'POST', body: { enabled } },
    ),
  schemaHistory: (limit = 20) =>
    api<{ status: string; data: SchemaSyncLogEntry[] }>(`/admin/system/schema/history?limit=${limit}`),

  // Firebase service-account (push notifications) — status only, never the key.
  firebaseServiceAccountStatus: () => api<FirebaseServiceAccountStatus>('/admin/firebase/service-account/status'),
  uploadFirebaseServiceAccount: (file: File) =>
    apiUpload<{ project_id: string | null; client_email: string | null }>('/admin/firebase/service-account', file),

  // Per-platform Firebase service accounts (Android/Web can live in
  // different Firebase projects — falls back to the shared one above when
  // not set for that platform).
  firebasePlatformServiceAccountStatus: (platform: FirebasePlatform) =>
    api<FirebaseServiceAccountStatus>(`/admin/firebase/service-account/${platform}/status`),
  uploadFirebasePlatformServiceAccount: (platform: FirebasePlatform, file: File) =>
    apiUpload<{ project_id: string | null; client_email: string | null }>(
      `/admin/firebase/service-account/${platform}`, file,
    ),
  deleteFirebasePlatformServiceAccount: (platform: FirebasePlatform) =>
    api<void>(`/admin/firebase/service-account/${platform}`, { method: 'DELETE' }),

  // Per-app Firebase service accounts (User/Astrologer apps can live in
  // different Firebase projects — the primary split, since a device token is
  // only deliverable through the Firebase project that minted it. Falls back
  // to the shared credential above when not set for that app).
  firebaseAppServiceAccountStatus: (app: FirebaseApp) =>
    api<FirebaseServiceAccountStatus>(`/admin/firebase/service-account/app/${app}/status`),
  uploadFirebaseAppServiceAccount: (app: FirebaseApp, file: File) =>
    apiUpload<{ project_id: string | null; client_email: string | null }>(
      `/admin/firebase/service-account/app/${app}`, file,
    ),
  deleteFirebaseAppServiceAccount: (app: FirebaseApp) =>
    api<void>(`/admin/firebase/service-account/app/${app}`, { method: 'DELETE' }),

  // Per-app Firebase client config (google-services.json).
  downloadFirebaseClientConfig: (app: MaintenanceApp) => apiDownload(`/admin/firebase/client-config/${app}`),
  uploadFirebaseClientConfig: (app: MaintenanceApp, file: File) =>
    apiUpload<FirebaseClientConfigResult>(`/admin/firebase/client-config/${app}`, file),

  // Firebase WEB app config (per app). Unlike google-services.json (baked
  // into mobile builds), both Flutter WEB builds read these live from
  // /v1/public/app-config at startup — saving takes effect on next load.
  getFirebaseWebConfig: () => api<FirebaseWebConfig>('/admin/firebase/web-config'),
  saveFirebaseWebConfig: (value: FirebaseWebConfig) =>
    api<FirebaseWebConfig>('/admin/firebase/web-config', { method: 'PUT', body: { value } }),

  // Astrologer profile-edit approvals (self-service edits held for review).
  listProfileEdits: (status?: ProfileEditStatus | 'all') =>
    api<ProfileEditRequest[]>(`/admin/profile-edits${status ? `?status=${status}` : ''}`),
  approveProfileEdit: (id: string) =>
    api(`/admin/profile-edits/${id}/approve`, { method: 'POST' }),
  rejectProfileEdit: (id: string, notes?: string) =>
    api(`/admin/profile-edits/${id}/reject`, { method: 'POST', body: { notes: notes || null } }),

  // Payout (withdraw request) lifecycle actions.
  approvePayout: (id: string) => api(`/admin/payouts/${id}/approve`, { method: 'POST' }),
  markPayoutPaid: (id: string, reference?: string) =>
    api(`/admin/payouts/${id}/mark-paid`, { method: 'POST', body: { reference: reference || null } }),
  rejectPayout: (id: string, reason?: string) =>
    api(`/admin/payouts/${id}/reject`, { method: 'POST', body: { reason: reason || null } }),

  // Refund a specific wallet-transaction charge back to the customer (shows
  // up in Refund History — same table filtered to type=refund — and pushes
  // the customer a notification).
  refundTransaction: (id: string, amount?: string, reason?: string) =>
    api<{ id: string; amount: string; wallet_balance: string }>(
      `/admin/wallet/transactions/${id}/refund`,
      { method: 'POST', body: { amount: amount || null, reason: reason || null } },
    ),

  // Lightweight astrologer list for pickers (e.g. the Astrologer Videos form).
  astrologerOptions: () => api<AstrologerOption[]>('/admin/astrologers/list'),

  // GST invoices (Phase H) — one per paid consultation. Download opens the
  // stored PDF; CSV exports the filtered set. GST seller config lives in
  // /admin/settings/gst (handled by the generic SettingsPage).
  downloadInvoice: async (id: string, invoiceNumber: string) => {
    const { blob } = await apiDownload(`/admin/invoices/${id}/download`)
    downloadBlob(blob, `${invoiceNumber.replace(/\//g, '-')}.pdf`)
  },
  exportInvoicesCsv: async (q?: string) => {
    const path = `/admin/invoices.csv${q ? `?q=${encodeURIComponent(q)}` : ''}`
    const { blob } = await apiDownload(path)
    downloadBlob(blob, 'invoices.csv')
  },

  // Content media uploads — used by the Banners / Promo Videos / Astrologer
  // Videos forms to turn a file picked on disk into a hosted URL.
  uploadImage: (file: File) => apiUpload<UploadResponse>('/admin/uploads/image', file),
  uploadVideo: (file: File) => apiUpload<UploadResponse>('/admin/uploads/video', file),
}
