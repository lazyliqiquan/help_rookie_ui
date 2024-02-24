import 'package:flutter/material.dart';
import 'package:help_rookie_ui/config/theme.dart';
import 'package:help_rookie_ui/data/config/local_store.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/data/user/config.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/pages/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:dio/dio.dart';

void main() {
  setPathUrlStrategy();
  //给每次请求的headers加上token
  WebNetwork.dio.interceptors
      .add(InterceptorsWrapper(onRequest: (options, handler) {
    options.headers['Authorization'] = WebLocalStore.getHash('token');
    return handler.next(options);
  }));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppTheme()),
      ChangeNotifierProvider(create: (_) => LoginModel()),
      ChangeNotifierProvider(create: (_) => WebConfigModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return fluent.FluentApp.router(
      title: 'help cookie',
      debugShowCheckedModeBanner: false,
      color: appTheme.color,
      darkTheme: fluent.FluentThemeData(
          brightness: Brightness.dark,
          accentColor: appTheme.color,
          visualDensity: VisualDensity.standard,
          focusTheme: fluent.FocusThemeData(
            glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
          )),
      theme: fluent.FluentThemeData(
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        activeColor: Colors.purple,
        inactiveBackgroundColor: Colors.blue,
        // inactiveColor: Colors.orangeAccent,//输入文本的时候出现的光标的颜色
        shadowColor: Colors.green,
        focusTheme: fluent.FocusThemeData(
          glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      locale: appTheme.locale,
      routerConfig: MyRouter().goRouter,
    );
  }
}
