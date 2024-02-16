import 'package:flutter/material.dart';
import 'package:help_rookie_ui/route_config/route_path.dart';

class WebRouteInformationParser extends RouteInformationParser<WebRoutePath> {
  @override
  Future<WebRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    debugPrint(routeInformation.uri.toString());
    List<String> pathSegments = routeInformation.uri.pathSegments;
    if (pathSegments.isEmpty) {
      return WebRoutePath.home();
    }
    if (pathSegments[0] == WebRoutePathNames.login.name) {
      return WebRoutePath.login();
    }
    if (pathSegments[0] == WebRoutePathNames.register.name) {
      return WebRoutePath.register();
    }
    if (pathSegments[0] == WebRoutePathNames.findPassword.name) {
      return WebRoutePath.findPassword();
    }
    if (pathSegments[0] == WebRoutePathNames.share.name) {
      //因为不一定是/share/id，也可以是/share/，前者表示查看指定共享代码，后者表示上传共享代码
      return WebRoutePath.share(pathSegments.sublist(1));
    }
    if (pathSegments[0] == WebRoutePathNames.seekHelp.name) {
      //  /seekHelp/表示查看求助列表，后面有id表示查看指定求助帖子
      return WebRoutePath.seekHelp(pathSegments.sublist(1));
    }
    if (pathSegments[0] == WebRoutePathNames.lendHand.name &&
        pathSegments.length > 1) {
      //  /lendHand/seekHelpId表示指定求助对应的帮助帖子列表
      //  /lendHand/seekHelpId/lendHandId表示特定的帮助帖子
      return WebRoutePath.lendHand(pathSegments.sublist(1));
    }

    if (pathSegments[0] == WebRoutePathNames.user.name) {
      //  /user/info 展示基本的用户信息，比如贡献记录
      //  /user/log/seek help(or)lend hand 历史操作帖子列表(点击列表跳转到指定帖子)
      //  /user/collect/seek help(or)lend hand 收藏列表
      //  /user/setting 设置网站，比如白天黑夜主题
      return WebRoutePath.user(pathSegments.sublist(1));
    }

    //url解析失败，直接解析为主页面
    return WebRoutePath.home();
  }

  @override
  RouteInformation restoreRouteInformation(WebRoutePath configuration) {
    return RouteInformation(
        uri: Uri.parse(
            '${configuration.routePathName}/${configuration.subRoute}'));
    // location:
    //             '${configuration.routePathName}/${configuration.subRoute.join('/')}'

    /// FIXME 可能会出现http://localhost:56972/share/2，但是页面却显示home的情况，
    //因为虽然浏览器的url变成了share/2,但是在WebRouterDelegate的pages的比较里面，和share的比较未通过，所以默认解析到home
    // return RouteInformation(location: '/share/${configuration.secondRoute}');
  }
}
