/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

class TixEvent extends TixBase {
  dynamic values;

  @override
  String get name => super.name == null ? runtimeType.toString() : super.name;

  TixEvent();

  TixEvent.click(this.values);
}

class TixError extends TixBase {
  dynamic error;
  dynamic stackTrace;

  TixError();

  @override
  String get name => super.name == null ? runtimeType.toString() : super.name;
}

abstract class TixBase {
  String name;
}
