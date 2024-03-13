import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl;

class EditModel extends ChangeNotifier {
  bool loading = true;
  bool isReadOnly = false;
  String? document; //修改的时候

  //进行编辑前的数据初始化
  // Future<int> editInit() async {}

  //添加新的求助
  Future<ReturnState> addSeekHelp(List<int>? file, int score, String document,
      String language, int maxDocumentLength) async {
    if (file == null) {
      return ReturnState.warning('You need to upload a file');
    }
    if (score <= 0) {
      return ReturnState.warning('There is a reward for at least one');
    }
    if (document.trim().isEmpty) {
      return ReturnState.warning(
          'Please write some words describing your request for help');
    }
    if (document.length > maxDocumentLength) {
      return ReturnState.warning(
          'Code description too much, limited to $maxDocumentLength bytes');
    }
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(file), //不需要await,文件已经以字节流的方式读出来了
      'score': score.toString(),
      'document': document,
      'language': language,
      'createTime': intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
    ReturnState returnState = await WebNetwork.dio
        .post('/add-seek-help', data: formData)
        .then((value) {
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    if (returnState.code == 0) {
      //  todo 一些成功后端更新操作
    }
    return returnState;
  }
}
