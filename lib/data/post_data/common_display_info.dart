/*
* 使用新技术的时候还是应该尝试一下，无非就是多花点时间而已，但是产生的连锁反应是巨大的,可观的
* */

//seek help list 和 lend hand list 共有的展示信息
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:help_rookie_ui/data/config/network.dart';

class CommonDisplayInfo extends UserAvatarInfo {
  late final int id; //id
  late final String title; //标题
  //创建时间,存放在数据库中的日期是字符串，不能排序，但是可以根据主键来排序
  late final String createTime; //创建时间
  late final bool status; //状态
  late final int likeSum; //点赞数
  late final int commentSum; //评论数
  late final int ban; //权限
  late final List<String> tags; //标签
  //seek help 特有的成员
  late final int reward; //悬赏
  late final String language; //语言
  late final int lendHandSum; //帮助数

  CommonDisplayInfo(dynamic data) : super(data['Users']['Avatar']) {
    id = data['ID'];
    title = data['Title'];
    createTime = data['CreateTime'];
    status = data['Status'];
    likeSum = data['LikeSum'];
    commentSum = data['CommentSum'];
    ban = data['Ban'];
    List<String> tempTags = data['Tags'].toString().split('#');
    tags = tempTags.sublist(0, min(3, tempTags.length));
    //  seek help 特有的成员
    reward = data['Reward'] ?? 0;
    language = data['Language'] ?? '';
    lendHandSum = data['LendHandSum'] ?? 0;
  }
}

//用户头像信息
class UserAvatarInfo {
  late final String avatarPath;
  late int imgOption; //0 获取头像成功 1 未上传头像 2 获取头像失败(后面两者都使用默认值)
  //不懂用path可不可以，感觉用path可以节约内存资源，优雅一点(具体实现原理 : html.Blob [待测试])
  // late final List<int> imageBytes;
  late final ImageProvider avatarProvider;

  UserAvatarInfo(dynamic data) {
    avatarPath = data;
    imgOption = 1;
    if (avatarPath.isNotEmpty) {
      imgOption = 2;
    }
  }

  //获取图片对应的资源
  Future<bool> fetchImage() async {
    FormData formData = FormData.fromMap({'filePath': avatarPath});

    return await WebNetwork.dio
        .post('/download-file',
            data: formData, options: Options(responseType: ResponseType.bytes))
        .then((value) {
      if (value.statusCode != 200) {
        return false;
      }
      final imageData = value.data as List<int>;
      avatarProvider = MemoryImage(Uint8List.fromList(imageData));
      imgOption = 0;
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
