import 'package:flutter/material.dart';
import 'package:help_rookie_ui/route_config/route_delegate.dart';
import 'package:help_rookie_ui/route_config/route_info_parse.dart';
import 'package:help_rookie_ui/web_data/route/route_deal.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';

void main() {
  setPathUrlStrategy();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => RouteDeal())],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WebRouterDelegate _routerDelegate = WebRouterDelegate();
  final WebRouteInformationParser _webRouteInformationParser =
      WebRouteInformationParser();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'help cookie',
      debugShowCheckedModeBanner: false,
      routerDelegate: _routerDelegate,
      routeInformationParser: _webRouteInformationParser,
      // supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
    );
  }
}
