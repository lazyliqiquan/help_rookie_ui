import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/other/helper.dart';
import 'package:help_rookie_ui/other/return_state.dart';

class MyInfoBar {
  static Future<void> showInfo(BuildContext context, ReturnState returnState,
      {int duration = 5}) async {
    await displayInfoBar(context,
        alignment: Alignment.topCenter,
        duration: Duration(seconds: duration), builder: (context, close) {
      return InfoBar(
        title: const Text(''),
        isLong: returnState.msg.length > 50,
        content: Text(returnState.msg),
        severity: WebHelper.parseStatus(returnState),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
      );
    });
  }
}
