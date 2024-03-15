import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/pages/other/float_widget/seek_help.dart';
import 'package:help_rookie_ui/pages/other/float_widget/seek_help_title.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';

class SeekHelpList extends StatefulWidget {
  const SeekHelpList({Key? key}) : super(key: key);

  @override
  State<SeekHelpList> createState() => _SeekHelpListState();
}

class _SeekHelpListState extends State<SeekHelpList> {
  @override
  Widget build(BuildContext context) {
    return ScreenLimit(
        widgetHeight: 1500,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(30),
          margin:
              const EdgeInsets.only(left: 130, right: 60, top: 50, bottom: 50),
          child: Column(
            children: [
              const SeekHelpTitle(),
              Container(
                color: Colors.grey[60],
                height: 1,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
              ),
              Expanded(child: Container()),
              const SizedBox(height: 20),
              Container(height: 50, color: Colors.grey)
            ],
          ),
        ));
  }
}
