// import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class MyQuillEditor extends StatelessWidget {
  const MyQuillEditor({
    required this.configurations,
    required this.scrollController,
    required this.focusNode,
    super.key,
  });

  final QuillEditorConfigurations configurations;
  final ScrollController scrollController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
        scrollController: scrollController,
        focusNode: focusNode,
        configurations: configurations.copyWith(
            elementOptions: const QuillEditorElementOptions(
              codeBlock: QuillEditorCodeBlockElementOptions(
                enableLineNumbers: true,
              ),
              orderedList: QuillEditorOrderedListElementOptions(),
              unorderedList: QuillEditorUnOrderedListElementOptions(
                useTextColorForDot: true,
              ),
            ),
            scrollable: true,
            placeholder: 'Start writting your notes...',
            padding: const EdgeInsets.all(16),
            onImagePaste: (imageBytes) async {
              return null;
            },
            embedBuilders: [...(FlutterQuillEmbeds.editorWebBuilders())]));
  }
}
