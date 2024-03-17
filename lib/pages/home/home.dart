import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/pages/other/loading.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return true ? const LoadingWidget() : ScreenLimit(
      child: Container(),
    );
  }
}
