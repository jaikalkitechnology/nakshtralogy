import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import 'core/app_config_repository.dart';
import 'core/di.dart';
import 'features/auth/astro_auth_repository.dart';
import 'features/auth/astro_session_cubit.dart';
import 'features/auth/google_auth.dart';
import 'features/auth/login_cubit.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_cubit.dart';
import 'router/app_router.dart';

class HindustaniAstroApp extends StatelessWidget {
  HindustaniAstroApp({super.key}) : _router = buildRouter(getIt<AstroSessionCubit>());

  final dynamic _router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AstroSessionCubit>.value(value: getIt<AstroSessionCubit>()),
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(getIt<AstroAuthRepository>(), getIt<AstroSessionCubit>(),
              getIt<AppConfigRepository>(), getIt<AstroGoogleSignIn>()),
        ),
      ],
      // Rebuild MaterialApp whenever the selected locale OR theme mode
      // changes. A new MaterialApp *instance* alone isn't enough to refresh
      // AppColors.x everywhere — Flutter's element diffing reuses existing
      // elements (and their last-painted output) for anything that isn't
      // itself marked dirty or reading an InheritedWidget that changed, and
      // AppColors.x is a bare static getter, not one. That's exactly why
      // switching themes made the Theme-driven Scaffold background flip
      // immediately while AppColors.ivory text elsewhere kept painting the
      // stale (pre-switch) value — near-white text left over on a now-white
      // background, i.e. invisible. Keying MaterialApp itself to the
      // resolved brightness forces Flutter to discard and remount the whole
      // subtree on every change, so every AppColors.x read is genuinely
      // fresh. This does NOT reset navigation — GoRouter's own position
      // lives in the stable `_router` object below, not in the Flutter
      // element tree being remounted.
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, locale) {
              return MaterialApp.router(
                key: ValueKey(themeState.brightness),
                onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                // Dark-only app: a single dark theme, pinned. No light theme,
                // no system flip — themeState is permanently dark.
                theme: AppTheme.dark(),
                darkTheme: AppTheme.dark(),
                themeMode: ThemeMode.dark,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}
