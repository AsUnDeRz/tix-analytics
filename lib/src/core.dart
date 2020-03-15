/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:tix_analytics/src/device_info.dart';
import 'package:tix_analytics/src/event.dart';

class TixAnalytics {
  static TixAnalytics get instance => TixAnalytics();
  factory TixAnalytics() => _singleton;
  static final TixAnalytics _singleton = TixAnalytics._init();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  SentryClient sentry;
  Map<String, dynamic> tagsDeviceInfo = {};

  TixAnalytics._init();

  Future init({String dsn = ''}) async {
    if (dsn.isNotEmpty) {
      sentry = new SentryClient(dsn: dsn);
    }
    tagsDeviceInfo = await mapperDeviceInfo(deviceInfoPlugin);
    return Future.value({debugPrint(tagsDeviceInfo.toString())});
  }

  void tix(dynamic) {
    switch (dynamic.runtimeType) {
      case TixEvent:
        log(dynamic.name, dynamic.values);
        break;
      case TixError:
        logError(dynamic.name, dynamic.error, dynamic.stackTrace);
        break;
      default:
        log('unhandle', dynamic);
        break;
    }
  }

  void log(String name, dynamic value) {
    debugPrint(DateTime.now().toString() + '  ' + name + '  ' + '$value');
  }

  void logError(String name, dynamic error, dynamic stackTrace) {
    if (sentry != null) {
      sentry.capture(
          event: Event(
              loggerName: name, exception: error, stackTrace: stackTrace, tags: tagsDeviceInfo));
    }
  }
}
