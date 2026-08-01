import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { Toaster } from "sonner";

const queryClient = new QueryClient();

/**
 * Placeholder shell for the Nakshtralogy Developer API portal.
 *
 * The developerApiPlatform agent (Phase 6) replaces this with the real routes:
 *   /auth (signup: business+GST or individual / login)
 *   /dashboard (overview)  /keys  /subscription  /wallet  /usage  /docs
 */
const Placeholder = () => (
  <div className="min-h-screen flex flex-col items-center justify-center gap-3 p-6 text-center">
    <div className="text-5xl">✨</div>
    <h1 className="text-2xl font-bold text-primary">Nakshtralogy Developer API</h1>
    <p className="text-muted-foreground max-w-md text-sm">
      Portal scaffold. Sign up, manage API keys, subscribe to the monthly
      All-Access plan, fund your wallet, track usage, and read the API docs.
    </p>
  </div>
);

const App = () => (
  <QueryClientProvider client={queryClient}>
    <Toaster position="top-right" richColors />
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Placeholder />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  </QueryClientProvider>
);

export default App;
