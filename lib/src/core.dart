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
  FirebaseAnalytics firebaseAnalytics;
  Map<String, String> tagsDeviceInfo = {};
  String env;

  TixAnalytics._init();

  Future init({String dsn = '', FirebaseAnalytics analytics, String envConfig = 'alpha'}) async {
    if (dsn.isNotEmpty) {
      await Sentry.init(
        (options) {
          options.dsn = dsn;
        },
      );
    }
    if (analytics != null) {
      firebaseAnalytics = analytics;
    }
    tagsDeviceInfo = await mapperDeviceInfo(deviceInfoPlugin);
    env = envConfig;
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

  void logError(String name, dynamic error, dynamic stackTrace) async {
    // await Sentry.captureException(error, stackTrace: stackTrace);
    await Sentry.captureEvent(
        SentryEvent(
            exception: SentryException(type: "error[${error.toString()}]", value: error.toString()),
            tags: tagsDeviceInfo,
            environment: env),
        stackTrace: stackTrace);
  }

  void observeRouteChange(String path) async {
    await logScreen(path);
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

  Future<void> logScreen(String name) async {
    if (firebaseAnalytics != null) {
      return await firebaseAnalytics.setCurrentScreen(
        screenName: name,
        screenClassOverride: name,
      );
    }
  }
}
