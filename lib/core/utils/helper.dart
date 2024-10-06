import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Helper {
  final Dio _dio;

  Helper(this._dio);

  Future<File> urlToFile({required String url}) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final randomName = Random().nextInt(1000).toString();
    final file = File('$tempPath/$randomName.png');
    await file.writeAsBytes(
      response.data!,
    );
    return file;
  }
}
