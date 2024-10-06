import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/repository/topic_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FavoriteVocabularyUseCase implements UseCaseWithParams<Vocabulary, int> {
  final TopicRepository _vocabularyRepository;

  FavoriteVocabularyUseCase(this._vocabularyRepository);

  @override
  ResultFuture<Vocabulary> call(int params) async {
    return await _vocabularyRepository.favoriteVocabulary(params);
  }
}
