class ApiConstants {
  static const String baseUrl = 'https://api.nakshatralogy.com/api/v1';
  static const String astrologerBase = '$baseUrl/astrologer';

  // Astrologer Auth
  static const String astroSignup = '$astrologerBase/signup';
  static const String astroLogin = '$astrologerBase/login';
  static const String astroGoogleLogin = '$astrologerBase/google-login';
  static const String astroForgotPassword = '$astrologerBase/forgot-password';
  static const String astroResetPassword = '$astrologerBase/reset-password';
  static const String astroRefresh = '$astrologerBase/refresh';
  static const String astroMe = '$astrologerBase/me';
  static const String astroProfile = '$astrologerBase/me/profile';
  static const String astroStatus = '$astrologerBase/me/status';
  // Service (astrologers also create charts for clients)
  static const String serviceBase = '$baseUrl/service';
  static const String servicePricing = '$serviceBase/pricing';
  static const String serviceCharts = '$serviceBase/charts';
  static const String servicePurchase = '$serviceBase/purchase';
  static const String serviceOrders = '$serviceBase/orders';
  static const String citySearch = '$serviceBase/city-search';
  static const String computeDasha = '$serviceBase/compute/dasha';
  static const String computeMoola = '$serviceBase/compute/moola';
  static const String computeGochar = '$serviceBase/compute/gochar';

  // Communication
  static const String kundliBase = '$baseUrl/kundli';

  // Career Specialist
  static const String careerBase = '$baseUrl/career';

  // Character Analysis
  static const String characterBase = '$baseUrl/character';

  // Kundli Milan
  static const String milanBase = '$baseUrl/milan';

  // Rashi (zodiac predictions)
  static const String rashiBase = '$baseUrl/rashi';
  static const String commBase = '$baseUrl/comm';
  static const String liveCreate = '$commBase/live/create';
  static const String chatHistory = '$commBase/chat/history';
  static const String callHistory = '$commBase/call/history';
  static const String gifts = '$commBase/gifts';

  // WebSocket
  static const String wsBase = 'wss://api.nakshatralogy.com';
  static const String wsChat = '$wsBase/ws/chat';
}

class AppConstants {
  static const String appName = 'Nakshtralogy Astro';
  static const String tagline = 'Astrologer Panel';
}
