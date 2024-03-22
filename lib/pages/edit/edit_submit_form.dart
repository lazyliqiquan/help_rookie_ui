import 'dart:html';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:help_rookie_ui/data/config/code.dart';
import 'package:help_rookie_ui/data/config/other.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/other/helper.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/widgets/convenience_module.dart';
import 'package:help_rookie_ui/widgets/macro_mixin.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class EditSubmitForm extends StatefulWidget {
  const EditSubmitForm({Key? key, required this.document}) : super(key: key);
  final List<Map<String, dynamic>> document;

  @override
  State<EditSubmitForm> createState() => _EditSubmitFormState();
}

class _EditSubmitFormState extends State<EditSubmitForm> with MacroComponent {
  static const String _fileSizeLimit = 'The file size exceeds the limit ';

  late List<TextEditingController> textEditingControllers;
  late FocusNode _focusNode;
  int _selectNum = 1;

  @override
  void initState() {
    _focusNode = FocusNode();
    textEditingControllers =
        List.generate(2, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < textEditingControllers.length; i++) {
      textEditingControllers[i].dispose();
    }
    super.dispose();
  }

  void _setSelectNum(int num) {
    _selectNum = num;
    setState(() {});
  }

  void _setTags(EditModel editModel) {
    if (textEditingControllers[1].text.trim().isEmpty) {
      return;
    }
    if (editModel.tags.length >= 3) {
      showInfo(context, ReturnState.info('Up to three tags'));
      return;
    }
    editModel.tags = textEditingControllers[1].text;
    textEditingControllers[1].clear();
  }

  @override
  Widget build(BuildContext context) {
    EditModel editModel = context.watch<EditModel>();
    return Center(
        child: Container(
            width: 600,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: DefaultTextStyle(
                style: TextStyle(color: Colors.grey[120]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextBox(
                    maxLines: 1,
                    maxLength: WebDetailConfig.postTitleLengthLimit,
                    controller: textEditingControllers[0],
                    placeholder: 'Title',
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[30]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              TextBox(
                                maxLines: 1,
                                maxLength: WebDetailConfig.tagLength,
                                controller: textEditingControllers[1],
                                focusNode: _focusNode,
                                placeholder: 'tag',
                                onEditingComplete: () {
                                  _setTags(editModel);
                                },
                              ),
                              ...List.generate(editModel.tags.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TagWrap(tag: editModel.tags[index]),
                                      IconButton(
                                          icon: const Icon(
                                              FluentIcons.calculator_subtract),
                                          onPressed: () {
                                            editModel.tags = index;
                                          })
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        )),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Button(
                                        child: Text('Code file',
                                            style: TextStyle(
                                                color: Colors.grey[120])),
                                        onPressed: () async {
                                          FilePickerResult? result =
                                              await WebHelper.selectAFile(
                                                  editModel.isSeekHelp
                                                      ? WebSupportCode
                                                          .allFileType()
                                                      : ['go']);
                                          if (result == null) {
                                            return;
                                          }
                                          //文件大小不能超出限制
                                          final int fileSize =
                                              result.files.first.size;
                                          if (fileSize >
                                              (editModel.maxCodeFileSize <<
                                                  10)) {
                                            if (context.mounted) {
                                              showInfo(
                                                  context,
                                                  ReturnState.info(
                                                      '$_fileSizeLimit${editModel.maxCodeFileSize}KB'));
                                              return;
                                            }
                                          }
                                          editModel.filePickerResult = result;
                                          // 如果是lend hand,那么文件类型应该和seek help的类型一致
                                          //  不能同时选择两个文件吧
                                        }),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(editModel.isRebuild
                                      ? ''
                                      : editModel.filePickerInfo())
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (editModel.isSeekHelp)
                                Row(
                                  children: [
                                    DigitalRegulator(
                                      low: 1,
                                      high: min(editModel.remainReward, 9),
                                      initValue: 1,
                                      callBack: _setSelectNum,
                                    ),
                                    const SizedBox(width: 20),
                                    Text('Reward amount : $_selectNum')
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () async {
                          ReturnState returnState = editModel.returnState;
                          if (editModel.isSeekHelp && !editModel.isRebuild) {
                            //  新建求助帖子
                            returnState = await editModel.addSeekHelp(
                                _selectNum, widget.document);
                          }
                          if (context.mounted) {
                            showInfo(context, returnState);
                          }
                        }.throttle(),
                        child: editModel.isUploading
                            ? const Center(
                                child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: ProgressRing(
                                      strokeWidth: 2.5,
                                    )))
                            : Text(editModel.isRebuild ? 'Save' : 'Submit')),
                  )
                ]))));
  }
}
