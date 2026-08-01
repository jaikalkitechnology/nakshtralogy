import { useState, type FormEvent } from "react";
import { useNavigate, Link } from "react-router-dom";
import { motion } from "framer-motion";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { Sparkles, AlertTriangle } from "lucide-react";
import { signupDeveloper } from "@/lib/api";

export default function SignupPage() {
  const navigate = useNavigate();
  const [accountType, setAccountType] = useState<"business" | "individual">("business");
  const [form, setForm] = useState({
    name: "", email: "", phone: "", password: "",
    company_name: "", gst_number: "", pan: "", billing_address: "", website: "",
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const set = (field: string) => (e: any) => setForm((f) => ({ ...f, [field]: e.target.value }));

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);
    if (accountType === "business" && (!form.company_name || !form.gst_number)) {
      setError("Company name and GST number are required for business accounts.");
      return;
    }
    setLoading(true);
    const { ok, data } = await signupDeveloper({ ...form, account_type: accountType });
    setLoading(false);
    if (ok) navigate("/dashboard");
    else setError(data?.detail || "Signup failed");
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4 py-10">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.35 }} className="w-full max-w-lg">
        <Card className="rounded-2xl border-border/60 bg-card/70 backdrop-blur">
          <CardHeader className="items-center text-center">
            <Sparkles className="mb-2 h-8 w-8 text-primary" />
            <CardTitle className="text-xl">Create a Developer Account</CardTitle>
            <p className="text-sm text-muted-foreground">Get an API key and one All-Access subscription for all 4 products.</p>
          </CardHeader>
          <CardContent>
            <form onSubmit={submit} className="space-y-4">
              {error && (
                <div className="flex items-center gap-2 rounded-lg border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-400">
                  <AlertTriangle className="h-4 w-4" /> {error}
                </div>
              )}

              <div className="space-y-1.5">
                <Label>Account type</Label>
                <Select value={accountType} onValueChange={(v) => setAccountType(v as "business" | "individual")}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="business">Business</SelectItem>
                    <SelectItem value="individual">Individual</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1.5">
                  <Label htmlFor="name">Full name</Label>
                  <Input id="name" value={form.name} onChange={set("name")} required />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="phone">Phone</Label>
                  <Input id="phone" value={form.phone} onChange={set("phone")} />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1.5">
                  <Label htmlFor="email">Email</Label>
                  <Input id="email" type="email" value={form.email} onChange={set("email")} required />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="password">Password</Label>
                  <Input id="password" type="password" value={form.password} onChange={set("password")} required minLength={6} />
                </div>
              </div>

              {accountType === "business" && (
                <>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="space-y-1.5">
                      <Label htmlFor="company_name">Company name</Label>
                      <Input id="company_name" value={form.company_name} onChange={set("company_name")} required />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="gst_number">GST number</Label>
                      <Input id="gst_number" value={form.gst_number} onChange={set("gst_number")} required />
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="space-y-1.5">
                      <Label htmlFor="pan">PAN (optional)</Label>
                      <Input id="pan" value={form.pan} onChange={set("pan")} />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="website">Website (optional)</Label>
                      <Input id="website" value={form.website} onChange={set("website")} />
                    </div>
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="billing_address">Billing address (optional)</Label>
                    <Textarea id="billing_address" value={form.billing_address} onChange={set("billing_address")} />
                  </div>
                </>
              )}

              <Button type="submit" className="w-full" disabled={loading}>
                {loading ? "Creating account..." : "Create account"}
              </Button>
            </form>
            <p className="mt-4 text-center text-sm text-muted-foreground">
              Already have an account? <Link to="/login" className="text-primary hover:underline">Sign in</Link>
            </p>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
