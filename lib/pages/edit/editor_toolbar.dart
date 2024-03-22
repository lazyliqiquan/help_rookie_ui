import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:provider/provider.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  static final picker = imagePicker.ImagePicker();

  final QuillController controller;
  final FocusNode focusNode;

  // Method to pick an image from the device's gallery
  Future<void> _pickImage(EditModel editModel) async {
    final imagePicker.XFile? pickedFile =
        await picker.pickImage(source: imagePicker.ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    //这里的editModel是read，但没事，我们没有界面需要用到这些数据
    editModel.imageFiles[pickedFile.path] = pickedFile;
    // final imageBytes = await pickedFile.readAsBytes();
    // imagePicker.XFile myBlob = imagePicker.XFile.fromData(imageBytes);
    controller
      ..skipRequestKeyboard = true
      ..insertImageBlock(imageSource: pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    EditModel editModel = context.read<EditModel>();
    return QuillToolbar(
      configurations: const QuillToolbarConfigurations(),
      child: Container(
        height: 47,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuillToolbarHistoryButton(isUndo: true, controller: controller),
            QuillToolbarHistoryButton(isUndo: false, controller: controller),
            QuillToolbarFontSizeButton(controller: controller),
            QuillToolbarClearFormatButton(controller: controller),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.bold),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.italic),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.underline),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.strikeThrough),
            QuillToolbarColorButton(
                controller: controller, isBackground: false),
            QuillToolbarColorButton(controller: controller, isBackground: true),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.centerAlignment),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.leftAlignment),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.rightAlignment),
            QuillToolbarCustomButton(
              controller: controller,
              options: QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.image, size: 25),
                  onPressed: () {
                    _pickImage(editModel);
                  }.throttle()),
            ),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.ol),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.ul),
            QuillToolbarToggleCheckListButton(controller: controller),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.codeBlock),
            QuillToolbarToggleStyleButton(
                options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.code_off_outlined, iconSize: 16),
                controller: controller,
                attribute: Attribute.inlineCode),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.blockQuote),
            QuillToolbarLinkStyleButton(controller: controller),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.subscript),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.superscript),
          ],
        ),
      ),
    );
  }
}
