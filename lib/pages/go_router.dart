import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/pages/edit/editor_screen.dart';
import 'package:help_rookie_ui/pages/home/home.dart';
import 'package:help_rookie_ui/pages/login/find_password.dart';
import 'package:help_rookie_ui/pages/login/login.dart';
import 'package:help_rookie_ui/pages/login/register.dart';
import 'package:help_rookie_ui/pages/seek_help/seek_help.dart';
import 'package:provider/provider.dart';

class MyRouter {
  GoRouter get goRouter => _router;
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Home(),
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
              path: 'seek-help',
              name: 'seek-help',
              builder: (context, state) => const SeekHelpList()),
          GoRoute(
              path: 'edit',
              name: 'edit',
              builder: (context, state) {
                //解析过程好像是从根出发，然后向下，每个组件的都会渲染一遍
                //但是我们加载数据是在build方法里面加载的，所以还应该判断一下最终显示的页面是不是自己
                return QuillScreen(
                  editOption: 0,
                  isSelf: state.uri.toString().split('/').length == 2,
                );
              },
              routes: [
                //好像还有先后顺序，':id' 应该放后面
                GoRoute(
                    path: 'lend-hand/:seekHelpId',
                    builder: (context, state) {
                      final int? seekHelpId =
                          int.tryParse(state.pathParameters['seekHelpId']!);

                      return QuillScreen(
                        editOption: 2,
                        seekHelpId: seekHelpId,
                        isSelf: state.uri.toString().split('/').length == 4,
                      );
                    },
                    routes: [
                      GoRoute(
                          path: ':lendHandId',
                          builder: (context, state) {
                            final int? seekHelpId = int.tryParse(
                                state.pathParameters['seekHelpId']!);
                            final int? lendHandId = int.tryParse(
                                state.pathParameters['lendHandId']!);

                            return QuillScreen(
                              editOption: 3,
                              seekHelpId: seekHelpId,
                              lendHandId: lendHandId,
                              isSelf: true,
                            );
                          })
                    ]),
                GoRoute(
                    path: ':seekHelpId',
                    builder: (context, state) {
                      final int? seekHelpId = int.tryParse(
                          state.pathParameters['seekHelpId'].toString());
                      return QuillScreen(
                        editOption: 1,
                        seekHelpId: seekHelpId,
                        isSelf: true,
                      );
                    })
              ])
        ])
  ]);
}
