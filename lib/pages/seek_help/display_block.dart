import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/seek_help/common_display_info.dart';

//列表展示块
class ListDisplayBlock extends StatelessWidget {
  const ListDisplayBlock({Key? key, required this.commonDisplayInfo})
      : super(key: key);
  final CommonDisplayInfo commonDisplayInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey[20]))),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: HyperlinkButton(
          style: ButtonStyle(
              padding:
                  ButtonState.resolveWith((states) => const EdgeInsets.all(2))),
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                  width: 50,
                  height: 50,
                  child: commonDisplayInfo.imgOption != 0
                      ? const Icon(
                          FluentIcons.photo_error,
                          size: 25,
                        )
                      : Image(
                          fit: BoxFit.fill,
                          image: commonDisplayInfo.avatarProvider)),
              const SizedBox(width: 10),
              Icon(!commonDisplayInfo.status
                  ? FluentIcons.accept_medium
                  : FluentIcons.calculator_subtract,size: 16,color: Colors.green,),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                height: 59,
                width: double.infinity,
                // color: Colors.purple,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        'title',
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Row(
                        children: [
//  标签，创建时间，
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
              const SizedBox(width: 20),
              SizedBox(
                  width: 300,
                  child: Row(children: [
                    Icon(FluentIcons.comment_add),
                    Text('comment sum'),
                    const SizedBox(width: 10),
                    Icon(FluentIcons.like),
                    Text('like sum')
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

// Row(
// children: [
// SizedBox(
// width: 70,
// child: commonDisplayInfo.imgOption == 0
// ? const Icon(FluentIcons.photo_error)
// : Icon(FluentIcons.photo_error)),
// const SizedBox(width: 10),
// Icon(commonDisplayInfo.status
// ? FluentIcons.accept_medium
//     : FluentIcons.calculator_subtract),
// const SizedBox(width: 10),
// Expanded(
// child: Column(
// children: [
// SizedBox(
// height: 30,
// child: Text(
// 'title',
// style: TextStyle(overflow: TextOverflow.ellipsis),
// ),
// ),
// const SizedBox(height: 5),
// Expanded(
// child: Row(
// children: [
// //  标签，创建时间，
// SizedBox(height: 30,)
// ],
// ),
// )
// ],
// )),
// const SizedBox(width: 20),
// SizedBox(
// width: 300,
// child: Row(children: [
// Icon(FluentIcons.comment_add),
// Text('comment sum'),
// const SizedBox(width: 10),
// Icon(FluentIcons.like),
// Text('like sum')
// ]))
// ],
// ),
