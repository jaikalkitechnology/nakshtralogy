import { useState, useEffect } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import StarField from "@/components/StarField";
import {
  Home, MessageCircle, Phone, Video, Wallet, User, LogOut, Clock,
  Star, CheckCircle, XCircle, Settings, Bell
} from "lucide-react";

type Tab = "home" | "requests" | "earnings" | "profile";

const AstrologerDashboard = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("home");

  useEffect(() => {
    if (!user) navigate("/auth");
  }, [user, navigate]);

  if (!user) return null;

  const pendingRequests = [
    { id: "1", userName: "Rahul Kumar", type: "chat" as const, time: "2 min ago" },
    { id: "2", userName: "Priya Singh", type: "voice" as const, time: "5 min ago" },
    { id: "3", userName: "Neha Sharma", type: "video" as const, time: "10 min ago" },
  ];

  const tabs = [
    { id: "home" as Tab, icon: <Home className="w-5 h-5" />, label: "Home" },
    { id: "requests" as Tab, icon: <Bell className="w-5 h-5" />, label: "Requests" },
    { id: "earnings" as Tab, icon: <Wallet className="w-5 h-5" />, label: "Earnings" },
    { id: "profile" as Tab, icon: <User className="w-5 h-5" />, label: "Profile" },
  ];

  const typeIcons = { chat: <MessageCircle className="w-4 h-4" />, voice: <Phone className="w-4 h-4" />, video: <Video className="w-4 h-4" /> };
  const typeColors = { chat: "text-primary", voice: "text-green-400", video: "text-cosmic-light" };

  return (
    <div className="min-h-screen gradient-mystic relative flex flex-col">
      <StarField />

      <header className="relative z-10 flex items-center justify-between p-4 border-b border-border bg-card/50 backdrop-blur-lg">
        <div className="flex items-center gap-2">
          <span className="text-xl">🔮</span>
          <span className="font-display text-gold-gradient text-lg">Astrologer Panel</span>
        </div>
        <div className="flex items-center gap-3">
          <Badge className="bg-green-500/20 text-green-400 border-green-500/30">Online</Badge>
          <button onClick={() => { logout(); navigate("/"); }}><LogOut className="w-5 h-5 text-muted-foreground" /></button>
        </div>
      </header>

      <main className="relative z-10 flex-1 overflow-auto pb-20">
        {activeTab === "home" && (
          <div className="p-4 space-y-6">
            <div>
              <h2 className="text-xl font-display text-foreground">Namaste, {user.name} 🙏</h2>
              <p className="text-muted-foreground text-sm mt-1">Your dashboard overview</p>
            </div>
            <div className="grid grid-cols-2 gap-3">
              {[
                { label: "Today's Earnings", value: "₹1,250", icon: "💰" },
                { label: "Total Consultations", value: "12", icon: "📊" },
                { label: "Avg Rating", value: "4.8 ⭐", icon: "⭐" },
                { label: "Pending Requests", value: "3", icon: "🔔" },
              ].map((s) => (
                <div key={s.label} className="bg-card/60 border border-border rounded-xl p-4">
                  <span className="text-2xl">{s.icon}</span>
                  <p className="text-lg font-semibold text-foreground mt-2">{s.value}</p>
                  <p className="text-xs text-muted-foreground">{s.label}</p>
                </div>
              ))}
            </div>

            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Recent Requests</h3>
              <div className="space-y-2">
                {pendingRequests.map((r) => (
                  <div key={r.id} className="bg-card/60 border border-border rounded-xl p-4 flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center text-lg">🧑</div>
                    <div className="flex-1">
                      <h4 className="text-sm font-semibold text-foreground">{r.userName}</h4>
                      <div className="flex items-center gap-2 text-xs text-muted-foreground">
                        <span className={typeColors[r.type]}>{typeIcons[r.type]}</span>
                        <span className="capitalize">{r.type}</span>
                        <span>• {r.time}</span>
                      </div>
                    </div>
                    <div className="flex gap-1.5">
                      <Button size="sm" className="gradient-gold text-primary-foreground h-8 w-8 p-0"><CheckCircle className="w-4 h-4" /></Button>
                      <Button size="sm" variant="outline" className="border-destructive text-destructive h-8 w-8 p-0"><XCircle className="w-4 h-4" /></Button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === "requests" && (
          <div className="p-4 space-y-4">
            <h2 className="text-xl font-display text-gold-gradient">Consultation Requests</h2>
            {pendingRequests.map((r) => (
              <div key={r.id} className="bg-card/60 border border-border rounded-xl p-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl">🧑</div>
                  <div className="flex-1">
                    <h4 className="font-semibold text-foreground">{r.userName}</h4>
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                      <span className={typeColors[r.type]}>{typeIcons[r.type]}</span>
                      <span className="capitalize">{r.type} Request</span>
                    </div>
                  </div>
                  <span className="text-xs text-muted-foreground">{r.time}</span>
                </div>
                <div className="flex gap-2 mt-3">
                  <Button size="sm" className="flex-1 gradient-gold text-primary-foreground">Accept</Button>
                  <Button size="sm" variant="outline" className="flex-1 border-destructive text-destructive">Decline</Button>
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === "earnings" && (
          <div className="p-4 space-y-6">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <p className="text-sm text-muted-foreground">Total Earnings</p>
              <p className="text-4xl font-display text-gold-gradient mt-2">₹{user.walletBalance}</p>
              <Button className="mt-4 gradient-gold text-primary-foreground">Withdraw</Button>
            </div>
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Earnings History</h3>
              <div className="space-y-2">
                {[
                  { amount: 200, desc: "Chat - Rahul Kumar (10 min)", date: "Today" },
                  { amount: 450, desc: "Video Call - Priya Singh (15 min)", date: "Yesterday" },
                  { amount: 300, desc: "Voice Call - Amit Patel (20 min)", date: "Mar 28" },
                ].map((t, i) => (
                  <div key={i} className="bg-card/60 border border-border rounded-lg p-3 flex items-center justify-between">
                    <div>
                      <p className="text-sm text-foreground">{t.desc}</p>
                      <p className="text-xs text-muted-foreground">{t.date}</p>
                    </div>
                    <span className="text-sm font-semibold text-green-400">+₹{t.amount}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === "profile" && (
          <div className="p-4 space-y-4">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
              <div className="w-20 h-20 rounded-full bg-secondary mx-auto flex items-center justify-center text-3xl">🔮</div>
              <h3 className="text-lg font-display text-foreground mt-3">{user.name}</h3>
              <p className="text-sm text-primary">Vedic Astrology</p>
              <p className="text-sm text-muted-foreground">{user.email}</p>
              <div className="flex justify-center gap-4 mt-3 text-sm text-muted-foreground">
                <span>⭐ 4.8</span><span>15 yrs exp</span><span>3500+ sessions</span>
              </div>
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

export default AstrologerDashboard;
