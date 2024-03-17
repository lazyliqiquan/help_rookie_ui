import 'package:fluent_ui/fluent_ui.dart';

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
