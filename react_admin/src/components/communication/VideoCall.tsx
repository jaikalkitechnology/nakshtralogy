import { useState, useEffect, useRef, useCallback } from "react";
import AgoraRTC, { IAgoraRTCClient, IAgoraRTCRemoteUser, ICameraVideoTrack, IMicrophoneAudioTrack } from "agora-rtc-sdk-ng";
import { callAction } from "@/services/api";
import { Button } from "@/components/ui/button";
import { Mic, MicOff, Video, VideoOff, PhoneOff, Volume2, CameraIcon } from "lucide-react";

interface VideoCallProps {
  callId: string;
  channelName: string;
  agoraToken: string;
  agoraAppId: string;
  callType: "voice" | "video";
  peerName: string;
  ratePerMin: number;
  uid: number; // 1=caller(user), 2=receiver(astrologer)
  eligibleMinutes?: number;
  maxCallSeconds?: number;
  onEnd?: () => void;
}

export default function VideoCall({
  callId, channelName, agoraToken, agoraAppId, callType, peerName,
  ratePerMin, uid, eligibleMinutes = 0, maxCallSeconds = 0, onEnd,
}: VideoCallProps) {
  const [joined, setJoined] = useState(false);
  const [remoteUser, setRemoteUser] = useState<IAgoraRTCRemoteUser | null>(null);
  const [muted, setMuted] = useState(false);
  const [camOff, setCamOff] = useState(false);
  const [seconds, setSeconds] = useState(0);
  const [ending, setEnding] = useState(false);

  const clientRef = useRef<IAgoraRTCClient>();
  const localAudioRef = useRef<IMicrophoneAudioTrack>();
  const localVideoRef = useRef<ICameraVideoTrack>();
  const localVideoElRef = useRef<HTMLDivElement>(null);
  const remoteVideoElRef = useRef<HTMLDivElement>(null);
  const timerRef = useRef<ReturnType<typeof setInterval>>();
  const maxTimerRef = useRef<ReturnType<typeof setTimeout>>();

  useEffect(() => {
    initAgora();
    return () => { cleanup(); };
  }, []);

  // Timer
  useEffect(() => {
    if (joined) {
      timerRef.current = setInterval(() => setSeconds((s) => s + 1), 1000);
    }
    return () => clearInterval(timerRef.current);
  }, [joined]);

  // Max call timer
  useEffect(() => {
    if (joined && maxCallSeconds > 0) {
      maxTimerRef.current = setTimeout(() => endCall(), maxCallSeconds * 1000);
    }
    return () => { if (maxTimerRef.current) clearTimeout(maxTimerRef.current); };
  }, [joined, maxCallSeconds]);

  const initAgora = async () => {
    try {
      const client = AgoraRTC.createClient({ mode: "rtc", codec: "vp8" });
      clientRef.current = client;

      client.on("user-published", async (user, mediaType) => {
        await client.subscribe(user, mediaType);
        if (mediaType === "video" && remoteVideoElRef.current) {
          user.videoTrack?.play(remoteVideoElRef.current);
        }
        if (mediaType === "audio") {
          user.audioTrack?.play();
        }
        setRemoteUser(user);
      });

      client.on("user-unpublished", (user, mediaType) => {
        if (mediaType === "video") user.videoTrack?.stop();
      });

      client.on("user-left", () => {
        setRemoteUser(null);
        endCall();
      });

      await client.join(agoraAppId, channelName, agoraToken, uid);

      const audioTrack = await AgoraRTC.createMicrophoneAudioTrack();
      localAudioRef.current = audioTrack;

      if (callType === "video") {
        const videoTrack = await AgoraRTC.createCameraVideoTrack();
        localVideoRef.current = videoTrack;
        if (localVideoElRef.current) videoTrack.play(localVideoElRef.current);
        await client.publish([audioTrack, videoTrack]);
      } else {
        await client.publish([audioTrack]);
      }

      setJoined(true);
    } catch (e) {
      console.error("Agora init failed:", e);
    }
  };

  const cleanup = async () => {
    clearInterval(timerRef.current);
    if (maxTimerRef.current) clearTimeout(maxTimerRef.current);
    localAudioRef.current?.close();
    localVideoRef.current?.close();
    await clientRef.current?.leave();
  };

  const endCall = useCallback(async () => {
    if (ending) return;
    setEnding(true);
    await cleanup();
    try { await callAction(callId, joined ? "end" : "cancel"); } catch {}
    onEnd?.();
  }, [ending, joined, callId, onEnd]);

  const toggleMute = () => {
    localAudioRef.current?.setEnabled(muted);
    setMuted(!muted);
  };
  const toggleCam = () => {
    localVideoRef.current?.setEnabled(camOff);
    setCamOff(!camOff);
  };

  const fmtTime = (s: number) => `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
  const cost = Math.ceil(seconds / 60) * ratePerMin;
  const remainSec = maxCallSeconds > 0 ? maxCallSeconds - seconds : Infinity;

  return (
    <div className="flex flex-col h-full bg-black rounded-xl overflow-hidden relative">
      {/* Remote video / audio-only display */}
      {callType === "video" ? (
        <div ref={remoteVideoElRef} className="flex-1 bg-black">
          {!remoteUser && (
            <div className="flex items-center justify-center h-full text-white/50 text-sm">
              {joined ? "Waiting for peer video..." : "Connecting..."}
            </div>
          )}
        </div>
      ) : (
        <div className="flex-1 flex flex-col items-center justify-center bg-gradient-to-b from-gray-900 to-black">
          <div className="w-24 h-24 rounded-full bg-primary/20 border-2 border-primary flex items-center justify-center text-3xl mb-4">
            {peerName[0]?.toUpperCase() || "?"}
          </div>
          <div className="text-white text-xl font-semibold">{peerName}</div>
          <div className="text-white/60 text-sm mt-1">{callType === "voice" ? "Voice Call" : "Video Call"}</div>
        </div>
      )}

      {/* Local video PIP */}
      {callType === "video" && (
        <div ref={localVideoElRef} className="absolute top-4 right-4 w-28 h-36 rounded-xl overflow-hidden border border-white/20 bg-gray-900">
          {camOff && <div className="flex items-center justify-center h-full text-white/50"><VideoOff className="w-6 h-6" /></div>}
        </div>
      )}

      {/* Timer overlay */}
      <div className="absolute top-4 left-4 bg-black/60 rounded-xl px-4 py-2 text-center">
        <div className="text-white text-2xl font-mono font-bold">{fmtTime(seconds)}</div>
        <div className="text-primary text-xs">₹{cost.toFixed(0)} • ₹{ratePerMin}/min</div>
        {eligibleMinutes > 0 && (
          <div className={`text-xs ${remainSec < 120 ? "text-red-400 font-bold" : "text-white/50"}`}>
            {remainSec < Infinity ? `${Math.floor(remainSec / 60)}m ${remainSec % 60}s left` : `${eligibleMinutes} min available`}
          </div>
        )}
      </div>

      {/* Controls */}
      <div className="flex items-center justify-center gap-5 py-5 bg-gradient-to-t from-black to-transparent">
        <button onClick={toggleMute} className={`w-12 h-12 rounded-full flex items-center justify-center border border-white/20 ${muted ? "bg-red-500/30" : "bg-white/10"}`}>
          {muted ? <MicOff className="w-5 h-5 text-white" /> : <Mic className="w-5 h-5 text-white" />}
        </button>
        {callType === "video" && (
          <button onClick={toggleCam} className={`w-12 h-12 rounded-full flex items-center justify-center border border-white/20 ${camOff ? "bg-red-500/30" : "bg-white/10"}`}>
            {camOff ? <VideoOff className="w-5 h-5 text-white" /> : <Video className="w-5 h-5 text-white" />}
          </button>
        )}
        <button onClick={endCall} className="w-14 h-14 rounded-full bg-red-500 flex items-center justify-center">
          <PhoneOff className="w-6 h-6 text-white" />
        </button>
      </div>
    </div>
  );
}
