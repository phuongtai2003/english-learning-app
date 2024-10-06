import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/errors/failure.dart';
import 'package:final_flashcard/features/folder/data/data_source/folder_remote_data_source.dart';
import 'package:final_flashcard/features/folder/data/model/add_folder_request.dart';
import 'package:final_flashcard/features/folder/data/model/add_folder_topic_request.dart';
import 'package:final_flashcard/features/folder/data/model/folder.dart';
import 'package:final_flashcard/features/folder/domain/repository/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource _folderRemoteDataSource;

  FolderRepositoryImpl(this._folderRemoteDataSource);

  @override
  ResultFuture<FolderModel> addFolder(
      String folderName, String? folderDescription) async {
    try {
      final result = await _folderRemoteDataSource.addFolder(
        AddFolderRequest(
          folderName: folderName,
          folderDescription: folderDescription,
        ),
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<List<FolderModel>> getFolders() async {
    try {
      final result = await _folderRemoteDataSource.getFolders();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<FolderModel> getFolderDetail(int folderId) async {
    try {
      final folder =
          await _folderRemoteDataSource.getFolderDetail(folderId: folderId);
      return Right(folder);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<FolderModel> removeTopicFromFolder(
      int folderId, int topicId) async {
    try {
      final folder = await _folderRemoteDataSource.removeTopicFromFolder(
        folderId: folderId,
        topicId: topicId,
      );
      return Right(folder);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<FolderModel> editFolder(
      int folderId, String folderName, String folderDescription) async {
    try {
      final folder = await _folderRemoteDataSource.editFolder(
        folderId: folderId,
        addFolderRequest: AddFolderRequest(
          folderName: folderName,
          folderDescription: folderDescription,
        ),
      );
      return Right(folder);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<bool> removeFolder(int folderId) async {
    try {
      final result =
          await _folderRemoteDataSource.removeFolder(folderId: folderId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<List<FolderModel>> getAvailableFolders(int topicId) async {
    try {
      final result = await _folderRemoteDataSource.getAvailableFolders(
        topicId: topicId,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<List<FolderModel>> addFolderToTopic(
      int topicId, List<int> folderIds) async {
    try {
      final result = await _folderRemoteDataSource.addFolderToTopic(
        topicId: topicId,
        request: AddFoldersTopicRequest(folderIds),
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return const Left(
        ApiFailure(
          message: 'something_went_wrong',
          statusCode: 500,
        ),
      );
    }
  }
}
