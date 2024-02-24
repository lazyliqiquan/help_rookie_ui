import 'package:fluent_ui/fluent_ui.dart';
import 'package:animated_text_kit/animated_text_kit.dart' as at;
import 'package:help_rookie_ui/config/theme.dart';
import 'package:provider/provider.dart';

class TopNavigationBar extends StatefulWidget {
  const TopNavigationBar({Key? key}) : super(key: key);

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  static const List<String> _strList = ['home', 'seek help', 'share'];
  static const List<IconData> _iconList = [FluentIcons.account_management];
  int _route = 1; // 0 项目介绍 1 home 2 seek help 3 share

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: appTheme.color.lighter))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: HyperlinkButton(
              onPressed: () {},
              child: at.AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  at.WavyAnimatedText('help cookie',
                      speed: const Duration(milliseconds: 500),
                      textStyle: TextStyle(
                          color: appTheme.color.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < _strList.length + 2; i++)
                  if (i % 2 == 0)
                    HyperlinkButton(
                        child: Text(
                          _strList[i ~/ 2],
                          style: TextStyle(
                              color: (i ~/ 2 + 1) == _route
                                  ? appTheme.color.normal
                                  : Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _route = i ~/ 2 + 1;
                          });
                        })
                  else
                    const SizedBox(width: 5)
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_iconList.length * 2, (index) {
                  if (index % 2 == 0) {
                    return IconButton(
                        icon: Icon(_iconList[index ~/ 2]), onPressed: () {});
                  }
                  return const SizedBox(width: 10);
                })),
          )
        ],
      ),
    );
  }
}
