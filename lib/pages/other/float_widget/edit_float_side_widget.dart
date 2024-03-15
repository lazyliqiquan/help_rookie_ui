import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/data/edit/edit.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/widgets/macro_mixin.dart';
import 'package:provider/provider.dart';

//编辑文档界面左侧的浮动组件
//seek help
//新建 : 返回，锁屏，提交(代码文件，悬赏，标题)
//编辑 : 返回，锁屏，保存(覆盖代码文件，)【可能会保存失败，因为已经有用户提交帮助帖子了】
//lend hand
//新建 : 返回，锁屏，提交(代码文件)
//编辑 : 返回，锁屏，保存(覆盖代码文件)【可能会保存失败，因为该帖子已经被求助者接受了】

class EditFloatSideWidget extends StatefulWidget {
  const EditFloatSideWidget({Key? key}) : super(key: key);

  @override
  State<EditFloatSideWidget> createState() => _EditFloatSideWidgetState();
}

class _EditFloatSideWidgetState extends State<EditFloatSideWidget>
    with MacroComponent {
  static List<IconData> iconDataList = [
    FluentIcons.return_to_session,
    FluentIcons.cloud_upload
  ];

  static const List<String> tooltips = ['Exit edit mode', 'Submit a post'];

  IconData _getIcon(bool isEditing, bool isReadOnly) {
    if (isEditing) {
      return isReadOnly ? FluentIcons.unlock : FluentIcons.lock;
    }
    return FluentIcons.edit;
  }

  String _getTooltip(bool isEditing, bool isReadOnly) {
    if (isEditing) {
      return isReadOnly ? 'Unlock edit box' : 'Lock edit box';
    }
    return 'Continue edit';
  }

  @override
  Widget build(BuildContext context) {
    EditModel editModel = context.watch<EditModel>();
    return Positioned(
        left: ScreenConfig.horizontalWidgetMargin,
        top: ScreenConfig.verticalWidgetMargin +
            (editModel.isReadOnly ? 0 : ScreenConfig.topWidgetHeight),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
          width: ScreenConfig.sideFloatWidgetWidth,
          height: 150,
          child: Column(
              children: List.generate(tooltips.length + 1, (index) {
            return Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: index < tooltips.length
                                ? Colors.grey[60]
                                : Colors.transparent))),
                child: Tooltip(
                  message: index == 1
                      ? _getTooltip(editModel.isEditing, editModel.isReadOnly)
                      : tooltips[index ~/ 2],
                  displayHorizontally: true,
                  useMousePosition: false,
                  child: IconButton(
                    icon: Icon(
                        index == 1
                            ? _getIcon(
                                editModel.isEditing, editModel.isReadOnly)
                            : iconDataList[index ~/ 2],
                        size: ScreenConfig.normalIconSize),
                    onPressed: () async {
                      if (index == 0) {
                        if (await showConfirmDialog(context, [
                          'Exit edit mode ?',
                          'The content you write will not be saved'
                        ])) {
                          if (context.mounted) {
                            context.goNamed('home');
                          }
                        }
                      } else if (index == 1) {
                        if (editModel.isEditing) {
                          editModel.isReadOnly = !editModel.isReadOnly;
                        } else {
                          editModel.isEditing = true;
                        }
                      } else {
                        editModel.isEditing = false;
                        editModel.isReadOnly = true;
                      }
                    }.throttle(),
                  ),
                ),
              ),
            );
          })),
        ));
  }
}
