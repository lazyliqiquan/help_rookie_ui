import 'package:flutter/material.dart';
import 'package:help_rookie_ui/pages/home/home.dart';
import 'package:help_rookie_ui/pages/login/find_password.dart';
import 'package:help_rookie_ui/pages/login/login.dart';
import 'package:help_rookie_ui/pages/login/register.dart';
import 'package:help_rookie_ui/pages/share/share.dart';
import 'package:help_rookie_ui/route_config/route_path.dart';
import 'package:help_rookie_ui/web_config/screen.dart';
import 'package:help_rookie_ui/web_data/route/route_deal.dart';
import 'package:provider/provider.dart';

class WebRouterDelegate extends RouterDelegate<WebRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<WebRoutePath> {
  @override
  late final GlobalKey<NavigatorState> navigatorKey;

  WebRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  WebRoutePath webRoutePath = WebRoutePath.home();

  @override
  WebRoutePath get currentConfiguration {
    debugPrint('currentConfiguration');
    return webRoutePath;
  }

  void _switchRoute(WebRoutePath webRoutePath) {
    debugPrint('_switchRoute');
    this.webRoutePath = webRoutePath;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double maxWidth = constraints.maxWidth;
      double maxHeight = constraints.maxHeight;
      debugPrint(constraints.toString());
      if (maxWidth < ScreenConfig.minWidth ||
          maxHeight < ScreenConfig.minHeight) {
        return const Center(
          child: Text(
              'The current screen is too small to display the interface properly'),
        );
      }
      //将路由切换的函数赋给RouteDeal的一个实例，这样就可以通过provider访问了，并且路由改变的状态可以通知到WebRouterDelegate
      context.read<RouteDeal>().initRoute(_switchRoute);
      debugPrint('Navigator');
      return Navigator(
        key: navigatorKey,
        pages: [
          //默认第一个页面是主路由，也就是 ' / '
          Home(),
          if (webRoutePath.routePathName == WebRoutePathNames.login)
            Login()
          else if (webRoutePath.routePathName == WebRoutePathNames.register)
            Register()
          else if (webRoutePath.routePathName == WebRoutePathNames.findPassword)
            FindPassword()
          else if (webRoutePath.routePathName == WebRoutePathNames.share)
            Share()
          // else if(webRoutePath.routePathName == WebRoutePathNames.seekHelp)
        ],
        onPopPage: (route, result) {
          //好像这里从来没有触发过诶
          debugPrint('onPopPage');
          debugPrint(route.toString());
          debugPrint(result.toString());
          if (!route.didPop(result)) {
            return false;
          }
          //如果路由解释失败，那么就导航到主路由
          webRoutePath = WebRoutePath.home();
          notifyListeners();
          return true;
        },
      );
    });
  }

  @override
  Future<void> setNewRoutePath(WebRoutePath configuration) async {
    debugPrint('setNewRoutePath');
    webRoutePath = configuration;
  }
}
