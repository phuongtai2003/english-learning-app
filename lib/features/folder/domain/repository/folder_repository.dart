import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';

abstract class FolderRepository {
  ResultFuture<Folder> addFolder(String folderName, String? folderDescription);
  ResultFuture<List<Folder>> getFolders();
  ResultFuture<Folder> getFolderDetail(int folderId);
  ResultFuture<Folder> removeTopicFromFolder(int folderId, int topicId);
  ResultFuture<Folder> editFolder(
    int folderId,
    String folderName,
    String folderDescription,
  );
  ResultFuture<bool> removeFolder(int folderId);
  ResultFuture<List<Folder>> getAvailableFolders(int topicId);
  ResultFuture<List<Folder>> addFolderToTopic(int topicId, List<int> folderIds);
}
