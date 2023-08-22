import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voca/injectable/injectable_init.dart';

@module
abstract class IntegrationModules {
  @Environment(InjectableEnv.integration)
  @preResolve
  Future<SharedPreferences> get prefs async {

    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    return SharedPreferences.getInstance();
  }
}
