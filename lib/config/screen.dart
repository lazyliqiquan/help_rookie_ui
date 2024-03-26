class ScreenConfig {
  static const double minWidth = 1100;
  static const double minHeight = 500;
  static const String flunkShowText =
      'The screen is too small to display normal content';

  //主界面和左边的外边距
  static const double showWidgetLeftMargin =
      horizontalWidgetMargin + sideFloatWidgetWidth;

  //竖直方向组件间的间距
  static const double verticalWidgetMargin = 40;

  //水平方向组件间的间距
  static const double horizontalWidgetMargin = 30;

  //顶部组件的高度(顶部导航栏或者编辑选项栏)
  static const double topWidgetHeight = 50;

  //侧边浮动组件的宽度
  static const double sideFloatWidgetWidth = 50;

  //滚动条宽度
  static const double scrollBarWidget = 22;

  //正常图标大小
  static const double normalIconSize = 20;

  //列表的高度
  static const double listDisplayBlockHeight = 65;
}
