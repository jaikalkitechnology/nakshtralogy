// Shapes mirrored from the FastAPI backend (app/schemas).

export type KYCStatus = 'pending' | 'approved' | 'rejected'

// ---- Payout details (blueprint §5 — UPI or Bank Account) ----

export type PayoutMethod = 'upi' | 'bank'
export type BankProofType = 'passbook' | 'cancelled_cheque' | 'bank_statement'

export interface Admin {
  id: string
  email: string
  name: string | null
}

export interface AuthResponse {
  access_token: string
  refresh_token: string
  admin: Admin
}

export interface KYCReviewItem {
  astrologer_id: string
  display_name: string | null
  mobile: string | null
  email: string | null
  kyc_status: KYCStatus
  full_name: string | null
  pan_number: string | null
  aadhaar_last4: string | null
  bank_account_last4: string | null
  bank_ifsc: string | null
  professional: Record<string, unknown>
  submitted_at: string | null
  /** Astrologer profile photo (absolute URL) */
  avatar_url: string | null
  /** Uploaded KYC document images (absolute URLs, null when not uploaded) */
  photo_url: string | null
  pan_doc_url: string | null
  aadhaar_doc_url: string | null
  aadhaar_back_doc_url: string | null
  bank_proof_url: string | null
  certificate_url: string | null
  /** Payout details (blueprint §5) — UPI id when 'upi', bank fields when 'bank' */
  payout_method: PayoutMethod | null
  upi_id: string | null
  bank_name: string | null
  bank_proof_type: BankProofType | null
}

export interface Astrologer {
  id: string
  display_name: string | null
  kyc_status: KYCStatus
  is_online: boolean
  is_live: boolean
  avg_rating: string
  review_count: number
  follower_count: number
}

export interface CustomerRow {
  id: string
  name: string | null
  mobile: string | null
  email: string | null
  avatar_url?: string | null
  language: string | null
  wallet_balance: string
  is_active: boolean
  created_at: string | null
}

export interface CustomerEditInput {
  name?: string
  email?: string
  mobile?: string
  language?: string
  avatar_url?: string
  is_active?: boolean
}

export interface AstrologerEditInput {
  display_name?: string
  bio?: string
  mobile?: string
  email?: string
  photo_url?: string
  skills?: string[]
  languages?: string[]
  years_experience?: number
  rate_chat_per_msg?: number
  rate_call_per_min?: number
  rate_video_per_min?: number
  kyc_status?: KYCStatus
  is_online?: boolean
}

export interface AdminStats {
  total_users: number
  total_astrologers: number
  pending_kyc: number
  approved_astrologers: number
  online_astrologers: number
  total_consultations: number
  completed_consultations: number
  gross_consultation_revenue: string
  platform_commission_earned: string
}

export interface RazorpaySettings {
  key_id: string | null
  key_secret_masked: string | null
  key_secret_configured?: boolean
  webhook_secret_masked: string | null
  webhook_secret_configured?: boolean
  is_active: boolean
  configured: boolean
  /**
   * Always null — the backing table never had this column; the serializer just
   * emits null for API-shape stability. Intentionally never rendered.
   */
  updated_at?: string | null
}

export interface RazorpaySettingsInput {
  key_id: string
  key_secret: string
  webhook_secret: string
  is_active: boolean
}

export interface NotificationSummary {
  pendingKyc: number
  pendingPayouts: number
}

// ---- Agora / Razorpay "diagnose" (GET …/diagnose) ----

export interface AgoraDiagnoseResult {
  active_creds_app_id_set: boolean
  active_creds_app_certificate_set: boolean
  token_expire_seconds: number
  agora_token_builder_installed: boolean
  test_token_prefix: string
  test_token_is_placeholder: boolean
  diagnosis: string
}

export interface RazorpayDiagnoseResult {
  credentials_configured: boolean
  source: string | null
  dev_mode: boolean
  key_id_prefix?: string
  test_order_ok?: boolean
  failure_reason?: string | null
  detail?: string
  diagnosis: string
  note?: string
}

// ---- Per-app maintenance mode (GET/PUT /admin/settings/maintenance/{app}) ----

export type MaintenanceApp = 'user' | 'astro'

export interface MaintenanceSetting {
  enabled: boolean
  message: string
}

