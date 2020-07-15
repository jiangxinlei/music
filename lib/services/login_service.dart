import 'package:flutter/material.dart';
import 'package:music/models/user_model.dart';
import 'package:music/utils/request_util.dart';

class LoginService {
  /// 手机登录
  /// 必选参数 : phone: 手机号码 password: 密码
  static Future<User> login(
      BuildContext context, String phone, String password) async {
    var response = await RequestUtil.request(context, '/login/cellphone', params: {
      'phone': phone,
      'password': password,
    });

    return User.fromJson(response.data);
  }
}