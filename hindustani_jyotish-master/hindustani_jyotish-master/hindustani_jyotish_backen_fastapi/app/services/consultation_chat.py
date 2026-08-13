"""Per-consultation WebSocket rooms for real-time chat.

Backed by :class:`RoomHub`, so broadcasts fan out across all worker processes
via Redis when it's available (and degrade to in-process for a single worker).
The public interface (connect/disconnect/broadcast/members) is unchanged.
"""
from __future__ import annotations

from app.services.ws_hub import RoomHub


class ConsultationChatManager(RoomHub):
    def __init__(self) -> None:
        super().__init__("consult")


chat_manager = ConsultationChatManager()
