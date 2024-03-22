import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/code.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/other/helper.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl;
import 'package:image_picker/image_picker.dart' as img;
import 'dart:convert' show jsonEncode;

/*
* 因为求助帖子 和 帮助帖子展示的时候需要的内容是差不多的(文档，代码)
* 然后求助帖子的点击频率肯定是很高的，求助帖子一定要缓存
* 帮助帖子的点击频率没有求助帖子高，但是还是可以缓存一下，毕竟请求加上处理的时间还是蛮多了
* 所以还是多写点代码，把EditModel拆成两个模块，一个求助模块和一个帮助模块，这样方便管理
* 但是还是需要保留EditModel模块的，像onlyRead等状态位可以放到其中来
* */

//fixme 如果我当前处于编辑状态，我编辑的过程中token过期了，那么我需要登录，这样可能会导致我的编辑内容的消失
//fixme 想到的解决办法是提交的时候发现token过期，那么就跳转到登录界面(保存当前编辑内容)，登录成功后跳转回当前编辑页面再提交即可
//todo 跳转到编辑页面的时候，需要请求一次服务器，检查当前用户是否处于登录状态或者有没有相关的权限
//可以在WebNetwork中封装一个专门下载文件(图片，代码)的方法，然后丢到stream中请求，请求失败就处理相应的问题
//图片请求失败可以使用默认的图片
class EditModel extends ChangeNotifier {
  //静态成员notifyListeners()的时候通知不到界面更新(虽然数据确实变了)
  String document = ''; //文档(修改模式下有效)
  Map<String, img.XFile> imageFiles = {}; //key 图片文件路径 value 图片文件
  FilePickerResult? _filePickerResult;
  List<String> _tags = []; //标签
  String language = '';
  int remainReward = 0; //剩余金额
  int maxDocumentHeight = 0; //文档最大高度
  int maxDocumentLength = 0; //文档最大限制
  int maxPictureSize = 0; //文档中的所有图片最大限制
  int maxCodeFileSize = 10; //文档中上传文件的最大限制
  //如果是修改操作，请求分为两个操作，一个去获取环境配置，另一个去获取文档以及其他信息
  // String language = ''; //原始代码文件所属的语言
  // List<String> tags = []; //算法标签
  ReturnState returnState = ReturnState.error('Url parse error');

  //在编辑的过程中应该监听输入内容的大小变化，超过现在就应该组织用户再输入新的内容了，
  //或者简单起见，也可以等到提交的时候再警告用户，但是这样子之前编辑的内容就白写了。
  //代码文件，悬赏，文档，图片，语言，日期(更新或创建),标签
  Future<ReturnState> addSeekHelp(
      int reward, List<Map<String, dynamic>> document) async {
    isUploading = true;
    if (_filePickerResult == null) {
      return ReturnState.warning('Code file not selected');
    }
    _parseImageFromDocument(document);
    //判断文档中的图片是否都存在，有一张文档中的图片不存在就返回错误
    for (var element in _imagePathFromDocument) {
      if (!imageFiles.keys.contains(element)) {
        return ReturnState.error('The locally cached image does not exist');
      }
    }

    FormData formData = FormData.fromMap({
      'editOption': '0',
      'imageNum': _imagePathFromDocument.length.toString(),
      'reward': reward,
      'document': jsonEncode(document),
      'tags': _tags.join('#'),
      'language': WebSupportCode.fileToLang(
          _filePickerResult!.files.first.name.split('.').last),
      'uploadTime': intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
    //将代码文件加载到表单中
    formData.files.add(MapEntry(
        'codeFile',
        MultipartFile.fromBytes(_filePickerResult!.files.first.bytes!,
            filename: 'codeFile')));
    //将图片加载到表单中
    for (int i = 0; i < _imagePathFromDocument.length; i++) {
      formData.files.add(MapEntry(
          'image$i',
          MultipartFile.fromBytes(
              await imageFiles[_imagePathFromDocument[i]]!.readAsBytes(),
              filename: 'image$i')));
    }
    return WebNetwork.dio.post('/add-seek-help', data: formData).then((value) {
      isUploading = false;
      return ReturnState.fromJson(value.data);
    });
  }

  //清空好像不算重新赋值，因为操作的数组一直是同一个,只是把它清空了而已
  final List<String> _imagePathFromDocument = [];

  void _parseImageFromDocument(List<Map<String, dynamic>> document) {
    _imagePathFromDocument.clear();
    for (int i = 0; i < document.length; i++) {
      _dfs(document[i]);
    }
  }

  void _dfs(Map<String, dynamic> oneRowData) {
    oneRowData.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        _dfs(value);
      } else {
        if (key == 'image') {
          _imagePathFromDocument.add(value.toString());
        }
      }
    });
  }

  String filePickerInfo() {
    if (_filePickerResult == null) {
      return 'No code file is selected';
    }
    return 'File size : ${WebHelper.unitConversion(_filePickerResult!.files.first.size)}';
  }

  set filePickerResult(FilePickerResult file) {
    _filePickerResult = file;
    notifyListeners();
  }

