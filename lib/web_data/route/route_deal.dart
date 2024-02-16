import 'package:flutter/material.dart';
import 'package:help_rookie_ui/route_config/route_path.dart';

//路由处理
class RouteDeal extends ChangeNotifier {
  // 储存路由
  // 使用场景 : 当界面只是局部改变，但是路由也要跟着变化的时候，可以通过notifyListeners通知界面重建
  // 可以通过它获取到url解析后的参数
  WebRoutePath webRoutePath = WebRoutePath.home();

  //WebRouterDelegate的切换路由的函数可以赋给它
  Function(WebRoutePath webRoutePath)? _switchRoute;

  void initRoute(Function(WebRoutePath) function) {
    _switchRoute = function;
  }

  void switchRoute(WebRoutePath webRoutePath) {
    this.webRoutePath = webRoutePath;
    _switchRoute?.call(webRoutePath);
    notifyListeners();
  }
}
