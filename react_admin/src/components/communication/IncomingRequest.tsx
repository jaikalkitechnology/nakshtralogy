import { useState, useEffect } from "react";
import { callAction, chatAction } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Phone, Video, MessageCircle, X } from "lucide-react";

interface IncomingRequestProps {
  type: "incoming_call" | "chat_request";
  id: string; // call_id or session_id
  callerName: string;
  callType?: string;
  ratePerMin?: number;
  ratePerSession?: number;
  billingMode?: string;
  onAccepted: (response: any) => void;
  onDeclined: () => void;
}

export default function IncomingRequest({
  type, id, callerName, callType = "voice", ratePerMin = 0,
  ratePerSession = 0, billingMode = "per_session", onAccepted, onDeclined,
}: IncomingRequestProps) {
  const [countdown, setCountdown] = useState(60);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      setCountdown((c) => {
        if (c <= 1) { clearInterval(timer); onDeclined(); return 0; }
        return c - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [onDeclined]);

  const accept = async () => {
    setLoading(true);
    try {
      const resp = type === "incoming_call"
        ? await callAction(id, "accept")
        : await chatAction(id, "accept");
      onAccepted(resp);
    } catch {
      onDeclined();
    }
  };

  const decline = async () => {
    try {
      if (type === "incoming_call") await callAction(id, "reject");
      else await chatAction(id, "cancel");
    } catch {}
    onDeclined();
  };

  const isCall = type === "incoming_call";
  const icon = isCall ? (callType === "video" ? <Video className="w-7 h-7" /> : <Phone className="w-7 h-7" />) : <MessageCircle className="w-7 h-7" />;
  const label = isCall ? `Incoming ${callType === "video" ? "Video" : "Voice"} Call` : "New Chat Request";
  const rateText = isCall ? `₹${ratePerMin}/min` : billingMode === "per_session" ? `₹${ratePerSession}/session` : `₹${ratePerMin}/min`;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm">
      <div className="bg-card border border-border rounded-2xl p-8 w-80 text-center shadow-2xl animate-in fade-in zoom-in">
        <div className={`w-16 h-16 mx-auto rounded-full flex items-center justify-center mb-4 ${isCall ? "bg-green-500/20 text-green-400" : "bg-accent/20 text-accent"}`}>
          {icon}
        </div>
        <div className="text-sm text-muted-foreground">{label}</div>
        <div className="text-xl font-bold text-foreground mt-1">{callerName}</div>
        <div className="text-primary text-sm mt-1">{rateText}</div>
        <div className={`text-xs mt-3 px-3 py-1 rounded-full inline-block ${countdown <= 10 ? "bg-destructive/20 text-destructive font-bold" : "bg-muted text-muted-foreground"}`}>
          Expires in {countdown}s
        </div>
        <div className="flex gap-4 mt-6 justify-center">
          <Button variant="destructive" size="lg" onClick={decline} disabled={loading} className="rounded-full w-16 h-16">
            <X className="w-6 h-6" />
          </Button>
          <Button size="lg" onClick={accept} disabled={loading} className="rounded-full w-16 h-16 bg-green-500 hover:bg-green-600">
            {loading ? <span className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" /> : isCall ? <Phone className="w-6 h-6" /> : <MessageCircle className="w-6 h-6" />}
          </Button>
        </div>
      </div>
    </div>
  );
}
