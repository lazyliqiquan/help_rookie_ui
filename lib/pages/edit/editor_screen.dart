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
    required this.document,
    super.key,
  });

  final String document;

  @override
  State<QuillScreen> createState() => _QuillScreenState();
}

final GlobalKey contentKey = GlobalKey();

class _QuillScreenState extends State<QuillScreen> {
  static final _controller = QuillController.basic();
  static final _editorFocusNode = FocusNode();
  static final _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    //不能用匿名方法传递，否则就重复监听了，可能倒是性能问题
    _controller.addListener(() {
      debugPrint(_controller.document.length.toString());
      debugPrint(_controller.document.toDelta().toString());
    });
    //序列化
    // final json = jsonEncode(_controller.document.toDelta().toJson());
    //反序列化
    if (widget.document.isEmpty) {
      _controller.document = Document();
    } else {
      final json = jsonDecode(widget.document);
      _controller.document = Document.fromJson(json);
    }
  }

  @override
  void dispose() {
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
