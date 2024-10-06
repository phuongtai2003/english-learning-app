import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/add_folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/add_folder_to_topic.dart';
import 'package:final_flashcard/features/folder/domain/use_case/get_available_folders.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_to_topic_event.dart';
part 'folder_to_topic_state.dart';

part 'folder_to_topic_bloc.freezed.dart';

class FolderToTopicBloc extends Bloc<FolderToTopicEvent, FolderToTopicState> {
  final AddFolderUseCase _addFolderUseCase;
  final GetAvailableFoldersUseCase _availableFoldersUseCase;
  final AddFoldersToTopicUseCase _addFoldersToTopic;
  FolderToTopicBloc(
    this._availableFoldersUseCase,
    this._addFolderUseCase,
    this._addFoldersToTopic,
  ) : super(const FolderToTopicInitial(FolderToTopicStateData())) {
    on<LoadAvailableFolders>(_loadAvailableFolders);
    on<TriggerFolderSelection>(_triggerFolderSelection);
    on<CreateFolder>(_createFolder);
    on<AddFoldersToTopicEvent>(_addFoldersToTopicExecute);
  }

  void _addFoldersToTopicExecute(
      AddFoldersToTopicEvent event, Emitter<FolderToTopicState> emit) async {
    emit(FolderToTopicState.loading(state.data));

    final response = await _addFoldersToTopic(
      AddFoldersToTopicParams(
        state.data.topic!.id!,
        state.data.selectedFolders.map((e) => e.id!).toList(),
      ),
    );

    response.fold(
      (failure) {
        emit(
          FolderToTopicState.addFolderToTopicFailed(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folders) {
        emit(
          FolderToTopicState.addFolderToTopicSuccess(
            state.data.copyWith(
              selectedFolders: [],
              folders: folders,
            ),
          ),
        );
      },
    );
  }

  void _createFolder(
      CreateFolder event, Emitter<FolderToTopicState> emit) async {
    emit(
      FolderToTopicState.loading(state.data),
    );

    final response = await _addFolderUseCase(
      AddFolderParams(
        folderName: event.title,
        folderDescription: event.description,
      ),
    );

    response.fold(
      (failure) {
        emit(
          FolderToTopicState.folderCreationFailed(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folder) {
        emit(
          FolderToTopicState.folderCreatedSuccessfully(
            state.data.copyWith(
              folders: [
                ...state.data.folders,
                folder,
              ],
              selectedFolders: [
                ...state.data.selectedFolders,
                folder,
              ],
            ),
          ),
        );
      },
    );
  }

  void _triggerFolderSelection(
      TriggerFolderSelection event, Emitter<FolderToTopicState> emit) {
    final selectedFolders = [
      ...state.data.selectedFolders,
    ];
    if (selectedFolders.contains(event.folder)) {
      selectedFolders.remove(event.folder);
    } else {
      selectedFolders.add(event.folder);
    }

    emit(
      FolderToTopicState.loaded(
        state.data.copyWith(
          selectedFolders: selectedFolders,
        ),
      ),
    );
  }

  void _loadAvailableFolders(
      LoadAvailableFolders event, Emitter<FolderToTopicState> emit) async {
    emit(FolderToTopicState.loading(state.data));

    final response = await _availableFoldersUseCase(event.topic.id!);

    response.fold(
      (failure) {
        emit(
          FolderToTopicState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folders) {
        emit(
          FolderToTopicState.loaded(
            state.data.copyWith(
              folders: folders,
              topic: event.topic,
            ),
          ),
        );
      },
    );
  }
}
