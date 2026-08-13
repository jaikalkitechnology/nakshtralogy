// Basic smoke test for the astrologer app via the shared model.
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

void main() {
  test('Astrologer.isApproved reflects kyc_status', () {
    const pending = Astrologer(id: '1');
    expect(pending.isApproved, isFalse);

    const approved = Astrologer(id: '1', kycStatus: 'approved');
    expect(approved.isApproved, isTrue);
  });
}