// ---- Google login (OAuth client IDs, GET/PUT /admin/settings/google-auth) ----
// Per app (user/astro) AND per platform (android/web) — see
// app/services/google_auth.py. Android consumes its value as
// `serverClientId` and, when blank, falls back to that app's Web ID.

export interface GoogleAuthSettings {
  user_android_client_id: string
  user_web_client_id: string
  astro_android_client_id: string
  astro_web_client_id: string
  /** Where each app's web build is hosted — normalised server-side to
   *  `scheme://host[:port]` (path/trailing slash stripped). Used to derive
   *  `javascript_origins` below. */
  user_web_origin: string
  astro_web_origin: string
  extra_client_ids: string[]
  /**
   * READ-ONLY helpers the server derives/reports — never sent back in a PUT
   * beyond the canonical fields above. Optional because an older deployed
   * backend may not include them yet; the page must never crash on their
   * absence.
   */
  android_oauth_clients?: {
    user: { package_name: string; client_id: string }
    astro: { package_name: string; client_id: string }
  }
  /** Normalised `*_web_origin` values, keyed by app — what to paste into
   *  Google Cloud console's "Authorized JavaScript origins". */
  javascript_origins?: { user: string; astro: string }
  /** Always false — Google Identity Services returns the credential in-page
   *  and validates the origin, not a redirect URL. */
  redirect_uris_required?: boolean
}

// ---- Firebase config (service account + per-app client config) ----

export interface FirebaseServiceAccountStatus {
  exists: boolean
  project_id: string | null
  client_email: string | null
  push_enabled: boolean
}

// ---- Firebase per-platform service account (Android/Web can live in
// different Firebase projects) ----

export type FirebasePlatform = 'android' | 'web'

// ---- Firebase per-app service account (User/Astrologer apps can live in
// different Firebase projects — the primary split, since device tokens are
// minted by each app's own Firebase project). ----

export type FirebaseApp = 'user' | 'astro'

export interface FirebaseClientConfigResult {
  app: string
  project_id: string | null
  updated_at: string | null
}

/** Firebase WEB app config for one Flutter app. Public browser config (no
 *  secrets) — the web builds call Firebase.initializeApp() with these,
 *  fetched live from /v1/public/app-config. */
export interface FirebaseWebApp {
  api_key: string
  auth_domain: string
  project_id: string
  storage_bucket: string
  messaging_sender_id: string
  /** The `1:…:web:…` id from Firebase console → Project settings → Your apps
   *  → Web. Blank until a Web app is registered; web init needs it. */
  app_id: string
  measurement_id: string
  /** Web Push certificate public key — required to mint web FCM tokens. */
  vapid_key: string
}

export interface FirebaseWebConfig {
  user: FirebaseWebApp
  astro: FirebaseWebApp
}

// ---- Content: media uploads (banners / promo videos / astrologer videos) ----

export interface UploadResponse {
  url: string
}

// ---- Astrologer picker (used by the Astrologer Videos "Astrologer" select) ----

export interface AstrologerOption {
  id: string
  name: string | null
}

// ---- Customer "full details" drill-down (GET /admin/customers/{id}/detail) ----

export interface CustomerDetailProfile {
  id: string
  name: string | null
  mobile: string | null
  email: string | null
  avatar_url: string | null
  dob: string | null
  gender: string | null
  birth_place: string | null
  language: string | null
  is_active: boolean
  created_at: string | null
}

export interface CustomerDetailWallet {
  balance: string
  total_credit: string
  total_debit: string
}

export interface CustomerDetailTransaction {
  id: string
  type: string
  amount: string
  balance_after: string
  reference_id: string | null
  status: string
  created_at: string
}

export interface CustomerDetailConsultation {
  id: string
  astrologer_id: string
  astrologer_name: string | null
  type: string
  status: string
  amount_charged: string
  duration_seconds: number | null
  created_at: string
}

export interface CustomerDetail {
  profile: CustomerDetailProfile
  wallet: CustomerDetailWallet
  transactions: CustomerDetailTransaction[]
  consultations: {
    total: number
    completed: number
    total_spent: string
    recent: CustomerDetailConsultation[]
  }
}

// ---- Astrologer "full details" drill-down (GET /admin/astrologers/{id}/detail) ----

