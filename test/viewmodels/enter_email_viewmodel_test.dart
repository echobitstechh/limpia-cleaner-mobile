import 'package:flutter_test/flutter_test.dart';
import 'package:Limpia/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('EnterEmailViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

