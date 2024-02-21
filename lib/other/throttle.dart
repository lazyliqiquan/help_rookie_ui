import 'package:flutter/material.dart';

class FunctionProxy<T> {
  static final Map<String, bool> _funcThrottle = {};
  final Function? target;

  FunctionProxy(this.target);

  //无参数版本
  void throttle() async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      try {
        await target?.call();
      } catch (e) {
        rethrow;
      } finally {
        _funcThrottle.remove(key);
      }
    }
  }

  //有参数版本
  void throttleArg(T value) async {
    String key = hashCode.toString();
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      try {
        await target?.call(value);
      } catch (e) {
        rethrow;
      } finally {
        _funcThrottle.remove(key);
      }
    }
  }
}

extension FunctionExt<T> on Function {
  VoidCallback throttle() {
    return FunctionProxy(this).throttle;
  }

  void Function(T) throttleArg() {
    return FunctionProxy(this).throttleArg;
  }
}
/*
* 好像调用的时候，下面两者都可以
*
*              onPressed: () {}.throttle()
*              onPressed: () {}.throttle,
* */