export interface AstrologerDetailProfile {
  id: string
  display_name: string | null
  mobile: string | null
  email: string | null
  photo_url: string | null
  bio: string | null
  skills: string[]
  languages: string[]
  years_experience: number | null
  rate_chat_per_msg: string
  rate_call_per_min: string
  rate_video_per_min: string
  kyc_status: KYCStatus
  is_online: boolean
  is_live: boolean
  avg_rating: string
  review_count: number
  followers: number
  created_at: string | null
}

export interface AstrologerDetailKyc {
  full_name: string | null
  dob: string | null
  address: string | null
  id_type: string | null
  pan_number: string | null
  aadhaar_last4: string | null
  bank_account_holder: string | null
  bank_account_last4: string | null
  bank_ifsc: string | null
  submitted_at: string | null
  reviewed_at: string | null
  reviewer_notes: string | null
  /** Uploaded KYC document images (absolute URLs, null when not uploaded) */
  photo_url: string | null
  pan_doc_url: string | null
  aadhaar_doc_url: string | null
  aadhaar_back_doc_url: string | null
  bank_proof_url: string | null
  certificate_url: string | null
  /** Payout details (blueprint §5) — UPI id when 'upi', bank fields when 'bank' */
  payout_method: PayoutMethod | null
  upi_id: string | null
  bank_name: string | null
  bank_proof_type: BankProofType | null
}

export interface AstrologerDetailEarnings {
  available_balance: string
  earned_consultations: string
  live_super_chat_gross: string
  live_gift_gross: string
  total_paid_out: string
  pending_payout_requests: number
}

export interface AstrologerDetailConsultation {
  id: string
  user_id: string
  user_name: string | null
  type: string
  status: string
  amount_charged: string
  astrologer_payout: string
  duration_seconds: number | null
  created_at: string
}

export interface AstrologerDetailPayout {
  id: string
  astrologer_id: string
  amount: string
  status: string
  bank_account_last4: string | null
  ifsc: string | null
  razorpay_payout_id: string | null
  paid_at: string | null
  created_at: string
}

export interface AstrologerDetail {
  profile: AstrologerDetailProfile
  kyc: AstrologerDetailKyc | null
  earnings: AstrologerDetailEarnings
  consultations: {
    total: number
    completed: number
    recent: AstrologerDetailConsultation[]
  }
  payouts: {
    recent: AstrologerDetailPayout[]
  }
}

// ---- Astrologer profile-edit approvals (GET /admin/profile-edits) ----

export type ProfileEditStatus = 'pending' | 'approved' | 'rejected'

/**
 * The proposed new values (`changes`) and today's live values (`current`) share
 * this shape — only keys the astrologer actually edited are present in
 * `changes`, and `current` mirrors the same keys.
 */
export interface ProfileEditFields {
  display_name?: string | null
  bio?: string | null
  photo_url?: string | null
  mobile?: string | null
  country_code?: string | null
  skills?: string[] | null
  languages?: string[] | null
  rate_chat_per_msg?: string | number | null
  rate_call_per_min?: string | number | null
  rate_video_per_min?: string | number | null
  super_chat_presets?: (string | number)[] | null
  /**
   * Staged KYC / payout changes. Mirrors a KYC submission: account number is
   * masked to last4, staged document uploads are `*_key` storage references
   * (no public URL until approved), plus payout fields (payout_method,
   * upi_id, bank_name, bank_proof_type, …).
   */
  kyc?: ProfileEditKycFields | null
}

/**
 * Nested KYC/payout diff object inside a profile-edit request. Keys mirror a
 * KYC submission and may grow; known keys are typed, the rest are indexable.
 */
export interface ProfileEditKycFields {
  [key: string]: unknown
  full_name?: string | null
  dob?: string | null
  address?: string | null
  pan_number?: string | null
  aadhaar_last4?: string | null
  pan_doc_key?: string | null
  aadhaar_doc_key?: string | null
  aadhaar_back_doc_key?: string | null
  bank_proof_key?: string | null
  payout_method?: PayoutMethod | null
  upi_id?: string | null
  bank_name?: string | null
  bank_account_holder?: string | null
  bank_account_last4?: string | null
  bank_ifsc?: string | null
  bank_proof_type?: BankProofType | null
}

export interface ProfileEditRequest {
  id: string
  astrologer_id: string
  astrologer_name: string | null
  astrologer_photo: string | null
  status: ProfileEditStatus
  submitted_at: string | null
  reviewed_at: string | null
  reviewer_notes: string | null
  changes: ProfileEditFields
  current: ProfileEditFields
}

