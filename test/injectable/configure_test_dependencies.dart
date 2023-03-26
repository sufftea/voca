import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'configure_test_dependencies.config.dart';

const testEnv = 'test';
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'testInit',
  preferRelativeImports: true,
  generateForDir: ['test', 'lib'],
)
Future<GetIt> configureTestDependencies() {
  return getIt.testInit(environment: testEnv);
}
