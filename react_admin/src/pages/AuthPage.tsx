import { useState } from "react";
import { useAuth, UserRole } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Star, Moon, Sun } from "lucide-react";
import StarField from "@/components/StarField";

const AuthPage = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [role, setRole] = useState<UserRole>("user");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { login, signup } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (isLogin) {
      login(email, password, role);
    } else {
      signup(name, email, password, role);
    }
    if (role === "admin") navigate("/admin");
    else if (role === "astrologer") navigate("/astrologer");
    else navigate("/dashboard");
  };

  const roles: { value: UserRole; label: string; icon: React.ReactNode }[] = [
    { value: "user", label: "User", icon: <Star className="w-4 h-4" /> },
    { value: "astrologer", label: "Astrologer", icon: <Moon className="w-4 h-4" /> },
    { value: "admin", label: "Admin", icon: <Sun className="w-4 h-4" /> },
  ];

  return (
    <div className="min-h-screen gradient-mystic flex items-center justify-center p-4 relative">
      <StarField />
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md relative z-10"
      >
        <div className="text-center mb-8">
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
            className="inline-block text-5xl mb-4"
          >
            ✨
          </motion.div>
          <h1 className="text-3xl font-display text-gold-gradient">
            JyotishConnect
          </h1>
          <p className="text-muted-foreground mt-2">Your Cosmic Journey Awaits</p>
        </div>

        <div className="bg-card/80 backdrop-blur-xl border border-border rounded-xl p-6 glow-gold">
          {/* Role Selection */}
          <div className="flex gap-2 mb-6">
            {roles.map((r) => (
              <button
                key={r.value}
                onClick={() => setRole(r.value)}
                className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-lg text-sm font-medium transition-all ${
                  role === r.value
                    ? "bg-primary text-primary-foreground glow-gold"
                    : "bg-muted text-muted-foreground hover:bg-muted/80"
                }`}
              >
                {r.icon}
                {r.label}
              </button>
            ))}
          </div>

          <h2 className="text-xl font-display text-foreground mb-4">
            {isLogin ? "Sign In" : "Create Account"}
          </h2>

          <form onSubmit={handleSubmit} className="space-y-4">
            {!isLogin && (
              <div>
                <Label className="text-foreground/80">Full Name</Label>
                <Input
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Enter your name"
                  className="bg-muted border-border focus:ring-primary"
                />
              </div>
            )}
            <div>
              <Label className="text-foreground/80">Email</Label>
              <Input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="your@email.com"
                className="bg-muted border-border focus:ring-primary"
              />
            </div>
            <div>
              <Label className="text-foreground/80">Password</Label>
              <Input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="bg-muted border-border focus:ring-primary"
              />
            </div>
            <Button type="submit" className="w-full gradient-gold text-primary-foreground font-semibold">
              {isLogin ? "Sign In" : "Create Account"}
            </Button>
          </form>

          <p className="text-center text-sm text-muted-foreground mt-4">
            {isLogin ? "Don't have an account?" : "Already have an account?"}{" "}
            <button
              onClick={() => setIsLogin(!isLogin)}
              className="text-primary hover:underline font-medium"
            >
              {isLogin ? "Sign Up" : "Sign In"}
            </button>
          </p>
        </div>
      </motion.div>
    </div>
  );
};

export default AuthPage;
