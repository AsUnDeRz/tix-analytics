/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:sentry/sentry.dart';
import 'package:tix_analytics/src/device_info.dart';
import 'package:tix_analytics/src/event.dart';

class TixAnalytics {
  static TixAnalytics get instance => TixAnalytics();
  factory TixAnalytics() => _singleton;
  static final TixAnalytics _singleton = TixAnalytics._init();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  FirebaseAnalytics? _firebaseAnalytics;
  MixpanelAPI? _mixpanel;
  Map<String, String> tagsDeviceInfo = {};
  String? env;

  TixAnalytics._init();

  Future init(
      {String dsn = '',
      FirebaseAnalytics? analytics,
      String envConfig = 'alpha',
      MixpanelAPI? mixpanel}) async {
    if (dsn.isNotEmpty) {
      await Sentry.init(
        (options) {
          options.dsn = dsn;
        },
      );
    }
    if (analytics != null) {
      _firebaseAnalytics = analytics;
    }
    if (mixpanel != null) {
      _mixpanel = mixpanel;
      await flushEvent();
    }
    tagsDeviceInfo = await mapperDeviceInfo(deviceInfoPlugin);
    env = envConfig;
    return Future.value({debugPrint(tagsDeviceInfo.toString())});
  }

  void tix(dynamic) async {
    assert(dynamic != null);
    switch (dynamic.runtimeType) {
      case TixEvent:
        logDebug(dynamic.name, dynamic.values);
        await logEvent(dynamic);
        break;
      case TixError:
        logError(dynamic.name, dynamic.error, dynamic.stackTrace);
        break;
      default:
        logDebug('unhandle', dynamic);
        break;
    }
  }

  void logDebug(String name, dynamic value) {
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

  Future<void> logEvent(TixEvent event) async {
    if (_firebaseAnalytics != null) {
      await _firebaseAnalytics?.logEvent(name: event.name ?? '', parameters: event.values);
    }
    if (_mixpanel != null) {
      _mixpanel?.track(event.name, event.values);
      await flushEvent();
    }
    return Future.value();
  }

  Future<void> logScreen(String name) async {
    if (_firebaseAnalytics != null) {
      await _firebaseAnalytics?.setCurrentScreen(
        screenName: name,
        screenClassOverride: name,
      );
    }

    return Future.value();
  }

  Future<void> flushEvent() async {
    if (_mixpanel != null) {
      _mixpanel?.flush();
    }
    return Future.value();
  }

  Future<void> updateUserProp() async {}

  Future<void> logScreenTime(TixEvent event) async {
    logDebug(event.name ?? '', event.values);
    return await logEvent(event);
  }
}
