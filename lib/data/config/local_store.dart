import 'dart:html' as html;

//本地数据存储，如token，用户名，密码等
class WebLocalStore {
  static void setHash(String key, String value) {
    html.window.localStorage[key] = value;
  }

  static String getHash(String key) {
    return html.window.localStorage[key] ?? '';
  }
}
