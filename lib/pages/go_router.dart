import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/pages/edit/editor_screen.dart';
import 'package:help_rookie_ui/pages/home/home.dart';
import 'package:help_rookie_ui/pages/home/home_page.dart';
import 'package:help_rookie_ui/pages/login/find_password.dart';
import 'package:help_rookie_ui/pages/login/login.dart';
import 'package:help_rookie_ui/pages/login/register.dart';
import 'package:provider/provider.dart';

class MyRouter {
  GoRouter get goRouter => _router;
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Home(
              child: HomePage(),
            ),
        redirect: (context, state) {
          // 只在首次加载是挑战到login,其他不跳转
          // if (state.uri.toString() == '/' &&
          //     !context.read<LoginModel>().isLoginSuccess) {
          //   return '/login';
          // }
          return null;
        },
        routes: [
          GoRoute(
              path: 'login',
              name: 'login',
              builder: (context, state) => const Login()),
          GoRoute(
              path: 'register',
              name: 'register',
              builder: (context, state) => const Register()),
          GoRoute(
              path: 'find-password',
              name: 'find-password',
              builder: (context, state) => const FindPassword()),
          GoRoute(
              path: 'edit',
              name: 'edit',
              redirect: (context, state) {
                //不管url是什么，都直接跳转到主页面的，而不是子路由
                return '/';
              },
              routes: [
                GoRoute(
                    path: 'seek-help',
                    name: 'seek-help',
                    builder: (context, state) =>
                        const EditorScreen(editStatus: 0, routeArgs: []),
                    routes: [
                      GoRoute(
                          path: ':seek-help-id',
                          builder: (context, state) =>
                              const EditorScreen(editStatus: 1, routeArgs: []))
                    ]),
                GoRoute(
                    path: ':seek-help-id/lend-hand',
                    builder: (context, state) =>
                        const EditorScreen(editStatus: 2, routeArgs: []),
                    routes: [
                      GoRoute(
                          path: ':lend-hand-id',
                          builder: (context, state) =>
                              const EditorScreen(editStatus: 3, routeArgs: []))
                    ]),
              ]),
        ])
  ]);
}