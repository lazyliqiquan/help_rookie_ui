import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/pages/login/background.dart';
import 'package:help_rookie_ui/pages/login/login.dart';
import 'package:help_rookie_ui/widgets/macro_mixin.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with MacroComponent {
  late List<TextEditingController> textEditingControllers;

  static const List<String> _strList = [
    'user name',
    'password',
    'confirm password',
    'mailbox',
    'auth code'
  ];

  @override
  void initState() {
    textEditingControllers =
        List.generate(_strList.length, (index) => TextEditingController());
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
        const LoginTopBar(isRegister: true),
        const SizedBox(height: 20),
        for (int i = 0; i < 9; i++)
          if (i % 2 == 1)
            const SizedBox(height: 10)
          else
            Row(
              children: [
                if (i > 7)
                  SendCode(getEmail: <String>() {
                    return textEditingControllers[3].text;
                  }),
                if (i > 7) const SizedBox(width: 10),
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
              ReturnState returnState = await context
                  .read<LoginModel>()
                  .register(
                      textEditingControllers[3].text,
                      textEditingControllers[4].text,
                      textEditingControllers[0].text,
                      textEditingControllers[1].text,
                      textEditingControllers[2].text);
              if (context.mounted) {
                await showInfo(context, returnState);
              }
              //这两个应该哪个在前，哪个在后？
              if (context.mounted && returnState.code == 0) {
                context.goNamed('login');
              }
            }.throttle(),
            child: const Text('Register'),
          ),
        )
      ],
    ));
  }
}

class LoginTopBar extends StatelessWidget {
  const LoginTopBar({Key? key, required this.isRegister}) : super(key: key);
  final bool isRegister;
  static const List<String> _strList = [
    'Create Account',
    'Forgot Password',
    'Fill in the form below'
  ];

  static const List<IconData> _iconDataList = [
    FluentIcons.people_add,
    FluentIcons.password_field
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          child: Button(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.chevron_left),
                  SizedBox(width: 10),
                  Text('login')
                ],
              ),
              onPressed: () {
                context.goNamed('login');
              }),
        ),
        const SizedBox(width: 40),
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_strList[isRegister ? 0 : 1],
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(
            _strList[2],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[200],
            ),
          )
        ]),
        const SizedBox(width: 40),
        Icon(_iconDataList[isRegister ? 0 : 1], size: 30)
      ],
    );
  }
}
