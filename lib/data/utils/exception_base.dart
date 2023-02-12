abstract class ExceptionBase implements Exception {
  const ExceptionBase(this.message);
  
  final String message;

  String get name;

  @override
  String toString() {
    return '$name: $message';
  }
}