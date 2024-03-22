import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;

class LendHandDocumentModel extends ChangeNotifier {
  String document = '';

  //静态成员notifyListeners()的时候通知不到界面更新(虽然数据确实变了)
  //但是我们可以弄一个普通来表明此时静态成员的状态
  static Map<String, img.XFile> imageFiles = {}; //key : 图片路径,value : 图片文件
  static String? codeFileString; //代码文件的文本形式
}
