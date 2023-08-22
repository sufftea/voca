import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable_init.config.dart';

const _env = String.fromEnvironment("INJECTABLE_ENV", defaultValue: InjectableEnv.main);

final getIt = GetIt.instance;

class InjectableEnv {
  const InjectableEnv._();

  static const main = 'main';
  static const test = 'test';
  static const integration = 'integration';
}

@InjectableInit()
Future<void> configureDependencies([String env = _env]) {
  return getIt.init(environment: env);
}