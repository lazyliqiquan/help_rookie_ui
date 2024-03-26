import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/post_data/list_common_data.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/pages/other/deal_error.dart';
import 'package:help_rookie_ui/pages/other/loading.dart';
import 'package:help_rookie_ui/pages/post_ui/common_list_ui.dart';
import 'package:provider/provider.dart';

class LendHandList extends StatefulWidget {
  const LendHandList({Key? key}) : super(key: key);

  @override
  State<LendHandList> createState() => _LendHandListState();
}

class _LendHandListState extends State<LendHandList> {
  bool _loading = true;
  ReturnState _returnState = ReturnState.success('Request successful');

  @override
  void initState() {
    List<Future<ReturnState>> requestList = [
      context.read<ListCommonSort>().sort(isSeekHelp: false),
      //  todo 还应该有一个PostModel之类的控件，方便控制悬浮按钮的点击事件
      //  如当前的求助帖子id，等等信息
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
    return _loading
        ? const LoadingWidget()
        : _returnState.code == 0
            ? const CommonListUI(floatWidgets: [])
            : DealError(errorInfo: _returnState.msg);
  }
}

//todo 左侧的悬浮按钮可以写在这里
