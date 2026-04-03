import { useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import StarField from "@/components/StarField";
import { mockAstrologers, kundliServices, zodiacSigns } from "@/data/mockData";
import {
  Star, MessageCircle, Phone, Video, Wallet, LogOut, Search,
  User, Home, BookOpen, Clock, Settings, Send, Smile
} from "lucide-react";
import { chatEmojis } from "@/data/mockData";

type Tab = "home" | "astrologers" | "services" | "chat" | "wallet" | "profile";

const UserDashboard = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<Tab>("home");
  const [searchQuery, setSearchQuery] = useState("");
  const [chatMessages, setChatMessages] = useState<{ text: string; fromUser: boolean; time: string }[]>([
    { text: "Namaste 🙏 How can I help you today?", fromUser: false, time: "10:00 AM" },
  ]);
  const [chatInput, setChatInput] = useState("");
  const [showEmoji, setShowEmoji] = useState(false);
  const [selectedAstrologer, setSelectedAstrologer] = useState(mockAstrologers[0]);

  if (!user) { navigate("/auth"); return null; }

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

  const filteredAstrologers = mockAstrologers.filter(
    (a) => a.name.toLowerCase().includes(searchQuery.toLowerCase()) || a.speciality.toLowerCase().includes(searchQuery.toLowerCase())
  );

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
              <div className="flex gap-3 overflow-x-auto pb-2">
                {zodiacSigns.map((z) => (
                  <div key={z.name} className="min-w-[70px] bg-card/60 border border-border rounded-xl p-3 text-center flex-shrink-0 hover:glow-gold transition-all cursor-pointer">
                    <span className="text-2xl">{z.symbol}</span>
                    <p className="text-xs text-foreground mt-1">{z.name}</p>
                  </div>
                ))}
              </div>
            </div>

            {/* Quick Services */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Quick Services</h3>
              <div className="grid grid-cols-2 gap-3">
                {kundliServices.slice(0, 4).map((s) => (
                  <div key={s.id} className="bg-card/60 border border-border rounded-xl p-4 hover:glow-gold transition-all cursor-pointer">
                    <span className="text-2xl">{s.icon}</span>
                    <h4 className="text-sm font-semibold text-foreground mt-2">{s.name}</h4>
                    <p className="text-xs text-primary mt-1">{s.price === 0 ? "Free" : `₹${s.price}`}</p>
                  </div>
                ))}
              </div>
            </div>

            {/* Online Astrologers */}
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Online Astrologers</h3>
              <div className="space-y-3">
                {mockAstrologers.filter((a) => a.status === "online").slice(0, 3).map((a) => (
                  <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4 flex items-center gap-4">
                    <div className="relative">
                      <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center text-xl">{a.avatar}</div>
                      <div className="absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full bg-green-500 border-2 border-card" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <h4 className="text-sm font-semibold text-foreground truncate">{a.name}</h4>
                      <p className="text-xs text-muted-foreground">{a.speciality} • ₹{a.pricePerMin}/min</p>
                    </div>
                    <div className="flex gap-1.5">
                      <Button size="sm" className="gradient-gold text-primary-foreground h-8 w-8 p-0" onClick={() => { setSelectedAstrologer(a); setActiveTab("chat"); }}>
                        <MessageCircle className="w-3.5 h-3.5" />
                      </Button>
                      <Button size="sm" variant="outline" className="border-primary text-primary h-8 w-8 p-0">
                        <Phone className="w-3.5 h-3.5" />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {activeTab === "astrologers" && (
          <div className="p-4 space-y-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder="Search astrologers..." className="pl-10 bg-muted border-border" />
            </div>
            <div className="space-y-3">
              {filteredAstrologers.map((a) => (
                <div key={a.id} className="bg-card/60 border border-border rounded-xl p-4">
                  <div className="flex items-center gap-4">
                    <div className="relative">
                      <div className="w-14 h-14 rounded-full bg-secondary flex items-center justify-center text-2xl">{a.avatar}</div>
                      <div className={`absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full border-2 border-card ${a.status === "online" ? "bg-green-500" : a.status === "busy" ? "bg-yellow-500" : "bg-muted-foreground"}`} />
                    </div>
                    <div className="flex-1">
                      <h4 className="font-semibold text-foreground">{a.name}</h4>
                      <p className="text-sm text-primary">{a.speciality}</p>
                      <div className="flex items-center gap-3 mt-1 text-xs text-muted-foreground">
                        <span className="flex items-center gap-0.5"><Star className="w-3 h-3 text-primary fill-primary" /> {a.rating}</span>
                        <span>{a.experience} yrs</span>
                        <span>{a.languages.join(", ")}</span>
                      </div>
                    </div>
                  </div>
                  <div className="flex gap-2 mt-3">
                    <Button size="sm" className="flex-1 gradient-gold text-primary-foreground text-xs" onClick={() => { setSelectedAstrologer(a); setActiveTab("chat"); }}>
                      <MessageCircle className="w-3 h-3 mr-1" /> Chat ₹{a.pricePerMin}/min
                    </Button>
                    <Button size="sm" variant="outline" className="flex-1 border-primary text-primary text-xs">
                      <Phone className="w-3 h-3 mr-1" /> Call
                    </Button>
                    <Button size="sm" variant="outline" className="flex-1 border-cosmic text-cosmic-light text-xs">
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
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {kundliServices.map((s) => (
                <div key={s.id} className="bg-card/60 border border-border rounded-xl p-5 hover:glow-gold transition-all cursor-pointer">
                  <div className="flex items-start gap-4">
                    <span className="text-3xl">{s.icon}</span>
                    <div>
                      <h3 className="font-semibold text-foreground">{s.name}</h3>
                      <p className="text-sm text-muted-foreground mt-1">{s.description}</p>
                      <Badge className="mt-2 gradient-gold text-primary-foreground">{s.price === 0 ? "Free" : `₹${s.price}`}</Badge>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {activeTab === "chat" && (
          <div className="flex flex-col h-[calc(100vh-8rem)]">
            {/* Chat Header */}
            <div className="p-3 border-b border-border bg-card/50 flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center text-lg">{selectedAstrologer.avatar}</div>
              <div>
                <h4 className="text-sm font-semibold text-foreground">{selectedAstrologer.name}</h4>
                <p className="text-xs text-primary">₹{selectedAstrologer.pricePerMin}/min • Online</p>
              </div>
              <div className="ml-auto flex gap-2">
                <Button size="sm" variant="outline" className="border-primary text-primary h-8 w-8 p-0"><Phone className="w-4 h-4" /></Button>
                <Button size="sm" variant="outline" className="border-cosmic text-cosmic-light h-8 w-8 p-0"><Video className="w-4 h-4" /></Button>
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
          <div className="p-4 space-y-6">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center glow-gold">
              <p className="text-sm text-muted-foreground">Wallet Balance</p>
              <p className="text-4xl font-display text-gold-gradient mt-2">₹{user.walletBalance}</p>
              <Button className="mt-4 gradient-gold text-primary-foreground">Add Money</Button>
            </div>
            <div>
              <h3 className="text-sm font-semibold text-primary mb-3">Recent Transactions</h3>
              <div className="space-y-2">
                {[
                  { type: "debit", amount: 100, desc: "Chat with Pandit Rajesh - 5 min", date: "Today" },
                  { type: "credit", amount: 500, desc: "Wallet Recharge", date: "Yesterday" },
                  { type: "debit", amount: 299, desc: "Birth Chart (Janam Kundli)", date: "Mar 28" },
                ].map((t, i) => (
                  <div key={i} className="bg-card/60 border border-border rounded-lg p-3 flex items-center justify-between">
                    <div>
                      <p className="text-sm text-foreground">{t.desc}</p>
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

        {activeTab === "profile" && (
          <div className="p-4 space-y-4">
            <div className="bg-card/60 border border-border rounded-xl p-6 text-center">
              <div className="w-20 h-20 rounded-full bg-secondary mx-auto flex items-center justify-center text-3xl">🧑</div>
              <h3 className="text-lg font-display text-foreground mt-3">{user.name}</h3>
              <p className="text-sm text-muted-foreground">{user.email}</p>
            </div>
            <div className="space-y-2">
              {["My Orders", "Consultation History", "Saved Astrologers", "Settings", "Help & Support"].map((item) => (
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
