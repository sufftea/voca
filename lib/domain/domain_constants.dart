class DomainConstants {
  const DomainConstants._();

  static const maxCardRepetitionsSetting = 14;
  static const minCardRepetitionsSetting = 5;
  static const defaultCardRepetitionsSetting = 6;
  static bool cardRepetitionSettingWithinRange(int n) {
    return n >= minCardRepetitionsSetting && n <= maxCardRepetitionsSetting;
  }
}
