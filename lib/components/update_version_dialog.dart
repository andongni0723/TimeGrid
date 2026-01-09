import 'package:flutter/material.dart';
import 'package:timegrid/utils/basic_dialog_util.dart';

Future<void> showUpdateVersionDialog(BuildContext context) async {
  if (!_isUpdateAvailable()) return;
  final (version, changelog) = await _fetchLatestReleaseTag();
  await showConfirmLeaveDialog(
    context,
    title: "Update available: $version",
    text: changelog,
    confirmText: "Update now",
    dismissText: "Maybe Later",
    onDismiss: () => {},
    onClick: () => {
      //TODO: jump to github releases latest
    },
  );
}

bool _isUpdateAvailable() {
  return true;
}

/// Fetch github.com to get latest release tag.
///
/// Return a version name and a change log.
Future<(String, String)> _fetchLatestReleaseTag() async {
  return ('v1.0.0', '- add Update Panel');
}
