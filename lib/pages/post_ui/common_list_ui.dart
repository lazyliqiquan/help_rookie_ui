import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/data/post_data/list_common_data.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';
import 'package:help_rookie_ui/pages/post_ui/display_block.dart';
import 'package:help_rookie_ui/pages/post_ui/list_title.dart';
import 'package:provider/provider.dart';

//seek help 和 lend hand共用ui
class CommonListUI extends StatefulWidget {
  const CommonListUI({Key? key, required this.floatWidgets}) : super(key: key);
  final List<Widget> floatWidgets;

  @override
  State<CommonListUI> createState() => _CommonListUIState();
}

class _CommonListUIState extends State<CommonListUI> {
  @override
  Widget build(BuildContext context) {
    ListCommonSort listCommonSort = context.watch<ListCommonSort>();
    return ScreenLimit(
      widgetHeight: listCommonSort.commonList.length *
              ScreenConfig.listDisplayBlockHeight +
          250,
      floatWidgets: widget.floatWidgets,
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(30),
          margin:
              const EdgeInsets.only(left: ScreenConfig.showWidgetLeftMargin),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  const ListTitle(),
                  Container(
                    color: Colors.grey[60],
                    height: 1,
                  ),
                  listCommonSort.commonList.isNotEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                listCommonSort.commonList.length, (index) {
                              return ListDisplayBlock(
                                  commonDisplayInfo:
                                      listCommonSort.commonList[index]);
                            }),
                          ),
                        )
                      : const SizedBox(
                          height: 100,
                          child: Center(child: Text('Nonexistent data')),
                        ),
                ],
              )),
              const SizedBox(height: 20),
              Container(height: 50, color: Colors.grey)
            ],
          )),
    );
  }
}
