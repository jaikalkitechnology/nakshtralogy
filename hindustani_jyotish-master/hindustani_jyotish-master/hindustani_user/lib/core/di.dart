import 'package:get_it/get_it.dart';
import 'package:hj_core/hj_core.dart';

import '../features/discovery/discovery_repository.dart';
import '../features/wallet/wallet_repository.dart';
import '../features/wallet/wallet_checkout.dart';
import '../features/insights/insights_repository.dart';
import '../features/invoices/invoice_repository.dart';
import '../features/config/app_config_repository.dart';
import '../features/consultation/consultation_repository.dart';
import '../features/home/banners_repository.dart';
import '../features/home/promo_videos_repository.dart';
import '../features/live/broadcast_repository.dart';
import '../features/profile/profile_repository.dart';
import '../l10n/locale_cubit.dart';
import 'maintenance/maintenance_repository.dart';
import 'push/push_service.dart';

final getIt = GetIt.instance;

/// Wire up singletons. Call once at startup before running the app.
void configureDependencies() {
  final config = AppConfig.fromEnv();
  final tokens = TokenStore();
  final api = ApiClient(config: config, tokenStore: tokens);

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<TokenStore>(tokens)
    ..registerSingleton<WakelockService>(const WakelockService())
    ..registerSingleton<ApiClient>(api)
    ..registerSingleton<AuthRepository>(
        AuthRepository(api: api, tokens: tokens, config: config))
    ..registerLazySingleton<AppConfigRepository>(() => AppConfigRepository(api))
    ..registerLazySingleton<DiscoveryRepository>(() => DiscoveryRepository(api))
    ..registerLazySingleton<WalletRepository>(() => WalletRepository(api))
    ..registerLazySingleton<WalletCheckout>(() => WalletCheckout(getIt<WalletRepository>()))
    ..registerLazySingleton<InsightsRepository>(() => InsightsRepository(api))
    ..registerLazySingleton<InvoiceRepository>(() => InvoiceRepository(api))
    ..registerLazySingleton<ConsultationRepository>(() => ConsultationRepository(api))
    ..registerLazySingleton<BroadcastRepository>(() => BroadcastRepository(api))
    ..registerLazySingleton<PromoVideosRepository>(() => PromoVideosRepository(api))
    ..registerLazySingleton<BannersRepository>(() => BannersRepository(api))
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepository(api))
    ..registerLazySingleton<MaintenanceRepository>(() => MaintenanceRepository(api))
    ..registerLazySingleton<PushService>(() => PushService(api));

  // Single app-wide AuthCubit; the API client tells it when the session dies.
  final authCubit = AuthCubit(getIt<AuthRepository>());
  api.onSessionExpired = authCubit.sessionExpired;
  getIt.registerSingleton<AuthCubit>(authCubit);

  // App-wide locale controller (persisted in secure storage).
  getIt.registerSingleton<LocaleCubit>(LocaleCubit());

  // App-wide light/dark mode controller (persisted in secure storage).
  getIt.registerSingleton<ThemeCubit>(ThemeCubit());
}
