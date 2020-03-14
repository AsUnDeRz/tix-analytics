import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:tix_analytics/src/device_info.dart';
import 'package:tix_analytics/src/event.dart';

abstract class CoreAnalyticsProvider {
  void tix(dynamic);
}

mixin Tix<T extends StatefulWidget> on State<T> implements CoreAnalyticsProvider {
  @override
  void tix(dynamic) {
    CoreAnalytics.instance.tix(dynamic);
  }

  @override
  void initState() {
    CoreAnalytics.instance.tix(TixEvent()..name = 'initState');
    super.initState();
  }

  @override
  void dispose() {
    CoreAnalytics.instance.tix(TixEvent()..name = 'dispose');
    super.dispose();
  }
}

class CoreAnalytics {
  static CoreAnalytics get instance => CoreAnalytics();
  factory CoreAnalytics() => _singleton;
  static final CoreAnalytics _singleton = CoreAnalytics._init();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  SentryClient sentry;
  Map<String, String> tagsDeviceInfo = {};

  CoreAnalytics._init();

  void initDeviceInfo() async {
    tagsDeviceInfo = await mapperDeviceInfo(deviceInfoPlugin);
  }

  void initPartner({String dsn = ''}) {
    if (dsn.isNotEmpty) {
      sentry = new SentryClient(dsn: dsn);
    }
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
