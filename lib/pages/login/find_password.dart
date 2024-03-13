import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/pages/login/background.dart';
import 'package:help_rookie_ui/pages/login/login.dart';
import 'package:help_rookie_ui/pages/login/register.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';
import 'package:help_rookie_ui/widgets/info_bar.dart';
import 'package:provider/provider.dart';

class FindPassword extends StatefulWidget {
  const FindPassword({Key? key}) : super(key: key);

  @override
  State<FindPassword> createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  static const List<String> _strList = [
    'password',
    'confirm password',
    'mailbox',
    'auth code'
  ];

  late List<TextEditingController> textEditingControllers;

  @override
  void initState() {
    textEditingControllers =
        List.generate(4, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < textEditingControllers.length; i++) {
      textEditingControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginTopBar(isRegister: false),
          const SizedBox(height: 20),
          for (int i = 0; i < 7; i++)
            if (i % 2 == 1)
              const SizedBox(height: 10)
            else
              Row(
                children: [
                  if (i > 5)
                    SendCode(getEmail: <String>() {
                      return textEditingControllers[2].text;
                    }),
                  if (i > 5) const SizedBox(width: 10),
                  Expanded(
                      child: TextBox(
                    controller: textEditingControllers[i ~/ 2],
                    placeholder: _strList[i ~/ 2],
                  ))
                ],
              ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                ReturnState returnState =
                    await context.read<LoginModel>().findPassword(
                          textEditingControllers[2].text,
                          textEditingControllers[3].text,
                          textEditingControllers[0].text,
                          textEditingControllers[1].text,
                        );
                if (context.mounted) {
                  await MyInfoBar.showInfo(context, returnState);
                }
                if (context.mounted && returnState.code == 0) {
                  context.goNamed('login');
                }
              }.throttle(),
              child: const Text('Find password'),
            ),
          )
        ],
      ),
    );
  }
}
