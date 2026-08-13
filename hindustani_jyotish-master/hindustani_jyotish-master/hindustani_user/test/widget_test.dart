// Basic smoke test for the Hindustani Jyotish user app.
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

void main() {
  test('AppUser.profileComplete reflects name + contact number', () {
    // Mobile alone (OTP login) is not enough — the name is still missing.
    const noName = AppUser(id: '1', mobile: '9000000000', countryCode: '+91');
    expect(noName.profileComplete, isFalse);

    // Name alone (Google login) is not enough — the contact is missing.
    const noMobile = AppUser(id: '1', name: 'Arjun');
    expect(noMobile.profileComplete, isFalse);

    // Birth details are NOT part of the signup gate anymore (spec §2).
    const complete =
        AppUser(id: '1', name: 'Arjun', mobile: '9000000000', countryCode: '+91');
    expect(complete.profileComplete, isTrue);
  });
}
