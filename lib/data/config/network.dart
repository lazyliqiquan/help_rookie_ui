import 'package:dio/dio.dart';

class WebNetwork {
  // static final dio = Dio();

  static final dio =
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8080', headers: {
    'Access-Control-Allow-Origin': '*', // 允许来自任何域名的请求
  }));
}
