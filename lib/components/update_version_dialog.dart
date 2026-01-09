import 'package:flutter/material.dart';
import 'package:timegrid/utils/basic_dialog_util.dart';
import 'package:timegrid/utils/result_dart.dart';
import 'package:timegrid/utils/utils-function.dart';

Future<void> showUpdateVersionDialog(BuildContext context) async {
  final String? latestVersion;
  final String? latestBody;
  final result = await _fetchLatestReleaseTag();
  switch (result) {
    case Ok<(String, String)>():
      latestVersion = result.value.$1;
      latestBody = result.value.$2;
      break;
    case Error():
      return;
  }
  if (!(_isUpdateAvailable(latestVersion, latestBody))) return;
  if (!context.mounted) return;
  await showConfirmLeaveDialog(
    context,
    title: "Update available: $latestVersion",
    text: latestBody,
    confirmText: "Update now",
    dismissText: "Maybe Later",
    onDismiss: () => {},
    onClick: () => {
      //TODO: jump to github releases latest
    },
  );
}

bool _isUpdateAvailable(String currentVersion, String latestVersion) {
  // final String currentVersion = await getAppVersion();
  // var (latestVersion, body) = await _fetchLatestReleaseTag();
  var current = currentVersion.trim().removePrefix("v");
  var latest = latestVersion.trim().removePrefix("v");
  return compareVersion(currentVersion, latestVersion) > 0;
}

/// Fetch github.com to get latest release tag.
///
/// Return a version name and a change log.
Future<Result<(String, String)>> _fetchLatestReleaseTag() async {
  var url = "https://api.github.com/repos/andongni0723/timegrid/releases/latest";
  return const Result.ok(('v1.0.0', '- add Update Panel'));
}
