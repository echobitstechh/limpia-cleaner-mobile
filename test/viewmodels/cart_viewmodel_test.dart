import 'package:flutter_test/flutter_test.dart';
import 'package:limpia/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CartViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
