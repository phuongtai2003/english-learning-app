import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:csv/csv.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:final_flashcard/features/learning/domain/entities/vocabulary_statistics.dart';
import 'package:final_flashcard/features/topic/domain/use_case/delete_topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/favorite_vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/use_case/save_topic_to_local.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_topic_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/vocabulary.dart';

part 'topic_details_event.dart';
part 'topic_details_state.dart';
part 'topic_details_bloc.freezed.dart';

class TopicDetailsBloc extends Bloc<TopicDetailsEvent, TopicDetailsState> {
  final GetTopicDetailsUseCase _getTopicDetailsUseCase;
  final SaveTopicToLocalUseCase _saveTopicToLocalUseCase;
  final FavoriteVocabularyUseCase _favoriteVocabularyUseCase;
  final DeleteTopicUseCase _deleteTopicUseCase;
  final ListToCsvConverter _listToCsvConverter =
      getIt.get<ListToCsvConverter>();
  TopicDetailsBloc(
    this._getTopicDetailsUseCase,
    this._saveTopicToLocalUseCase,
    this._favoriteVocabularyUseCase,
    this._deleteTopicUseCase,
  ) : super(const TopicDetailsState.initial(TopicDetailsStateData())) {
    on<GetTopicDetails>(_getTopicDetails);
    on<ToggleSpeakingStatus>(_toggleSpeakingStatus);
    on<ToggleLearnButtonBottom>(
      _toggleLearnButtonBottom,
      transformer: (events, mapper) => events
          .debounceTime(
            const Duration(milliseconds: 300),
          )
          .asyncExpand(mapper),
    );
    on<DownloadTopicToLocal>(_downloadTopicToLocal);
    on<FavoriteVocabulary>(_favoriteVocabulary);
    on<ToggleStudyAll>(_toggleStudyAll);
    on<DeleteTopic>(_deleteTopic);
    on<AddPendingTopicBloc>(_addPendingTopicBloc);
    on<DeletePendingTopicBloc>(_deletePendingTopicBloc);
    on<ExportToCsv>(_exportToCsv);
  }

  void _getTopicDetails(
      GetTopicDetails event, Emitter<TopicDetailsState> emit) async {
    emit(
      TopicDetailsState.loading(state.data),
    );
    final response = await _getTopicDetailsUseCase(
      {
        'topicId': event.topicId,
        'userId': event.userId,
      },
    );

    response.fold(
      (failure) {
        emit(
          TopicDetailsState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (result) {
        emit(
          TopicDetailsState.loaded(
            state.data.copyWith(
              topic: result.topic,
              favoriteVocabularies: result.favoriteVocabularies,
              userId: event.userId,
              vocabularyStatistics: result.vocabularyStatistics,
            ),
          ),
        );
      },
    );
  }

  void _toggleSpeakingStatus(
      ToggleSpeakingStatus event, Emitter<TopicDetailsState> emit) {
    emit(
      TopicDetailsState.loaded(
        state.data.copyWith(
          vocabSpeakingIndex: event.vocabIndex,
          isTermSpeaking: event.isTermSpeaking,
          isDefinitionSpeaking: event.isDefinitionSpeaking,
        ),
      ),
    );
  }

  void _toggleLearnButtonBottom(
      ToggleLearnButtonBottom event, Emitter<TopicDetailsState> emit) {
    emit(
      TopicDetailsState.loaded(
        state.data.copyWith(
          showLearnButtonBottom: event.showLearnButtonBottom,
        ),
      ),
    );
  }

  void _downloadTopicToLocal(
      DownloadTopicToLocal event, Emitter<TopicDetailsState> emit) async {
    emit(
      TopicDetailsState.downloadLoading(state.data),
    );
    final response = await _saveTopicToLocalUseCase(
      {
        'topic': event.topic,
        'userId': event.userId,
      },
    );

    response.fold(
      (failure) {
        emit(
          TopicDetailsState.downloadFailure(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (_) {
        emit(
          TopicDetailsState.downloadSuccess(state.data.copyWith(
            topic: state.data.topic!.copyWith(
              isDownloaded: true,
            ),
          )),
        );
      },
    );
  }

  void _favoriteVocabulary(
      FavoriteVocabulary event, Emitter<TopicDetailsState> emit) async {
    final response = await _favoriteVocabularyUseCase(event.vocabId);

    response.fold(
      (failure) {
        emit(
          TopicDetailsState.error(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (vocabulary) {
        final favoriteVocabularies = [...state.data.favoriteVocabularies];
        final index = favoriteVocabularies.indexWhere(
          (element) => element.id == vocabulary.id,
        );
        if (index != -1) {
          favoriteVocabularies.removeAt(index);
        } else {
          favoriteVocabularies.add(vocabulary);
        }
        emit(
          TopicDetailsState.loaded(
            state.data.copyWith(
              favoriteVocabularies: favoriteVocabularies,
            ),
          ),
        );
      },
    );
  }

  void _toggleStudyAll(ToggleStudyAll event, Emitter<TopicDetailsState> emit) {
    emit(
      TopicDetailsState.loaded(
        state.data.copyWith(
          learnAll: event.studyAll,
        ),
      ),
    );
  }

  void _deleteTopic(DeleteTopic event, Emitter<TopicDetailsState> emit) async {
    emit(
      TopicDetailsState.loading(state.data),
    );
    final response = await _deleteTopicUseCase(state.data.topic?.id ?? 0);

    response.fold(
      (failure) {
        emit(
          TopicDetailsState.deleteTopicError(
            state.data.copyWith(
              error: failure.message,
            ),
          ),
        );
      },
      (_) {
        emit(
          TopicDetailsState.deleteTopicSuccess(
            state.data.copyWith(
              error: '',
            ),
          ),
        );
      },
    );
  }

  void _addPendingTopicBloc(
      AddPendingTopicBloc event, Emitter<TopicDetailsState> emit) {
    emit(
      TopicDetailsState.loaded(
        state.data.copyWith(
          addTopicBloc: event.addTopicBloc,
        ),
      ),
    );
  }

  void _deletePendingTopicBloc(
      DeletePendingTopicBloc event, Emitter<TopicDetailsState> emit) {
    emit(
      TopicDetailsState.loaded(
        state.data.copyWith(
          addTopicBloc: null,
        ),
      ),
    );
  }

  void _exportToCsv(ExportToCsv event, Emitter<TopicDetailsState> emit) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final android = await deviceInfoPlugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    if (storageStatus == PermissionStatus.granted) {
      List<List<String>> csvData = [
        ['Term', 'Definition'],
        ...state.data.topic!.vocabularies!.map(
          (e) => [
            e.term ?? '',
            e.definition ?? '',
          ],
        ),
      ];
      String csv = _listToCsvConverter.convert(csvData);
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        final file =
            File('${dir.absolute.path}/${state.data.topic?.title ?? ''}.csv');
        await file.writeAsString(csv);
        emit(
          TopicDetailsState.exportToCsvSuccess(state.data),
        );
        OpenFile.open(file.path);
      } else {
        emit(
          TopicDetailsState.exportToCsvFailed(state.data),
        );
      }
    }
    if (storageStatus == PermissionStatus.denied) {
      await Permission.storage.request();
    }
  }
}
