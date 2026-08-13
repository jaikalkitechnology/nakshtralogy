/// Runtime configuration. Override [apiBaseUrl] via --dart-define=API_BASE_URL=...
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  final String apiBaseUrl;

  static const _envBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://fastapi.hindustanijyotish.com/v1',
  );

  /// Default config. `10.0.2.2` is the Android emulator's host loopback.
  factory AppConfig.fromEnv() => const AppConfig(apiBaseUrl: _envBase);
}
