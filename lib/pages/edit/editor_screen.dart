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
import 'package:help_rookie_ui/pages/other/float_widget/edit_float_side_widget.dart';
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


  //好吧，决定了，就在initState里面请求
  @override
  void initState() {
    super.initState();

    //fixme go-router 不能用匿名方法传递，否则就重复监听了，可能倒是性能问题
    _controller.addListener(() {
      // debugPrint(_controller.document.length.toString());
      // debugPrint(_controller.document.toDelta().toString());
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

  @override
  void dispose() {
    //todo 要不会造成死循环吧
    _dealFinally = false;
    super.dispose();
  }

  Widget floatEditToolbar = Positioned(
      left: 0,
      right: ScreenConfig.scrollBarWidget,
      top: 0,
      child:
          MyQuillToolbar(controller: _controller, focusNode: _editorFocusNode));

  @override
  Widget build(BuildContext context) {
    EditModel editModel = context.watch<EditModel>();
    return ScreenLimit(
        showTopNavigationBar: false,
        isCustom: editModel.isEditing,
        floatWidgets: [
          const EditFloatSideWidget(),
          if (!editModel.isReadOnly) floatEditToolbar
        ],
        child: Container(
          height: editModel.isEditing ? 1200 : null,
          color: editModel.isEditing ? Colors.white : null,
          margin: EdgeInsets.only(
              left: ScreenConfig.showWidgetLeftMargin,
              top: editModel.isReadOnly ? 0 : ScreenConfig.topWidgetHeight),
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
              : const EditSubmitForm(),
        ));
  }

  bool _dealFinally = false;

  //处理路由
  void _deal() {
    // 这里也能获取到context吗？
    //不是调用自己的
    if (!widget.isSelf || _dealFinally) {
      return;
    }
    context.read<EditModel>().editAuthentication(
        widget.editOption < 2, widget.editOption % 2 == 1,
        seekHelpId: widget.seekHelpId, lendHandId: widget.lendHandId);
    _dealFinally = true;
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
