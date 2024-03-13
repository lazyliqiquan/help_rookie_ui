import 'package:fluent_ui/fluent_ui.dart';

// 创建一个备案模块，每个界面底部都需要显示，但是我们不需要用户一打开界面就能看到，
// 只有刻意的寻找的时候才有必要给用户看到，这样可以改善用户的体验
class ICPRecord extends StatelessWidget {
  const ICPRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 500,
      child: const Center(
        child: Text('备案号',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
