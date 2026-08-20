import { useState, useEffect, useCallback, useMemo } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import {
  BookOpen, Play, Loader2, ChevronRight, AlertCircle, Copy, Check,
  ShieldCheck, CreditCard, Sparkles, FileText, Moon as MoonIcon, Terminal, Package, FileJson, Languages,
} from "lucide-react";
import {
  fetchGatewayCategorySamples, callGatewayEndpoint, GATEWAY_CATEGORIES,
  type GatewayCategorySamples, type GatewayEndpointSample,
} from "@/lib/api";

const CATEGORY_LABELS: Record<string, string> = {
  kundli: "Kundli",
  reports: "Special Reports",
  rashi: "Rashi",
  forecast: "Today Forecast",
};

// Response languages supported by the gateway `?lang=` param. `en` (default)
// returns the response unchanged; every other code localizes the display text
// (labels, grades, dignities, verdicts, rashi metadata) — numbers/scores never
// change. Kept in sync with the backend app/core/report_translator + gateway.
const RESPONSE_LANGUAGES: { code: string; label: string }[] = [
  { code: "en", label: "English (default)" },
  { code: "hi", label: "हिन्दी — Hindi" },
  { code: "bn", label: "বাংলা — Bengali" },
  { code: "gu", label: "ગુજરાતી — Gujarati" },
  { code: "kn", label: "ಕನ್ನಡ — Kannada" },
  { code: "ml", label: "മലയാളം — Malayalam" },
  { code: "mr", label: "मराठी — Marathi" },
  { code: "pa", label: "ਪੰਜਾਬੀ — Punjabi" },
  { code: "ta", label: "தமிழ் — Tamil" },
  { code: "te", label: "తెలుగు — Telugu" },
];

const CATEGORY_DESCRIPTIONS: Record<string, string> = {
  kundli: "Full birth chart + one endpoint per analysis module, plus /kundli/all for everything in one call.",
  reports: "19 report engines: 14 single-chart specialists + 5 combined two-chart reports (incl. Kundli Milan).",
  rashi: "12-sign zodiac metadata, traits, and gochar-based predictions — no birth data needed.",
  forecast: "Today's probability forecast for a birth chart.",
};

// F.4 documentation cards — quick-reference tiles into the live Swagger/
// Redoc docs and the sections already on this page (Auth, Payments/
// Subscription, the 4 gateway categories, SDK samples, and this Playground).
const DOC_CARDS = [
  { icon: ShieldCheck, label: "Authentication", desc: "Bearer sk_live_/sk_test_ keys", href: "https://api.nakshatralogy.com/api/v2/docs" },
  { icon: CreditCard, label: "Payments & Subscription", desc: "Wallet-funded All-Access plan", href: "/subscription" },
  { icon: Sparkles, label: "Kundli", desc: "Birth chart + analysis modules", href: "#kundli" },
  { icon: FileText, label: "Special Reports", desc: "19 report engines", href: "#reports" },
  { icon: MoonIcon, label: "Rashi", desc: "12-sign zodiac metadata", href: "#rashi" },
  { icon: Terminal, label: "Today Forecast", desc: "Daily probability forecast", href: "#forecast" },
  { icon: Package, label: "SDK Samples", desc: "curl · Python · Node · PHP", href: "#playground" },
  { icon: FileJson, label: "Postman / OpenAPI", desc: "Swagger + Redoc reference", href: "https://api.nakshatralogy.com/api/v2/redoc" },
];

