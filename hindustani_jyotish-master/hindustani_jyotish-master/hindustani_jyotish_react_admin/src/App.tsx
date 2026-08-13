import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import type { ReactNode } from 'react'
import { AuthProvider, useAuth } from './auth/AuthContext'
import Layout from './components/Layout'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import KYCQueuePage from './pages/KYCQueuePage'
import ProfileEditApprovalsPage from './pages/ProfileEditApprovalsPage'
import ListPage from './pages/ListPage'
import CouponsPage from './pages/CouponsPage'
import LiveGiftsPage from './pages/LiveGiftsPage'
import SimpleCrudPage from './pages/SimpleCrudPage'
import CosmicServicesPage from './pages/CosmicServicesPage'
import SettingsPage from './pages/SettingsPage'
import MaintenancePage from './pages/MaintenancePage'
import SchemaSyncPage from './pages/SchemaSyncPage'
import FirebaseConfigPage from './pages/FirebaseConfigPage'
import AgoraSettingsPage from './pages/AgoraSettingsPage'
import WalletManagementPage from './pages/WalletManagementPage'
import AstrologerChargesPage from './pages/AstrologerChargesPage'
import AstrologerDetailsPage from './pages/AstrologerDetailsPage'
import CommissionPage from './pages/CommissionPage'
import CustomersPage from './pages/CustomersPage'
import DeletedAccountsPage from './pages/DeletedAccountsPage'
import PayoutsPage from './pages/PayoutsPage'
import WalletTransactionsPage from './pages/WalletTransactionsPage'
import WalletLedgerPage from './pages/WalletLedgerPage'
import ReviewsPage from './pages/ReviewsPage'
import RazorpaySettingsPage from './pages/RazorpaySettingsPage'
import InvoicesPage from './pages/InvoicesPage'
import GoogleLoginSettingsPage from './pages/GoogleLoginSettingsPage'
import CredentialsOverviewPage from './pages/CredentialsOverviewPage'
import { RESOURCES } from './config/resources'
import { adminApi } from './api/endpoints'

function RequireAuth({ children }: { children: ReactNode }) {
  const { isAuthenticated } = useAuth()
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />
}

