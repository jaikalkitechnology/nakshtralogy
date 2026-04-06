import { useState, useEffect, useRef, useCallback } from "react";
import { getWsChatUrl, getChatMessages, chatAction, uploadChatFile } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Send, Paperclip, PhoneOff, Clock, MessageCircle } from "lucide-react";

interface ChatWindowProps {
  sessionId: string;
  peerName: string;
  billingMode?: string;
  ratePerMin?: number;
  ratePerSession?: number;
  sessionMessageLimit?: number;
  isAstrologer?: boolean;
  onEnd?: () => void;
}

interface Message {
  id?: string;
  sender_id?: string;
  sender_name?: string;
  content?: string;
  message_type?: string;
  media_url?: string;
  file_name?: string;
  timestamp?: string;
  is_astrologer?: boolean;
  user_message_count?: number;
  remaining_messages?: number;
}

export default function ChatWindow({
  sessionId, peerName, billingMode = "per_session", ratePerMin = 0,
  ratePerSession = 0, sessionMessageLimit = 45, isAstrologer = false, onEnd,
}: ChatWindowProps) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [connected, setConnected] = useState(false);
  const [seconds, setSeconds] = useState(0);
  const [userMsgCount, setUserMsgCount] = useState(0);
  const [remaining, setRemaining] = useState(sessionMessageLimit);
  const [ended, setEnded] = useState(false);
  const wsRef = useRef<WebSocket | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const timerRef = useRef<ReturnType<typeof setInterval>>();
  const myId = useRef<string>("");

  // Load user ID from localStorage
  useEffect(() => {
    try {
      const raw = localStorage.getItem("app_user");
      if (raw) myId.current = JSON.parse(raw).id || "";
    } catch {}
  }, []);

  // Load message history
  useEffect(() => {
    getChatMessages(sessionId).then((msgs) => {
      if (Array.isArray(msgs)) setMessages(msgs);
    }).catch(() => {});
  }, [sessionId]);

  // Connect WebSocket
  useEffect(() => {
    const url = getWsChatUrl(sessionId);
    const ws = new WebSocket(url);
    wsRef.current = ws;

    ws.onopen = () => setConnected(true);
    ws.onmessage = (e) => {
      try {
        const data = JSON.parse(e.data);
        if (data.type === "message") {
          setMessages((prev) => [...prev, data]);
          if (data.user_message_count != null) setUserMsgCount(data.user_message_count);
          if (data.remaining_messages != null) setRemaining(data.remaining_messages);
        } else if (data.type === "session_info") {
          setConnected(true);
          if (data.user_message_count) setUserMsgCount(data.user_message_count);
        } else if (data.type === "session_ended") {
          setEnded(true);
          clearInterval(timerRef.current);
        }
      } catch {}
    };
    ws.onclose = () => setConnected(false);
    ws.onerror = () => setConnected(false);

    timerRef.current = setInterval(() => setSeconds((s) => s + 1), 1000);

    return () => { ws.close(); clearInterval(timerRef.current); };
  }, [sessionId]);

  // Auto-scroll
  useEffect(() => {
    scrollRef.current?.scrollTo(0, scrollRef.current.scrollHeight);
  }, [messages]);

  const sendMessage = useCallback(() => {
    if (!input.trim() || !wsRef.current) return;
    wsRef.current.send(JSON.stringify({ type: "message", content: input.trim(), message_type: "text" }));
    setInput("");
  }, [input]);

  const endSession = async () => {
    try { await chatAction(sessionId, "end"); } catch {}
    wsRef.current?.send(JSON.stringify({ type: "end_session" }));
    setEnded(true);
    clearInterval(timerRef.current);
    onEnd?.();
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    try {
      const resp = await uploadChatFile(file);
      if (resp.media_url) {
        const fileType = file.name.endsWith(".pdf") ? "pdf" : "image";
        wsRef.current?.send(JSON.stringify({
          type: "message", content: fileType === "pdf" ? `📄 ${file.name}` : "📷 Photo",
          message_type: fileType, media_url: resp.media_url, file_name: resp.file_name, file_size: resp.file_size,
        }));
      }
    } catch {}
    e.target.value = "";
  };

  const fmtTime = (s: number) => `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
  const cost = billingMode === "per_session" ? ratePerSession : Math.ceil(seconds / 60) * ratePerMin;

  return (
    <div className="flex flex-col h-full bg-background border border-border rounded-xl overflow-hidden">
      {/* Header */}
      <div className="flex items-center gap-3 px-4 py-3 bg-card border-b border-border">
        <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center text-sm">
          {peerName[0]?.toUpperCase() || "?"}
        </div>
        <div className="flex-1 min-w-0">
          <div className="text-sm font-semibold text-foreground truncate">{peerName}</div>
          <div className="text-xs text-muted-foreground flex items-center gap-2">
            <Clock className="w-3 h-3" />
            <span>{fmtTime(seconds)}</span>
            {billingMode === "per_session" ? (
              <span>• {remaining} msgs left</span>
            ) : (
              <span>• ₹{cost.toFixed(0)}</span>
            )}
            {connected && <span className="w-2 h-2 rounded-full bg-green-500 inline-block" />}
          </div>
        </div>
        <div className="text-xs px-2 py-1 rounded-full bg-primary/10 text-primary font-semibold">
          {billingMode === "per_session" ? `₹${ratePerSession}/sess` : `₹${ratePerMin}/min`}
        </div>
        {!ended && (
          <Button size="sm" variant="destructive" onClick={endSession}><PhoneOff className="w-4 h-4 mr-1" />End</Button>
        )}
      </div>

      {/* Session info banner */}
      {billingMode === "per_session" && (
        <div className="px-4 py-1.5 bg-accent/10 text-xs text-accent-foreground flex items-center gap-1">
          <MessageCircle className="w-3 h-3" />
          <span>{userMsgCount}/{sessionMessageLimit} messages used</span>
          <span className="ml-auto font-semibold">{remaining} left</span>
        </div>
      )}

      {/* Messages */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto px-4 py-3 space-y-2">
        {ended && (
          <div className="text-center text-sm text-destructive font-semibold py-4">Session ended</div>
        )}
        {messages.map((msg, i) => {
          const isMe = msg.sender_id === myId.current;
          return (
            <div key={msg.id || i} className={`flex ${isMe ? "justify-end" : "justify-start"}`}>
              <div className={`max-w-[75%] rounded-2xl px-3.5 py-2 ${isMe ? "bg-primary text-primary-foreground rounded-br-sm" : "bg-card border border-border rounded-bl-sm"}`}>
                {!isMe && <div className="text-[10px] font-semibold text-accent mb-0.5">{msg.sender_name}</div>}
                {msg.message_type === "image" && msg.media_url && (
                  <img src={msg.media_url} className="rounded-lg max-w-full mb-1" alt="" />
                )}
                {msg.message_type === "pdf" && msg.media_url && (
                  <div className="flex items-center gap-2 bg-black/10 rounded-lg p-2 mb-1">
                    <span className="text-xl">📄</span>
                    <span className="text-xs truncate">{msg.file_name || "Document"}</span>
                  </div>
                )}
                {msg.content && <div className="text-sm">{msg.content}</div>}
                <div className={`text-[10px] mt-0.5 ${isMe ? "text-primary-foreground/60" : "text-muted-foreground"} text-right`}>
                  {msg.timestamp?.substring(11, 16) || ""}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Input */}
      {!ended && (
        <div className="flex items-center gap-2 px-3 py-2.5 bg-card border-t border-border">
          <label className="cursor-pointer">
            <Paperclip className="w-5 h-5 text-primary" />
            <input type="file" className="hidden" accept="image/*,.pdf" onChange={handleFileUpload} />
          </label>
          <Input
            value={input} onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && sendMessage()}
            placeholder="Type a message..." className="flex-1 rounded-full"
          />
          <Button size="icon" onClick={sendMessage} disabled={!input.trim()} className="rounded-full w-9 h-9">
            <Send className="w-4 h-4" />
          </Button>
        </div>
      )}
    </div>
  );
}
