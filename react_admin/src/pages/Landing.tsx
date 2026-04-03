import { motion } from "framer-motion";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Star, Phone, MessageCircle, Video, Sparkles } from "lucide-react";
import StarField from "@/components/StarField";
import { zodiacSigns, mockAstrologers, kundliServices } from "@/data/mockData";
import heroImg from "@/assets/hero-astrology.jpg";

const Landing = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen gradient-mystic relative overflow-hidden">
      <StarField />

      {/* Navbar */}
      <nav className="relative z-10 flex items-center justify-between p-4 md:px-8 lg:px-16">
        <div className="flex items-center gap-2">
          <span className="text-2xl">✨</span>
          <span className="text-xl font-display text-gold-gradient">JyotishConnect</span>
        </div>
        <div className="flex gap-3">
          <Button variant="ghost" className="text-foreground hover:text-primary" onClick={() => navigate("/auth")}>
            Login
          </Button>
          <Button className="gradient-gold text-primary-foreground" onClick={() => navigate("/auth")}>
            Get Started
          </Button>
        </div>
      </nav>

      {/* Hero */}
      <section className="relative z-10 px-4 md:px-8 lg:px-16 py-12 md:py-20">
        <div className="max-w-7xl mx-auto grid md:grid-cols-2 gap-12 items-center">
          <motion.div initial={{ opacity: 0, x: -30 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.8 }}>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-display leading-tight">
              <span className="text-gold-gradient">Unlock Your</span>
              <br />
              <span className="text-foreground">Cosmic Destiny</span>
            </h1>
            <p className="text-muted-foreground mt-4 text-lg max-w-lg">
              Connect with India's top astrologers for personalized Kundli readings, horoscope analysis, and life guidance through chat, voice & video calls.
            </p>
            <div className="flex flex-wrap gap-4 mt-8">
              <Button size="lg" className="gradient-gold text-primary-foreground glow-gold" onClick={() => navigate("/auth")}>
                <Sparkles className="w-5 h-5 mr-2" /> Consult Now
              </Button>
              <Button size="lg" variant="outline" className="border-primary text-primary hover:bg-primary/10" onClick={() => navigate("/auth")}>
                Free Kundli
              </Button>
            </div>
            <div className="flex gap-8 mt-10">
              {[
                { icon: <MessageCircle className="w-5 h-5" />, label: "Chat" },
                { icon: <Phone className="w-5 h-5" />, label: "Voice Call" },
                { icon: <Video className="w-5 h-5" />, label: "Video Call" },
              ].map((item) => (
                <div key={item.label} className="flex items-center gap-2 text-muted-foreground">
                  <div className="p-2 rounded-lg bg-secondary text-primary">{item.icon}</div>
                  <span className="text-sm">{item.label}</span>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 0.8, delay: 0.2 }}>
            <div className="relative">
              <div className="absolute inset-0 rounded-2xl glow-cosmic opacity-50" />
              <img src={heroImg} alt="Cosmic Zodiac Wheel" width={1920} height={1080} className="rounded-2xl border border-border relative" />
            </div>
          </motion.div>
        </div>
      </section>

      {/* Zodiac Strip */}
      <section className="relative z-10 py-8 overflow-hidden">
        <div className="flex gap-6 animate-marquee whitespace-nowrap">
          {[...zodiacSigns, ...zodiacSigns].map((z, i) => (
            <div key={i} className="flex items-center gap-2 text-muted-foreground">
              <span className="text-2xl">{z.symbol}</span>
              <span className="text-sm font-medium">{z.name}</span>
            </div>
          ))}
        </div>
      </section>

      {/* Services */}
      <section className="relative z-10 px-4 md:px-8 lg:px-16 py-16">
        <h2 className="text-3xl font-display text-center text-gold-gradient mb-12">Our Services</h2>
        <div className="max-w-6xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-4">
          {kundliServices.slice(0, 8).map((s, i) => (
            <motion.div
              key={s.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="bg-card/60 backdrop-blur border border-border rounded-xl p-4 text-center hover:glow-gold transition-all cursor-pointer"
            >
              <span className="text-3xl">{s.icon}</span>
              <h3 className="text-sm font-semibold text-foreground mt-2">{s.name}</h3>
              <p className="text-xs text-muted-foreground mt-1">{s.price === 0 ? "Free" : `₹${s.price}`}</p>
            </motion.div>
          ))}
        </div>
      </section>

      {/* Featured Astrologers */}
      <section className="relative z-10 px-4 md:px-8 lg:px-16 py-16">
        <h2 className="text-3xl font-display text-center text-gold-gradient mb-12">Top Astrologers</h2>
        <div className="max-w-6xl mx-auto grid md:grid-cols-3 gap-6">
          {mockAstrologers.slice(0, 3).map((a, i) => (
            <motion.div
              key={a.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.15 }}
              className="bg-card/60 backdrop-blur border border-border rounded-xl p-6 hover:glow-gold transition-all"
            >
              <div className="flex items-center gap-4">
                <div className="w-14 h-14 rounded-full bg-secondary flex items-center justify-center text-2xl">
                  {a.avatar}
                </div>
                <div>
                  <h3 className="font-semibold text-foreground">{a.name}</h3>
                  <p className="text-sm text-primary">{a.speciality}</p>
                </div>
              </div>
              <div className="flex items-center gap-4 mt-4 text-sm text-muted-foreground">
                <span className="flex items-center gap-1"><Star className="w-3 h-3 text-primary fill-primary" /> {a.rating}</span>
                <span>{a.experience} yrs</span>
                <span className="text-primary font-semibold">₹{a.pricePerMin}/min</span>
              </div>
              <div className="flex gap-2 mt-4">
                <Button size="sm" className="flex-1 gradient-gold text-primary-foreground text-xs">
                  <MessageCircle className="w-3 h-3 mr-1" /> Chat
                </Button>
                <Button size="sm" variant="outline" className="flex-1 border-primary text-primary text-xs">
                  <Phone className="w-3 h-3 mr-1" /> Call
                </Button>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* Footer */}
      <footer className="relative z-10 border-t border-border py-8 px-4 text-center text-sm text-muted-foreground">
        <p>© 2026 JyotishConnect. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default Landing;
