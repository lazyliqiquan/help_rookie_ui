import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/data/config/other.dart';
import 'package:help_rookie_ui/data/seek_help/common_display_info.dart';
import 'package:help_rookie_ui/other/return_state.dart';

class SeekHelpBasicInfo extends CommonDisplayInfo {
  //创建时间,存放在数据库中的日期是字符串，不能排序，但是可以根据主键来排序
  late final int reward; //悬赏
  late final String language; //语言
  late final int lendHandSum; //帮助数

  SeekHelpBasicInfo(super.data, this.reward, this.language, this.lendHandSum);

  factory SeekHelpBasicInfo.formJson(dynamic data) {
    return SeekHelpBasicInfo(
        data, data['Reward'], data['Language'], data['LendHandSum']);
  }
}

class SeekHelpListModel extends ChangeNotifier {
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

    return await WebNetwork.dio
        .post('/seek-help-list', data: formData)
        .then((value) {
      if (value.data['code'] == 0) {
        dynamic tempData = value.data['data'];
        total = tempData['total'];
        List tempSeekHelpList = tempData['seek-help-list'];
        seekHelpList = List.generate(tempSeekHelpList.length, (index) {
          return SeekHelpBasicInfo.formJson(tempSeekHelpList[index]);
        });
        //虽然图片还没有加载成功，但是可以先展示其他数据，用户头像就先使用默认的
        //特别注意，我们在initState里面使用的是read模式，就算调用notifyListeners()也没事，不会被获取到
        //按钮点击的时候，监听使用的是watch，可以监听到变化
        notifyListeners();
        //  todo 异步请求图片数据，stream
        for (var element in seekHelpList) {
          if (element.imgOption == 1) {
            continue;
          }
          //这里没有使用await，所以不会阻塞
          element.fetchImage().then((value) {
            if (value) {
              //只有请求成功的时候才有必要通知界面更新
              notifyListeners();
            }
          });
        }
      }
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return ReturnState.error(error.toString());
    });
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
