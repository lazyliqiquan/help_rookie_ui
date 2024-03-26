import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/config/code.dart';

//筛选条件
//状态，语言，排序方式
//status, language, sort

class FlyoutOptions extends StatefulWidget {
  const FlyoutOptions(
      {Key? key, required this.popupType, this.isSeekHelp = true})
      : super(key: key);
  final int popupType;
  final bool isSeekHelp;

  @override
  State<FlyoutOptions> createState() => _FlyoutOptionsState();
}

class _FlyoutOptionsState extends State<FlyoutOptions> {
  @override
  Widget build(BuildContext context) {
    return DropDownButton(
        trailing: Icon(_trailingList[widget.popupType]),
        items: [
          MenuFlyoutItemBuilder(builder: (context) {
            return Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(_popupTitle[widget.popupType],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)));
          }),
          const MenuFlyoutSeparator(),
          ...List.generate(_getLength().length, (index) {
            return MenuFlyoutItem(
                leading: widget.popupType == 2
                    ? Icon(
                        _sortOptionIconList.sublist(
                            0,
                            _sortOptionIconList.length -
                                (widget.isSeekHelp ? 0 : 2))[index],
                        color: Colors.black)
                    : null,
                text: Text(_getLength()[index]),
                onPressed: () {});
          })
        ]);
  }

  List<String> _getLength() {
    if (widget.popupType == 0) {
      if (widget.isSeekHelp) {
        return _seekHelpStatusList;
      }
      return _lendHandStatusList;
    } else if (widget.popupType == 1) {
      return _languageList;
    }
    if (widget.isSeekHelp) {
      return _sortOptionStrList;
    }
    return _sortOptionStrList.sublist(0, _sortOptionStrList.length - 2);
  }

  static const _trailingList = [
    FluentIcons.event_tentative,
    FluentIcons.code,
    FluentIcons.sort_lines_ascending
  ];
  static const _popupTitle = ['Status', 'Language', 'Sort'];
  static const _seekHelpStatusList = ['All', 'Resolved', 'Unsolved'];
  static const _lendHandStatusList = ['All', 'Accept', 'Unapproved'];
  static const _sortOptionStrList = [
    'Time',
    'Like',
    'Comment',
    'Reward',
    'dynamic'
  ];
  static const _languageList = ['All', ...WebSupportCode.supportLanguage];
  static const _sortOptionIconList = [
    FluentIcons.date_time_mirrored,
    FluentIcons.like,
    FluentIcons.comment,
    //下面两个lend hand list用不到
    FluentIcons.circle_dollar,
    FluentIcons.add_friend
  ];
//  FluentIcons.commitments 握手图标
}
