import 'package:fluent_ui/fluent_ui.dart';
import 'package:animated_text_kit/animated_text_kit.dart' as at;
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/config/theme.dart';
import 'package:provider/provider.dart';

class TopNavigationBar extends StatefulWidget {
  const TopNavigationBar({Key? key}) : super(key: key);

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  static const List<IconData> _routeIcons = [
    FluentIcons.home,
    FluentIcons.hands_free,
    FluentIcons.share
  ];
  static const List<IconData> _iconList = [FluentIcons.account_management];

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return Container(
      height: 47,
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[80],
                offset: const Offset(2.0, 2.0),
                blurRadius: 4.0),
          ],
          borderRadius: BorderRadius.circular(4),
          border:
              Border(top: BorderSide(width: 2, color: appTheme.color.lighter))),
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
                for (int i = 0; i < _routeIcons.length + 2; i++)
                  if (i % 2 == 0)
                    IconButton(
                        icon: Icon(
                          _routeIcons[i ~/ 2],
                          size: 20,
                          color: Colors.grey[130],
                        ),
                        onPressed: () {
                          if (i == 0) {
                            context.goNamed('home');
                          } else if (i == 2) {
                            context.goNamed('seek-help');
                          }
                        })
                  else
                    const SizedBox(width: 10)
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
