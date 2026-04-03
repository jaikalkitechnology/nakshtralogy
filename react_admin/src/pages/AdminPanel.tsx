import { useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import StarField from "@/components/StarField";
import { mockUsers, mockAstrologers, mockWalletTransactions } from "@/data/mockData";
import {
  Users, Star, Wallet, Settings, LogOut, Search, BarChart3,
  Shield, Ban, CheckCircle, DollarSign, TrendingUp, Eye
} from "lucide-react";

type Tab = "overview" | "users" | "astrologers" | "wallet" | "pricing" | "settings";

const AdminPanel = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("overview");
  const [searchQuery, setSearchQuery] = useState("");

  if (!user) { navigate("/auth"); return null; }

  const tabs = [
    { id: "overview" as Tab, icon: <BarChart3 className="w-5 h-5" />, label: "Overview" },
    { id: "users" as Tab, icon: <Users className="w-5 h-5" />, label: "Users" },
    { id: "astrologers" as Tab, icon: <Star className="w-5 h-5" />, label: "Astrologers" },
    { id: "wallet" as Tab, icon: <Wallet className="w-5 h-5" />, label: "Wallet" },
    { id: "pricing" as Tab, icon: <DollarSign className="w-5 h-5" />, label: "Pricing" },
    { id: "settings" as Tab, icon: <Settings className="w-5 h-5" />, label: "Settings" },
  ];

  const pricingConfig = [
    { service: "Chat", pricePerMin: 15, commission: 30 },
    { service: "Voice Call", pricePerMin: 25, commission: 25 },
    { service: "Video Call", pricePerMin: 40, commission: 20 },
  ];

  return (
    <div className="min-h-screen gradient-mystic relative">
      <StarField />

      <div className="relative z-10 flex min-h-screen">
        {/* Sidebar - Desktop */}
        <aside className="hidden md:flex flex-col w-64 bg-card/50 backdrop-blur-lg border-r border-border p-4">
          <div className="flex items-center gap-2 mb-8">
            <Shield className="w-6 h-6 text-primary" />
            <span className="font-display text-gold-gradient text-lg">Admin Panel</span>
          </div>
          <nav className="space-y-1 flex-1">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-all ${
                  activeTab === tab.id ? "bg-primary/10 text-primary font-medium" : "text-muted-foreground hover:text-foreground hover:bg-muted/50"
                }`}
              >
                {tab.icon}
                {tab.label}
              </button>
            ))}
          </nav>
          <Button variant="outline" className="border-destructive text-destructive mt-auto" onClick={() => { logout(); navigate("/"); }}>
            <LogOut className="w-4 h-4 mr-2" /> Logout
          </Button>
        </aside>

        {/* Main Content */}
        <main className="flex-1 overflow-auto pb-20 md:pb-4">
          <header className="p-4 border-b border-border bg-card/30 backdrop-blur-sm flex items-center justify-between">
            <h1 className="text-lg font-display text-foreground capitalize">{activeTab}</h1>
            <div className="flex items-center gap-2">
              <Badge className="gradient-gold text-primary-foreground">Admin</Badge>
            </div>
          </header>

          <div className="p-4">
            {activeTab === "overview" && (
              <div className="space-y-6">
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {[
                    { label: "Total Users", value: "1,247", icon: <Users className="w-5 h-5" />, trend: "+12%" },
                    { label: "Astrologers", value: "85", icon: <Star className="w-5 h-5" />, trend: "+5%" },
                    { label: "Revenue", value: "₹4,52,000", icon: <TrendingUp className="w-5 h-5" />, trend: "+18%" },
                    { label: "Active Sessions", value: "23", icon: <Eye className="w-5 h-5" />, trend: "" },
                  ].map((s) => (
                    <div key={s.label} className="bg-card/60 border border-border rounded-xl p-4">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-primary">{s.icon}</span>
                        {s.trend && <span className="text-xs text-green-400">{s.trend}</span>}
                      </div>
                      <p className="text-xl font-semibold text-foreground">{s.value}</p>
                      <p className="text-xs text-muted-foreground">{s.label}</p>
                    </div>
                  ))}
                </div>

                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">Recent Transactions</h3>
                  <div className="space-y-2">
                    {mockWalletTransactions.slice(0, 5).map((t) => (
                      <div key={t.id} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                        <div>
                          <p className="text-sm text-foreground">{t.description}</p>
                          <p className="text-xs text-muted-foreground">{t.date}</p>
                        </div>
                        <span className={`text-sm font-semibold ${t.type === "credit" ? "text-green-400" : "text-destructive"}`}>
                          {t.type === "credit" ? "+" : "-"}₹{t.amount}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {activeTab === "users" && (
              <div className="space-y-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder="Search users..." className="pl-10 bg-muted border-border" />
                </div>
                <div className="bg-card/60 border border-border rounded-xl overflow-hidden">
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b border-border">
                          <th className="text-left p-3 text-muted-foreground font-medium">Name</th>
                          <th className="text-left p-3 text-muted-foreground font-medium hidden md:table-cell">Email</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Balance</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Status</th>
                          <th className="text-left p-3 text-muted-foreground font-medium">Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {mockUsers.filter((u) => u.name.toLowerCase().includes(searchQuery.toLowerCase())).map((u) => (
                          <tr key={u.id} className="border-b border-border last:border-0">
                            <td className="p-3 text-foreground">{u.name}</td>
                            <td className="p-3 text-muted-foreground hidden md:table-cell">{u.email}</td>
                            <td className="p-3 text-primary font-medium">₹{u.walletBalance}</td>
                            <td className="p-3">
                              <Badge className={u.status === "active" ? "bg-green-500/20 text-green-400" : "bg-destructive/20 text-destructive"}>{u.status}</Badge>
                            </td>
                            <td className="p-3">
                              <div className="flex gap-1">
                                <Button size="sm" variant="outline" className="h-7 text-xs border-border">View</Button>
                                <Button size="sm" variant="outline" className={`h-7 text-xs ${u.status === "active" ? "border-destructive text-destructive" : "border-green-500 text-green-400"}`}>
                                  {u.status === "active" ? <Ban className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
                                </Button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {activeTab === "astrologers" && (
              <div className="space-y-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder="Search astrologers..." className="pl-10 bg-muted border-border" />
                </div>
                <div className="grid md:grid-cols-2 gap-4">
                  {mockAstrologers.filter((a) => a.name.toLowerCase().includes(searchQuery.toLowerCase())).map((a) => (
                    <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4">
                      <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl">{a.avatar}</div>
                        <div className="flex-1">
                          <h4 className="font-semibold text-foreground">{a.name}</h4>
                          <p className="text-sm text-primary">{a.speciality}</p>
                        </div>
                        <Badge className={a.status === "online" ? "bg-green-500/20 text-green-400" : a.status === "busy" ? "bg-yellow-500/20 text-yellow-400" : "bg-muted text-muted-foreground"}>{a.status}</Badge>
                      </div>
                      <div className="grid grid-cols-3 gap-2 mt-3 text-center">
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">⭐ {a.rating}</p>
                          <p className="text-[10px] text-muted-foreground">Rating</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-foreground">{a.totalConsultations}</p>
                          <p className="text-[10px] text-muted-foreground">Sessions</p>
                        </div>
                        <div className="bg-muted rounded-lg p-2">
                          <p className="text-sm font-semibold text-primary">₹{a.pricePerMin}</p>
                          <p className="text-[10px] text-muted-foreground">Per min</p>
                        </div>
                      </div>
                      <div className="flex gap-2 mt-3">
                        <Button size="sm" variant="outline" className="flex-1 text-xs border-border">Edit</Button>
                        <Button size="sm" variant="outline" className="flex-1 text-xs border-destructive text-destructive">Block</Button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {activeTab === "wallet" && (
              <div className="space-y-6">
                <div className="grid md:grid-cols-3 gap-4">
                  <div className="bg-card/60 border border-border rounded-xl p-4 text-center glow-gold">
                    <p className="text-sm text-muted-foreground">Total Platform Revenue</p>
                    <p className="text-3xl font-display text-gold-gradient mt-2">₹4,52,000</p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-4 text-center">
                    <p className="text-sm text-muted-foreground">Total User Wallets</p>
                    <p className="text-3xl font-display text-foreground mt-2">₹2,05,000</p>
                  </div>
                  <div className="bg-card/60 border border-border rounded-xl p-4 text-center">
                    <p className="text-sm text-muted-foreground">Pending Payouts</p>
                    <p className="text-3xl font-display text-cosmic-light mt-2">₹85,000</p>
                  </div>
                </div>

                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">All Transactions</h3>
                  <div className="space-y-2">
                    {mockWalletTransactions.map((t) => (
                      <div key={t.id} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                        <div>
                          <p className="text-sm text-foreground">{t.description}</p>
                          <p className="text-xs text-muted-foreground">User: {t.userId} • {t.date}</p>
                        </div>
                        <span className={`text-sm font-semibold ${t.type === "credit" ? "text-green-400" : "text-destructive"}`}>
                          {t.type === "credit" ? "+" : "-"}₹{t.amount}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {activeTab === "pricing" && (
              <div className="space-y-6">
                <h2 className="text-xl font-display text-gold-gradient">Service Pricing & Commission</h2>
                <div className="bg-card/60 border border-border rounded-xl overflow-hidden">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b border-border">
                        <th className="text-left p-3 text-muted-foreground font-medium">Service</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Base Price/min</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Commission %</th>
                        <th className="text-left p-3 text-muted-foreground font-medium">Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {pricingConfig.map((p) => (
                        <tr key={p.service} className="border-b border-border last:border-0">
                          <td className="p-3 text-foreground font-medium">{p.service}</td>
                          <td className="p-3 text-primary">₹{p.pricePerMin}</td>
                          <td className="p-3 text-foreground">{p.commission}%</td>
                          <td className="p-3">
                            <Button size="sm" variant="outline" className="h-7 text-xs border-primary text-primary">Edit</Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>

                <div className="bg-card/60 border border-border rounded-xl p-4">
                  <h3 className="text-sm font-semibold text-primary mb-3">Wallet Deduction Rules</h3>
                  <div className="space-y-2 text-sm text-muted-foreground">
                    <p>• Chat: ₹{pricingConfig[0].pricePerMin}/min deducted from user wallet</p>
                    <p>• Voice Call: ₹{pricingConfig[1].pricePerMin}/min deducted from user wallet</p>
                    <p>• Video Call: ₹{pricingConfig[2].pricePerMin}/min deducted from user wallet</p>
                    <p>• Minimum wallet balance required: ₹50</p>
                    <p>• Auto-disconnect when balance reaches ₹0</p>
                  </div>
                </div>
              </div>
            )}

            {activeTab === "settings" && (
              <div className="space-y-4">
                <h2 className="text-xl font-display text-gold-gradient">Platform Settings</h2>
                {["General Settings", "Payment Gateway", "Notification Settings", "Content Management", "Report & Analytics", "Support Tickets"].map((item) => (
                  <div key={item} className="bg-card/60 border border-border rounded-lg p-4 flex items-center justify-between cursor-pointer hover:glow-gold transition-all">
                    <span className="text-foreground">{item}</span>
                    <span className="text-muted-foreground">›</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </main>
      </div>

      {/* Mobile Bottom Nav */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-20 bg-card/90 backdrop-blur-lg border-t border-border">
        <div className="flex">
          {tabs.slice(0, 5).map((tab) => (
            <button key={tab.id} onClick={() => setActiveTab(tab.id)} className={`flex-1 flex flex-col items-center py-2.5 transition-colors ${activeTab === tab.id ? "text-primary" : "text-muted-foreground"}`}>
              {tab.icon}
              <span className="text-[10px] mt-0.5">{tab.label}</span>
            </button>
          ))}
        </div>
      </nav>
    </div>
  );
};

export default AdminPanel;
