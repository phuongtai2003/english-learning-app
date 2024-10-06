class AddFoldersTopicRequest {
  final List<int> folderIds;

  AddFoldersTopicRequest(this.folderIds);

  Map<String, dynamic> toJson() {
    return {
      'folderIds': folderIds,
    };
  }
}
