import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorToolbar extends StatefulWidget {
  const EditorToolbar(
      {Key? key, required this.controller, required this.focusNode})
      : super(key: key);
  final QuillController controller;
  final FocusNode focusNode;

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      configurations: const QuillToolbarConfigurations(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          children: [
            QuillToolbarHistoryButton(
              isUndo: true,
              controller: widget.controller,
            ),
            QuillToolbarHistoryButton(
              isUndo: false,
              controller: widget.controller,
            ),
            QuillToolbarFontSizeButton(controller: widget.controller),
            QuillToolbarSelectHeaderStyleDropdownButton(
              controller: widget.controller,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(),
              controller: widget.controller,
              attribute: Attribute.bold,
            ),
            QuillToolbarToggleStyleButton(
              options: const QuillToolbarToggleStyleButtonOptions(),
              controller: widget.controller,
              attribute: Attribute.italic,
            ),
            QuillToolbarToggleStyleButton(
              controller: widget.controller,
              attribute: Attribute.underline,
            ),
            QuillToolbarClearFormatButton(
              controller: widget.controller,
            ),
            QuillToolbarColorButton(
              controller: widget.controller,
              isBackground: false,
            ),
            QuillToolbarColorButton(
              controller: widget.controller,
              isBackground: true,
            ),
            QuillToolbarSelectAlignmentButton(
              controller: widget.controller,
            ),
            QuillToolbarToggleCheckListButton(
              controller: widget.controller,
            ),
            QuillToolbarToggleStyleButton(
              controller: widget.controller,
              attribute: Attribute.ol,
            ),
            QuillToolbarToggleStyleButton(
              controller: widget.controller,
              attribute: Attribute.ul,
            ),
            QuillToolbarToggleStyleButton(
              controller: widget.controller,
              attribute: Attribute.inlineCode,
            ),
            QuillToolbarToggleStyleButton(
                controller: widget.controller, attribute: Attribute.codeBlock),
            QuillToolbarToggleStyleButton(
              controller: widget.controller,
              attribute: Attribute.blockQuote,
            ),
            QuillToolbarLinkStyleButton(controller: widget.controller),
          ],
        ),
      ),
    );
  }
}
