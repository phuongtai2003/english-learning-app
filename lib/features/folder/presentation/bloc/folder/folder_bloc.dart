import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/add_folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/get_user_folders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_event.dart';
part 'folder_state.dart';
part 'folder_bloc.freezed.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final AddFolderUseCase _addFolderUseCase;
  final GetUserFoldersUseCase _getUserFoldersUseCase;

  FolderBloc(this._addFolderUseCase, this._getUserFoldersUseCase)
      : super(const FolderState.initial(FolderStateData())) {
    on<AddFolder>(_addFolder);
    on<LoadFolder>(_loadFolder);
  }

  void _loadFolder(LoadFolder event, Emitter<FolderState> emit) async {
    emit(
      FolderState.loading(
        state.data,
      ),
    );
    final response = await _getUserFoldersUseCase();
    response.fold(
      (failure) {
        emit(
          FolderState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folders) {
        emit(
          FolderState.loaded(
            state.data.copyWith(
              folders: folders,
            ),
          ),
        );
      },
    );
  }

  void _addFolder(AddFolder event, Emitter<FolderState> emit) async {
    emit(
      FolderState.addFolderSuccess(
        state.data,
      ),
    );
    final response = await _addFolderUseCase(
      AddFolderParams(
        folderName: event.folderName,
        folderDescription: event.folderDescription,
      ),
    );
    response.fold(
      (failure) {
        emit(
          FolderState.addFolderFailure(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (folder) {
        emit(
          FolderState.addFolderSuccess(
            state.data,
          ),
        );
      },
    );
  }
}
