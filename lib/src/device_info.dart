import 'dart:io';

import 'package:device_info/device_info.dart';

Future<Map<String, dynamic>> mapperDeviceInfo(DeviceInfoPlugin deviceInfoPlugin) async {
  final deviceInfo = Platform.isAndroid
      ? _readAndroidBuildData(await deviceInfoPlugin.androidInfo)
      : _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  return deviceInfo;
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
  };
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'hardware': build.hardware,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
  };
}
