"""SQLAlchemy models. Import all here so Alembic + metadata see them."""
from app.models.admin import Admin  # noqa: F401
from app.models.admin_content import (  # noqa: F401
    AgoraSetting,
    AppSetting,
    AstrologerVideo,
    Banner,
    CosmicService,
    Coupon,
    DiscountType,
    FAQ,
    PromoVideo,
    RazorpaySetting,
)
from app.models.astrologer import Astrologer, KYCStatus  # noqa: F401
from app.models.auth_session import AuthSession  # noqa: F401
from app.models.broadcast import LiveBroadcast  # noqa: F401
from app.models.kyc import AstrologerKYC  # noqa: F401
from app.models.consultation import Consultation, ConsultationStatus, ConsultationType  # noqa: F401,E501
from app.models.device_token import DeviceToken  # noqa: F401
from app.models.follow import AstrologerFollow  # noqa: F401
from app.models.invoice import Invoice  # noqa: F401
from app.models.kundli import KundliReport  # noqa: F401
from app.models.live_engagement import (  # noqa: F401
    EngagementKind,
    LiveEngagementEvent,
    LiveGift,
)
from app.models.message import ConsultationMessage  # noqa: F401
from app.models.notification import (  # noqa: F401
    Notification,
    NotificationBroadcast,
)
from app.models.otp import OtpCode  # noqa: F401
from app.models.payout import AstrologerPayout, PayoutStatus  # noqa: F401
from app.models.profile_edit import (  # noqa: F401
    AstrologerProfileEdit,
    ProfileEditStatus,
)
from app.models.schema_sync import SchemaSyncLog  # noqa: F401
from app.models.support import (  # noqa: F401
    SupportTicket,
    SupportTicketMessage,
)
from app.models.user import User  # noqa: F401
from app.models.wallet import (  # noqa: F401
    TransactionStatus,
    TransactionType,
    WalletTransaction,
)

__all__ = [
    "Admin",
    "AppSetting",
    "AstrologerVideo",
    "Banner",
    "CosmicService",
    "Coupon",
    "DiscountType",
    "FAQ",
    "PromoVideo",
    "RazorpaySetting",
    "Astrologer",
    "KYCStatus",
    "AstrologerKYC",
    "AuthSession",
    "Consultation",
    "ConsultationStatus",
    "ConsultationType",
    "DeviceToken",
    "AstrologerFollow",
    "ConsultationMessage",
    "Notification",
    "NotificationBroadcast",
    "Invoice",
    "KundliReport",
    "LiveBroadcast",
    "EngagementKind",
    "LiveEngagementEvent",
    "LiveGift",
    "OtpCode",
    "AstrologerPayout",
    "PayoutStatus",
    "AstrologerProfileEdit",
    "ProfileEditStatus",
    "SchemaSyncLog",
    "SupportTicket",
    "SupportTicketMessage",
    "User",
    "TransactionStatus",
    "TransactionType",
    "WalletTransaction",
]
