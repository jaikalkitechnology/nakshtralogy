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

  // Service
  static const String serviceBase = '$baseUrl/service';
  static const String servicePricing = '$serviceBase/pricing';
  static const String serviceCharts = '$serviceBase/charts';
  static const String servicePurchase = '$serviceBase/purchase';
  static const String serviceOrders = '$serviceBase/orders';
  static const String computeDasha = '$serviceBase/compute/dasha';
  static const String computeGochar = '$serviceBase/compute/gochar';

  // Communication
  static const String commBase = '$baseUrl/comm';
  static const String callInitiate = '$commBase/call/initiate';
  static const String liveActive = '$commBase/live/active';
  static const String chatInitiate = '$commBase/chat/initiate';
  static const String gifts = '$commBase/gifts';

  // WebSocket
  static const String wsBase = 'wss://api.nakshatralogy.com';
  static const String wsChat = '$wsBase/ws/chat';
}

class AppConstants {
  static const String appName = 'Nakshtralogy';
  static const String tagline = 'Your Cosmic Journey Awaits';
}
