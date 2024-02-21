import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'dart:ui' show FontFeature;

class EditorArea extends StatefulWidget {
  const EditorArea(
      {Key? key,
      required this.configurations,
      required this.scrollController,
      required this.focusNode})
      : super(key: key);
  final QuillEditorConfigurations configurations;
  final ScrollController scrollController;
  final FocusNode focusNode;

  @override
  State<EditorArea> createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  @override
  Widget build(BuildContext context) {
    return QuillEditor(
        focusNode: widget.focusNode,
        scrollController: widget.scrollController,
        configurations: widget.configurations.copyWith(
            elementOptions: const QuillEditorElementOptions(
              codeBlock: QuillEditorCodeBlockElementOptions(
                enableLineNumbers: true,
              ),
              orderedList: QuillEditorOrderedListElementOptions(),
              unorderedList: QuillEditorUnOrderedListElementOptions(
                useTextColorForDot: true,
              ),
            ),
            customStyles: const DefaultStyles(
              h1: DefaultTextBlockStyle(
                TextStyle(
                  fontSize: 32,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                VerticalSpacing(16, 0),
                VerticalSpacing(0, 0),
                null,
              ),
              sizeSmall: TextStyle(fontSize: 9),
              subscript: TextStyle(
                fontFamily: 'SF-UI-Display',
                fontFeatures: [FontFeature.subscripts()],
              ),
              superscript: TextStyle(
                fontFamily: 'SF-UI-Display',
                fontFeatures: [FontFeature.superscripts()],
              ),
            ),
            scrollable: true,
            placeholder: 'Start writting your notes...',
            padding: const EdgeInsets.all(10),
            embedBuilders: [...(FlutterQuillEmbeds.editorWebBuilders())]));
  }
}

