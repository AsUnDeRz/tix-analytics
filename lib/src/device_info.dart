/*
 * Copyright (c) 2020. Tix analytics Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:io';

import 'package:device_info/device_info.dart';

Future<Map<String, String>> mapperDeviceInfo(DeviceInfoPlugin deviceInfoPlugin) async {
  final deviceInfo = Platform.isAndroid
      ? _readAndroidBuildData(await deviceInfoPlugin.androidInfo)
      : _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  return deviceInfo;
}

Map<String, String> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, String>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice.toString(),
    'platform': 'ios'
  };
}

Map<String, String> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, String>{
    'version.sdkInt': build.version.sdkInt.toString(),
    'version.release': build.version.release,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'hardware': build.hardware,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'isPhysicalDevice': build.isPhysicalDevice.toString(),
    'androidId': build.androidId,
    'platform': 'android'
  };
}
