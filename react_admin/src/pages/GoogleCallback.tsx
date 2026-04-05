import { useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { saveGoogleOAuthSession } from "@/services/api";
import StarField from "@/components/StarField";

/**
 * Handles the redirect from Google after the user authorises the app.
 * Backend redirects here with query params containing access_token, refresh_token,
 * user_id, name, email, role. We persist them and send the user to their dashboard.
 */
const GoogleCallback = () => {
  const [params] = useSearchParams();
  const navigate = useNavigate();

  useEffect(() => {
    const error = params.get("google_error");
    if (error) {
      navigate(`/auth?error=${encodeURIComponent(error)}`, { replace: true });
      return;
    }

    const user = saveGoogleOAuthSession(params);
    if (!user) {
      navigate("/auth?error=missing_tokens", { replace: true });
      return;
    }

    // Role-based redirect
    const target =
      user.role === "astrologer" ? "/astrologer" :
      user.role === "admin" ? "/admin" :
      "/dashboard";

    // Full reload so AuthProvider re-reads localStorage on mount
    window.location.replace(target);
  }, [params, navigate]);

  return (
    <div className="min-h-screen gradient-mystic flex items-center justify-center p-4 relative">
      <StarField />
      <div className="relative z-10 bg-card/80 backdrop-blur-xl border border-border rounded-xl p-8 text-center glow-gold">
        <div className="text-4xl mb-3 animate-spin inline-block">✨</div>
        <h1 className="text-xl font-display text-gold-gradient">Signing you in...</h1>
        <p className="text-muted-foreground text-sm mt-2">Completing Google login</p>
      </div>
    </div>
  );
};

export default GoogleCallback;
