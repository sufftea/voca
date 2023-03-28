import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable_init.config.dart';

const mainEnv = 'main';

final getIt = GetIt.instance;
@InjectableInit()
Future<void> configureDependencies() {
  return getIt.init(environment: mainEnv);
}
