import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_flashcard/core/utils/helper.dart';
import 'package:final_flashcard/features/topic/domain/entities/flashcard_vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/add_topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/delete_topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/update_topic.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_topic_event.dart';
part 'add_topic_state.dart';

part 'add_topic_bloc.freezed.dart';

class AddTopicBloc extends Bloc<AddTopicEvent, AddTopicState> {
  final Helper _helper;
  final AddTopicUseCase _addTopicUseCase;
  final DeleteTopicUseCase _deleteTopicUseCase;
  final UpdateTopicUseCase _updateTopicUseCase;
  AddTopicBloc(
    this._addTopicUseCase,
    this._helper,
    this._deleteTopicUseCase,
    this._updateTopicUseCase,
  ) : super(
          const AddTopicState.initial(
            AddTopicStateData(),
          ),
        ) {
    on<ChangeFlashcardIndex>(_changeFlashcardIndex);
    on<AddFlashcard>(_addFlashcard);
    on<PickImage>(_pickImage);
    on<RemoveImage>(_removeImage);
    on<ChangeTermLanguage>(_changeTermLanguage);
    on<ChangeDefinitionLanguage>(_changeDefinitionLanguage);
    on<ChangeTopicPublic>(_changeTopicPublic);
    on<AddTopic>(_addTopic);
    on<RemoveFlashcard>(_removeFlashcard);
    on<LoadedTopic>(_loadedTopic);
    on<DeleteTopic>(_deleteTopic);
    on<UpdateTopicEvent>(_updateTopic);
    on<ImportCsvFileEvent>(_importCsvFile);
  }

