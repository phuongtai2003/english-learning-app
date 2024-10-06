import 'package:dio/dio.dart';
import 'package:final_flashcard/configs/common/global_constants.dart';
import 'package:final_flashcard/features/folder/data/model/add_folder_request.dart';
import 'package:final_flashcard/features/folder/data/model/add_folder_topic_request.dart';
import 'package:final_flashcard/features/folder/data/model/folder.dart';
import 'package:retrofit/http.dart';

part 'folder_remote_data_source.g.dart';

@RestApi(baseUrl: GlobalConstants.baseUrl)
abstract class FolderRemoteDataSource {
  factory FolderRemoteDataSource(Dio dio) = _FolderRemoteDataSource;

  @GET('folders')
  Future<List<FolderModel>> getFolders();

  @POST('folders/add')
  Future<FolderModel> addFolder(
    @Body() AddFolderRequest addFolderRequest,
  );

  @GET('folders/{folderId}')
  Future<FolderModel> getFolderDetail({
    @Path('folderId') required int folderId,
  });

  @DELETE('folders/{folderId}/remove-topic/{topicId}')
  Future<FolderModel> removeTopicFromFolder({
    @Path('folderId') required int folderId,
    @Path('topicId') required int topicId,
  });

  @PUT('folders/{folderId}/edit')
  Future<FolderModel> editFolder({
    @Path('folderId') required int folderId,
    @Body() required AddFolderRequest addFolderRequest,
  });

  @DELETE('folders/{folderId}/delete')
  Future<bool> removeFolder({
    @Path('folderId') required int folderId,
  });

  @GET('folders/available/{topicId}')
  Future<List<FolderModel>> getAvailableFolders({
    @Path('topicId') required int topicId,
  });

  @POST('folders/add-to-topic/{topicId}')
  Future<List<FolderModel>> addFolderToTopic({
    @Path('topicId') required int topicId,
    @Body() required AddFoldersTopicRequest request,
  });
}
