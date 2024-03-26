import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/widgets/flyout_option.dart';

class ListTitle extends StatefulWidget {
  const ListTitle({Key? key, this.isSeekHelp = true}) : super(key: key);
  final bool isSeekHelp;

  @override
  State<ListTitle> createState() => _ListTitleState();
}

class _ListTitleState extends State<ListTitle> {
  static const _lendHandTitle = 'Thank the following users for their help';
  static const _seekHelpTitle = 'Give someone a rose to keep the fragrance';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.isSeekHelp ? _seekHelpTitle : _lendHandTitle,
            style: TextStyle(
                color: Colors.grey[100],
                fontWeight: FontWeight.w500,
                fontSize: 15),
          ),
          Row(
            children: [
              Tooltip(
                  message: widget.isSeekHelp ? 'Seek Help' : 'Lend Hand',
                  child: IconButton(
                      icon: const Icon(FluentIcons.add), onPressed: () {})),
              const SizedBox(width: 20),
              FlyoutOptions(popupType: 0, isSeekHelp: widget.isSeekHelp),
              const SizedBox(width: 20),
              if (widget.isSeekHelp)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlyoutOptions(popupType: 1),
                    SizedBox(width: 20),
                  ],
                ),
              FlyoutOptions(popupType: 2, isSeekHelp: widget.isSeekHelp),
            ],
          )
        ],
      ),
    );
  }
}
