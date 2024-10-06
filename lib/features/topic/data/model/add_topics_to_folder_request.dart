class AddTopicsToFolderRequest {
  final List<int> topicIds;

  AddTopicsToFolderRequest({required this.topicIds});

  Map<String, dynamic> toJson() {
    return {
      'topicIds': topicIds,
    };
  }
}
