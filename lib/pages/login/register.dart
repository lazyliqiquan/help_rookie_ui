import 'package:flutter/material.dart';
import 'package:help_rookie_ui/route_config/route_path.dart';
import 'package:help_rookie_ui/web_data/route/route_deal.dart';
import 'package:provider/provider.dart';

// onPressed: () {
// context.read<RouteDeal>().jiLu(WebRoutePath.login());
// },

class Register extends Page {
  //如果切换路由后是相同的界面，可能是没有设置key导致的(widget复用，比较widget和key)
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }
}
