extension DateTimeExt on DateTime {
  static DateTime fromDaysSinceEpoch(int days) {
    return DateTime.fromMillisecondsSinceEpoch(days * 1000 * 60 * 60 * 24);
  }

  int get daysSinceEpoch {
    return millisecondsToDays(millisecondsSinceEpoch);
  }
}

int millisecondsToDays(int milliseconds) {
  return (milliseconds / (1000 * 60 * 60 * 24)).floor();
}
