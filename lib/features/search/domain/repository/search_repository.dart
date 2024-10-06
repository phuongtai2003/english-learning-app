import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';

abstract class SearchRepostory {
  ResultFuture<List<Topic>> fetchSearchTopics();
}
