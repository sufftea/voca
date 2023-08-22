import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voca/injectable/injectable_init.dart';

@module
abstract class Modules {
  @Environment(InjectableEnv.main)
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
