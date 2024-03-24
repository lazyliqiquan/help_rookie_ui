import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'
    show QuillSharedExtensionsConfigurations;
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/pages/edit/edit_submit_form.dart';
import 'package:help_rookie_ui/pages/edit/editor_area.dart';
import 'package:help_rookie_ui/pages/edit/editor_toolbar.dart';
import 'package:help_rookie_ui/pages/other/deal_error.dart';
import 'package:help_rookie_ui/pages/other/float_widget/edit_float_side_widget.dart';
import 'package:help_rookie_ui/pages/other/loading.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';
import 'package:provider/provider.dart';

class QuillScreen extends StatefulWidget {
  const QuillScreen({
    this.editOption = 0,
    this.seekHelpId,
    this.lendHandId,
    this.isSelf = false,
    super.key,
  });

  final int? seekHelpId;
  final int? lendHandId;
  final bool isSelf;

  // 0 新增求助 1 修改求助 2 新增帮助 3 修改帮助
  final int editOption;

  @override
  State<QuillScreen> createState() => _QuillScreenState();
}

final GlobalKey contentKey = GlobalKey();

class _QuillScreenState extends State<QuillScreen> {
  //我是用静态成员，document虽然调用了notifyListeners(),但是能监听得到吗？他是quill内部自己维护，应该可以
  static final _controller = QuillController.basic();
  static final _editorFocusNode = FocusNode();
  static final _editorScrollController = ScrollController();
  bool _loading = true;

  //得用深度优先搜索
  void dfs(Map<String, dynamic> map) {
    //能够保证value的类型只会是Map<String,dynamic> 或者是 String吗，有没有可能还包含List<Map<String, dynamic>>
    //应该是能够保证的，一行一般只有一个属性
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        dfs(value);
      } else {
        if (key == 'image') {
          debugPrint('*${value.toString()}*');
        }
      }
    });
  }

  //好吧，决定了，就在initState里面请求
  //况且edit这个模块请求的次数应该不多，而且需要最新的数据，所以每次调用initState都请求后端也是可以接受的
  //但是不能在initState里面调用notifyListeners()，就算不调用应该也检测得到值吧，因为是初始值,不算改变值
  @override
  void initState() {
    super.initState();

    List<Future<void>> requestList = [
      context.read<EditModel>().editAuthentication(
          widget.editOption < 2, widget.editOption % 2 == 1,
          seekHelpId: widget.seekHelpId, lendHandId: widget.lendHandId),
      // if(widget.editOption == 1 || widget.editOption == 3)
      //    todo 还需要加载之前的文档以及其他资源
    ];

    //判断是否是真的调用自己
    if (widget.isSelf) {
      Future.wait(requestList).then((value) {
        //等异步队列里面的任务都处理完毕了，就回调该方法
        // 避免报错 setState() called after dispose()
        if (context.mounted) {
          setState(() {
            _loading = false;
          });
          //  todo 给编辑控制器加上监听事件
        }
      });
    }

    //fixme go-router 不能用匿名方法传递，否则就重复监听了，可能倒是性能问题
    _controller.addListener(() {
      //todo 如果有些操作不合法，可以去掉
      // _controller.undo();
      // debugPrint('*' * 30);
      // final json = _controller.document.toDelta().toJson();
      // debugPrint(json.length.toString());
      // for (int i = 0; i < json.length; i++) {
      //   dfs(json[i]);
      // }
      // debugPrint(_controller.document.length.toString());
      // debugPrint(_controller.document.toDelta().toString());
      // final json = jsonEncode(_controller.document.toDelta().toJson());

      // debugPrint(json.toString());
    });
    //序列化
    // final json = jsonEncode(_controller.document.toDelta().toJson());

    //反序列化
    _controller.document = Document();
    // if (widget.document.isEmpty) {
    // } else {
    //   final json = jsonDecode(widget.document);
    //   _controller.document = Document.fromJson(json);
    // }
  }

  Widget floatEditToolbar = Positioned(
      left: 0,
      right: ScreenConfig.scrollBarWidget,
      top: 0,
      child:
          MyQuillToolbar(controller: _controller, focusNode: _editorFocusNode));

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingWidget()
        : Builder(builder: (context) {
            EditModel editModel = context.watch<EditModel>();
            return editModel.returnState.code == 0
                ? ScreenLimit(
                    showTopNavigationBar: false,
                    isCustom: editModel.isEditing,
                    floatWidgets: [
                      const EditFloatSideWidget(),
                      if (!editModel.isReadOnly) floatEditToolbar
                    ],
                    widgetHeight: 1200,
                    child: Container(
                      //isCustom为true的时候，widgetHeight才有用
                      // height: editModel.isEditing ? 1200 : null,
                      color: editModel.isEditing ? Colors.white : null,
                      margin: EdgeInsets.only(
                          left: ScreenConfig.showWidgetLeftMargin,
                          top: editModel.isReadOnly
                              ? 0
                              : ScreenConfig.topWidgetHeight),
                      child: editModel.isEditing
                          ? MyQuillEditor(
                              key: contentKey,
                              configurations: QuillEditorConfigurations(
                                sharedConfigurations: _sharedConfigurations,
                                controller: _controller,
                                readOnly: editModel.isReadOnly,
                              ),
                              scrollController: _editorScrollController,
                              focusNode: _editorFocusNode,
                            )
                          : EditSubmitForm(
                              document:
                                  _controller.document.toDelta().toJson()),
                    ))
                : DealError(errorInfo: editModel.returnState.msg);
          });
  }

  QuillSharedConfigurations get _sharedConfigurations {
    return const QuillSharedConfigurations(
      // locale: Locale('en'),
      extraConfigurations: {
        QuillSharedExtensionsConfigurations.key:
            QuillSharedExtensionsConfigurations(
          assetsPrefix: 'assets', // Defaults to assets
        ),
      },
    );
  }
}
