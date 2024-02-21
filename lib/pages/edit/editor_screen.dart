import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen(
      {Key? key, required this.editStatus, required this.routeArgs})
      : super(key: key);

  //编辑状态 0 新增求助 1 修改求助 2 新增帮助 3 修改帮助
  //根据不同的状态相应不同的方法
  final int editStatus;
  final List<String> routeArgs;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

//还需要显示一些其他页面
//比如：
//没有编辑权限,显示无法编辑页面
//未登录，显示未登录页面,该页面可以添加一个按钮，点击跳转到登陆界面
//等等...
class _EditorScreenState extends State<EditorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
