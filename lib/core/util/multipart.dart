import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MultiPartUtil {
  static Future<MapEntry<String, dynamic>> createFileFormField(
      String filePath, String fieldName) async {
    final mime = lookupMimeType('filePath', headerBytes: [0xFF, 0xD8]);

    if (mime == null) throw Exception("Invalid File");

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      contentType: MediaType.parse(mime),
    );

    return MapEntry(fieldName, multipartFile);
  }
}
