import 'package:fluent_ui/fluent_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      color: const Color(0xfff0f2f5),
      child: Center(
        child: Container(height: 50, width: 50,color: Colors.white,),
      ),
    );
  }
}
