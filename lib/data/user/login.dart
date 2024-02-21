import 'dart:async';

import 'package:flutter/material.dart';
import 'package:help_rookie_ui/data/config/local_store.dart';
import 'package:help_rookie_ui/data/config/network.dart';
import 'package:help_rookie_ui/other/helper.dart';
import 'package:help_rookie_ui/other/return_state.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' as intl;

//登录相关的
class LoginModel extends ChangeNotifier {
  int countDown = 0;
  Timer? _timer;
  bool _isRemember = false;
  bool isLoginSuccess = false;

  set isRemember(bool value) {
    _isRemember = value;
    notifyListeners();
  }

  bool get isRemember => _isRemember;

  void _setUserLocalInfo(String name, String password) {
    WebLocalStore.setHash('remember', isRemember.toString());
    if (_isRemember) {
      WebLocalStore.setHash('name', name);
      WebLocalStore.setHash('password',
          password.isNotEmpty ? WebHelper.encryptFunc(password) : password);
    }
  }

  List<String> getUserLocalInfo() {
    _isRemember = bool.tryParse(WebLocalStore.getHash('isRemember')) ?? false;
    if (_isRemember) {
      String password = WebLocalStore.getHash('password');
      return [
        WebLocalStore.getHash('name'),
        password.isNotEmpty ? WebHelper.decryptFunc(password) : password
      ];
    }
    return ['', ''];
  }

  void _setTimer() {
    //取消之前的倒计时，保证同一时间只有一个倒计时在执行
    _timer?.cancel();
    //取消了，_timer也不会变为null
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown <= 0) {
        timer.cancel();
      } else {
        countDown--;
        notifyListeners();
      }
    });
  }

  Future<ReturnState> findPassword(String email, String code, String password,
      String confirmPassword) async {
    if (email.isEmpty ||
        code.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return ReturnState.warning('The input cannot be empty');
    }
    if (!WebHelper.isEmailValid(email)) {
      return ReturnState.warning('The entered email address format is invalid');
    }
    if (password != confirmPassword) {
      return ReturnState.warning(
          'The password before and after is inconsistent');
    }
    FormData formData =
        FormData.fromMap({'email': email, 'code': code, 'password': password});

    ReturnState returnState = await WebNetwork.dio
        .post('/find-password', data: formData)
        .then((value) {
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    if (returnState.code == 0) {
      countDown = 0;
      notifyListeners();
    }
    return returnState;
  }

  Future<ReturnState> register(String email, String code, String name,
      String password, String confirmPassword) async {
    if (email.isEmpty ||
        code.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return ReturnState.warning('The input cannot be empty');
    }
    if (!WebHelper.isEmailValid(email)) {
      return ReturnState.warning('The entered email address format is invalid');
    }
    if (password != confirmPassword) {
      return ReturnState.warning(
          'The password before and after is inconsistent');
    }
    FormData formData = FormData.fromMap({
      'email': email,
      'code': code,
      'name': name,
      'password': password,
      'registerTime': intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
    });

    ReturnState returnState =
        await WebNetwork.dio.post('/register', data: formData).then((value) {
      debugPrint(value.data.toString());
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    if (returnState.code == 0) {
      countDown = 0;
      notifyListeners();
    }
    return returnState;
  }

  Future<ReturnState> login(
      int loginType, String nameOrMail, String authCode) async {
    if (nameOrMail.isEmpty || authCode.isEmpty) {
      return ReturnState.warning('The input cannot be empty');
    }
    FormData formData = FormData.fromMap({
      'loginType': loginType.toString(),
      'nameOrMail': nameOrMail,
      'authCode': authCode
    });
    ReturnState returnState =
        await WebNetwork.dio.post('/login', data: formData).then((value) {
      debugPrint(value.data.toString());
      if (value.data['data'] != null) {
        dynamic data = value.data['data'];
        WebLocalStore.setHash('token', data['token']);
        _setUserLocalInfo(data['name'], data['password']);
        isLoginSuccess = true;
      }
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
    if (returnState.code == 0 && loginType == 2) {
      countDown = 0;
      notifyListeners();
    }
    return returnState;
  }

  Future<ReturnState> sendCode(String email) async {
    if (email.isEmpty) {
      return ReturnState.warning('The mailbox cannot be empty');
    }
    if (!WebHelper.isEmailValid(email)) {
      return ReturnState.warning('The entered email address format is invalid');
    }
    if (countDown > 0) {
      return ReturnState.warning(
          'The verification code has not expired, please use the previous one');
    }
    FormData formData = FormData.fromMap({'email': email});
    return await WebNetwork.dio
        .post('/send-code', data: formData)
        .then((value) {
      if (value.data['data'] != null) {
        dynamic data = value.data['data'];
        countDown = data['ttl'];
        _setTimer();
      }
      return ReturnState.fromJson(value.data);
    }).onError((error, stackTrace) {
      return ReturnState.error(error.toString());
    });
  }
}
