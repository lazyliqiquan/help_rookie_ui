import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/data/seek_help/seek_help_list.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/pages/other/deal_error.dart';
import 'package:help_rookie_ui/pages/other/float_widget/seek_help.dart';
import 'package:help_rookie_ui/pages/other/float_widget/seek_help_title.dart';
import 'package:help_rookie_ui/pages/other/loading.dart';
import 'package:help_rookie_ui/pages/other/screen_limit.dart';
import 'package:help_rookie_ui/pages/seek_help/display_block.dart';
import 'package:provider/provider.dart';

class SeekHelpList extends StatefulWidget {
  const SeekHelpList({Key? key}) : super(key: key);

  @override
  State<SeekHelpList> createState() => _SeekHelpListState();
}

class _SeekHelpListState extends State<SeekHelpList> {
  //每次运行initState,_loading的值都是默认值(true)吗
  bool _loading = true;
  ReturnState _returnState = ReturnState.success('Request successful');

  @override
  void initState() {
    List<Future<ReturnState>> requestList = [
      context.read<SeekHelpListModel>().requestSeekHelpList()
    ];
    Future.wait(requestList).then((value) {
      for (var element in value) {
        if (element.code != 0) {
          //不一定要写在setState里面
          _returnState = element;
          break;
        }
      }
      if (context.mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SeekHelpListModel seekHelpListModel = context.watch<SeekHelpListModel>();
    return _loading
        ? const LoadingWidget()
        : _returnState.code == 0
            ? ScreenLimit(
                //根据列表的长度来判断高度
                //fixme 待修复
                widgetHeight: seekHelpListModel.seekHelpList.length * 100 + 500,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.only(
                      left: ScreenConfig.showWidgetLeftMargin),
                  child: Column(
                    children: [
                      const SeekHelpTitle(),
                      Container(
                        color: Colors.grey[60],
                        height: 1,
                        margin: const EdgeInsets.only(top: 20),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              seekHelpListModel.seekHelpList.length, (index) {
                            return ListDisplayBlock(
                                commonDisplayInfo:
                                    seekHelpListModel.seekHelpList[index]);
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(height: 50, color: Colors.grey)
                    ],
                  ),
                ))
            : DealError(errorInfo: _returnState.msg);
  }
}
