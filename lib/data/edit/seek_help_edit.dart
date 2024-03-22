import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;

class SeekHelpDocumentModel extends ChangeNotifier {
  int curSeekHelpId = 0;//当前缓存的求助帖子的id，通过id来判断是否需要缓存
  Map<String, img.XFile> imageFiles = {}; //key : 图片路径,value : 图片文件
  String? codeFileString; //代码文件的文本形式

  //帖子基本数据
  int reward = 0; //悬赏金额
  String createTime = '';
  String updateTime = '';
  String codePath = '';
  String language = '';
  List<int> like = [];
  int pageView = 0;
  bool status = false;
  String document = '';
  List<String> imagePath = [];
  List<String> tags = []; //标签
  int ban = 0;
  int lendHandSum = 0;
  int commentSum = 0;

  //求助帖子作者数据
  int userId = 0;
  String userName = '';
  String userAvatar = '';
  int userReward = 0;
  int userBan = 0;
  int userSeekHelpSum = 0;
  int userLendHelpSum = 0;
}
