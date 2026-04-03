class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
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
}

class AppConstants {
  static const String appName = 'Nakshtralogy';
  static const String tagline = 'Your Cosmic Journey Awaits';
}
