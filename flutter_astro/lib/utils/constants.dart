class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
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
  static const String computeDasha = '$serviceBase/compute/dasha';
  static const String computeMoola = '$serviceBase/compute/moola';
  static const String computeGochar = '$serviceBase/compute/gochar';
}

class AppConstants {
  static const String appName = 'Nakshtralogy Astro';
  static const String tagline = 'Astrologer Panel';
}
