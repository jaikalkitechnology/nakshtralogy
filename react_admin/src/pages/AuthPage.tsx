import { useState } from "react";
import { useAuth, UserRole } from "@/contexts/AuthContext";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { GoogleLogin, CredentialResponse } from "@react-oauth/google";
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
  const [phone, setPhone] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const { login, googleLogin, signupAsUser, signupAsAstrologer } = useAuth();
  const navigate = useNavigate();

  const handleGoogleSuccess = async (credentialResponse: CredentialResponse) => {
    setError("");
    if (!credentialResponse.credential) {
      setError("Google sign-in failed: no credential returned");
      return;
    }
    setLoading(true);
    const { error: err, redirectTo } = await googleLogin(credentialResponse.credential, role);
    setLoading(false);
    if (err) { setError(err); return; }
    navigate(redirectTo);
  };

  const handleGoogleError = () => {
    setError("Google sign-in was cancelled or failed");
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    if (isLogin) {
      const { error: err, redirectTo } = await login(email, password, role);
      setLoading(false);
      if (err) { setError(err); return; }
      navigate(redirectTo);
    } else {
      let result;
      if (role === "astrologer") {
        result = await signupAsAstrologer({
          name, email, password,
          ...(phone ? { phone } : {}),
          display_name: name,
        });
      } else {
        result = await signupAsUser(name, email, password, phone || undefined);
      }
      setLoading(false);
      if (result.error) { setError(result.error); return; }
      navigate(result.redirectTo);
    }
  };

  const roles: { value: UserRole; label: string; icon: React.ReactNode; color: string }[] = [
    { value: "user", label: "User", icon: <Star className="w-4 h-4" />, color: "text-primary" },
    { value: "astrologer", label: "Astrologer", icon: <Moon className="w-4 h-4" />, color: "text-cosmic-light" },
    { value: "admin", label: "Admin", icon: <Sun className="w-4 h-4" />, color: "text-yellow-400" },
  ];

  const demoCredentials: Record<string, { email: string; password: string }> = {
    user: { email: "rahul@example.com", password: "user@123" },
    astrologer: { email: "rajesh.sharma@example.com", password: "astro@123" },
    admin: { email: "admin@nakshatralogy.com", password: "admin@123" },
  };

  const fillDemo = () => {
    const creds = demoCredentials[role];
    setEmail(creds.email);
    setPassword(creds.password);
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
          <p className="text-muted-foreground mt-2">Your Cosmic Journey Awaits</p>
        </div>

        <div className="bg-card/80 backdrop-blur-xl border border-border rounded-xl p-6 glow-gold">
          {/* Role Selection */}
          <div className="flex gap-2 mb-6">
            {roles.map((r) => (
              <button
                key={r.value}
                onClick={() => { setRole(r.value); setError(""); }}
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
            <span className="text-sm font-normal text-muted-foreground ml-2">
              as {role === "admin" ? "Admin" : role === "astrologer" ? "Astrologer" : "User"}
            </span>
          </h2>

          {error && (
            <div className="bg-destructive/10 border border-destructive/30 rounded-lg p-3 mb-4">
              <p className="text-sm text-destructive">{error}</p>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            {!isLogin && (
              <>
                <div>
                  <Label className="text-foreground/80">Full Name</Label>
                  <Input
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Enter your name"
                    className="bg-muted border-border focus:ring-primary"
                    required
                  />
                </div>
                {role !== "admin" && (
                  <div>
                    <Label className="text-foreground/80">Phone (optional)</Label>
                    <Input
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      placeholder="+91 98765 43210"
                      className="bg-muted border-border focus:ring-primary"
                    />
                  </div>
                )}
              </>
            )}
            <div>
              <Label className="text-foreground/80">Email</Label>
              <Input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="your@email.com"
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
              {loading ? "Please wait..." : isLogin ? "Sign In" : "Create Account"}
            </Button>
          </form>

          {/* Google Login (not available for admin) */}
          {role !== "admin" && (
            <>
              <div className="flex items-center gap-2 my-4">
                <div className="flex-1 h-px bg-border" />
                <span className="text-xs text-muted-foreground">OR</span>
                <div className="flex-1 h-px bg-border" />
              </div>
              <div className="flex justify-center">
                <GoogleLogin
                  onSuccess={handleGoogleSuccess}
                  onError={handleGoogleError}
                  theme="filled_black"
                  text={isLogin ? "signin_with" : "signup_with"}
                  shape="rectangular"
                  width="320"
                />
              </div>
            </>
          )}

          <div className="flex items-center justify-between mt-4">
            <p className="text-sm text-muted-foreground">
              {isLogin ? "Don't have an account?" : "Already have an account?"}{" "}
              <button
                onClick={() => { setIsLogin(!isLogin); setError(""); }}
                className="text-primary hover:underline font-medium"
              >
                {isLogin ? "Sign Up" : "Sign In"}
              </button>
            </p>
          </div>

          {/* Demo credentials helper */}
          {isLogin && (
            <div className="mt-4 p-3 bg-muted/50 rounded-lg">
              <div className="flex items-center justify-between">
                <p className="text-xs text-muted-foreground">
                  Demo: <code className="text-primary">{demoCredentials[role].email}</code>
                </p>
                <button
                  onClick={fillDemo}
                  className="text-xs text-primary hover:underline font-medium"
                >
                  Fill
                </button>
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                Seed first: <code className="text-primary">POST /api/v1/admin/seed-open</code>
              </p>
            </div>
          )}
        </div>
      </motion.div>
    </div>
  );
};

export default AuthPage;
