import 'package:flutter/cupertino.dart';

enum WebRoutePathNames {
  home,
  login,
  register,
  findPassword,
  share,
  seekHelp,
  lendHand,
  user
}

class WebRoutePath {
  //一级路由,其中空字符串表示主界面
  WebRoutePathNames routePathName = WebRoutePathNames.home;

  //子路由
  //如果一级路由解析成功，子路由解析失败，应该显示默认的一级路由，而不是无脑显示主界面
  String subRoute = '';

  //主界面
  WebRoutePath.home()
      : routePathName = WebRoutePathNames.home,
        subRoute = '';

  WebRoutePath.login()
      : routePathName = WebRoutePathNames.login,
        subRoute = '';

  WebRoutePath.register()
      : routePathName = WebRoutePathNames.register,
        subRoute = '';

  WebRoutePath.findPassword()
      : routePathName = WebRoutePathNames.findPassword,
        subRoute = '';

  WebRoutePath.share(List<String> subRoute)
      : routePathName = WebRoutePathNames.share,
        subRoute = _parseShare(subRoute);

  WebRoutePath.seekHelp(List<String> subRoute)
      : routePathName = WebRoutePathNames.seekHelp,
        subRoute = _parseSeekHelp(subRoute);

  WebRoutePath.lendHand(List<String> subRoute)
      : routePathName = WebRoutePathNames.lendHand,
        subRoute = _parseLendHand(subRoute);

  WebRoutePath.user(List<String> subRoute)
      : routePathName = WebRoutePathNames.user,
        subRoute = _parseUser(subRoute);

  static String _parseShare(List<String> subRouteList) {
    //前端多处理一点，处理好id不为整数的情况
    if (subRouteList.isNotEmpty && int.tryParse(subRouteList[0]) != null) {
      return subRouteList[0];
    }
    return '';
  }

  static String _parseSeekHelp(List<String> subRouteList) {
    if (subRouteList.isNotEmpty || int.tryParse(subRouteList[0]) != null) {
      return subRouteList[0];
    }
    return '';
  }

  //TODO lend-hand没有默认的路由，初步考虑应该和seek-help合起来，lend-hand解析失败就显示seek-help列表
  static String _parseLendHand(List<String> subRouteList) {
    String subRoute = '';
    if (int.tryParse(subRouteList[0]) == null) {
      return subRouteList[0];
    }
    return '';

    if (subRouteList.length > 1) {
      try {
        int.parse(subRouteList[1]);
        //  如果前面出现异常，就不会执行到后面
        subRoute += '/${subRouteList[1]}';
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return subRoute;
  }

  static const List<String> _userRoutes = ['info', 'log', 'collect', 'setting'];
  static const List<String> _logRoutes = ['seek-help', 'lend-hand'];

  static String _parseUser(List<String> subRouteList) {
    if (subRouteList.isEmpty) {
      return 'info';
    }
    if (!_userRoutes.contains(subRouteList[0])) {
      //如果一级路由出错，那么默认解析到info路由
      return 'info';
    }
    if (subRouteList[0] == _userRoutes[0]) {
      return 'info';
    }
    if (subRouteList[0] == _userRoutes[1]) {
      String subRoute = _userRoutes[1];
      if (subRouteList.length < 2 || subRouteList[1] == _logRoutes[0]) {
        subRoute += '/${_logRoutes[0]}';
      } else {
        subRoute += '/${_logRoutes[1]}';
      }
      return subRoute;
    }
    if (subRouteList[0] == _userRoutes[2]) {
      String subRoute = _userRoutes[2];
      if (subRouteList.length < 2 || subRouteList[1] == _logRoutes[0]) {
        subRoute += '/${_logRoutes[0]}';
      } else {
        subRoute += '/${_logRoutes[1]}';
      }
      return subRoute;
    }
    return 'setting';
  }

  @override
  bool operator ==(Object other) {
    //只比较一级路由，然后后面的
    return (other is WebRoutePath) && routePathName == other.routePathName;
  }

  @override
  int get hashCode => routePathName.hashCode ^ subRoute.hashCode;
}
