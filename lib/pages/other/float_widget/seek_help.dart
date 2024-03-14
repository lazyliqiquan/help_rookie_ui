import 'package:fluent_ui/fluent_ui.dart';

class SeekHelpSideFloatButton extends StatefulWidget {
  const SeekHelpSideFloatButton({Key? key}) : super(key: key);

  @override
  State<SeekHelpSideFloatButton> createState() =>
      _SeekHelpSideFloatButtonState();
}

class _SeekHelpSideFloatButtonState extends State<SeekHelpSideFloatButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 103,
        left: 40,
        child: Container(
          width: 50,
          height: 200,
          color: Colors.white,
          child: Column(
            children: [],
          ),
        ));
  }
}
