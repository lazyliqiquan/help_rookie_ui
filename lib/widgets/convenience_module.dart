import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/config/theme.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:help_rookie_ui/other/throttle.dart';
import 'package:help_rookie_ui/widgets/macro_mixin.dart';
import 'package:provider/provider.dart';

class DigitalRegulator extends StatefulWidget {
  const DigitalRegulator(
      {Key? key,
      required this.low,
      required this.high,
      required this.initValue,
      required this.callBack})
      : super(key: key);
  final int low;
  final int high;
  final int initValue;
  final void Function(int) callBack;

  @override
  State<DigitalRegulator> createState() => _DigitalRegulatorState();
}

class _DigitalRegulatorState extends State<DigitalRegulator>
    with MacroComponent {
  static const _exceedLow = 'Beyond lower bound';
  static const _exceedHigh = 'Beyond upper bound';

  int _selectNum = 0;

  @override
  void initState() {
    _selectNum = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 100,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[30]),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
                icon: const Icon(FluentIcons.calculator_subtract),
                onPressed: () async {
                  if (_selectNum <= widget.low) {
                    await showInfo(context, ReturnState.info(_exceedLow));
                    return;
                  }
                  setState(() {
                    _selectNum--;
                  });
                  widget.callBack(_selectNum);
                }.throttle()),
          ),
          Expanded(child: Center(child: Text(_selectNum.toString()))),
          Expanded(
              child: IconButton(
                  icon: const Icon(FluentIcons.calculator_addition),
                  onPressed: () async {
                    if (_selectNum >= widget.high) {
                      await showInfo(context, ReturnState.info(_exceedHigh));
                      return;
                    }
                    setState(() {
                      _selectNum++;
                    });
                    widget.callBack(_selectNum);
                  }.throttle()))
        ],
      ),
    );
  }
}

class TagWrap extends StatelessWidget {
  const TagWrap({Key? key, required this.tag}) : super(key: key);
  final String tag;

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.watch<AppTheme>();
    return Container(
      height: 25,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: appTheme.color.light,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Center(
          child: Text(tag,
              style: const TextStyle(color: Colors.white, fontSize: 12))),
    );
  }
}

class SelectOneToNine extends StatefulWidget {
  const SelectOneToNine({Key? key, required this.callBack}) : super(key: key);
  final void Function(int) callBack;

  @override
  State<SelectOneToNine> createState() => _SelectOneToNineState();
}

class _SelectOneToNineState extends State<SelectOneToNine> {
  int selectNum = 1;

  @override
  Widget build(BuildContext context) {
    return SplitButton(
      flyout: FlyoutContent(
        constraints: const BoxConstraints(maxWidth: 150.0),
        child: Wrap(
            runSpacing: 10.0,
            spacing: 8.0,
            children: List.generate(9, (index) {
              return Button(
                autofocus: index + 1 == selectNum,
                style: ButtonStyle(
                  padding: ButtonState.all(
                    const EdgeInsets.all(4.0),
                  ),
                ),
                onPressed: () {
                  setState(() => selectNum = index + 1);
                  widget.callBack(index + 1);
                  Navigator.of(context).pop(index + 1);
                },
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Center(child: Text('${index + 1}')),
                ),
              );
            })),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadiusDirectional.horizontal(
            start: Radius.circular(4.0),
          ),
        ),
        height: 32,
        width: 32,
        child: Center(child: Text('$selectNum')),
      ),
    );
  }
}
