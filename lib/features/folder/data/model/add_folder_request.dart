class AddFolderRequest {
  final String folderName;
  final String? folderDescription;

  AddFolderRequest({
    required this.folderName,
    required this.folderDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      "folderName": folderName,
      "folderDescription": folderDescription,
    };
  }
}
