import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/data/post_data/common_display_info.dart';

//列表展示块
class ListDisplayBlock extends StatelessWidget {
  const ListDisplayBlock({Key? key, required this.commonDisplayInfo})
      : super(key: key);
  final CommonDisplayInfo commonDisplayInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenConfig.listDisplayBlockHeight,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
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
              Icon(
                commonDisplayInfo.status
                    ? FluentIcons.accept_medium
                    : FluentIcons.calculator_subtract,
                size: 16,
                color: commonDisplayInfo.status ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          commonDisplayInfo.title,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey[130],
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(commonDisplayInfo.tags.length,
                            (index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.purple.lightest,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 2),
                            child: Text(commonDisplayInfo.tags[index],
                                style: TextStyle(
                                    color: Colors.purple.darkest,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          );
                        }),
                        const SizedBox(width: 30),
                        Text(
                          commonDisplayInfo.createTime,
                          style: TextStyle(
                              color: Colors.grey[60],
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              )),
              const SizedBox(width: 20),
              DefaultTextStyle(
                style: TextStyle(
                    color: Colors.grey[60],
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
                child: SizedBox(
                    width: 150,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            FluentIcons.comment_add,
                            color: Colors.grey[60],
                          ),
                          const SizedBox(width: 10),
                          Text(commonDisplayInfo.likeSum.toString()),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            height: 20,
                            width: 1,
                            color: Colors.grey[50],
                          ),
                          Icon(FluentIcons.like, color: Colors.grey[60]),
                          const SizedBox(width: 10),
                          Text('${commonDisplayInfo.commentSum}'),
                          const SizedBox(width: 10)
                        ])),
              )
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
