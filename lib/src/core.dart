/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  FirebaseAnalytics firebaseAnalytics;
  Map<String, dynamic> tagsDeviceInfo = {};

  TixAnalytics._init();

  Future init({String dsn = '', FirebaseAnalytics analytics}) async {
    if (dsn.isNotEmpty) {
      sentry = new SentryClient(dsn: dsn);
    }
    if (analytics != null) {
      firebaseAnalytics = analytics;
    }
    tagsDeviceInfo = await mapperDeviceInfo(deviceInfoPlugin);
    return Future.value({debugPrint(tagsDeviceInfo.toString())});
  }

  void tix(dynamic) async {
    assert(dynamic != null);
    switch (dynamic.runtimeType) {
      case TixEvent:
        log(dynamic.name, dynamic.values);
        await logFireBaseAnalytics(dynamic);
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
    assert(() {
      if (sentry != null) {
        sentry.capture(
            event: Event(
                loggerName: name, exception: error, stackTrace: stackTrace, tags: tagsDeviceInfo));
      }
      return true;
    }());
  }

  Future<void> logFireBaseAnalytics(TixEvent event) async {
    if (firebaseAnalytics != null) {
      return await firebaseAnalytics.logEvent(
        name: event.name,
        parameters: event.values,
      );
    } else {
      return Future.value();
    }
  }
}
