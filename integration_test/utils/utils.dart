
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'string_x.dart';


Future<void> testCase(
  String description,
  AsyncCallback callback,
) async {
  description = description.trimIndent();

  try {
    await callback();
  } catch (_) {
    debugPrint('[✘] $description'.red());
    rethrow;
  }

  debugPrint('[✔] $description'.green());
}
