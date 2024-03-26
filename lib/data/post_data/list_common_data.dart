import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/config/code.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/data/config/other.dart';
import 'package:help_rookie_ui/data/post_data/common_display_info.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:dio/dio.dart';

/*
* 悟了，我可以继承，实现，混入同时使用呀
* 继承 : 使用父类的成员
* 实现 : seek help 和 lend hand 各自实现属于自己的方法
* 混入 : 使用mixin类的特性
* */

/*
* 或者可以有更好的方法，谁说一个页面只能由一个Model控制的
* */

//seek help 和lend hand列表共有的数据和方法，主要起到筛选的作用
class ListCommonSort extends ChangeNotifier {
  List<CommonDisplayInfo> commonList = [];
  int total = 0;
  int page = 0; //当前页数
  //不可同时存在筛选条件
  int sortOption = 0; // 0 最新 1 高悬赏 | 后面三种有空再实现 2 高点赞 3 多评论 4 活跃(帮助最多)
  //可同时存在筛选条件
  int status = 0; //是否解决 1 解决 2 为解决
  int language = 0; // 语言
  bool _isSeekHelp = true;

  Future<ReturnState> sort(
      {int option = 0, int value = 0, bool isSeekHelp = true}) async {
    if (!_isRequest(option, value, isSeekHelp)) {
      return ReturnState.info(
          'The data in the list now matches the filtering criteria');
    }
    FormData formData = _getFormData(option, value);

    return await WebNetwork.dio
        .post('/${isSeekHelp ? 'seek-help' : 'lend-hand'}-list', data: formData)
        .then((result) {
      if (result.data['code'] == 0) {
        //调用父类的构造方法
        _init(result.data['data']);
        //虽然图片还没有加载成功，但是可以先展示其他数据，用户头像就先使用默认的
        //特别注意，我们在initState里面使用的是read模式，就算调用notifyListeners()也没事，不会被获取到
        //按钮点击的时候，监听使用的是watch，可以监听到变化
        _set(option, value, isSeekHelp);
        notifyListeners();
        //  todo 异步请求图片数据，stream
        for (var element in commonList) {
          if (element.imgOption == 1) {
            continue;
          }
          //这里没有使用await，所以不会阻塞
          element.fetchImage().then((value) {
            if (value) {
              //只有请求成功的时候才有必要通知界面更新
              notifyListeners();
              //  fixme 每张图片加载成功后都会notifyListeners()，会不会导致页面状态反复初始化，滚动条滚动到开始的位置
              //  解决办法，可能的解决办法
              //  将Model的初始化放到ScreenLimit里面，这样就不会反复初始化滚动条了，
              //  或者滚动条使用static
            }
          });
        }
      }
      return ReturnState.fromJson(result.data);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return ReturnState.error(error.toString());
    });
  }

  //重置筛选条件
  void _reset() {
    total = 0;
    page = 0;
    sortOption = 0;
    status = 0;
    language = 0;
  }

  //更新标记位
  void _set(int option, int value, bool isSeekHelp) {
    _isSeekHelp = isSeekHelp;
    if (option == 0) {
      page = value;
    } else if (option == 1) {
      sortOption = value;
    } else if (option == 2) {
      status = value;
    }
    language = value;
  }

  FormData _getFormData(int option, int value) {
    //后面优化的地方可以是参数的合法性，如页数不能超过总页数等等
    return FormData.fromMap({
      'baseOffset':
          ((option == 0 ? value : page) * WebDetailConfig.seekHelpListNumOfPage)
              .toString(),
      'size': WebDetailConfig.seekHelpListNumOfPage.toString(),
      'sortOption': '${option == 1 ? value : sortOption}',
      'status': '${option == 2 ? value : status}',
      'language': [
        'All',
        ...WebSupportCode.supportLanguage
      ][option == 3 ? value : language],
    });
  }

  void _init(dynamic data) {
    total = data['total'];
    List tempList = data['list'];
    commonList = List.generate(tempList.length, (index) {
      return CommonDisplayInfo(tempList[index]);
    });
  }

  //判断有没有必要请求
  bool _isRequest(int option, int value, bool isSeekHelp) {
    //如果前后两次请求的对象不一样，那么必须要重新请求数据了
    if (_isSeekHelp != isSeekHelp) {
      //请求对象不一样，还应该将筛选条件重置
      _reset();
      return true;
    }
    if (option == 0) {
      return page != value;
    } else if (option == 1) {
      return sortOption != value;
    } else if (option == 2) {
      return status != value;
    }
    return language != value;
  }
}
