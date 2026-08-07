import { useState, useEffect, useCallback, type ReactNode } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  RefreshCw, Radio, Phone, Video, MessageSquare, Star, X,
  Gift, Users, Pin,
} from "lucide-react";
import {
  adminLogsLive, adminLogsLiveDetail, adminLogsCalls,
  adminLogsChats, adminLogsChatTranscript, adminLogsSessionReviews,
} from "@/services/api";

type Tab = "live" | "calls" | "chats" | "reviews";

/**
 * Communication Logs — a full activity log for every communication channel:
 *   · Live streams  (GET /admin/logs/live, /admin/logs/live/{id})
 *   · Voice/Video calls (GET /admin/logs/calls)
 *   · Paid chats    (GET /admin/logs/chats, /admin/logs/chats/{id})
 *   · Session reviews (GET /admin/logs/session-reviews)
 * Click a live stream or chat row to open its full transcript/timeline.
 */
export default function CommunicationLogs() {
  const [tab, setTab] = useState<Tab>("live");
  const [rows, setRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  const [detail, setDetail] = useState<any>(null);       // live timeline OR chat transcript
  const [detailKind, setDetailKind] = useState<"live" | "chat" | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setErr(null);
    try {
      const fn =
        tab === "live" ? adminLogsLive :
        tab === "calls" ? adminLogsCalls :
        tab === "chats" ? adminLogsChats :
        adminLogsSessionReviews;
      const r = await fn({ limit: 50 });
      if (r.ok) {
        setRows(r.data?.items ?? []);
      } else if (r.status === 404) {
        setErr("Endpoint not found — deploy the backend with communication logs.");
        setRows([]);
      } else {
        setErr(r.data?.detail || `Failed (${r.status})`);
        setRows([]);
      }
    } catch (e: any) {
      setErr(String(e));
    } finally {
      setLoading(false);
    }
  }, [tab]);

  useEffect(() => { load(); }, [load]);

  const openLive = async (id: string) => {
    const r = await adminLogsLiveDetail(id);
    if (r.ok) { setDetail(r.data); setDetailKind("live"); }
  };
  const openChat = async (id: string) => {
    const r = await adminLogsChatTranscript(id);
    if (r.ok) { setDetail(r.data); setDetailKind("chat"); }
  };

  const TABS: { key: Tab; label: string; icon: any }[] = [
    { key: "live", label: "Live Streams", icon: Radio },
    { key: "calls", label: "Calls", icon: Phone },
    { key: "chats", label: "Chats", icon: MessageSquare },
    { key: "reviews", label: "Reviews", icon: Star },
  ];

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display text-gold-gradient flex items-center gap-2">
            <Radio className="w-6 h-6 text-primary" /> Communication Logs
          </h1>
          <p className="text-sm text-muted-foreground">Full activity across live streams, calls, chats and session reviews.</p>
        </div>
        <Button size="sm" onClick={load} disabled={loading}>
          <RefreshCw className={`w-4 h-4 mr-1 ${loading ? "animate-spin" : ""}`} /> Refresh
        </Button>
      </div>

      {/* Tabs */}
      <div className="flex flex-wrap gap-2">
        {TABS.map((t) => (
          <button
            key={t.key}
            onClick={() => setTab(t.key)}
            className={`flex items-center gap-1.5 rounded-xl px-3.5 py-2 text-sm font-semibold transition-colors ${
              tab === t.key ? "bg-gradient-to-br from-gold to-gold-light text-primary-foreground" : "border border-border text-muted-foreground hover:text-foreground"
            }`}
          >
            <t.icon className="w-4 h-4" /> {t.label}
          </button>
        ))}
      </div>

      {err && <div className="rounded-lg border border-destructive/40 bg-destructive/10 text-destructive text-sm p-3">{err}</div>}

      <div className="rounded-xl border border-border bg-card/60 overflow-hidden">
        {rows.length === 0 && !loading ? (
          <p className="p-6 text-sm text-muted-foreground text-center">No records.</p>
        ) : (
          <div className="overflow-x-auto">
            {tab === "live" && <LiveTable rows={rows} onOpen={openLive} />}
            {tab === "calls" && <CallsTable rows={rows} />}
            {tab === "chats" && <ChatsTable rows={rows} onOpen={openChat} />}
            {tab === "reviews" && <ReviewsTable rows={rows} />}
          </div>
        )}
      </div>

      {detail && detailKind === "live" && <LiveDetailModal data={detail} onClose={() => setDetail(null)} />}
      {detail && detailKind === "chat" && <ChatDetailModal data={detail} onClose={() => setDetail(null)} />}
    </div>
  );
}

const th = "text-left p-2.5 font-semibold text-muted-foreground";
const td = "p-2.5 text-foreground";

