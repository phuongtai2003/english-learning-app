import 'package:equatable/equatable.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';

class Quiz extends Equatable {
  final Vocabulary? vocabulary;
  final List<Vocabulary>? options;
  final Vocabulary? answer;
  final String? answerText;
  final bool? isCorrect;
  final bool? findDefinition;
  final bool? isPromptTerm;

  const Quiz({
    required this.vocabulary,
    required this.options,
    required this.answer,
    required this.isCorrect,
    required this.findDefinition,
    required this.isPromptTerm,
    required this.answerText,
  });

  @override
  List<Object?> get props => [
        vocabulary,
        options,
        isCorrect,
        findDefinition,
        isPromptTerm,
        answer,
      ];

  Quiz copyWith({
    Vocabulary? vocabulary,
    List<Vocabulary>? options,
    Vocabulary? answer,
    bool? isCorrect,
    bool? findDefinition,
    bool? isPromptTerm,
    String? answerText,
  }) {
    return Quiz(
      vocabulary: vocabulary ?? this.vocabulary,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      findDefinition: findDefinition ?? this.findDefinition,
      isPromptTerm: isPromptTerm ?? this.isPromptTerm,
      answerText: answerText ?? this.answerText,
    );
  }
}
