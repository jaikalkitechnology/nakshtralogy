import { useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Shield } from "lucide-react";
import StarField from "@/components/StarField";

const AuthPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    const { error: err, redirectTo } = await login(email, password);
    setLoading(false);
    if (err) { setError(err); return; }
    navigate(redirectTo);
  };

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
            Nakshtralogy
          </h1>
          <p className="text-muted-foreground mt-2">Admin Console</p>
        </div>

        <div className="bg-card/80 backdrop-blur-xl border border-border rounded-xl p-6 glow-gold">
          <div className="flex items-center gap-2 mb-6">
            <div className="flex items-center justify-center w-10 h-10 rounded-lg bg-primary/15 text-yellow-400">
              <Shield className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-xl font-display text-foreground leading-tight">Admin Sign In</h2>
              <p className="text-xs text-muted-foreground">Authorized administrators only</p>
            </div>
          </div>

          {error && (
            <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-3 mb-4">
              <p className="text-sm text-destructive">{error}</p>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label className="text-foreground/80">Email</Label>
              <Input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@nakshatralogy.com"
                className="bg-muted border-border focus:ring-primary"
                required
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
                required
                minLength={6}
              />
            </div>
            <Button type="submit" disabled={loading} className="w-full gradient-gold text-primary-foreground font-semibold">
              {loading ? "Please wait..." : "Sign In"}
            </Button>
          </form>
        </div>
      </motion.div>
    </div>
  );
};

export default AuthPage;
