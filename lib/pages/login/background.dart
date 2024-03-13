import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';

//登录界面的背景
class LoginBackground extends StatelessWidget {
  const LoginBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return ScreenLimit(
      isCustom: false,
      showTopNavigationBar: false,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.grey])),
        child: Center(
          child: Container(
            width: 400,
            height: 450,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[40],
              border: Border.all(
                color: theme.resources.controlStrokeColorSecondary,
              ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), child: child),
          ),
        ),
      ),
    );
  }
}
