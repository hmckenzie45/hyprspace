import 'package:flutter_test/flutter_test.dart';

import 'package:hyprspace_flutter/core/utils/validators.dart';

void main() {
  group('Validators.validateIpAddress', () {
    test('accepts valid IPv4', () {
      expect(Validators.validateIpAddress('10.1.1.1'), isNull);
      expect(Validators.validateIpAddress('192.168.0.255'), isNull);
    });

    test('rejects invalid inputs', () {
      expect(Validators.validateIpAddress(''), isNotNull);
      expect(Validators.validateIpAddress(null), isNotNull);
      expect(Validators.validateIpAddress('256.0.0.1'), isNotNull);
      expect(Validators.validateIpAddress('10.1.1'), isNotNull);
      expect(Validators.validateIpAddress('not-an-ip'), isNotNull);
    });
  });

  group('Validators.validateCidr', () {
    test('accepts valid CIDR', () {
      expect(Validators.validateCidr('10.1.1.1/24'), isNull);
      expect(Validators.validateCidr('192.168.0.0/16'), isNull);
      expect(Validators.validateCidr('0.0.0.0/0'), isNull);
    });

    test('rejects invalid inputs', () {
      expect(Validators.validateCidr('10.1.1.1'), isNotNull);
      expect(Validators.validateCidr('10.1.1.1/33'), isNotNull);
      expect(Validators.validateCidr(''), isNotNull);
      expect(Validators.validateCidr(null), isNotNull);
    });
  });

  group('Validators.validatePort', () {
    test('accepts valid ports', () {
      expect(Validators.validatePort(1), isNull);
      expect(Validators.validatePort(8001), isNull);
      expect(Validators.validatePort(65535), isNull);
    });

    test('rejects out-of-range values', () {
      expect(Validators.validatePort(null), isNotNull);
      expect(Validators.validatePort(0), isNotNull);
      expect(Validators.validatePort(65536), isNotNull);
      expect(Validators.validatePort(-1), isNotNull);
    });
  });

  group('Validators.validatePeerId', () {
    test('accepts non-empty IDs of sufficient length', () {
      expect(
          Validators.validatePeerId('QmYyQSo1c1Ym7orWxLYvCrzRX5As14boGgrF1DhySeg8P7'),
          isNull);
    });

    test('rejects empty or too-short IDs', () {
      expect(Validators.validatePeerId(null), isNotNull);
      expect(Validators.validatePeerId(''), isNotNull);
      expect(Validators.validatePeerId('short'), isNotNull);
    });
  });

  group('Validators.validateInterfaceName', () {
    test('accepts valid names', () {
      expect(Validators.validateInterfaceName('hs0'), isNull);
      expect(Validators.validateInterfaceName('vpn-1'), isNull);
      expect(Validators.validateInterfaceName('hypr_space'), isNull);
    });

    test('rejects invalid names', () {
      expect(Validators.validateInterfaceName(''), isNotNull);
      expect(Validators.validateInterfaceName(null), isNotNull);
      expect(Validators.validateInterfaceName('has spaces'), isNotNull);
      expect(Validators.validateInterfaceName('has/slash'), isNotNull);
    });
  });

  group('Validators.isValidBase64Key', () {
    test('returns false for null or empty', () {
      expect(Validators.isValidBase64Key(null), isFalse);
      expect(Validators.isValidBase64Key(''), isFalse);
    });

    test('returns false for non-base64 string', () {
      expect(Validators.isValidBase64Key('not-base64!!!'), isFalse);
    });
  });
}