export default function DocsPlaygroundPage() {
  const [byCategory, setByCategory] = useState<Record<string, GatewayCategorySamples>>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeCategory, setActiveCategory] = useState<string>("kundli");
  const [activeEndpoint, setActiveEndpoint] = useState<GatewayEndpointSample | null>(null);
  const [bodyText, setBodyText] = useState("");
  const [apiKey, setApiKey] = useState(localStorage.getItem("developer_playground_key") || "");
  const [running, setRunning] = useState(false);
  const [response, setResponse] = useState<{ ok: boolean; data: any } | null>(null);
  const [elapsedMs, setElapsedMs] = useState<number | null>(null);
  const [copiedKey, setCopiedKey] = useState<string | null>(null);
  // Persist the chosen response language (like the API key) so it survives a
  // page reload instead of snapping back to English every time.
  const [lang, setLang] = useState<string>(
    () => localStorage.getItem("developer_playground_lang") || "en",
  );
  useEffect(() => {
    localStorage.setItem("developer_playground_lang", lang);
  }, [lang]);

  // `?lang=` is only appended for a non-default language, so the shown path,
  // samples and live call stay byte-identical to before for English.
  const langQuery = lang !== "en" ? `?lang=${lang}` : "";
  // Inject `?lang=` into a code sample's endpoint URL. The samples embed the
  // full URL as `https://api.nakshatralogy.com<path>"`, so the path is always
  // immediately followed by a closing quote — splice the query in there.
  const withLang = useCallback(
    (code: string) =>
      !langQuery || !activeEndpoint
        ? code
        : code.split(`${activeEndpoint.path}"`).join(`${activeEndpoint.path}${langQuery}"`),
    [langQuery, activeEndpoint],
  );

  const copyText = (key: string, text: string) => {
    navigator.clipboard?.writeText(text);
    setCopiedKey(key);
    setTimeout(() => setCopiedKey((k) => (k === key ? null : k)), 1500);
  };

  useEffect(() => {
    localStorage.setItem("developer_playground_key", apiKey);
  }, [apiKey]);

  const loadAll = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const results = await Promise.all(GATEWAY_CATEGORIES.map((c) => fetchGatewayCategorySamples(c)));
      const next: Record<string, GatewayCategorySamples> = {};
      let anyOk = false;
      results.forEach((r, i) => {
        if (r.ok) { next[GATEWAY_CATEGORIES[i]] = r.data; anyOk = true; }
      });
      if (!anyOk) throw new Error("Could not reach the gateway docs endpoint.");
      setByCategory(next);
      const first = next.kundli?.endpoints?.[0] || Object.values(next)[0]?.endpoints?.[0] || null;
      setActiveEndpoint(first);
      setBodyText(first?.sample_body ? JSON.stringify(first.sample_body, null, 2) : "");
    } catch (e: any) {
      setError(e?.message || "Failed to load endpoint catalog.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadAll(); }, [loadAll]);

  const endpointsForCategory = useMemo(
    () => byCategory[activeCategory]?.endpoints || [],
    [byCategory, activeCategory],
  );

  const selectEndpoint = (ep: GatewayEndpointSample) => {
    setActiveEndpoint(ep);
    setBodyText(ep.sample_body ? JSON.stringify(ep.sample_body, null, 2) : "");
    setResponse(null);
    setElapsedMs(null);
  };

  const run = async () => {
    if (!activeEndpoint) return;
    if (!apiKey.trim()) { alert("Paste your API key (test or live) to try a live call."); return; }
    setRunning(true);
    setResponse(null);
    try {
      let body: Record<string, any> | undefined;
      if (activeEndpoint.method === "POST" && bodyText.trim()) {
        try { body = JSON.parse(bodyText); } catch { alert("Request body is not valid JSON."); setRunning(false); return; }
      }
      const { ok, data, elapsedMs: ms } = await callGatewayEndpoint(activeEndpoint.method, `${activeEndpoint.path}${langQuery}`, apiKey.trim(), body);
      setResponse({ ok, data });
      setElapsedMs(ms);
    } catch (e: any) {
      setResponse({ ok: false, data: { error: e?.message || "Request failed" } });
    } finally {
      setRunning(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="flex items-center gap-2 text-xl font-semibold"><BookOpen className="h-5 w-5 text-primary" /> API Docs &amp; Playground</h1>
        <p className="text-sm text-muted-foreground">
          Full interactive reference lives at <code>/api/v2/docs</code> (Swagger) and <code>/api/v2/redoc</code> —
          this page groups all ~53 endpoints by the 4 gateway categories with a live "try it" against your own key.
        </p>
      </div>

      {error && (
        <Card className="rounded-2xl border-red-500/30 bg-red-500/5">
          <CardContent className="flex items-center justify-between gap-3 py-4 text-sm">
            <span className="flex items-center gap-2 text-red-400"><AlertCircle className="h-4 w-4" /> {error}</span>
            <Button size="sm" variant="outline" onClick={loadAll}>Retry</Button>
          </CardContent>
        </Card>
      )}

      {/* Documentation cards */}
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        {DOC_CARDS.map((d) => {
          const isAnchor = d.href.startsWith("#");
          const CardInner = (
            <>
              <div className="grid h-9 w-9 flex-none place-items-center rounded-xl bg-gold/10 text-gold"><d.icon className="h-[16px] w-[16px]" /></div>
              <div className="min-w-0">
                <b className="block truncate text-[13px] text-foreground">{d.label}</b>
                <span className="truncate text-[11px] text-muted-foreground">{d.desc}</span>
              </div>
            </>
          );
          return isAnchor ? (
            <button
              key={d.label}
              onClick={() => setActiveCategory(d.href.slice(1) === "playground" ? activeCategory : (d.href.slice(1) || activeCategory))}
              className="lift flex items-center gap-2.5 rounded-xl border border-border/70 bg-glass/40 p-3 text-left"
            >
              {CardInner}
            </button>
          ) : (
            <a key={d.label} href={d.href} target={d.href.startsWith("http") ? "_blank" : undefined} rel="noreferrer" className="lift flex items-center gap-2.5 rounded-xl border border-border/70 bg-glass/40 p-3">
              {CardInner}
            </a>
          );
        })}
      </div>

      <Tabs value={activeCategory} onValueChange={(v) => { setActiveCategory(v); setActiveEndpoint(null); setResponse(null); }}>
        <TabsList>
          {GATEWAY_CATEGORIES.map((c) => (
            <TabsTrigger key={c} value={c}>
              {CATEGORY_LABELS[c]}
              {byCategory[c] && <Badge variant="outline" className="ml-2 px-1.5 text-[10px]">{byCategory[c].endpoint_count}</Badge>}
            </TabsTrigger>
          ))}
        </TabsList>

        {GATEWAY_CATEGORIES.map((c) => (
          <TabsContent key={c} value={c} className="space-y-4">
            <p className="text-sm text-muted-foreground">{CATEGORY_DESCRIPTIONS[c]}</p>

            {loading ? (
              <div className="space-y-2">
                {Array.from({ length: 6 }).map((_, i) => (
                  <div key={i} className="h-10 animate-pulse rounded-lg bg-muted" />
                ))}
              </div>
            ) : endpointsForCategory.length === 0 ? (
              <p className="text-sm text-muted-foreground">No endpoints found for this category.</p>
            ) : (
              <div className="grid gap-4 lg:grid-cols-[280px_1fr]">
                <div className="max-h-[520px] space-y-1 overflow-auto rounded-xl border border-border/60 bg-card/40 p-2">
                  {endpointsForCategory.map((ep) => (
                    <button
                      key={ep.path}
                      onClick={() => selectEndpoint(ep)}
                      className={`flex w-full items-center justify-between gap-2 rounded-lg px-2.5 py-2 text-left text-xs transition-colors ${
                        activeEndpoint?.path === ep.path ? "bg-primary/10 text-primary" : "hover:bg-muted/60"
                      }`}
                    >
                      <span className="flex items-center gap-2 truncate">
                        <Badge variant="outline" className={`px-1.5 text-[10px] ${ep.method === "GET" ? "border-sky-500/40 text-sky-400" : "border-emerald-500/40 text-emerald-400"}`}>
                          {ep.method}
                        </Badge>
                        <span className="truncate">{ep.summary}</span>
                      </span>
                      <ChevronRight className="h-3.5 w-3.5 flex-shrink-0 opacity-50" />
                    </button>
                  ))}
                </div>

                {activeEndpoint && (
                  <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
                    <CardHeader className="space-y-1">
                      <CardTitle className="text-base">{activeEndpoint.summary}</CardTitle>
                      <p className="font-mono text-xs text-muted-foreground">
                        {activeEndpoint.method} {activeEndpoint.path}
                        {langQuery && <span className="text-gold">{langQuery}</span>}
                      </p>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      <div className="grid gap-3 md:grid-cols-2">
                        <div className="space-y-1.5">
                          <Label>Your API key (sk_test_... or sk_live_...)</Label>
                          <Input value={apiKey} onChange={(e) => setApiKey(e.target.value)} placeholder="sk_test_..." />
                        </div>
                        <div className="space-y-1.5">
                          <Label className="flex items-center gap-1.5">
                            <Languages className="h-3.5 w-3.5 text-gold" /> Response language
                          </Label>
                          <Select value={lang} onValueChange={setLang}>
                            <SelectTrigger><SelectValue /></SelectTrigger>
                            <SelectContent>
                              {RESPONSE_LANGUAGES.map((l) => (
                                <SelectItem key={l.code} value={l.code}>{l.label}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                      </div>

                      <Button onClick={run} disabled={running} className="w-full">
                        {running ? <Loader2 className="mr-1 h-4 w-4 animate-spin" /> : <Play className="mr-1 h-4 w-4" />}
                        {running ? "Running..." : "Run request"}
                      </Button>

                      {langQuery && (
                        <p className="rounded-lg border border-gold/25 bg-gold/5 px-3 py-2 text-xs text-muted-foreground">
                          <span className="text-foreground">Localized response:</span> the request adds{" "}
                          <code className="text-gold">{langQuery}</code>. Only display text (labels, grades, dignities,
                          verdicts, rashi metadata) is translated — all numbers, scores and dates are unchanged.
                        </p>
                      )}

                      {activeEndpoint.method === "POST" && (
                        <div className="space-y-1.5">
                          <Label>Request body (editable JSON)</Label>
                          <Textarea value={bodyText} onChange={(e) => setBodyText(e.target.value)} rows={7} className="font-mono text-xs" />
                        </div>
                      )}

                      {response && (
                        <div className="space-y-2">
                          <div className="flex items-center justify-between gap-2">
                            <div className="flex items-center gap-2">
                              <Badge variant="outline" className={response.ok ? "border-emerald-500/30 text-emerald-400" : "border-red-500/30 text-red-400"}>
                                {response.ok ? "Success" : "Error"}
                              </Badge>
                              {elapsedMs !== null && <span className="text-xs text-muted-foreground">{elapsedMs}ms</span>}
                            </div>
                            <Button size="sm" variant="ghost" onClick={() => copyText("response", JSON.stringify(response.data, null, 2))}>
                              {copiedKey === "response" ? <Check className="mr-1 h-3.5 w-3.5 text-emerald-400" /> : <Copy className="mr-1 h-3.5 w-3.5" />} Copy
                            </Button>
                          </div>
                          <pre className="max-h-72 overflow-auto rounded-lg bg-muted p-3 text-xs">{JSON.stringify(response.data, null, 2)}</pre>
                        </div>
                      )}

                      <Tabs defaultValue="curl">
                        <TabsList>
                          <TabsTrigger value="curl">curl</TabsTrigger>
                          <TabsTrigger value="python">Python</TabsTrigger>
                          <TabsTrigger value="node">Node</TabsTrigger>
                          <TabsTrigger value="php">PHP</TabsTrigger>
                        </TabsList>
                        {Object.entries(activeEndpoint.samples).map(([sampleLang, code]) => (
                          <TabsContent key={sampleLang} value={sampleLang} className="relative">
                            <Button size="sm" variant="ghost" className="absolute right-1 top-1 z-10" onClick={() => copyText(sampleLang, withLang(code))}>
                              {copiedKey === sampleLang ? <Check className="mr-1 h-3.5 w-3.5 text-emerald-400" /> : <Copy className="mr-1 h-3.5 w-3.5" />} Copy
                            </Button>
                            <pre className="max-h-72 overflow-auto rounded-lg bg-muted p-3 text-xs">{withLang(code)}</pre>
                          </TabsContent>
                        ))}
                      </Tabs>
                    </CardContent>
                  </Card>
                )}
              </div>
            )}
          </TabsContent>
        ))}
      </Tabs>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Reference</CardTitle></CardHeader>
        <CardContent className="space-y-2 text-sm text-muted-foreground">
          <p><strong className="text-foreground">Auth:</strong> <code>Authorization: Bearer sk_live_...</code> or <code>sk_test_...</code></p>
          <p><strong className="text-foreground">Rate limit:</strong> 1 request/second per key — 429 + <code>Retry-After</code> when exceeded.</p>
          <p><strong className="text-foreground">Subscription:</strong> every call requires an active All-Access subscription — 402 otherwise.</p>
          <p><strong className="text-foreground">Response language:</strong> add <code>?lang=</code> to any endpoint to localize the display text — <code>en</code> (default), <code>hi</code>, <code>bn</code>, <code>gu</code>, <code>kn</code>, <code>ml</code>, <code>mr</code>, <code>pa</code>, <code>ta</code>, <code>te</code>. Full-name (<code>hindi</code>) and <code>Accept-Language</code> values (<code>hi-IN</code>) are also accepted; unknown falls back to English. Only labels/grades/verdicts translate — numbers never change.</p>
          <p><strong className="text-foreground">Categories:</strong> <code>kundli</code>, <code>reports</code>, <code>rashi</code>, <code>forecast</code> — back-compat aliases (<code>/kundli</code>, <code>/reports/&#123;key&#125;</code>, <code>/milan</code>, <code>/forecast</code>) still work.</p>
          <p><strong className="text-foreground">Full docs:</strong> Swagger at <code>/api/v2/docs</code>, Redoc at <code>/api/v2/redoc</code>.</p>
        </CardContent>
      </Card>
    </div>
  );
}
