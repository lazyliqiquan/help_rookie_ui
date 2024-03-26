import 'package:image_picker/image_picker.dart' as img;

//文档具备的一些信息
//抽象的依据
//seek help , lend hand
//编辑，展示
class CommonDocument {
  String document = ''; //文档(修改和展示模式下有效，新建模式下无效)
  Map<String, img.XFile> imageFiles = {}; //key 图片文件路径 value 图片文件
  List<String> tags = [];
}
