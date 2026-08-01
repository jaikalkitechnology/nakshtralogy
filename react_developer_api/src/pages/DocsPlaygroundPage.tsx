import { useState, useEffect, useCallback } from "react";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { BookOpen, Play, Loader2 } from "lucide-react";
import { callGateway, fetchGatewayCodeSamples } from "@/lib/api";

const PRODUCTS = [
  { value: "kundli", label: "Kundli" },
  { value: "career", label: "Special Report — Career" },
  { value: "milan", label: "Kundli Milan" },
  { value: "forecast", label: "Today Forecast" },
];

const DEFAULT_PERSON = { name: "Rahul Kumar", gender: "M", dob: "15/08/1992", tob: "06:30", place: "Delhi, India" };
const DEFAULT_PERSON_2 = { name: "Priya Singh", gender: "F", dob: "22/03/1995", tob: "14:15", place: "Mumbai, India" };

export default function DocsPlaygroundPage() {
  const [product, setProduct] = useState("kundli");
  const [apiKey, setApiKey] = useState(localStorage.getItem("developer_playground_key") || "");
  const [running, setRunning] = useState(false);
  const [response, setResponse] = useState<any>(null);
  const [elapsedMs, setElapsedMs] = useState<number | null>(null);
  const [samples, setSamples] = useState<any>(null);
  const [samplesLoading, setSamplesLoading] = useState(true);

  useEffect(() => {
    localStorage.setItem("developer_playground_key", apiKey);
  }, [apiKey]);

  const loadSamples = useCallback(async () => {
    setSamplesLoading(true);
    const isReport = !["kundli", "milan", "forecast"].includes(product);
    const { ok, data } = await fetchGatewayCodeSamples(isReport ? "specialist" : product);
    if (ok) setSamples(data);
    setSamplesLoading(false);
  }, [product]);

  useEffect(() => { loadSamples(); }, [loadSamples]);

  const run = async () => {
    if (!apiKey.trim()) { alert("Paste your API key (test or live) to try a live call."); return; }
    setRunning(true);
    setResponse(null);
    try {
      const body = product === "milan" ? { person1: DEFAULT_PERSON_2, person2: DEFAULT_PERSON } : DEFAULT_PERSON;
      const { ok, data, elapsedMs: ms } = await callGateway(product, apiKey.trim(), body);
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
          Full reference lives at <code>/api/v2/docs</code> (Swagger) and <code>/api/v2/redoc</code> — this page
          is a quickstart + live "try it" against your own key.
        </p>
      </div>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Try it live</CardTitle></CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-3 md:grid-cols-2">
            <div className="space-y-1.5">
              <Label>Product</Label>
              <Select value={product} onValueChange={setProduct}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  {PRODUCTS.map((p) => <SelectItem key={p.value} value={p.value}>{p.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1.5">
              <Label>Your API key (sk_test_... or sk_live_...)</Label>
              <Input value={apiKey} onChange={(e) => setApiKey(e.target.value)} placeholder="sk_test_..." />
            </div>
          </div>
          <div className="rounded-lg bg-muted p-3 text-xs text-muted-foreground">
            Sample request body: <code>{JSON.stringify(product === "milan" ? { person1: DEFAULT_PERSON_2, person2: DEFAULT_PERSON } : DEFAULT_PERSON)}</code>
          </div>
          <Button onClick={run} disabled={running}>
            {running ? <Loader2 className="mr-1 h-4 w-4 animate-spin" /> : <Play className="mr-1 h-4 w-4" />}
            {running ? "Running..." : "Run request"}
          </Button>

          {response && (
            <div className="space-y-2">
              <div className="flex items-center gap-2">
                <Badge variant="outline" className={response.ok ? "border-emerald-500/30 text-emerald-400" : "border-red-500/30 text-red-400"}>
                  {response.ok ? "Success" : "Error"}
                </Badge>
                {elapsedMs !== null && <span className="text-xs text-muted-foreground">{elapsedMs}ms</span>}
              </div>
              <pre className="max-h-80 overflow-auto rounded-lg bg-muted p-3 text-xs">{JSON.stringify(response.data, null, 2)}</pre>
            </div>
          )}
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Code samples</CardTitle></CardHeader>
        <CardContent>
          {samplesLoading ? (
            <p className="text-sm text-muted-foreground">Loading samples...</p>
          ) : samples ? (
            <Tabs defaultValue="curl">
              <TabsList>
                <TabsTrigger value="curl">curl</TabsTrigger>
                <TabsTrigger value="python">Python</TabsTrigger>
                <TabsTrigger value="node">Node</TabsTrigger>
                <TabsTrigger value="php">PHP</TabsTrigger>
              </TabsList>
              {Object.entries(samples.samples || {}).map(([lang, code]) => (
                <TabsContent key={lang} value={lang}>
                  <pre className="max-h-80 overflow-auto rounded-lg bg-muted p-3 text-xs">{code as string}</pre>
                </TabsContent>
              ))}
            </Tabs>
          ) : (
            <p className="text-sm text-muted-foreground">Samples unavailable right now.</p>
          )}
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 bg-card/60 backdrop-blur">
        <CardHeader><CardTitle className="text-base">Reference</CardTitle></CardHeader>
        <CardContent className="space-y-2 text-sm text-muted-foreground">
          <p><strong className="text-foreground">Auth:</strong> <code>Authorization: Bearer sk_live_...</code> or <code>sk_test_...</code></p>
          <p><strong className="text-foreground">Rate limit:</strong> 1 request/second per key — 429 + <code>Retry-After</code> when exceeded.</p>
          <p><strong className="text-foreground">Subscription:</strong> every call requires an active All-Access subscription — 402 otherwise.</p>
          <p><strong className="text-foreground">Full docs:</strong> Swagger at <code>/api/v2/docs</code>, Redoc at <code>/api/v2/redoc</code>.</p>
        </CardContent>
      </Card>
    </div>
  );
}
