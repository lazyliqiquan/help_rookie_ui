import 'package:fluent_ui/fluent_ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/data/user/login.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/pages/login/background.dart';
import 'package:help_rookie_ui/widgets/info_bar.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _loginType = 0;
  late List<TextEditingController> textEditingControllers;
  static const List<IconData> _iconList = [
    Icons.person_outline,
    Icons.mail_outline,
    Icons.verified_user_outlined
  ];

  static const List<String> _strList = ['user name', 'mailbox', 'auth code'];

  @override
  void initState() {
    textEditingControllers =
        List.generate(2, (index) => TextEditingController());
    final List<String> userLocalInfo =
        context.read<LoginModel>().getUserLocalInfo();
    textEditingControllers[0].text = userLocalInfo[0];
    textEditingControllers[1].text = userLocalInfo[1];
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
    LoginModel loginModel = context.watch<LoginModel>();

    return LoginBackground(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Help cookie',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25)),
        const SizedBox(height: 10),
        const Text('Give someone a rose, leave fragrance in your hand',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black54)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_iconList.length, (index) {
            return ui.ToggleButton(
              checked: _loginType == index,
              onChanged: (_) {
                if (index == 0 || _loginType == 0) {
                  textEditingControllers[0].clear();
                }
                setState(() {
                  _loginType = index;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconList[index], size: 20),
                  const SizedBox(width: 10),
                  Text(_strList[index])
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        ui.TextBox(
          controller: textEditingControllers[0],
          placeholder: 'Name',
          expands: false,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (_loginType == 2)
              SendCode(getEmail: <String>() {
                return textEditingControllers[0].text;
              }),
            if (_loginType == 2) const SizedBox(width: 10),
            Expanded(
                child: ui.TextBox(
              controller: textEditingControllers[1],
              placeholder: _loginType == 2 ? 'auth code' : 'password',
              expands: false,
            ))
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ui.Checkbox(
                  checked: loginModel.isRemember,
                  onChanged: (bool? value) {
                    context.read<LoginModel>().isRemember = (value ?? false);
                  }.throttleArg(),
                ),
                const SizedBox(width: 10),
                const Text('Remember me')
              ],
            ),
            ui.HyperlinkButton(
              child: const Text('Forgot password'),
              onPressed: () {
                context.goNamed('find-password');
              },
            )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
            width: double.infinity,
            child: ui.FilledButton(
              onPressed: () async {
                ReturnState returnState = await context
                    .read<LoginModel>()
                    .login(_loginType, textEditingControllers[0].text,
                        textEditingControllers[1].text);
                if (context.mounted) {
                  await MyInfoBar.showInfo(context, returnState);
                }
                if (context.mounted && returnState.code == 0) {
                  context.goNamed('home');
                }
              }.throttle(),
              child: const Text('Sign in'),
            )),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don‘t have an account ? '),
            ui.HyperlinkButton(
              child: const Text('Request a free trial'),
              onPressed: () {
                context.goNamed('register');
                debugPrint('register');
              },
            )
          ],
        )
      ],
    ));
  }
}

class SendCode extends StatefulWidget {
  const SendCode({Key? key, required this.getEmail}) : super(key: key);
  final String Function() getEmail;

  @override
  State<SendCode> createState() => _SendCodeState();
}

class _SendCodeState extends State<SendCode> {
  @override
  Widget build(BuildContext context) {
    LoginModel loginModel = context.watch<LoginModel>();
    return SizedBox(
        width: 100,
        child: ui.ToggleButton(
          checked: false,
          onChanged: (_) async {
            ReturnState returnState =
                await context.read<LoginModel>().sendCode(widget.getEmail());
            if (context.mounted) {
              await MyInfoBar.showInfo(context, returnState);
            }
          }.throttleArg(),
          child: Text(loginModel.countDown <= 0
              ? 'Send code'
              : loginModel.countDown.toString()),
        ));
  }
}
