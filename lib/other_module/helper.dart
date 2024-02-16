import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class WebHelper {
  //加解密
  static String secretKey = 'help' * 4;
  static final securityKey = encrypt.Key.fromUtf8(secretKey);
  static final securityIV = encrypt.IV.fromUtf8(secretKey);
  static final encrypter = encrypt.Encrypter(encrypt.AES(securityKey));

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
}