// ---- Chat transcript drill-down (GET /admin/chat-rooms/{id}/messages) ----

export type ChatSenderRole = 'user' | 'astrologer'

export interface ChatRoomConsultation {
  id: string
  user_id: string
  astrologer_id: string
  user_name: string | null
  astrologer_name: string | null
  type: string
  status: string
  rate: string
  duration_seconds: number | null
  message_count: number
  amount_charged: string
  created_at: string
}

export interface ChatMessage {
  id: string
  sender_role: ChatSenderRole
  sender_id: string
  sender_name: string | null
  body: string
  created_at: string
}

export interface ChatTranscript {
  consultation: ChatRoomConsultation
  messages: ChatMessage[]
}

// ── Database schema auto-sync ("auto mode") ──────────────────────────
export interface SchemaMissingColumn {
  table: string
  column: string
  type: string
  ddl?: string
  nullable?: boolean
}

export interface SchemaExtraColumn {
  table: string
  column: string
}

export interface SchemaDiff {
  missing_tables: string[]
  missing_columns: SchemaMissingColumn[]
  extra_columns: SchemaExtraColumn[]
  in_sync: boolean
}

export interface SchemaApplyResult {
  dry_run: boolean
  created_tables: string[]
  added_columns: SchemaMissingColumn[]
  skipped: { table: string; column: string; reason: string }[]
  errors: unknown[]
  extra_columns: SchemaExtraColumn[]
  notes: string[]
}

export interface SchemaSyncLogEntry {
  id: string
  source: string
  dry_run: boolean
  created_tables: string[]
  added_columns: SchemaMissingColumn[]
  skipped: unknown[]
  errors: unknown[]
  notes: string[]
  triggered_by: string | null
  created_at: string | null
}

export type DeletedAccountType = 'all' | 'user' | 'astrologer'

/** A soft-deleted (anonymised) account row from `/admin/deleted-accounts`. */
export interface DeletedAccount {
  type: 'user' | 'astrologer'
  id: string
  name: string | null
  mobile: string | null
  email: string | null
  deleted_at: string | null
  deleted_reason: string | null
  restore_deadline: string | null
}

// ── TDS on payouts (Phase I) ──────────────────────────────────────────
/** TDS deduction config. Rates are fractions (0.10 = 10%). */
export interface TdsSettings {
  rate: number
  pan_required: boolean
  no_pan_rate: number
}

export interface TdsReportRow {
  astrologer_id: string
  astrologer_name: string | null
  pan: string | null
  gross: string
  tds: string
  net: string
  payouts: number
}

export interface TdsReport {
  period: string
  financial_year: string
  quarter: number | null
  from: string
  to: string
  items: TdsReportRow[]
  totals: { gross: string; tds: string; net: string; payouts: number; astrologers: number }
}

// Notification broadcast (Phase K)
export type BroadcastRole = 'user' | 'astrologer' | 'all'

export interface BroadcastResult {
  role: BroadcastRole
  recipients: number
  sent: number
  failed: number
  skipped: boolean
}

export interface BroadcastRecord {
  id: string
  role: BroadcastRole
  title: string
  body: string | null
  recipient_count: number
  created_at: string | null
}

// FAQ + support tickets (Phase L)
export type FaqApp = 'user' | 'astro' | 'both'

export interface Faq {
  id: string
  app: FaqApp
  category: string | null
  question_en: string
  answer_en: string
  question_hi: string | null
  answer_hi: string | null
  sort_order: number
  is_active: boolean
}

export interface FaqInput {
  app: FaqApp
  category?: string | null
  question_en: string
  answer_en: string
  question_hi?: string | null
  answer_hi?: string | null
  sort_order?: number
  is_active?: boolean
}

export type TicketStatus = 'open' | 'pending' | 'closed'
export type TicketSender = 'user' | 'astrologer' | 'admin'

export interface TicketMessage {
  id: string
  sender: TicketSender
  body: string
  created_at: string | null
}

export interface SupportTicket {
  id: string
  subject: string
  status: TicketStatus
  requester_role: 'user' | 'astrologer'
  requester_id: string
  requester_name: string | null
  created_at: string | null
  updated_at: string | null
  messages?: TicketMessage[]
}

export interface TicketList {
  items: SupportTicket[]
  total: number
  counts: Record<string, number>
  page: number
  size: number
}
