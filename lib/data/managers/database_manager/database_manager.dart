import 'package:sqflite/sqflite.dart';

abstract class DatabaseManager {
  Database get db;

  static const userProgressPath = 'en_user_progress.db';

  Future<void> init();
}
