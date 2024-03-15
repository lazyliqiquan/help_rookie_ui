import 'dart:ui' show FontFeature;
import 'package:desktop_drop/desktop_drop.dart' show DropTarget;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:help_rookie_ui/config/screen.dart';

class MyQuillEditor extends StatefulWidget {
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
  State<MyQuillEditor> createState() => _MyQuillEditorState();
}

class _MyQuillEditorState extends State<MyQuillEditor> {
  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      scrollController: widget.scrollController,
      focusNode: widget.focusNode,
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
        customStyles: const DefaultStyles(),
        scrollable: true,
        placeholder: 'Start editing ...',
        padding: const EdgeInsets.only(
            left: 25,
            right: ScreenConfig.scrollBarWidget + 25,
            top: 25,
            bottom: 25),
        onImagePaste: (imageBytes) async {
          return null;
        },
        embedBuilders: FlutterQuillEmbeds.editorWebBuilders(),
        builder: (context, rawEditor) {
          return DropTarget(
            onDragDone: (details) {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final file = details.files.first;
              //todo 自己记得写一个提示信息
              // final isSupported = imageFileExtensions.any(file.name.endsWith);
              // if (!isSupported) {
              //   scaffoldMessenger.showText(
              //     'Only images are supported right now: ${file.mimeType}, ${file.name}, ${file.path}, $imageFileExtensions',
              //   );
              //   return;
              // }
              context.requireQuillController.insertImageBlock(
                imageSource: file.path,
              );
              // scaffoldMessenger.showText('Image is inserted.');
            },
            child: rawEditor,
          );
        },
      ),
    );
  }
}
