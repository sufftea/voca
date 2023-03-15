class Flavors {
  const Flavors._();

  static const current = String.fromEnvironment('FLAVOR');

  static const dev = 'dev';
  static const production = 'production';
}
