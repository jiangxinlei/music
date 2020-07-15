import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:music/application.dart';
import 'package:music/routes/navigator_route.dart';
import 'package:music/routes/routes.dart';
import 'package:music/utils/utils.dart';
import 'package:music/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';

import 'log_util.dart';

class RequestLogInterceptor extends LogInterceptor {
  RequestLogInterceptor({
    request = true,
    requestHeader = true,
    requestBody = false,
    responseHeader = true,
    responseBody = false,
    error = true, 
    logSize = 9999999,
  }) : super(
            request: request,
            requestHeader: requestHeader,
            requestBody: requestBody,
            responseHeader: responseHeader,
            responseBody: responseBody,
            error: error,
            logPrint: logSize);
  
  @override
  printKV(String key, Object v) {
    LogUtil.e('$key: $v');
  }
  @override
  printAll(msg) {
    LogUtil.e('$msg');
  }
}

class RequestUtil {
  static final String BASE_URL = 'http://121.40.207.170:3000/';

  static Dio _dio;

  static void init() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cj = PersistCookieJar(dir: tempPath);

    // 创建 DIO 实例
    BaseOptions baseOptions = BaseOptions(
      baseUrl: BASE_URL,
      followRedirects: false
    );

    _dio = Dio(baseOptions)
      ..interceptors.add(CookieManager(cj))
      ..interceptors.add(RequestLogInterceptor(responseBody: true, requestBody: true));
  }

  // 请求接口的方法
  static Future<Response> request(
    BuildContext context,
    String url, 
    {
      Map<String, dynamic> params,
      bool isShowLoading = true,
    }
  ) async {
    if (isShowLoading) Loading.showLoading(context);
    try {
      return await _dio.get(url, queryParameters: params);
    } on DioError catch (e) {
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response != null) {
        if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
          _reLogin();
          return Future.error(Response(data: -1));
        } else {
          return Future.value(e.response);
        }
      } else {
        return Future.error(Response(data: -1));
      }
    } finally {
      Loading.hideLoading(context);
    }
  }

  static void _reLogin() {
    Future.delayed(Duration(milliseconds: 200), () {
      Application.getIt<NavigatorRoute>().popAndPushNamed(Routes.login);
      Utils.showToast('登录失效，请重新登录');
    });
  }

}