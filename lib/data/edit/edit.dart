import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl;
import 'package:image_picker/image_picker.dart' as img;

//应该包装的好一点，这样添加，修改，展示的时候都可以用这一个组件了
//先确定一下需求
//document,images,帖子类型(求助还是帮助),
//fixme 如果我当前处于编辑状态，我编辑的过程中token过期了，那么我需要登录，这样可能会导致我的编辑内容的消失
//fixme 想到的解决办法是提交的时候发现token过期，那么就跳转到登录界面(保存当前编辑内容)，登录成功后跳转回当前编辑页面再提交即可
//todo 跳转到编辑页面的时候，需要请求一次服务器，检查当前用户是否处于登录状态或者有没有相关的权限
//可以在WebNetwork中封装一个专门下载文件(图片，代码)的方法，然后丢到stream中请求，请求失败就处理相应的问题
//图片请求失败可以使用默认的图片
class EditModel extends ChangeNotifier {
  bool loading = false;
  bool _isReadOnly = false;
  bool _isEditing = true; //是否正在编辑
  String document = '';

  set isReadOnly(bool value) {
    _isReadOnly = value;
    notifyListeners();
  }

  bool get isReadOnly => _isReadOnly;

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  bool get isEditing => _isEditing;

  //静态成员notifyListeners()的时候通知不到界面更新(虽然数据确实变了)
  static Map<String, img.XFile> imageFiles = {};
  static List<int>? codeFileBytes;
  static String? codeFileString;

  //在编辑的过程中应该监听输入内容的大小变化，超过现在就应该组织用户再输入新的内容了，
  //或者简单起见，也可以等到提交的时候再警告用户，但是这样子之前编辑的内容就白写了。
  //代码文件，悬赏，文档，图片，语言，日期(更新或创建),标签
  Future<int> addSeekHelp() async {
    return 1;
  }

//  在跳转到添加求助页面的时候，要做一次鉴权：登录没有，有没有权限等
  Future<int> authenticate() async {
    return 1;
  }
}

// class EditModel extends ChangeNotifier {
//   bool loading = true;
//   bool isReadOnly = false;
//   String? document; //修改的时候
//
//   //进行编辑前的数据初始化
//   // Future<int> editInit() async {}
//
//   //添加新的求助
//   Future<ReturnState> addSeekHelp(List<int>? file, int score, String document,
//       String language, int maxDocumentLength) async {
//     if (file == null) {
//       return ReturnState.warning('You need to upload a file');
//     }
//     if (score <= 0) {
//       return ReturnState.warning('There is a reward for at least one');
//     }
//     if (document.trim().isEmpty) {
//       return ReturnState.warning(
//           'Please write some words describing your request for help');
//     }
//     if (document.length > maxDocumentLength) {
//       return ReturnState.warning(
//           'Code description too much, limited to $maxDocumentLength bytes');
//     }
//     FormData formData = FormData.fromMap({
//       'file': MultipartFile.fromBytes(file), //不需要await,文件已经以字节流的方式读出来了
//       'score': score.toString(),
//       'document': document,
//       'language': language,
//       'createTime': intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
//     });
//     ReturnState returnState = await WebNetwork.dio
//         .post('/add-seek-help', data: formData)
//         .then((value) {
//       return ReturnState.fromJson(value.data);
//     }).onError((error, stackTrace) {
//       return ReturnState.error(error.toString());
//     });
//     if (returnState.code == 0) {
//       //  todo 一些成功后端更新操作
//     }
//     return returnState;
//   }
// }
