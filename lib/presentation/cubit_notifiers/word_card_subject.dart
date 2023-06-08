import 'package:injectable/injectable.dart';
import 'package:voca/domain/entities/word_card.dart';
import 'package:voca/presentation/base/utils/base_subject.dart';

@LazySingleton()
class WordCardSubject extends BaseSubject<WordCard> {}
