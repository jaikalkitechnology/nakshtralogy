class ApiConstants {
  static const String baseUrl = 'https://api.nakshatralogy.com/api/v1';
  static const String userBase = '$baseUrl/user';
  static const String astrologerBase = '$baseUrl/astrologer';

  // User Auth
  static const String userSignup = '$userBase/signup';
  static const String userSignupSendOtp = '$userBase/signup/send-otp';
  static const String userSignupVerifyOtp = '$userBase/signup/verify-otp';
  static const String userSignupResendOtp = '$userBase/signup/resend-otp';
  static const String userLogin = '$userBase/login';
  static const String userGoogleLogin = '$userBase/google-login';
  static const String userForgotPassword = '$userBase/forgot-password';
  static const String userResetPassword = '$userBase/reset-password';
  static const String userForgotSendOtp = '$userBase/forgot-password/send-otp';
  static const String userForgotReset = '$userBase/forgot-password/reset';
  static const String userChangePwdSendOtp = '$userBase/me/password/send-otp';
  static const String userChangePwdWithOtp = '$userBase/me/password/change';
  static const String userRefresh = '$userBase/refresh';
  static const String userMe = '$userBase/me';

  // Google server-side OAuth (shared redirect flow — role=user).
  // login-url → Google → callback redirects to `frontendReturnUrl` (web) or the
  // mobile deep link with ?token=&refresh=. verify accepts a native id_token.
  static const String googleBase = '$baseUrl/google';
  static const String googleLoginUrl = '$googleBase/login-url';
  static const String googleVerify = '$googleBase/verify';

  // Web push (public runtime config + token registration).
  static const String webpushConfig = '$baseUrl/config/webpush';
  static const String userPushRegister = '$userBase/push/register';

  // Auth callback return targets.
  // Web: the SPA route the backend redirects to with ?token=&refresh=.
  // Mobile: the custom-scheme deep link the external browser returns through.
  static const String webAuthCallbackUrl = 'https://app.nakshatralogy.com/auth/callback';
  static const String mobileAuthCallback = 'nakshatralogy://auth/callback';

  // Astrologer public
  static const String astrologerList = '$astrologerBase/list';

  // Kundli
  static const String kundliBase = '$baseUrl/kundli';

  // Career Specialist
  static const String careerBase = '$baseUrl/career';

  // Character Analysis
  static const String characterBase = '$baseUrl/character';

  // Kundli Milan
  static const String milanBase = '$baseUrl/milan';

  // Dept Reports (15 specialists)
  static const String specialistBase = '$baseUrl/specialist';

  // Daily Forecast & Rashi
  static const String forecastBase = '$baseUrl/forecast';

  // AI Config (languages, domains from DB)
  static const String aiConfigBase = '$baseUrl/ai-config';

  // Rashi (zodiac)
  static const String rashiBase = '$baseUrl/rashi';

  // AI Agent
  static const String agentBase = '$baseUrl/agent';
  static const String agentChat = '$agentBase/chat';
  static const String agentDomains = '$agentBase/domains';

  // Service
  static const String serviceBase = '$baseUrl/service';
  static const String servicePricing = '$serviceBase/pricing';
  static const String serviceCharts = '$serviceBase/charts';
  static const String servicePurchase = '$serviceBase/purchase';
  static const String serviceOrders = '$serviceBase/orders';
  static const String serviceEntitlements = '$serviceBase/entitlements';
  static const String citySearch = '$serviceBase/city-search';
  static const String computeDasha = '$serviceBase/compute/dasha';
  static const String computeGochar = '$serviceBase/compute/gochar';

  // Communication
  static const String commBase = '$baseUrl/comm';
  static const String callInitiate = '$commBase/call/initiate';
  static const String callHistory = '$commBase/call/history';
  static const String liveActive = '$commBase/live/active';
  static const String chatInitiate = '$commBase/chat/initiate';
  static const String chatHistory = '$commBase/chat/history';
  static const String gifts = '$commBase/gifts';

  // Notifications
  static const String notifications = '$baseUrl/notifications';

  // WebSocket
  static const String wsBase = 'wss://api.nakshatralogy.com';
  static const String wsChat = '$wsBase/ws/chat';
  static const String wsAgentChat = '$wsBase/ws/agent/chat';
}

class AppConstants {
  static const String appName = 'Nakshatralogy';
  static const String tagline = 'Your Cosmic Journey Awaits';
}
