import 'package:get_it/get_it.dart';
import 'package:hj_core/hj_core.dart';

import '../features/auth/astro_auth_repository.dart';
import '../features/auth/astro_session_cubit.dart';
import '../features/auth/google_auth.dart';
import '../features/notifications/notification_repository.dart';
import '../features/portal/portal_repository.dart';
import '../features/support/support_repository.dart';
import '../l10n/locale_cubit.dart';
import 'app_config_repository.dart';
import 'push/pending_request_action.dart';
import 'push/push_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  final config = AppConfig.fromEnv();
  final tokens = TokenStore();
  final api = ApiClient(config: config, tokenStore: tokens);

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<TokenStore>(tokens)
    ..registerSingleton<WakelockService>(const WakelockService())
    ..registerSingleton<ApiClient>(api)
    ..registerSingleton<AstroAuthRepository>(AstroAuthRepository(api: api, tokens: tokens))
    ..registerSingleton<AppConfigRepository>(AppConfigRepository(api))
    ..registerSingleton<AstroGoogleSignIn>(AstroGoogleSignIn())
    ..registerLazySingleton<PortalRepository>(() => PortalRepository(api, config, tokens))
    ..registerLazySingleton<NotificationRepository>(() => NotificationRepository(api))
    ..registerLazySingleton<SupportRepository>(() => SupportRepository(api, app: 'astro'))
    ..registerSingleton<PushService>(PushService(api))
    ..registerSingleton<PendingRequestAction>(PendingRequestAction())
    ..registerSingleton<LocaleCubit>(LocaleCubit())
    ..registerSingleton<ThemeCubit>(ThemeCubit());

  final session = AstroSessionCubit(getIt<AstroAuthRepository>(), getIt<AstroGoogleSignIn>());
  api.onSessionExpired = session.sessionExpired;
  getIt.registerSingleton<AstroSessionCubit>(session);
}
