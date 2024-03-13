import 'package:help_rookie_ui/config/theme.dart';
import 'package:help_rookie_ui/data/config/local_store.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/pages/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:dio/dio.dart';

void main() {
  setPathUrlStrategy();
  //给每次请求的headers加上token
  WebNetwork.dio.interceptors
      .add(InterceptorsWrapper(onRequest: (options, handler) {
    options.headers['Authorization'] = WebLocalStore.getHash('token');
    return handler.next(options);
  }));

  // WebConfigModel webConfigModel = await WebConfigModel.getWebConfig();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppTheme()),
      ChangeNotifierProvider(create: (_) => LoginModel()),
      ChangeNotifierProvider(create: (_) => EditModel()),
      // ChangeNotifierProvider.value(value: webConfigModel),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return FluentApp.router(
      title: 'help cookie',
      debugShowCheckedModeBanner: false,
      color: appTheme.color,
      darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: appTheme.color,
          visualDensity: VisualDensity.standard,
          focusTheme: FocusThemeData(
            glowFactor: is10footScreen(context) ? 2.0 : 0.0,
          )),
      theme: FluentThemeData(
        iconTheme: IconThemeData(size: 16, color: appTheme.color),
        scrollbarTheme: ScrollbarThemeData(
            backgroundColor: Colors.transparent,
            scrollbarColor: Colors.grey[110],
            scrollbarPressingColor: Colors.grey[140],
            thickness: 15,
            hoveringThickness: 15,
            radius: const Radius.circular(0),
            // 滚动条的圆角
            hoveringRadius: const Radius.circular(0)),
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        activeColor: Colors.purple,
        inactiveBackgroundColor: Colors.blue,
        // inactiveColor: Colors.orangeAccent,//输入文本的时候出现的光标的颜色
        shadowColor: Colors.green,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      locale: appTheme.locale,
      routerConfig: MyRouter().goRouter,
    );
  }
}
