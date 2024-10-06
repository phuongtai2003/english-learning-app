import 'package:final_flashcard/features/learning/domain/entities/quiz.dart';
import 'package:final_flashcard/features/topic/data/model/vocabulary.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required VocabularyModel? vocabulary,
    required List<VocabularyModel>? options,
    required bool? isCorrect,
    required VocabularyModel? answer,
    required bool? findDefinition,
    required bool? isPromptTerm,
    required String? answerText,
  }) : super(
          vocabulary: vocabulary,
          options: options,
          isCorrect: isCorrect,
          answer: answer,
          findDefinition: findDefinition,
          isPromptTerm: isPromptTerm,
          answerText: answerText,
        );

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      vocabulary: json['vocabulary'] != null
          ? VocabularyModel.fromJson(json['vocabulary'])
          : null,
      options: json['options'] != null
          ? json['options']
              .map<VocabularyModel>((e) => VocabularyModel.fromJson(e))
              .toList()
          : [],
      isCorrect: json['isCorrect'],
      findDefinition: json['findDefinition'],
      isPromptTerm: json['isPromptTerm'],
      answer: json['answer'] != null
          ? VocabularyModel.fromJson(json['answer'])
          : null,
      answerText: json['answerText'],
    );
  }

  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      vocabulary: quiz.vocabulary != null
          ? VocabularyModel.fromEntity(quiz.vocabulary!)
          : null,
      options: quiz.options != null
          ? quiz.options!
              .map<VocabularyModel>((e) => VocabularyModel.fromEntity(e))
              .toList()
          : [],
      isCorrect: quiz.isCorrect,
      findDefinition: quiz.findDefinition,
      isPromptTerm: quiz.isPromptTerm,
      answer:
          quiz.answer != null ? VocabularyModel.fromEntity(quiz.answer!) : null,
      answerText: quiz.answerText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocabulary': vocabulary != null
          ? VocabularyModel.fromEntity(vocabulary!).toJson()
          : null,
      'options': options != null
          ? options!
              .map(
                (e) => VocabularyModel.fromEntity(e).toJson(),
              )
              .toList()
          : [],
      'isCorrect': isCorrect,
      'findDefinition': findDefinition,
      'isPromptTerm': isPromptTerm,
      'answer':
          answer != null ? VocabularyModel.fromEntity(answer!).toJson() : null,
      'answerText': answerText,
    };
  }
}
