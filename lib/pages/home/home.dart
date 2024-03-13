import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/pages/home/home_page.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';
import 'package:help_rookie_ui/pages/other/top_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.child}) : super(key: key);
  final Widget child;

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
    return ScreenLimit(
      child: const HomePage(),
    );
  }
}
