import { useState, useEffect, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { RefreshCw, X, Search, CreditCard, Webhook } from "lucide-react";
import {
  adminPaymentTransactions,
  adminPaymentWebhooks,
  adminPaymentWebhookDetail,
  adminPaymentSummary,
} from "@/services/api";

type Tab = "transactions" | "webhooks";

/**
 * Payments — Razorpay/PayU/PayPal transactions and the webhook audit log.
 *   · Transactions: every wallet-recharge order (GET /payments/admin/transactions)
 *   · Webhook Logs: every gateway callback we received, verified + processed
 *     (GET /payments/admin/webhooks; click a row for the raw payload)
 * Read-only. All records are updated server-side by the signed webhook.
 */
export default function Payments() {
  const [tab, setTab] = useState<Tab>("transactions");
  const [rows, setRows] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [summary, setSummary] = useState<any>(null);
  const [detail, setDetail] = useState<any>(null);

  const [gateway, setGateway] = useState("");
  const [status, setStatus] = useState("");
  const [q, setQ] = useState("");
  const [page, setPage] = useState(0);
  const LIMIT = 50;

  const load = useCallback(async () => {
    setLoading(true);
    setErr(null);
    try {
      const params: Record<string, any> = { limit: LIMIT, offset: page * LIMIT, gateway, status };
      const r =
        tab === "transactions"
          ? await adminPaymentTransactions({ ...params, q })
          : await adminPaymentWebhooks(params);
      if (r.ok) {
        setRows(r.data.items || []);
        setTotal(r.data.total || 0);
      } else {
        setErr("Failed to load");
      }
    } catch {
      setErr("Network error");
    } finally {
      setLoading(false);
    }
  }, [tab, page, gateway, status, q]);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(() => {
    adminPaymentSummary().then((r) => r.ok && setSummary(r.data));
  }, []);

  const switchTab = (t: Tab) => {
    setTab(t);
    setPage(0);
    setRows([]);
    setStatus("");
    setGateway("");
    setQ("");
  };

  const openDetail = async (id: string) => {
    const r = await adminPaymentWebhookDetail(id);
    if (r.ok) setDetail(r.data);
  };

  const money = (v: any, cur?: string) =>
    v == null ? "—" : `${cur === "USD" ? "$" : "₹"}${Number(v).toLocaleString()}`;

  const statusColor = (s: string) =>
    ["paid", "credited", "processed"].includes(s)
      ? "bg-emerald-500/15 text-emerald-400 border-emerald-500/30"
      : ["failed", "error", "invalid_signature"].includes(s)
      ? "bg-red-500/15 text-red-400 border-red-500/30"
      : ["duplicate", "ignored"].includes(s)
      ? "bg-slate-500/15 text-slate-300 border-slate-500/30"
      : "bg-amber-500/15 text-amber-400 border-amber-500/30";

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-white">Payments</h1>
          <p className="text-sm text-slate-400">
            Razorpay transactions and the signed webhook audit log
          </p>
        </div>
        <Button variant="outline" onClick={load} disabled={loading}>
          <RefreshCw className={`w-4 h-4 mr-2 ${loading ? "animate-spin" : ""}`} />
          Refresh
        </Button>
      </div>

      {/* Summary cards */}
      {summary && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          <Stat label="Paid total" value={`₹${Number(summary.paid_total_inr || 0).toLocaleString()}`} />
          <Stat label="Paid orders" value={summary.orders_by_status?.paid ?? 0} />
          <Stat label="Webhooks received" value={summary.webhooks_total ?? 0} />
          <Stat
            label="Invalid signatures"
            value={summary.webhooks_invalid_signature ?? 0}
            danger={(summary.webhooks_invalid_signature ?? 0) > 0}
          />
        </div>
      )}

      {/* Tabs */}
      <div className="flex gap-2 border-b border-slate-700">
        <TabBtn active={tab === "transactions"} onClick={() => switchTab("transactions")} icon={<CreditCard className="w-4 h-4" />}>
          Transactions
        </TabBtn>
        <TabBtn active={tab === "webhooks"} onClick={() => switchTab("webhooks")} icon={<Webhook className="w-4 h-4" />}>
          Webhook Logs
        </TabBtn>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-2 items-center">
        <select
          value={gateway}
          onChange={(e) => { setPage(0); setGateway(e.target.value); }}
          className="bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-sm text-slate-200"
        >
          <option value="">All gateways</option>
          <option value="razorpay">Razorpay</option>
          <option value="payu">PayU</option>
          <option value="paypal">PayPal</option>
        </select>
        <select
          value={status}
          onChange={(e) => { setPage(0); setStatus(e.target.value); }}
          className="bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-sm text-slate-200"
        >
          <option value="">All statuses</option>
          {tab === "transactions" ? (
            <>
              <option value="created">Created</option>
              <option value="paid">Paid</option>
              <option value="failed">Failed</option>
            </>
          ) : (
            <>
              <option value="credited">Credited</option>
              <option value="processed">Processed</option>
              <option value="ignored">Ignored</option>
              <option value="duplicate">Duplicate</option>
              <option value="invalid_signature">Invalid signature</option>
              <option value="error">Error</option>
            </>
          )}
        </select>
        {tab === "transactions" && (
          <div className="flex w-full items-center gap-1 rounded-lg border border-slate-700 bg-slate-800 px-2 sm:w-56">
            <Search className="w-4 h-4 text-slate-500 flex-none" />
            <input
              value={q}
              onChange={(e) => setQ(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && (setPage(0), load())}
              placeholder="Order / payment id / user…"
              className="w-full bg-transparent py-2 text-sm text-slate-200 outline-none"
            />
          </div>
        )}
      </div>

      {err && <div className="text-red-400 text-sm">{err}</div>}

      {/* Table */}
      <div className="overflow-x-auto rounded-xl border border-slate-800">
        <table className="w-full text-sm">
          <thead className="bg-slate-900 text-slate-400">
            {tab === "transactions" ? (
              <tr>
                {["User", "Gateway", "Amount", "Status", "Payment id", "Order id", "Date"].map((h) => (
                  <th key={h} className="text-left font-medium px-3 py-2.5 whitespace-nowrap">{h}</th>
                ))}
              </tr>
            ) : (
              <tr>
                {["Event", "Gateway", "Status", "Sig", "Amount", "Order ref", "Payment id", "Date"].map((h) => (
                  <th key={h} className="text-left font-medium px-3 py-2.5 whitespace-nowrap">{h}</th>
                ))}
              </tr>
            )}
          </thead>
          <tbody className="divide-y divide-slate-800">
            {rows.length === 0 && !loading && (
              <tr><td colSpan={8} className="text-center text-slate-500 py-8">No records</td></tr>
            )}
            {tab === "transactions"
              ? rows.map((o) => (
                  <tr key={o.id} className="hover:bg-slate-800/40">
                    <td className="px-3 py-2.5">
                      <div className="text-slate-200">{o.user_name || "—"}</div>
                      <div className="text-slate-500 text-xs">{o.user_email || o.user_id}</div>
                    </td>
                    <td className="px-3 py-2.5 capitalize text-slate-300">{o.gateway}</td>
                    <td className="px-3 py-2.5 text-slate-200">{money(o.amount, o.currency)}</td>
                    <td className="px-3 py-2.5"><Badge className={statusColor(o.status)}>{o.status}</Badge></td>
                    <td className="px-3 py-2.5 font-mono text-xs text-slate-400">{o.gateway_payment_id || "—"}</td>
                    <td className="px-3 py-2.5 font-mono text-xs text-slate-400">{o.gateway_order_id || o.id}</td>
                    <td className="px-3 py-2.5 text-slate-400 whitespace-nowrap">{fmtDate(o.created_at)}</td>
                  </tr>
                ))
              : rows.map((e) => (
                  <tr key={e.id} className="hover:bg-slate-800/40 cursor-pointer" onClick={() => openDetail(e.id)}>
                    <td className="px-3 py-2.5 text-slate-200">{e.event || "—"}</td>
                    <td className="px-3 py-2.5 capitalize text-slate-300">{e.gateway}</td>
                    <td className="px-3 py-2.5"><Badge className={statusColor(e.status)}>{e.status}</Badge></td>
                    <td className="px-3 py-2.5">
                      {e.signature_valid
                        ? <span className="text-emerald-400">✓</span>
                        : <span className="text-red-400">✗</span>}
                    </td>
                    <td className="px-3 py-2.5 text-slate-200">{money(e.amount, e.currency)}</td>
                    <td className="px-3 py-2.5 font-mono text-xs text-slate-400">{e.order_ref || "—"}</td>
                    <td className="px-3 py-2.5 font-mono text-xs text-slate-400">{e.payment_id || "—"}</td>
                    <td className="px-3 py-2.5 text-slate-400 whitespace-nowrap">{fmtDate(e.created_at)}</td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      <div className="flex items-center justify-between text-sm text-slate-400">
        <span>{total} record{total === 1 ? "" : "s"}</span>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" disabled={page === 0 || loading} onClick={() => setPage((p) => p - 1)}>Prev</Button>
          <span className="px-2 py-1">Page {page + 1}</span>
          <Button variant="outline" size="sm" disabled={(page + 1) * LIMIT >= total || loading} onClick={() => setPage((p) => p + 1)}>Next</Button>
        </div>
      </div>

      {/* Webhook detail modal */}
      {detail && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4" onClick={() => setDetail(null)}>
          <div className="bg-slate-900 border border-slate-700 rounded-xl max-w-3xl w-full max-h-[85vh] overflow-hidden flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-4 py-3 border-b border-slate-700">
              <div>
                <div className="text-white font-semibold">{detail.event || "Webhook event"}</div>
                <div className="text-xs text-slate-400">{detail.gateway} · {detail.status} · {fmtDate(detail.created_at)}</div>
              </div>
              <button onClick={() => setDetail(null)} className="text-slate-400 hover:text-white"><X className="w-5 h-5" /></button>
            </div>
            <div className="p-4 overflow-auto space-y-3">
              <div className="grid grid-cols-2 gap-2 text-sm">
                <KV k="Event id" v={detail.event_id} />
                <KV k="Signature valid" v={detail.signature_valid ? "Yes" : "No"} />
                <KV k="Payment id" v={detail.payment_id} />
                <KV k="Gateway order id" v={detail.gateway_order_id} />
                <KV k="Order ref" v={detail.order_ref} />
                <KV k="Amount" v={detail.amount != null ? money(detail.amount, detail.currency) : "—"} />
                {detail.error && <KV k="Error" v={detail.error} />}
              </div>
              <div>
                <div className="text-xs text-slate-500 mb-1">Raw payload</div>
                <pre className="bg-slate-950 border border-slate-800 rounded-lg p-3 text-xs text-slate-300 overflow-auto max-h-96 whitespace-pre-wrap">
                  {prettyJson(detail.raw)}
                </pre>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function Stat({ label, value, danger }: { label: string; value: any; danger?: boolean }) {
  return (
    <div className="rounded-xl border border-slate-800 bg-slate-900/60 px-4 py-3">
      <div className="text-xs text-slate-400">{label}</div>
      <div className={`text-xl font-bold ${danger ? "text-red-400" : "text-white"}`}>{value}</div>
    </div>
  );
}

function TabBtn({ active, onClick, icon, children }: any) {
  return (
    <button
      onClick={onClick}
      className={`flex items-center gap-2 px-4 py-2.5 text-sm font-medium border-b-2 -mb-px ${
        active ? "border-amber-400 text-amber-400" : "border-transparent text-slate-400 hover:text-slate-200"
      }`}
    >
      {icon}
      {children}
    </button>
  );
}

function KV({ k, v }: { k: string; v: any }) {
  return (
    <div>
      <div className="text-xs text-slate-500">{k}</div>
      <div className="text-slate-200 font-mono text-xs break-all">{v || "—"}</div>
    </div>
  );
}

function fmtDate(s?: string) {
  if (!s) return "—";
  const d = new Date(s);
  return isNaN(d.getTime()) ? s : d.toLocaleString();
}

function prettyJson(raw?: string) {
  if (!raw) return "—";
  try {
    return JSON.stringify(JSON.parse(raw), null, 2);
  } catch {
    return raw;
  }
}
