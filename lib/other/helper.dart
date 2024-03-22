import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as ui;

class WebHelper {
  //加解密
  static String secretKey = 'help' * 4;
  static final securityKey = encrypt.Key.fromUtf8(secretKey);
  static final securityIV = encrypt.IV.fromUtf8(secretKey);
  static final encrypter = encrypt.Encrypter(encrypt.AES(securityKey));

  //加解密的字符串不能为空
  static String encryptFunc(String plainText) {
    return encrypter.encrypt(plainText, iv: securityIV).base64;
  }

  static String decryptFunc(String secretText) {
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(secretText),
        iv: securityIV);
  }

  //跳转到某个链接
  static void openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url);
    } else {
      debugPrint('无法打开链接: $url');
    }
  }

//根据给定的后缀列表，选择一个文件
  static Future<FilePickerResult?> selectAFile(List<String> fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: fileType,
      allowMultiple: false,
      withData: true,
    );
    return result;
  }

  static const List<String> units = ['Bytes', 'KB', 'MB'];

  //单位转换，将比特转换为其他单位，方便查看
  static String unitConversion(int bytes) {
    int i = 0;
    for (; i < units.length; i++) {
      if (bytes >= 1024) {
        bytes >>= 10;
      } else {
        break;
      }
    }
    return '$bytes ${units[i]}';
  }

  static bool isEmailValid(String email) {
    // 正则表达式模式用于匹配合法的邮箱地址格式
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static ui.InfoBarSeverity parseStatus(ReturnState returnState) {
    switch (returnState.code) {
      case 0:
        return ui.InfoBarSeverity.success;
      case 1:
        return ui.InfoBarSeverity.warning;
      case 2:
        return ui.InfoBarSeverity.error;
      default:
        return ui.InfoBarSeverity.info;
    }
  }
}
