class ApiConstants {
  static const String baseUrl = 'https://api.nakshatralogy.com/api/v1';
  static const String userBase = '$baseUrl/user';
  static const String astrologerBase = '$baseUrl/astrologer';

  // User Auth
  static const String userSignup = '$userBase/signup';
  static const String userLogin = '$userBase/login';
  static const String userGoogleLogin = '$userBase/google-login';
  static const String userForgotPassword = '$userBase/forgot-password';
  static const String userResetPassword = '$userBase/reset-password';
  static const String userRefresh = '$userBase/refresh';
  static const String userMe = '$userBase/me';

  // Astrologer public
  static const String astrologerList = '$astrologerBase/list';

  // Kundli
  static const String kundliBase = '$baseUrl/kundli';

  // Career Specialist
  static const String careerBase = '$baseUrl/career';

  // Character Analysis
  static const String characterBase = '$baseUrl/character';

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

  // WebSocket
  static const String wsBase = 'wss://api.nakshatralogy.com';
  static const String wsChat = '$wsBase/ws/chat';
  static const String wsAgentChat = '$wsBase/ws/agent/chat';
}

class AppConstants {
  static const String appName = 'Nakshtralogy';
  static const String tagline = 'Your Cosmic Journey Awaits';
}
