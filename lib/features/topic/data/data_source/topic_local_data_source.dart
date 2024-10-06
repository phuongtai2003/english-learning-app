import 'dart:convert';

import 'package:final_flashcard/configs/storage/hive_storage.dart';
import 'package:final_flashcard/features/topic/data/model/topic.dart';
import 'package:injectable/injectable.dart';

abstract class TopicLocalDataSource {
  const TopicLocalDataSource();

  Future<void> saveTopicToStorage(
      {required TopicModel topic, required int userId});
  Future<bool> isTopicDownloaded(int topicId, int userId);
  Future<TopicModel?> getTopicFromStorage(int topicId, int userId);
}

@LazySingleton(as: TopicLocalDataSource)
class TopicLocalDataSourceImpl implements TopicLocalDataSource {
  final HiveStorage _hiveStorage;
  const TopicLocalDataSourceImpl(this._hiveStorage);

  @override
  Future<void> saveTopicToStorage(
      {required TopicModel topic, required int userId}) async {
    _hiveStorage.saveData<TopicModel>(
      '$userId-${topic.id}',
      topic,
      (data) {
        return jsonEncode(data.toJson());
      },
    );
  }

  @override
  Future<bool> isTopicDownloaded(int topicId, int userId) {
    return _hiveStorage.isKeyExists('$userId-$topicId');
  }

  @override
  Future<TopicModel?> getTopicFromStorage(int topicId, int userId) {
    return _hiveStorage.getData<TopicModel>(
      '$userId-$topicId',
      (data) {
        return TopicModel.fromJson(jsonDecode(data));
      },
    );
  }
}
