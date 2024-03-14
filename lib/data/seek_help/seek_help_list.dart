import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/data/config/other.dart';
import 'package:help_rookie_ui/other/return_state.dart';

class SeekHelpBasicInfo {
  late final int id; //求助帖子编号
  //创建时间,存放在数据库中的日期是字符串，不能排序，但是可以根据主键来排序
  late final String createTime;
  late final int reward; //悬赏
  late final String title; //标题
  late final String language; //语言
  late final bool status; //状态
  late final int likeSum; //点赞数
  late final int lendHandSum; //帮助数
  late final int commentSum; //评论数
  late final int ban; //权限
  late final List<String> tags; //标签
  //用户头像地址(先把基本信息请求过来，用户头像通过stream去请求，请求失败用默认值),
  //暂时没有必要展示用户信息，这样会导致一次请求的数据过大，想看就点进求助帖子里面看
  late final List<int> avatars;

  SeekHelpBasicInfo();

  factory SeekHelpBasicInfo.formJson(dynamic data) {
    SeekHelpBasicInfo seekHelpBasicInfo = SeekHelpBasicInfo();
    seekHelpBasicInfo.id = data['ID'];
    seekHelpBasicInfo.createTime = data['CreateTime'];
    seekHelpBasicInfo.reward = data['Reward'];
    seekHelpBasicInfo.title = data['Title'];
    seekHelpBasicInfo.language = data['Language'];
    seekHelpBasicInfo.status = data['Status'];
    seekHelpBasicInfo.ban = data['Ban'];
    //fixme 不懂有没有问题哦
    seekHelpBasicInfo.tags = data['Tags'];
    return seekHelpBasicInfo;
  }
}

class SeekHelpListModel extends ChangeNotifier {
  //正在加载数据，此时应该显示加载动画
  //加载失败就不改变原来加载之前的数据就好了，弹出一个对话框提示用户失败的原因即可
  bool isLoading = true;
  List<SeekHelpBasicInfo> seekHelpList = [];
  int total = 0; //符合条件的数据总数
  int curPage = 0; //当前页数
  //可同时存在筛选条件
  String language = 'All'; //语言
  int status = 0; //是否解决 1 解决 2 为解决
  //不可同时存在筛选条件
  int sortOption = 0; // 0 最新 1 高悬赏 | 后面三种有空再实现 2 高点赞 3 多评论 4 活跃(帮助最多)

  //获取指定页面的数据
  Future<ReturnState> requestSeekHelpList({int page = 0}) async {
    FormData formData = FormData.fromMap({
      'baseOffset': (page * WebDetailConfig.seekHelpListNumOfPage).toString(),
      'size': WebDetailConfig.seekHelpListNumOfPage.toString(),
      'sortOption': sortOption.toString(),
      'language': language,
      'status': status.toString()
    });

    ReturnState returnState = await WebNetwork.dio
        .post('/seek-help-list', data: formData)
        .then((value) {
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    return returnState;
  }
}

//请求数据模板
/*
FormData formData =
        FormData.fromMap({});

    ReturnState returnState = await WebNetwork.dio
        .post('/find-password', data: formData)
        .then((value) {
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    return returnState;
* */
