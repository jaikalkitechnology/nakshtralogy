import { createRoot } from "react-dom/client";
import { GoogleOAuthProvider } from "@react-oauth/google";
import App from "./App.tsx";
import "./index.css";

const GOOGLE_CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID || "";

if (!GOOGLE_CLIENT_ID) {
  console.warn(
    "⚠️ VITE_GOOGLE_CLIENT_ID not set. Google Sign-In will be disabled.\n" +
    "Create a .env file with:\n" +
    "VITE_GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com"
  );
}

// Export so other components can check
export const isGoogleConfigured = GOOGLE_CLIENT_ID.length > 10;

createRoot(document.getElementById("root")!).render(
  <GoogleOAuthProvider clientId={GOOGLE_CLIENT_ID || "not-configured"}>
    <App />
  </GoogleOAuthProvider>
);
