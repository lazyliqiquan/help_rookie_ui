import 'package:fluent_ui/fluent_ui.dart';
import 'package:help_rookie_ui/data/config/network.dart';

//一些配置信息，如用户名，上传文件大小限制等
class WebConfigModel extends ChangeNotifier {
//  网站的配置
//默认为零，这样连接失败也无法选中文件
  int maxHelpFileSize = 0; //求助或帮助上传的文件的最大值，单位字节
  int maxShareFileSize = 0; //共享代码上传文件的最大值，单位字节
  int maxDocumentLength = 0; //帖子描述文档的最大值

  //获取网站配置信息
  static Future<WebConfigModel> getWebConfig() async {
    WebConfigModel webConfigModel = WebConfigModel();
    return await WebNetwork.dio.post('/web-config').then((value) {
      if (value.data['code'] == 0) {
        dynamic data = value.data['data'];
        webConfigModel.maxHelpFileSize = data['maxHelpFileSize'];
        webConfigModel.maxShareFileSize = data['maxShareFileSize'];
        webConfigModel.maxDocumentLength = data['maxDocumentLength'];
      }
      return webConfigModel;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return WebConfigModel();
    });
  }
}
