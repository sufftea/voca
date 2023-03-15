import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:voca/utils/flavors.dart';
import 'injectable_init.config.dart';

final getIt = GetIt.instance;
@InjectableInit()
void configureDependencies() => getIt.init(
      environment: Flavors.current,
    );