  void _updateTopic(
    UpdateTopicEvent event,
    Emitter<AddTopicState> emit,
  ) async {
    emit(
      AddTopicState.loading(
        state.data,
      ),
    );
    final oldVocabulariesIds = state.data.flashcardsList
        .where((element) => element.vocabulary?.id != null)
        .map(
          (e) => e.vocabulary!.id!.toString(),
        )
        .toList();
    final oldVocabulariesTerms = state.data.flashcardsList
        .where((element) => element.vocabulary?.id != null)
        .map((e) => e.cardTermController.text)
        .toList();

    final oldVocabulariesDefinitions = state.data.flashcardsList
        .where((element) => element.vocabulary?.id != null)
        .map((e) => e.cardDefinitionController.text)
        .toList();
    final newVocabulariesTerms = state.data.flashcardsList
        .where((element) => element.vocabulary?.id == null)
        .map((e) => e.cardTermController.text)
        .toList();
    final newVocabulariesDefinitions = state.data.flashcardsList
        .where((element) => element.vocabulary?.id == null)
        .map((e) => e.cardDefinitionController.text)
        .toList();
    final deletedVocabulariesIds = state.data.currentTopic!.vocabularies!
        .where(
          (element) => !state.data.flashcardsList
              .map((e) => e.vocabulary?.id)
              .contains(element.id),
        )
        .map((e) => e.id!.toString())
        .toList();
    final isHasImage = state.data.flashcardsList
        .map((e) => e.vocabulary?.image != null)
        .toList();
    final images = state.data.flashcardsList
        .map((e) => e.vocabulary?.image)
        .where((element) => element != null)
        .map((e) => e!)
        .toList();

    final params = UpdateTopicParams(
      topicId: state.data.currentTopic!.id!,
      topicName: event.topicName,
      topicDescription: event.topicDescription,
      definitionLanguage: state.data.definitionLanguage,
      termLanguage: state.data.termLanguage,
      oldVocabulariesIds: oldVocabulariesIds,
      oldVocabulariesTerms: oldVocabulariesTerms,
      oldVocabulariesDefinitions: oldVocabulariesDefinitions,
      newVocabulariesTerms: newVocabulariesTerms,
      newVocabulariesDefinitions: newVocabulariesDefinitions,
      deletedVocabulariesIds: deletedVocabulariesIds,
      imagesList: images,
      hasImages: isHasImage.map((e) => e.toString()).toList(),
    );

    final res = await _updateTopicUseCase(params);

    res.fold(
      (l) {
        emit(
          AddTopicState.error(
            state.data.copyWith(
              error: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          AddTopicState.updateTopicSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _deleteTopic(
    DeleteTopic event,
    Emitter<AddTopicState> emit,
  ) async {
    emit(
      AddTopicState.loading(
        state.data,
      ),
    );
    final res = await _deleteTopicUseCase(
      state.data.currentTopic!.id!,
    );
    res.fold(
      (l) {
        emit(
          AddTopicState.deleteTopicError(
            state.data.copyWith(
              error: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          AddTopicState.deleteTopicSuccess(
            state.data,
          ),
        );
      },
    );
  }

  void _loadedTopic(
    LoadedTopic event,
    Emitter<AddTopicState> emit,
  ) async {
    emit(
      AddTopicState.loading(
        state.data,
      ),
    );
    final flashcardWidgetsList = await Future.wait(
      event.topic.vocabularies!.map(
        (e) async {
          final image = e.image != null
              ? await _helper.urlToFile(
                  url: e.image!,
                )
              : null;
          return FlashCardWidget(
            vocabulary: FlashCardVocabulary(
              id: e.id,
              term: e.term,
              definition: e.definition,
              image: image,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
            ),
            cardTermController: TextEditingController(
              text: e.term ?? '',
            ),
            cardDefinitionController: TextEditingController(
              text: e.definition ?? '',
            ),
            cardImage: image,
            onImagePicked: (image) {
              add(
                PickImage(
                  state.data.flashcardIndex,
                  image,
                ),
              );
            },
            onRemoveImage: () {
              add(
                RemoveImage(
                  state.data.flashcardIndex,
                ),
              );
            },
            onRemove: () {
              add(
                RemoveFlashcard(
                  state.data.flashcardIndex,
                ),
              );
            },
          );
        },
      ).toList(),
    );

    final imagesList = await Future.wait(
      event.topic.vocabularies!.map(
        (e) async {
          if (e.image == null) return null;
          return await _helper.urlToFile(
            url: e.image!,
          );
        },
      ).toList(),
    );
    emit(
      AddTopicState.loaded(
        state.data.copyWith(
          currentTopic: event.topic,
          flashcardsList: flashcardWidgetsList,
          images: imagesList,
          termLanguage: event.topic.termLocale ?? 'en',
          definitionLanguage: event.topic.definitionLocale ?? 'en',
          isTopicPublic: event.topic.isPublic ?? false,
          isNewTopic: false,
        ),
      ),
    );
  }

  void _removeFlashcard(
    RemoveFlashcard event,
    Emitter<AddTopicState> emit,
  ) {
    final flashcardsList = [
      ...state.data.flashcardsList,
    ];
    final images = [
      ...state.data.images,
    ];
    flashcardsList.removeAt(event.index);
    images.removeAt(event.index);
    emit(
      AddTopicState.removeFlashcard(
        state.data.copyWith(
          flashcardsList: flashcardsList,
          images: images,
          flashcardIndex: flashcardsList.isEmpty
              ? -1
              : event.index == flashcardsList.length
                  ? event.index - 1
                  : event.index,
        ),
      ),
    );
  }

  void _changeTopicPublic(
    ChangeTopicPublic event,
    Emitter<AddTopicState> emit,
  ) {
    emit(
      AddTopicState.changeTopicPublic(
        state.data.copyWith(isTopicPublic: event.isPublic),
      ),
    );
  }

  void _changeDefinitionLanguage(
    ChangeDefinitionLanguage event,
    Emitter<AddTopicState> emit,
  ) {
    emit(
      AddTopicState.changeDefinitionLanguage(
        state.data.copyWith(definitionLanguage: event.language),
      ),
    );
  }

  void _changeTermLanguage(
    ChangeTermLanguage event,
    Emitter<AddTopicState> emit,
  ) {
    emit(
      AddTopicState.changeTermLanguage(
        state.data.copyWith(termLanguage: event.language),
      ),
    );
  }

  void _removeImage(
    RemoveImage event,
    Emitter<AddTopicState> emit,
  ) {
    final images = [
      ...state.data.images,
    ];
    final flashcardsList = [
      ...state.data.flashcardsList,
    ];
    images[event.index] = null;
    flashcardsList[event.index] = FlashCardWidget(
      vocabulary: flashcardsList[event.index].vocabulary == null
          ? const FlashCardVocabulary(
              id: null,
              term: null,
              definition: null,
              image: null,
              createdAt: null,
              updatedAt: null,
              deletedAt: null,
            )
          : flashcardsList[event.index].vocabulary?.copyWith(
                image: null,
              ),
      onImagePicked: (image) => add(
        PickImage(
          state.data.flashcardIndex,
          image,
        ),
      ),
      onRemove: () => add(
        RemoveFlashcard(
          state.data.flashcardIndex,
        ),
      ),
      onRemoveImage: () => add(
        RemoveImage(
          state.data.flashcardIndex,
        ),
      ),
      cardDefinitionController:
          flashcardsList[event.index].cardDefinitionController,
      cardTermController: flashcardsList[event.index].cardTermController,
      cardImage: null,
    );
    emit(
      AddTopicState.removeImage(
        state.data.copyWith(
          images: images,
          flashcardsList: flashcardsList,
        ),
      ),
    );
  }

  void _changeFlashcardIndex(
    ChangeFlashcardIndex event,
    Emitter<AddTopicState> emit,
  ) {
    emit(
      AddTopicState.changeIndex(
        state.data.copyWith(flashcardIndex: event.index),
      ),
    );
  }

  void _addFlashcard(
    AddFlashcard event,
    Emitter<AddTopicState> emit,
  ) {
    final flashcardsList = [
      ...state.data.flashcardsList,
    ];
    final images = [
      ...state.data.images,
    ];
    images.add(null);
    flashcardsList.add(
      FlashCardWidget(
        vocabulary: null,
        onRemove: () => add(
          RemoveFlashcard(
            state.data.flashcardIndex,
          ),
        ),
        onImagePicked: (image) => add(
          PickImage(state.data.flashcardIndex, image),
        ),
        onRemoveImage: () {
          add(
            RemoveImage(
              state.data.flashcardIndex,
            ),
          );
        },
        cardDefinitionController: TextEditingController(),
        cardTermController: TextEditingController(),
        cardImage: images[images.length - 1],
      ),
    );
    emit(
      AddTopicState.addFlashcard(
        state.data.copyWith(
          flashcardsList: flashcardsList,
          images: images,
          flashcardIndex: flashcardsList.length - 1,
        ),
      ),
    );
  }

  void _pickImage(
    PickImage event,
    Emitter<AddTopicState> emit,
  ) {
    final images = [
      ...state.data.images,
    ];
    images[event.index] = event.image;

    final flashCardList = [
      ...state.data.flashcardsList,
    ];

    flashCardList[event.index] = FlashCardWidget(
      vocabulary: flashCardList[event.index].vocabulary == null
          ? FlashCardVocabulary(
              id: null,
              term: null,
              definition: null,
              image: event.image,
              createdAt: null,
              updatedAt: null,
              deletedAt: null)
          : flashCardList[event.index].vocabulary?.copyWith(
                image: event.image,
              ),
      onImagePicked: (image) => add(
        PickImage(
          state.data.flashcardIndex,
          image,
        ),
      ),
      onRemove: () => add(
        RemoveFlashcard(
          state.data.flashcardIndex,
        ),
      ),
      onRemoveImage: () => add(
        RemoveImage(
          state.data.flashcardIndex,
        ),
      ),
      cardDefinitionController:
          flashCardList[event.index].cardDefinitionController,
      cardTermController: flashCardList[event.index].cardTermController,
      cardImage: event.image,
    );
    emit(
      AddTopicState.pickImage(
        state.data.copyWith(
          images: images,
          flashcardsList: flashCardList,
        ),
      ),
    );
  }

  void _addTopic(
    AddTopic event,
    Emitter<AddTopicState> emit,
  ) async {
    emit(
      AddTopicState.loading(
        state.data,
      ),
    );
    final params = AddTopicParams(
      topicName: event.topicName,
      topicDescription: event.topicDescription,
      isPublic: state.data.isTopicPublic,
      images: state.data.images
          .where((element) => element != null)
          .map((e) => e!)
          .toList(),
      termLanguage: state.data.termLanguage,
      definitionLanguage: state.data.definitionLanguage,
      terms: state.data.flashcardsList
          .map((e) => e.cardTermController.text)
          .toList(),
      definitions: state.data.flashcardsList
          .map((e) => e.cardDefinitionController.text)
          .toList(),
      indexes: state.data.images
          .asMap()
          .entries
          .where((element) => element.value != null)
          .map((e) => e.key)
          .toList(),
    );
    final res = await _addTopicUseCase(params);
    res.fold(
      (l) {
        emit(
          AddTopicState.error(
            state.data.copyWith(
              error: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          AddTopicState.addTopicSuccess(
            state.data,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    for (var element in state.data.flashcardsList) {
      element.cardTermController.dispose();
      element.cardDefinitionController.dispose();
    }
    return super.close();
  }

  void _importCsvFile(
      ImportCsvFileEvent event, Emitter<AddTopicState> emit) async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (res == null) return;
    final input = File(res.files.single.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    final flashcardsList = [
      ...state.data.flashcardsList,
    ];
    final images = [
      ...state.data.images,
    ];
    for (final field in fields) {
      images.add(null);
      flashcardsList.add(
        FlashCardWidget(
          vocabulary: null,
          onRemove: () => add(
            RemoveFlashcard(
              state.data.flashcardIndex,
            ),
          ),
          onImagePicked: (image) => add(
            PickImage(state.data.flashcardIndex, image),
          ),
          onRemoveImage: () {
            add(
              RemoveImage(
                state.data.flashcardIndex,
              ),
            );
          },
          cardDefinitionController: TextEditingController(
            text: field[1],
          ),
          cardTermController: TextEditingController(
            text: field[0],
          ),
          cardImage: images[images.length - 1],
        ),
      );
    }
    emit(
      AddTopicState.addFlashcard(
        state.data.copyWith(
          flashcardsList: flashcardsList,
          images: images,
          flashcardIndex: flashcardsList.length - 1,
        ),
      ),
    );
  }
}
