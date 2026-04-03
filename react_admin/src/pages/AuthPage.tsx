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
  const [role, setRole] = useState<UserRole>("admin");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("admin@nakshatralogy.com");
  const [password, setPassword] = useState("admin@123");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const { login, signup } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    if (isLogin) {
      const err = await login(email, password, role);
      setLoading(false);
      if (err) {
        setError(err);
        return;
      }
      navigate("/admin");
    } else {
      signup(name, email, password, role);
      setLoading(false);
      navigate("/admin");
    }
  };

  const roles: { value: UserRole; label: string; icon: React.ReactNode }[] = [
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
            Nakshtralogy Admin
          </h1>
          <p className="text-muted-foreground mt-2">Platform Management Console</p>
        </div>

        <div className="bg-card/80 backdrop-blur-xl border border-border rounded-xl p-6 glow-gold">
          <h2 className="text-xl font-display text-foreground mb-4">
            {isLogin ? "Admin Sign In" : "Create Account"}
          </h2>

          {error && (
            <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-3 mb-4">
              <p className="text-sm text-destructive">{error}</p>
            </div>
          )}

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
                placeholder="admin@nakshatralogy.com"
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
            <Button type="submit" disabled={loading} className="w-full gradient-gold text-primary-foreground font-semibold">
              {loading ? "Signing in..." : isLogin ? "Sign In" : "Create Account"}
            </Button>
          </form>

          <div className="mt-4 p-3 bg-muted/50 rounded-lg">
            <p className="text-xs text-muted-foreground text-center">
              Default: <code className="text-primary">admin@nakshatralogy.com</code> / <code className="text-primary">admin@123</code>
            </p>
            <p className="text-xs text-muted-foreground text-center mt-1">
              Run <code className="text-primary">POST /api/v1/admin/seed-open</code> first to create admin user
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
};

export default AuthPage;
