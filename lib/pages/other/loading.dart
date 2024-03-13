import 'package:fluent_ui/fluent_ui.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProgressBar(),
    );
  }
}
