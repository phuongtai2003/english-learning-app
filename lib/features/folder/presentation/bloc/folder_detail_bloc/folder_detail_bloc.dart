import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/edit_folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/get_folder_detail.dart';
import 'package:final_flashcard/features/folder/domain/use_case/remove_folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/remove_topic_from_folder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_detail_event.dart';
part 'folder_detail_state.dart';

part 'folder_detail_bloc.freezed.dart';

class FolderDetailBloc extends Bloc<FolderDetailEvent, FolderDetailState> {
  final GetFolderDetailUseCase _getFolderDetailUseCase;
  final RemoveTopicFromFolderUseCase _removeTopicFromFolderUseCase;
  final EditFolderUseCase _editFolderUseCase;
  final RemoveFolderUseCase _removeFolderUseCase;
  FolderDetailBloc(
    this._getFolderDetailUseCase,
    this._removeTopicFromFolderUseCase,
    this._editFolderUseCase,
    this._removeFolderUseCase,
  ) : super(const FolderDetailState.initial(FolderDetailStateData())) {
    on<LoadFolderDetail>(_loadFolderDetails);
    on<RemoveTopicFromFolder>(_removeTopicFromFolder);
    on<EditFolder>(_editFolder);
    on<RemoveFolder>(_removeFolder);
  }

  void _removeFolder(
      RemoveFolder event, Emitter<FolderDetailState> emit) async {
    emit(FolderDetailState.removeFolderLoading(state.data));
    final response = await _removeFolderUseCase(
      RemoveFolderUseCaseParams(
        folderId: state.data.folder!.id!,
      ),
    );

    response.fold(
      (failure) {
        emit(
          FolderDetailState.removeFolderError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (success) {
        emit(
          FolderDetailState.removeFolderSuccess(
            state.data.copyWith(
              folder: null,
            ),
          ),
        );
      },
    );
  }

  void _editFolder(EditFolder event, Emitter<FolderDetailState> emit) async {
    emit(
      FolderDetailState.editFolderLoading(
        state.data,
      ),
    );
    final response = await _editFolderUseCase(
      EditFolderUseCaseParams(
        folderId: state.data.folder!.id!,
        folderName: event.folderName,
        folderDescription: event.folderDescription,
      ),
    );
    response.fold(
      (failure) {
        emit(
          FolderDetailState.editFolderError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folder) {
        emit(
          FolderDetailState.editFolderSuccess(
            state.data.copyWith(
              folder: folder,
            ),
          ),
        );
      },
    );
  }

  void _removeTopicFromFolder(
      RemoveTopicFromFolder event, Emitter<FolderDetailState> emit) async {
    emit(
      FolderDetailState.loading(
        state.data,
      ),
    );
    final response = await _removeTopicFromFolderUseCase(
      RemoveTopicFromFolderUseCaseParams(
        state.data.folder!.id!,
        event.topicId,
      ),
    );
    response.fold(
      (failure) {
        emit(
          FolderDetailState.removedTopicError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folder) {
        emit(
          FolderDetailState.removedTopicSuccess(
            state.data.copyWith(
              folder: folder,
            ),
          ),
        );
      },
    );
  }

  void _loadFolderDetails(
      LoadFolderDetail event, Emitter<FolderDetailState> emit) async {
    emit(
      FolderDetailState.loading(
        state.data,
      ),
    );
    final response = await _getFolderDetailUseCase(event.folderId);
    response.fold(
      (failure) {
        emit(
          FolderDetailState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folder) {
        emit(
          FolderDetailState.loaded(
            state.data.copyWith(
              folder: folder,
            ),
          ),
        );
      },
    );
  }
}
