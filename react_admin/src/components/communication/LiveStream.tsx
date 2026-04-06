import { useState, useEffect, useRef } from "react";
import AgoraRTC, { IAgoraRTCClient, ICameraVideoTrack, IMicrophoneAudioTrack } from "agora-rtc-sdk-ng";
import {
  startLiveStream, endLiveStream, joinLiveStream, leaveLiveStream,
  getLiveQuestions, getLiveViewers, getLiveSuperChats,
  sendLiveQuestion, sendLiveGift, sendSuperChat, fetchGifts,
} from "@/services/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Send, Users, Gift, DollarSign, Mic, MicOff, Camera, StopCircle, X } from "lucide-react";

// ═══════════════════════════════════════════════════════════════════
//  HOST VIEW (Astrologer goes live)
// ═��═════════════════════════════════════════════════════════════════
interface HostProps {
  streamId: string;
  channelName: string;
  agoraToken: string;
  agoraAppId: string;
  title: string;
  onEnd?: () => void;
}

export function LiveHostView({ streamId, channelName, agoraToken, agoraAppId, title, onEnd }: HostProps) {
  const [isLive, setIsLive] = useState(false);
  const [muted, setMuted] = useState(false);
  const [viewers, setViewers] = useState(0);
  const [peak, setPeak] = useState(0);
  const [questions, setQuestions] = useState<any[]>([]);
  const [superChats, setSuperChats] = useState<any[]>([]);
  const [seconds, setSeconds] = useState(0);

  const clientRef = useRef<IAgoraRTCClient>();
  const audioRef = useRef<IMicrophoneAudioTrack>();
  const videoRef = useRef<ICameraVideoTrack>();
  const localElRef = useRef<HTMLDivElement>(null);
  const pollRef = useRef<ReturnType<typeof setInterval>>();
  const timerRef = useRef<ReturnType<typeof setInterval>>();

  useEffect(() => {
    initAgora();
    return () => cleanup();
  }, []);

  const initAgora = async () => {
    const client = AgoraRTC.createClient({ mode: "live", codec: "vp8" });
    clientRef.current = client;
    await client.setClientRole("host");
    const audio = await AgoraRTC.createMicrophoneAudioTrack();
    const video = await AgoraRTC.createCameraVideoTrack();
    audioRef.current = audio;
    videoRef.current = video;
    if (localElRef.current) video.play(localElRef.current);
  };

  const goLive = async () => {
    if (!clientRef.current) return;
    await clientRef.current.join(agoraAppId, channelName, agoraToken, 0);
    await clientRef.current.publish([audioRef.current!, videoRef.current!]);
    await startLiveStream(streamId);
    setIsLive(true);
    timerRef.current = setInterval(() => setSeconds((s) => s + 1), 1000);
    poll();
    pollRef.current = setInterval(poll, 3000);
  };

  const poll = async () => {
    const [v, q, sc] = await Promise.all([
      getLiveViewers(streamId), getLiveQuestions(streamId), getLiveSuperChats(streamId),
    ]);
    setViewers(v.total || 0);
    setPeak(v.peak || 0);
    if (Array.isArray(q)) setQuestions(q);
    if (Array.isArray(sc)) setSuperChats(sc);
  };

  const stop = async () => {
    clearInterval(pollRef.current);
    clearInterval(timerRef.current);
    audioRef.current?.close();
    videoRef.current?.close();
    await clientRef.current?.leave();
    await endLiveStream(streamId);
    onEnd?.();
  };

  const cleanup = () => {
    clearInterval(pollRef.current);
    clearInterval(timerRef.current);
    audioRef.current?.close();
    videoRef.current?.close();
    clientRef.current?.leave();
  };

  const fmtTime = (s: number) => `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;

  return (
    <div className="flex flex-col h-full bg-black rounded-xl overflow-hidden relative">
      <div ref={localElRef} className="flex-1 bg-black" />
      {!isLive && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-black/60">
          <div className="text-4xl mb-3">🔮</div>
          <div className="text-white text-lg font-semibold">{title}</div>
          <div className="text-white/50 text-sm mb-4">Preview your camera</div>
          <Button onClick={goLive} className="bg-red-500 hover:bg-red-600 text-white">Go Live</Button>
        </div>
      )}
      {isLive && (
        <>
          {/* Top bar */}
          <div className="absolute top-3 left-3 right-3 flex items-center gap-2">
            <span className="bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">LIVE {fmtTime(seconds)}</span>
            <span className="bg-black/50 text-white text-xs px-2 py-1 rounded flex items-center gap-1"><Users className="w-3 h-3" />{viewers}</span>
            <span className="ml-auto bg-black/50 text-white/60 text-xs px-2 py-1 rounded">Peak: {peak}</span>
          </div>
          {/* Super chats */}
          {superChats.length > 0 && (
            <div className="absolute top-12 left-3 right-3 flex gap-2 overflow-x-auto">
              {superChats.slice(0, 5).map((sc, i) => (
                <div key={i} className="bg-gradient-to-r from-yellow-600/80 to-purple-600/70 text-white text-xs rounded-lg px-3 py-1.5 whitespace-nowrap">
                  <span className="font-bold">{sc.sender_name}</span> ₹{sc.amount} — {sc.message}
                </div>
              ))}
            </div>
          )}
          {/* Chat overlay */}
          <div className="absolute bottom-20 left-3 right-20 max-h-48 overflow-y-auto flex flex-col-reverse gap-1">
            {questions.map((q, i) => (
              <div key={i} className="bg-black/50 text-xs text-white rounded-full px-3 py-1.5">
                <span className="text-yellow-400 font-semibold">{q.display_name}</span> {q.question}
              </div>
            ))}
          </div>
          {/* Controls */}
          <div className="absolute bottom-3 left-0 right-0 flex items-center justify-center gap-4">
            <button onClick={() => { setMuted(!muted); audioRef.current?.setEnabled(muted); }} className={`w-10 h-10 rounded-full flex items-center justify-center ${muted ? "bg-red-500/50" : "bg-white/10"} border border-white/20`}>
              {muted ? <MicOff className="w-4 h-4 text-white" /> : <Mic className="w-4 h-4 text-white" />}
            </button>
            <button onClick={() => videoRef.current && AgoraRTC.createCameraVideoTrack().then(t => { videoRef.current?.close(); videoRef.current = t; if(localElRef.current) t.play(localElRef.current); clientRef.current?.publish([t]); })} className="w-10 h-10 rounded-full bg-white/10 border border-white/20 flex items-center justify-center">
              <Camera className="w-4 h-4 text-white" />
            </button>
            <button onClick={stop} className="w-12 h-12 rounded-full bg-red-500 flex items-center justify-center">
              <StopCircle className="w-5 h-5 text-white" />
            </button>
          </div>
        </>
      )}
    </div>
  );
}


// ═══════════════════════════════════════════════════════════════════
//  VIEWER VIEW (User watches live stream)
// ═══════════════════���═════════════════════════════��═════════════════
interface ViewerProps {
  streamId: string;
  title: string;
  hostName: string;
  superChatRate?: number;
  onLeave?: () => void;
}

export function LiveViewerView({ streamId, title, hostName, superChatRate = 50, onLeave }: ViewerProps) {
  const [joined, setJoined] = useState(false);
  const [viewers, setViewers] = useState(0);
  const [questions, setQuestions] = useState<any[]>([]);
  const [superChats, setSuperChats] = useState<any[]>([]);
  const [gifts, setGifts] = useState<any[]>([]);
  const [input, setInput] = useState("");
  const [showGifts, setShowGifts] = useState(false);
  const [showSuperChat, setShowSuperChat] = useState(false);
  const [scMsg, setScMsg] = useState("");
  const [scAmt, setScAmt] = useState(`${superChatRate}`);

  const clientRef = useRef<IAgoraRTCClient>();
  const remoteElRef = useRef<HTMLDivElement>(null);
  const pollRef = useRef<ReturnType<typeof setInterval>>();

  useEffect(() => {
    join();
    fetchGifts().then(g => { if (Array.isArray(g)) setGifts(g); });
    return () => cleanup();
  }, []);

  const join = async () => {
    const resp = await joinLiveStream(streamId);
    if (!resp.agora_token) return;

    const client = AgoraRTC.createClient({ mode: "live", codec: "vp8" });
    clientRef.current = client;
    await client.setClientRole("audience");

    client.on("user-published", async (user, mediaType) => {
      await client.subscribe(user, mediaType);
      if (mediaType === "video" && remoteElRef.current) user.videoTrack?.play(remoteElRef.current);
      if (mediaType === "audio") user.audioTrack?.play();
    });
    client.on("user-left", () => { onLeave?.(); });

    await client.join(resp.agora_app_id, resp.channel_name, resp.agora_token, resp.agora_uid || 0);
    setJoined(true);
    poll();
    pollRef.current = setInterval(poll, 3000);
  };

  const poll = async () => {
    const [v, q, sc] = await Promise.all([
      getLiveViewers(streamId), getLiveQuestions(streamId), getLiveSuperChats(streamId),
    ]);
    setViewers(v.total || 0);
    if (Array.isArray(q)) setQuestions(q);
    if (Array.isArray(sc)) setSuperChats(sc);
  };

  const leave = async () => {
    clearInterval(pollRef.current);
    await clientRef.current?.leave();
    await leaveLiveStream(streamId);
    onLeave?.();
  };

  const cleanup = () => { clearInterval(pollRef.current); clientRef.current?.leave(); };

  const send = async () => { if (!input.trim()) return; await sendLiveQuestion(streamId, input.trim()); setInput(""); poll(); };
  const doGift = async (id: string) => { await sendLiveGift(streamId, id); setShowGifts(false); poll(); };
  const doSuperChat = async () => {
    const amt = parseFloat(scAmt);
    if (!scMsg.trim() || isNaN(amt) || amt < superChatRate) return;
    await sendSuperChat(streamId, scMsg.trim(), amt);
    setShowSuperChat(false); setScMsg(""); setScAmt(`${superChatRate}`); poll();
  };

  return (
    <div className="flex flex-col h-full bg-black rounded-xl overflow-hidden relative">
      <div ref={remoteElRef} className="flex-1 bg-black">
        {!joined && <div className="flex items-center justify-center h-full text-white/50">Connecting...</div>}
      </div>

      {/* Top bar */}
      <div className="absolute top-3 left-3 right-3 flex items-center gap-2">
        <div className="bg-black/60 rounded-full px-3 py-1.5 flex items-center gap-2">
          <div className="w-6 h-6 rounded-full bg-primary/30 text-xs flex items-center justify-center">{hostName[0]}</div>
          <span className="text-white text-xs font-semibold">{hostName}</span>
        </div>
        <span className="bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">LIVE</span>
        <span className="bg-black/50 text-white text-xs px-2 py-1 rounded flex items-center gap-1"><Users className="w-3 h-3" />{viewers}</span>
        <button onClick={leave} className="ml-auto bg-white/10 rounded-full p-1.5"><X className="w-4 h-4 text-white" /></button>
      </div>

      {/* Super chats */}
      {superChats.length > 0 && (
        <div className="absolute top-14 left-3 right-3 flex gap-2 overflow-x-auto">
          {superChats.slice(0, 5).map((sc, i) => (
            <div key={i} className="bg-gradient-to-r from-yellow-600/80 to-purple-600/70 text-white text-xs rounded-lg px-3 py-1.5 whitespace-nowrap shrink-0">
              <span className="font-bold">{sc.sender_name}</span> ₹{sc.amount} — {sc.message}
            </div>
          ))}
        </div>
      )}

      {/* Chat overlay */}
      <div className="absolute bottom-16 left-3 right-20 max-h-48 overflow-y-auto flex flex-col-reverse gap-1">
        {questions.map((q, i) => (
          <div key={i} className="bg-black/50 text-xs text-white rounded-full px-3 py-1.5">
            <span className="text-yellow-400 font-semibold">{q.display_name}</span> {q.question}
          </div>
        ))}
      </div>

      {/* Bottom controls */}
      <div className="absolute bottom-0 left-0 right-0 flex items-center gap-2 px-3 py-2.5">
        <Input value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={(e) => e.key === "Enter" && send()}
          placeholder="Say something..." className="flex-1 rounded-full bg-white/10 border-white/20 text-white text-sm" />
        <button onClick={send} className="w-9 h-9 rounded-full bg-primary flex items-center justify-center"><Send className="w-4 h-4 text-black" /></button>
        <button onClick={() => setShowGifts(!showGifts)} className="w-9 h-9 rounded-full bg-white/10 border border-white/20 flex items-center justify-center"><Gift className="w-4 h-4 text-purple-400" /></button>
        <button onClick={() => setShowSuperChat(!showSuperChat)} className="w-9 h-9 rounded-full bg-primary/20 border border-primary/40 flex items-center justify-center"><DollarSign className="w-4 h-4 text-primary" /></button>
      </div>

      {/* Gift sheet */}
      {showGifts && (
        <div className="absolute bottom-16 left-0 right-0 bg-gray-900/95 border-t border-white/10 p-4 rounded-t-xl">
          <div className="text-white text-sm font-semibold mb-3">Send a Gift</div>
          <div className="flex flex-wrap gap-3">
            {gifts.map((g) => (
              <button key={g.id} onClick={() => doGift(g.id)} className="flex flex-col items-center w-16">
                <div className="text-2xl">{g.icon}</div>
                <div className="text-white/60 text-[10px]">{g.name}</div>
                <div className="text-primary text-[10px] font-semibold">₹{g.price}</div>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Super chat dialog */}
      {showSuperChat && (
        <div className="absolute bottom-16 left-3 right-3 bg-gray-900/95 border border-white/10 p-4 rounded-xl">
          <div className="text-white text-sm font-semibold mb-2">Super Chat (min ₹{superChatRate})</div>
          <Input value={scMsg} onChange={(e) => setScMsg(e.target.value)} placeholder="Pinned message..." className="mb-2 bg-white/10 border-white/20 text-white text-sm" />
          <div className="flex items-center gap-2">
            <Input value={scAmt} onChange={(e) => setScAmt(e.target.value)} type="number" className="w-24 bg-white/10 border-white/20 text-white text-sm" />
            <div className="flex gap-1">
              {[superChatRate, 100, 200, 500].filter(a => a >= superChatRate).map(a => (
                <button key={a} onClick={() => setScAmt(`${a}`)} className="text-xs bg-primary/20 text-primary px-2 py-1 rounded">₹{a}</button>
              ))}
            </div>
            <Button size="sm" onClick={doSuperChat} className="ml-auto">Send</Button>
          </div>
        </div>
      )}
    </div>
  );
}
