import 'dart:math';

import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async {
  var info = await PackageInfo.fromPlatform();
  return info.version;
}

Future<String> getAppName() async {
  var info = await PackageInfo.fromPlatform();
  return info.appName;
}

int compareVersion(String a, String b) {
  var pa = a.split(".");
  var pb = b.split(".");
  var maxLen = max(pa.length, pb.length);
  for (var i = 0; i < maxLen; i++) {
    var ai = pa.length > i ? int.parse(pa[i]) : 0;
    var bi = pb.length > i ? int.parse(pa[i]) : 0;
    if (ai != bi) return ai.compareTo(bi);
  }
  return 0;
}

extension StringPrefix on String {
  String removePrefix(String prefix) {
    return startsWith(prefix) ? substring(prefix.length) : this;
  }
}
