import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:help_rookie_ui/pages/edit/editor_area.dart';
import 'package:help_rookie_ui/pages/edit/editor_toolbar.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, required this.document}) : super(key: key);
  final Document document;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _controller = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();
  var _isReadOnly = false;

  @override
  void initState() {
    super.initState();
    _controller.document = widget.document;
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!_isReadOnly)
            MyQuillToolbar(
              controller: _controller,
              focusNode: _editorFocusNode,
            ),
          Expanded(
            child: MyQuillEditor(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                readOnly: _isReadOnly,
              ),
              scrollController: _editorScrollController,
              focusNode: _editorFocusNode,
            ),
          ),
        ],
      ),
    );
  }
}