//  在跳转到添加求助页面的时候，要做一次鉴权：登录没有，有没有权限等
  // 0 添加求助帖子 1 修改求助帖子 2 添加帮助帖子 3 修改帮助帖子
//  这里只是预判断一下，最后真正提交的时候还要判断一次
  Future<void> editAuthentication(bool isSeekHelp, bool isRebuild,
      {int? seekHelpId, int? lendHandId}) async {
    late final int option;
    if (_isSeekHelp) {
      option = _isRebuild ? 1 : 0;
    } else {
      option = _isRebuild ? 3 : 2;
    }
    if ((option == 1 || option == 2) && !_judgeId(seekHelpId)) {
      return;
    }
    if (option == 3 && !_judgeId(lendHandId)) {
      return;
    }
    FormData formData = FormData.fromMap({
      'editOption': option.toString(),
      'seekHelpId': seekHelpId ?? '',
      'lendHandId': lendHandId ?? ''
    });
    //  需要从后端获取一些环境配置
    await WebNetwork.dio.post('/preEdit', data: formData).then((value) {
      returnState = ReturnState.fromJson(value.data);
      if (returnState.code == 0) {
        _parseData(value.data['data']);
      }
    }).onError((error, stackTrace) {
      returnState = ReturnState.error(error.toString());
      debugPrint('editAuthentication');
      debugPrint(error.toString());
    });
    notifyListeners();
  }

  void _parseData(dynamic data) {
    remainReward = data['remainReward'];
    language = data['language'];
    dynamic temp = data['documentLimit'];
    maxDocumentHeight = temp[0];
    maxDocumentLength = temp[1];
    maxPictureSize = temp[2];
    maxCodeFileSize = temp[3];
  }

  bool _judgeId(int? id) {
    //这里判断，就不需要向后端发送请求了
    return id != null && id > 0 && id < (1 << 30);
  }

  List<String> get tags => _tags;

  //可以添加,删除和赋值,据类型判断
  set tags(dynamic data) {
    if (data is int) {
      // 删除指定下标的标签
      _tags.removeAt(data);
      notifyListeners();
    } else if (data is String) {
      // 添加标签
      _tags.add(data);
      notifyListeners();
    } else {
      // 修改模式，获取之前的标签
      _tags = [...data];
      // 不能在initState期间调用notifyListeners()
    }
    debugPrint(_tags.toString());
  }

  bool _isUploading = false; //是否正在上传
  bool _isReadOnly = false;
  bool _isEditing = true; //是否正在编辑
  bool _isSeekHelp = true; //是否是关于求助帖子的
  bool _isRebuild = false; //是否是修改操作

  bool get isUploading => _isUploading;

  set isUploading(bool value) {
    //处理一下，避免永远notifyListeners(),而且如果没有改变，也没有必要更新
    if (_isUploading != value) {
      _isUploading = value;
      notifyListeners();
    }
  }

  bool get isReadOnly => _isReadOnly;

  set isReadOnly(bool value) {
    if (_isReadOnly != value) {
      _isReadOnly = value;
      notifyListeners();
    }
  }

  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    if (_isEditing != value) {
      _isEditing = value;
      notifyListeners();
    }
  }

  bool get isSeekHelp => _isSeekHelp;

  set isSeekHelp(bool value) {
    if (_isSeekHelp != value) {
      _isSeekHelp = value;
      notifyListeners();
    }
  }

  bool get isRebuild => _isRebuild;

  set isRebuild(bool value) {
    if (_isRebuild != value) {
      _isRebuild = value;
      notifyListeners();
    }
  }
}

Future<ReturnState> findPassword(
    String email, String code, String password, String confirmPassword) async {
  FormData formData =
      FormData.fromMap({'email': email, 'code': code, 'password': password});

  ReturnState returnState =
      await WebNetwork.dio.post('/find-password', data: formData).then((value) {
    return ReturnState.fromJson(value.data);
  }).onError((error, stackTrace) {
    return ReturnState.error(error.toString());
  });
  return returnState;
}
