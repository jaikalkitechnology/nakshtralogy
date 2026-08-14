// Smoke tests for the profile-section Edit Profile + Bank & PAN screens.
//
// They verify each screen lays out without a frame error and renders its key
// affordances, driving them through the same DI wiring the app uses (getIt for
// PortalRepository + AstroSessionCubit) but with a fake repository so no
// network is touched. The Bank & PAN payload deliberately omits document URLs
// so no Image.network is created during the test.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/auth/astro_auth_repository.dart';
import 'package:hindustani_astro/features/auth/astro_session_cubit.dart';
import 'package:hindustani_astro/features/auth/google_auth.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/features/profile/ui/bank_pan_screen.dart';
import 'package:hindustani_astro/features/profile/ui/edit_profile_screen.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
import 'package:hj_core/hj_core.dart';

class _FakeAuth implements AstroAuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

class _FakeGoogle implements AstroGoogleSignIn {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

/// Only [kycStatus] is exercised; everything else throws if reached.
class _FakePortal implements PortalRepository {
  _FakePortal(this._kyc);
  final Map<String, dynamic> _kyc;

  @override
  Future<Map<String, dynamic>> kycStatus() async => _kyc;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

class _TestSession extends AstroSessionCubit {
  _TestSession() : super(_FakeAuth(), _FakeGoogle());
}

Widget _wrap(Widget child, AstroSessionCubit session) => BlocProvider.value(
      value: session,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  setUp(() {
    getIt.reset();
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('EditProfileScreen lays out and shows the save action',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final session = _TestSession();
    addTearDown(session.close);
    session.onAuthenticated(const Astrologer(
      id: '1',
      displayName: 'Pandit Test',
      skills: ['Vedic'],
      languages: ['Hindi'],
      rateChatPerMsg: '5.00',
      superChatPresets: ['20.00'],
    ));
    getIt.registerSingleton<PortalRepository>(_FakePortal(const {}));
    getIt.registerSingleton<AstroSessionCubit>(session);

    await tester.pumpWidget(_wrap(const EditProfileScreen(), session));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Save changes'), findsOneWidget);
    // Prefilled display name from the seeded session.
    expect(find.text('Pandit Test'), findsOneWidget);
  });

  testWidgets('BankPanScreen renders masked details and the edit CTA',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final session = _TestSession();
    addTearDown(session.close);
    session.onAuthenticated(const Astrologer(id: '1', kycStatus: 'approved'));
    getIt.registerSingleton<PortalRepository>(_FakePortal(const {
      'kyc_status': 'approved',
      'payout_method': 'bank',
      'bank_name': 'State Bank of India',
      'bank_account_holder': 'Test Astrologer',
      'bank_account_last4': '4321',
      'bank_ifsc': 'SBIN0001234',
      'pan_number': 'ABCDE1234F',
      'aadhaar_last4': '9876',
    }));
    getIt.registerSingleton<AstroSessionCubit>(session);

    await tester.pumpWidget(_wrap(const BankPanScreen(), session));
    // Resolve the kycStatus() future and rebuild.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);
    expect(find.text('State Bank of India'), findsOneWidget);
    // Masked account chip (last4 only).
    expect(find.text('•••• 4321'), findsOneWidget);
    // Edit CTA present (details exist -> "Edit", not "Add").
    expect(find.text('Edit bank & PAN details'), findsOneWidget);
    // Approval note shown for an approved astrologer.
    expect(
      find.textContaining('admin approval'),
      findsWidgets,
    );
  });
}
