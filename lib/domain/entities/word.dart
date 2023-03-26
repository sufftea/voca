import 'package:equatable/equatable.dart';

class Word extends Equatable {
  const Word({
    required this.name,
    required this.id,
  });

  final String name;
  final int id;

  @override
  List<Object?> get props => [
        name,
        id,
      ];
}