function StatusBadge({ s }: { s: string }) {
  const map: Record<string, string> = {
    live: "bg-red-500/20 text-red-400",
    ended: "bg-muted text-muted-foreground",
    completed: "bg-green-500/20 text-green-400",
    scheduled: "bg-yellow-500/20 text-yellow-400",
    missed: "bg-destructive/20 text-destructive",
    rejected: "bg-destructive/20 text-destructive",
    cancelled: "bg-muted text-muted-foreground",
    expired: "bg-muted text-muted-foreground",
  };
  return <Badge className={map[s] || "bg-muted text-muted-foreground"}>{s}</Badge>;
}

function LiveTable({ rows, onOpen }: { rows: any[]; onOpen: (id: string) => void }) {
  return (
    <table className="w-full text-xs">
      <thead className="bg-muted/50"><tr>
        <th className={th}>Title</th><th className={th}>Host</th><th className={th}>Status</th>
        <th className={th}>Peak</th><th className={th}>Chat</th><th className={th}>Gifts ₹</th>
        <th className={th}>Started</th><th className={th}></th>
      </tr></thead>
      <tbody>
        {rows.map((r) => (
          <tr key={r.id} className="border-t border-border hover:bg-muted/30">
            <td className={td}>{r.title}</td>
            <td className={td}>{r.host_name || "—"}</td>
            <td className={td}><StatusBadge s={r.status} /></td>
            <td className={td}>{r.peak_viewers}</td>
            <td className={td}>{r.questions}</td>
            <td className={td}>₹{Number(r.total_gifts_amount || 0).toFixed(0)}{r.gift_goal ? ` / ${Number(r.gift_goal).toFixed(0)}` : ""}</td>
            <td className={td}>{r.started_at?.slice(0, 16) || "—"}</td>
            <td className={td}><Button size="sm" variant="outline" onClick={() => onOpen(r.id)}>View log</Button></td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function CallsTable({ rows }: { rows: any[] }) {
  return (
    <table className="w-full text-xs">
      <thead className="bg-muted/50"><tr>
        <th className={th}>Type</th><th className={th}>Caller</th><th className={th}>Astrologer</th>
        <th className={th}>Status</th><th className={th}>Duration</th><th className={th}>Amount ₹</th><th className={th}>When</th>
      </tr></thead>
      <tbody>
        {rows.map((r) => (
          <tr key={r.id} className="border-t border-border hover:bg-muted/30">
            <td className={td}>
              <span className="inline-flex items-center gap-1">
                {r.call_type === "video" ? <Video className="w-3.5 h-3.5" /> : <Phone className="w-3.5 h-3.5" />} {r.call_type}
              </span>
            </td>
            <td className={td}>{r.caller_name || "—"}</td>
            <td className={td}>{r.astrologer_name || "—"}</td>
            <td className={td}><StatusBadge s={r.status} /></td>
            <td className={td}>{fmtDur(r.duration_sec)}</td>
            <td className={td}>₹{Number(r.total_amount || 0).toFixed(0)}</td>
            <td className={td}>{(r.created_at || "").slice(0, 16)}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function ChatsTable({ rows, onOpen }: { rows: any[]; onOpen: (id: string) => void }) {
  return (
    <table className="w-full text-xs">
      <thead className="bg-muted/50"><tr>
        <th className={th}>User</th><th className={th}>Astrologer</th><th className={th}>Status</th>
        <th className={th}>Msgs</th><th className={th}>Amount ₹</th><th className={th}>When</th><th className={th}></th>
      </tr></thead>
      <tbody>
        {rows.map((r) => (
          <tr key={r.id} className="border-t border-border hover:bg-muted/30">
            <td className={td}>{r.user_name || "—"}</td>
            <td className={td}>{r.astrologer_name || "—"}</td>
            <td className={td}><StatusBadge s={r.status} /></td>
            <td className={td}>{r.message_count}</td>
            <td className={td}>₹{Number(r.total_amount || 0).toFixed(0)}</td>
            <td className={td}>{(r.created_at || "").slice(0, 16)}</td>
            <td className={td}><Button size="sm" variant="outline" onClick={() => onOpen(r.id)}>Transcript</Button></td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function Stars({ n }: { n: number }) {
  return (
    <span className="inline-flex text-primary">
      {[1, 2, 3, 4, 5].map((i) => (
        <Star key={i} className={`w-3.5 h-3.5 ${i <= n ? "fill-primary text-primary" : "text-muted-foreground"}`} />
      ))}
    </span>
  );
}

function ReviewsTable({ rows }: { rows: any[] }) {
  return (
    <table className="w-full text-xs">
      <thead className="bg-muted/50"><tr>
        <th className={th}>Reviewer</th><th className={th}>Astrologer</th><th className={th}>Type</th>
        <th className={th}>Rating</th><th className={th}>Comment</th><th className={th}>When</th>
      </tr></thead>
      <tbody>
        {rows.map((r) => (
          <tr key={r.id} className="border-t border-border hover:bg-muted/30">
            <td className={td}>{r.reviewer_name || "—"}</td>
            <td className={td}>{r.astrologer_name || "—"}</td>
            <td className={td}>{r.session_type}</td>
            <td className={td}><Stars n={r.rating} /></td>
            <td className={`${td} max-w-[280px]`}>{r.comment || <span className="text-muted-foreground">—</span>}</td>
            <td className={td}>{(r.created_at || "").slice(0, 16)}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

function Modal({ title, onClose, children }: { title: string; onClose: () => void; children: ReactNode }) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={onClose}>
      <div className="w-full max-w-2xl max-h-[85vh] overflow-hidden rounded-2xl border border-border bg-card shadow-xl flex flex-col" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between border-b border-border p-4">
          <h3 className="font-display text-lg text-foreground">{title}</h3>
          <button onClick={onClose} className="text-muted-foreground hover:text-foreground"><X className="w-5 h-5" /></button>
        </div>
        <div className="overflow-y-auto p-4">{children}</div>
      </div>
    </div>
  );
}

function LiveDetailModal({ data, onClose }: { data: any; onClose: () => void }) {
  const s = data.stream || {};
  const c = data.counts || {};
  const timeline: any[] = data.timeline || [];
  return (
    <Modal title={`Live: ${s.title || ""}`} onClose={onClose}>
      <div className="mb-3 flex flex-wrap gap-2 text-xs">
        <Badge className="bg-cosmic/15 text-foreground">Host: {s.host_name || "—"}</Badge>
        <Badge className="bg-cosmic/15 text-foreground"><Users className="w-3 h-3 mr-1" /> Peak {s.peak_viewers}</Badge>
        <Badge className="bg-cosmic/15 text-foreground"><Gift className="w-3 h-3 mr-1" /> ₹{Number(s.total_gifts_amount || 0).toFixed(0)}{s.gift_goal ? ` / ${Number(s.gift_goal).toFixed(0)}` : ""}</Badge>
        <Badge className="bg-cosmic/15 text-foreground">{c.chat || 0} chat · {c.host_replies || 0} replies · {c.gifts || 0} gifts · {c.super_chats || 0} super</Badge>
      </div>
      <div className="space-y-1.5">
        {timeline.length === 0 && <p className="text-sm text-muted-foreground text-center py-4">No activity recorded.</p>}
        {timeline.map((e, i) => (
          <div key={i} className="flex items-start gap-2 text-xs rounded-lg bg-muted/30 p-2">
            <TimelineIcon type={e.type} pinned={e.is_pinned} />
            <div className="min-w-0 flex-1">
              <span className={`font-semibold ${e.type === "host_reply" ? "text-primary" : "text-foreground"}`}>{e.actor || "User"}</span>
              {e.amount ? <span className="ml-1 text-green-400">₹{Number(e.amount).toFixed(0)}</span> : null}
              {e.text ? <span className="ml-1 text-muted-foreground break-words">{e.text}</span> : null}
            </div>
            <span className="flex-none text-[10px] text-muted-foreground">{(e.at || "").slice(11, 19)}</span>
          </div>
        ))}
      </div>
    </Modal>
  );
}

function TimelineIcon({ type, pinned }: { type: string; pinned?: boolean }) {
  if (type === "gift") return <Gift className="w-3.5 h-3.5 flex-none text-green-400 mt-0.5" />;
  if (type === "super_chat") return <Star className="w-3.5 h-3.5 flex-none text-primary mt-0.5" />;
  if (type === "host_reply") return <MessageSquare className="w-3.5 h-3.5 flex-none text-primary mt-0.5" />;
  if (pinned) return <Pin className="w-3.5 h-3.5 flex-none text-accent mt-0.5" />;
  return <MessageSquare className="w-3.5 h-3.5 flex-none text-muted-foreground mt-0.5" />;
}

function ChatDetailModal({ data, onClose }: { data: any; onClose: () => void }) {
  const s = data.session || {};
  const msgs: any[] = data.messages || [];
  return (
    <Modal title={`Chat: ${s.user_name || "User"} ↔ ${s.astrologer_name || "Astrologer"}`} onClose={onClose}>
      <div className="space-y-1.5">
        {msgs.length === 0 && <p className="text-sm text-muted-foreground text-center py-4">No messages.</p>}
        {msgs.map((m) => {
          const mine = m.sender === "user";
          return (
            <div key={m.id} className={`flex ${mine ? "justify-start" : "justify-end"}`}>
              <div className={`max-w-[75%] rounded-2xl px-3 py-2 text-xs ${mine ? "bg-muted/50 text-foreground" : "bg-primary/20 text-foreground"}`}>
                <div className="mb-0.5 text-[10px] font-semibold text-muted-foreground">{mine ? "User" : "Astrologer"}</div>
                {m.message_type !== "text" ? (
                  <span className="italic text-muted-foreground">[{m.message_type}] {m.file_name || m.media_url || ""}</span>
                ) : (
                  <span className="break-words">{m.content}</span>
                )}
                <div className="mt-0.5 text-right text-[9px] text-muted-foreground">{(m.at || "").slice(11, 19)}</div>
              </div>
            </div>
          );
        })}
      </div>
    </Modal>
  );
}

function fmtDur(sec: number) {
  const s = Number(sec || 0);
  const m = Math.floor(s / 60);
  const r = s % 60;
  return `${m}m ${r}s`;
}
