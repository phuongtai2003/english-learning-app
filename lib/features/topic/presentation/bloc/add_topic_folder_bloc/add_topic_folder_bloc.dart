import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/add_topics_to_folder.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_available_topics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_topic_folder_event.dart';
part 'add_topic_folder_state.dart';

part 'add_topic_folder_bloc.freezed.dart';

class AddTopicFolderBloc
    extends Bloc<AddTopicFolderEvent, AddTopicFolderState> {
  final GetAvailableTopicsUseCase _getAvailableTopicsUseCase;
  final AddTopicsToFolderUseCase _addTopicsToFolderUseCase;
  AddTopicFolderBloc(
      this._getAvailableTopicsUseCase, this._addTopicsToFolderUseCase)
      : super(const AddTopicFolderState.initial(AddTopicFolderStateData())) {
    on<GetAvailableTopics>(_onGetAvailableTopics);
    on<TriggerSelectTopic>(_onTriggerSelectTopic);
    on<AddTopicsToFolder>(_onAddTopicsToFolder);
  }

  void _onAddTopicsToFolder(
    AddTopicsToFolder event,
    Emitter<AddTopicFolderState> emit,
  ) async {
    emit(AddTopicFolderState.loading(state.data));
    final res = await _addTopicsToFolderUseCase(
      AddTopicsToFolderParams(
        state.data.selectedTopics.map((e) => e.id!).toList(),
        state.data.folder!.id!,
      ),
    );
    res.fold(
      (failure) {
        emit(
          AddTopicFolderState.addedError(
            state.data.copyWith(error: failure.message),
          ),
        );
      },
      (topics) {
        emit(
          AddTopicFolderState.addedSuccess(
            state.data.copyWith(
              selectedTopics: [],
              availableTopics: state.data.availableTopics
                  .where(
                      (element) => !state.data.selectedTopics.contains(element))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _onTriggerSelectTopic(
    TriggerSelectTopic event,
    Emitter<AddTopicFolderState> emit,
  ) {
    final selectedTopics = [...state.data.selectedTopics];
    if (selectedTopics.contains(event.topic)) {
      selectedTopics.remove(event.topic);
    } else {
      selectedTopics.add(event.topic);
    }
    emit(
      AddTopicFolderState.loaded(
        state.data.copyWith(selectedTopics: selectedTopics),
      ),
    );
  }

  void _onGetAvailableTopics(
    GetAvailableTopics event,
    Emitter<AddTopicFolderState> emit,
  ) async {
    emit(
      AddTopicFolderState.loading(
        state.data.copyWith(folder: event.folder),
      ),
    );
    final res = await _getAvailableTopicsUseCase(event.folder.id!);
    res.fold(
      (failure) {
        emit(
          AddTopicFolderState.error(
            state.data.copyWith(error: failure.message),
          ),
        );
      },
      (topics) {
        emit(
          AddTopicFolderState.loaded(
            state.data.copyWith(availableTopics: topics),
          ),
        );
      },
    );
  }
}
