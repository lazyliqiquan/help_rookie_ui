import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/config/code.dart';
import 'package:help_rookie_ui/data/config/other.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/widgets/convenience_module.dart';

class EditSubmitForm extends StatefulWidget {
  const EditSubmitForm({Key? key}) : super(key: key);

  @override
  State<EditSubmitForm> createState() => _EditSubmitFormState();
}

class _EditSubmitFormState extends State<EditSubmitForm> {
  late List<TextEditingController> textEditingControllers;
  static const List<String> _strList = ['Title'];
  int _selectNum = 1;

  @override
  void initState() {
    textEditingControllers =
        List.generate(1, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < textEditingControllers.length; i++) {
      textEditingControllers[i].dispose();
    }
    super.dispose();
  }

  String _message() {
    return 'Only support : ${WebSupportCode.supportLanguage.join(' , ')}.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        height: 300,
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.grey[120]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(FluentIcons.title),
                  const SizedBox(width: 20),
                  Expanded(
                      child: TextBox(
                    maxLines: 1,
                    maxLength: WebDetailConfig.postTitleLengthLimit,
                    controller: textEditingControllers[0],
                    placeholder: _strList[0],
                  ))
                ],
              ),
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    const Icon(FluentIcons.file_code),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 300,
                      child: Tooltip(
                        message: _message(),
                        child: ToggleButton(
                          child: Text(
                              true ? 'Select code file' : 'Overlay code file'),
                          checked: false,
                          onChanged: (_) async {
                            await Future.delayed(const Duration(seconds: 5),
                                () {
                              debugPrint('sds');
                            });
                          }.throttleArg(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    Text('File size : 1000 MB')
                  ],
                ),
              ),
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    const Icon(FluentIcons.circle_dollar),
                    const SizedBox(width: 20),
                    SelectOneToNine(
                      callBack: (int num) {
                        _selectNum = num;
                      },
                    )
                  ],
                ),
              ),
              //  todo 文档大小
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    const Icon(FluentIcons.diet_plan_notebook),
                    const SizedBox(width: 20),
                    Text('jslskd' * 5)
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child:
                    FilledButton(child: const Text('Save'), onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
