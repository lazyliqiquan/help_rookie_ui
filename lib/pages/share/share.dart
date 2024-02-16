import 'package:flutter/material.dart';

class Share extends Page {
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
