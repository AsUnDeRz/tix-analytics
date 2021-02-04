/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:tix_analytics/src/core.dart';

class TixEvent extends TixBase {
  dynamic values;

  @override
  String get name => super.name == null ? runtimeType.toString() : super.name;

  TixEvent();

  TixEvent.click(this.values);

  TixEvent.completeRegistration({String eventName = "complete_registration"}) {
    name = eventName;
  }

  TixEvent.viewPage(String namePage, {String eventName = "view_page"}) {
    name = eventName;
    values = {"name": namePage};
  }

  TixEvent.viewContentDetail(String contentName, {String eventName = "view_content"}) {
    values = {"name": contentName};
    name = eventName;
  }

  TixEvent.addToCart(String product, int count, double value,
      {String eventName = "add_to_cart", String currency = "THB"}) {
    values = {"product": product, "items": count, "value": value, "currency": currency};
    name = eventName;
  }

  TixEvent.viewCart(double total, int count,
      {String eventName = "view_cart", String currency = "THB"}) {
    values = {"value": total, "items": count, "currency": currency};
    name = eventName;
  }

  TixEvent.initiateCheckout(
      {double total, int count, String eventName = "initiate_checkout", String currency = "THB"}) {
    name = eventName;
    values = {"value": total, "items": count, "currency": currency};
  }

  TixEvent.checkout(
      {double total, int count, String eventName = "checkout", String currency = "THB"}) {
    name = eventName;
    values = {"value": total, "items": count, "currency": currency};
  }

  void addCustomValue(Map<String, dynamic> moreValue) {
    if (values is Map && moreValue != null) {
      if (values == null) {
        values = {};
      }
      values.addAll(moreValue);
    }
  }
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
