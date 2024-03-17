import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/other/helper.dart';
import 'package:help_rookie_ui/other/return_state.dart';

mixin MacroComponent {

  Future<void> showInfo(BuildContext context, ReturnState returnState,
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

  Future<bool> showConfirmDialog(BuildContext context, List<String> message,
      {List<String> btnText = const ['Cancel', 'Confirm']}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(message[0]),
        content: Text(message[1]),
        actions: [
          Button(
              child: Text(btnText[0]),
              onPressed: () => Navigator.pop(context, false)),
          FilledButton(
            child: Text(btnText[1]),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
