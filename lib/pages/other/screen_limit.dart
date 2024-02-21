import 'package:flutter/material.dart';
import 'package:help_rookie_ui/config/screen.dart';

//显示页面之前，先判断一下当前屏幕是否达到最小显示尺寸要求
class ScreenLimit extends StatelessWidget {
  const ScreenLimit({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      if (maxWidth < ScreenConfig.minWidth ||
          maxHeight < ScreenConfig.minHeight) {
        return const Center(child: Text(ScreenConfig.flunkShowText));
      }
      return child;
    }));
  }
}
