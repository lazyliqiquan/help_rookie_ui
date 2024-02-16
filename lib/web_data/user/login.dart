import 'package:flutter/material.dart';
import 'package:help_rookie_ui/other_module/operating_state.dart';
import 'package:dio/dio.dart';
import 'package:help_rookie_ui/web_data/config/network.dart';

//为了模块化开发，数据应该完全解耦，哪怕数据会冗余一点
class LoginModel extends ChangeNotifier {
  //登录方式，nameOrEmail，authCode
  Future<OperatingState> login(List<String> list) async {
    FormData formData = FormData.fromMap({
      'loginType': list[0],
      'nameOrMail': list[1],
      'authCode': list[2],
    });
    await WebNetwork.dio.post('/login',data: formData).then((value){

    }).onError((error, stackTrace){

    });
  }
}
