import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/use_case/use_case.dart';
import 'package:final_flashcard/features/search/domain/repository/search_repository.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchSearchTopicsUseCase extends UseCaseWithoutParams<List<Topic>> {
  final SearchRepostory _searchRepostory;

  FetchSearchTopicsUseCase(this._searchRepostory);

  @override
  ResultFuture<List<Topic>> call() async {
    return await _searchRepostory.fetchSearchTopics();
  }
}
