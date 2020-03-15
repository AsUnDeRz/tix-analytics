/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tix_analytics/src/core.dart';
import 'package:tix_analytics/src/event.dart';

abstract class TixAnalyticsProvider {
  void tix(dynamic);
  void startTix();
  void endTix();
}

mixin Tix<T extends StatefulWidget> on State<T> implements TixAnalyticsProvider {
  Timer timer;

  @override
  void tix(dynamic) {
    TixAnalytics.instance.tix(dynamic);
  }

  @override
  void startTix() {
    assert(() {
      if (timer == null) {
        timer = Timer.periodic(Duration(seconds: 1), (_) {});
        TixAnalytics.instance.tix(TixEvent()
          ..name = 'startTix$runtimeType'
          ..values = timer.tick);
      }
      return true;
    }());
  }

  @override
  void endTix() {
    assert(() {
      if (timer != null) {
        timer.cancel();
        TixAnalytics.instance.tix(TixEvent()
          ..name = 'endTix$runtimeType'
          ..values = timer.tick);
      }
      return true;
    }());
  }

  @override
  void initState() {
    startTix();
    super.initState();
  }

  @override
  void dispose() {
    endTix();
    super.dispose();
  }
}
