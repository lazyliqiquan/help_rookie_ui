import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WebNetwork {
  // static final dio = Dio();

  static final dio =
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8080', headers: {
    'Access-Control-Allow-Origin': '*', // 允许来自任何域名的请求
  }));

  //从后端下载指定路径的文件，图片或文本文件
  static Future<dynamic> downloadFile(String filePath,
      {bool plainText = false}) async {
    FormData formData = FormData.fromMap({
      'file': filePath,
    });
    return await dio
        .post('/downloadFile',
            data: formData,
            options: Options(
                responseType:
                    plainText ? ResponseType.plain : ResponseType.bytes))
        .then((value) {
      return value.data;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return null;
    });
  }
}