const list = (key: keyof typeof RESOURCES) => {
  const r = RESOURCES[key]
  return (
    <ListPage
      title={r.title}
      subtitle={r.subtitle}
      endpoint={r.endpoint}
      columns={r.columns}
      rowDetail={r.rowDetail}
    />
  )
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route
            element={
              <RequireAuth>
                <Layout />
              </RequireAuth>
            }
          >
            <Route path="/" element={<DashboardPage />} />

            {/* Users */}
            <Route path="/customers" element={<CustomersPage />} />
            <Route path="/deleted-accounts" element={<DeletedAccountsPage />} />

            {/* Astrologers */}
            <Route path="/astrologers" element={<AstrologerDetailsPage />} />
            <Route path="/charges" element={<AstrologerChargesPage />} />
            <Route path="/top" element={list('top')} />
            <Route path="/approval" element={<KYCQueuePage />} />
            <Route path="/approval-status" element={list('approvals')} />
            <Route path="/profile-edits" element={<ProfileEditApprovalsPage />} />

            {/* Wallet */}
            <Route path="/wallet" element={<WalletManagementPage />} />
            <Route path="/wallet-transactions" element={<WalletTransactionsPage />} />
            <Route path="/wallet-ledger" element={<WalletLedgerPage />} />
            <Route path="/payouts" element={<PayoutsPage />} />
            <Route path="/refunds" element={list('refunds')} />
            <Route path="/invoices" element={<InvoicesPage />} />

            {/* Sessions */}
            <Route path="/sessions" element={list('consultations')} />
            <Route path="/chat-rooms" element={list('chatRooms')} />
            <Route path="/reviews" element={<ReviewsPage />} />

            {/* Content */}
            <Route path="/coupons" element={<CouponsPage />} />
            <Route
              path="/banners"
              element={
                <SimpleCrudPage
                  title="Banners"
                  subtitle="Home-screen promotional banners."
                  endpoint="/admin/banners"
                  fields={[
                    { key: 'title', label: 'Title' },
                    { key: 'image_url', label: 'Image', required: true, placeholder: 'https://…', kind: 'image' },
                    { key: 'link_url', label: 'Link URL' },
                    { key: 'position', label: 'Position' },
                  ]}
                  display={[
                    { key: 'title', label: 'Title' },
                    { key: 'image_url', label: 'Image' },
                    { key: 'position', label: 'Pos' },
                    { key: 'is_active', label: 'Active' },
                  ]}
                />
              }
            />
            <Route path="/cosmic-services" element={<CosmicServicesPage />} />
            <Route path="/live-gifts" element={<LiveGiftsPage />} />
            <Route
              path="/promo-videos"
              element={
                <SimpleCrudPage
                  title="Feature Videos"
                  endpoint="/admin/promo-videos"
                  fields={[
                    { key: 'title', label: 'Title' },
                    { key: 'video_url', label: 'Video', required: true, kind: 'video' },
                    { key: 'thumbnail_url', label: 'Thumbnail', kind: 'image' },
                  ]}
                  display={[
                    { key: 'title', label: 'Title' },
                    { key: 'video_url', label: 'Video' },
                    { key: 'thumbnail_url', label: 'Thumbnail' },
                    { key: 'is_active', label: 'Active' },
                  ]}
                />
              }
            />
            <Route
              path="/astrologer-videos"
              element={
                <SimpleCrudPage
                  title="Astrologer Videos"
                  endpoint="/admin/astrologer-videos"
                  fields={[
                    {
                      key: 'astrologer_id',
                      label: 'Astrologer',
                      kind: 'select',
                      placeholder: '— none —',
                      loadOptions: () =>
                        adminApi
                          .astrologerOptions()
                          .then((list) => list.map((a) => ({ value: a.id, label: a.name || a.id }))),
                    },
                    { key: 'title', label: 'Title' },
                    { key: 'video_url', label: 'Video', required: true, kind: 'video' },
                    { key: 'thumbnail_url', label: 'Thumbnail', kind: 'image' },
                  ]}
                  display={[
                    { key: 'title', label: 'Title' },
                    { key: 'astrologer_id', label: 'Astrologer' },
                    { key: 'video_url', label: 'Video' },
                    { key: 'thumbnail_url', label: 'Thumbnail' },
                    { key: 'is_active', label: 'Active' },
                  ]}
                />
              }
            />

            {/* Settings */}
            <Route path="/credentials" element={<CredentialsOverviewPage />} />
            <Route
              path="/social-links"
              element={
                <SettingsPage
                  title="Social Links"
                  endpoint="/admin/settings/social-links"
                  fields={[
                    { key: 'facebook', label: 'Facebook' },
                    { key: 'instagram', label: 'Instagram' },
                    { key: 'youtube', label: 'YouTube' },
                    { key: 'whatsapp', label: 'WhatsApp' },
                  ]}
                />
              }
            />
            <Route
              path="/privacy-policy"
              element={
                <SettingsPage
                  title="Privacy Policy"
                  subtitle="The Privacy Policy URL both apps open. Leave empty until you have one — the apps then tell users it hasn't been added yet."
                  endpoint="/admin/settings/privacy-policy"
                  fields={[
                    { key: 'url', label: 'Privacy Policy URL', placeholder: 'https://example.com/privacy' },
                  ]}
                />
              }
            />
            <Route
              path="/support-contact"
              element={
                <SettingsPage
                  title="Helpline & Support"
                  subtitle="Support contact shown in both apps. Leave empty until configured — the apps then show a friendly message."
                  endpoint="/admin/settings/support-contact"
                  fields={[
                    { key: 'email', label: 'Helpline email', placeholder: 'help@example.com' },
                    { key: 'phone', label: 'Helpline phone', placeholder: '+91 98765 43210' },
                  ]}
                />
              }
            />
            <Route path="/agora" element={<AgoraSettingsPage />} />
            <Route path="/razorpay" element={<RazorpaySettingsPage />} />
            <Route path="/commission" element={<CommissionPage />} />
            <Route
              path="/gst-settings"
              element={
                <SettingsPage
                  title="GST"
                  subtitle="Seller identity + tax details printed on every GST invoice. The rate is applied GST-inclusive (place of supply unknown → CGST+SGST split). Leave GSTIN blank until registered."
                  endpoint="/admin/settings/gst"
                  fields={[
                    { key: 'seller_name', label: 'Legal name', placeholder: 'Hindustani Jyotish Pvt Ltd' },
                    { key: 'seller_gstin', label: 'Seller GSTIN', placeholder: '27ABCDE1234F1Z5' },
                    { key: 'seller_address', label: 'Registered address', placeholder: 'City, State' },
                    { key: 'default_rate', label: 'Default GST rate (%)', placeholder: '18' },
                    { key: 'hsn_sac', label: 'HSN / SAC code', placeholder: '998399' },
                  ]}
                />
              }
            />
            <Route path="/maintenance" element={<MaintenancePage />} />
            <Route path="/schema-sync" element={<SchemaSyncPage />} />
            <Route path="/firebase-config" element={<FirebaseConfigPage />} />
            <Route path="/google-login" element={<GoogleLoginSettingsPage />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}
