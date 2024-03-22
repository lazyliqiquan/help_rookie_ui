import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';

class DealError extends StatefulWidget {
  const DealError({Key? key, required this.errorInfo}) : super(key: key);
  final String errorInfo;

  @override
  State<DealError> createState() => _DealErrorState();
}

class _DealErrorState extends State<DealError> {
  @override
  Widget build(BuildContext context) {
    return ScreenLimit(
        showTopNavigationBar: false,
        isCustom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.errorInfo, style: TextStyle(color: Colors.grey[120])),
              const SizedBox(height: 20),
              FilledButton(
                  child: const Text('go home'),
                  onPressed: () {
                    context.goNamed('home');
                  })
            ],
          ),
        ));
  }
}
