import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timegrid/utils/basic_dialog_util.dart';
import 'package:timegrid/utils/result_dart.dart';
import 'package:timegrid/utils/utils-function.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> showUpdateVersionDialog(BuildContext context) async {
  debugPrint('[UpdateCheck] show dialog');
  final String currentVersion = await getAppVersion();
  final String? latestVersion;
  final String? latestBody;
  final result = await _fetchLatestReleaseTag();
  switch (result) {
    case Ok<(String, String)>():
      latestVersion = result.value.$1;
      latestBody = result.value.$2;
      break;
    case Error():
      debugPrint('[UpdateCheck] fetch failed: ${result.error}');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error.toString())),
      );
      return;
  }
  if (!_isUpdateAvailable(currentVersion, latestVersion)) return;
  if (!context.mounted) return;
  await showConfirmLeaveDialog(
    context,
    title: "Update available: $latestVersion",
    text: latestBody,
    confirmText: "Update now",
    dismissText: "Maybe Later",
    onDismiss: () => {},
    onClick: () {
      final uri = Uri.parse('https://github.com/andongni0723/timegrid/releases/latest');
      launchUrl(uri, mode: LaunchMode.externalApplication).then((ok) {
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open release page')),
          );
        }
      });
    },
  );
}

bool _isUpdateAvailable(String currentVersion, String latestVersion) {
  var current = currentVersion.trim().removePrefix("v");
  var latest = latestVersion.trim().removePrefix("v");
  debugPrint('[UpdateCheck] current=$current latest=$latest');
  debugPrint('[UpdateCheck] result: ${compareVersion(current, latest) < 0}');
  return compareVersion(current, latest) < 0;
}

/// Fetch github.com to get latest release tag.
///
/// Return a version name and a change log.
Future<Result<(String, String)>> _fetchLatestReleaseTag() async {
  try {
    var url = Uri.parse("https://api.github.com/repos/andongni0723/timegrid/releases/latest");
    var res = await http.get(url).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      var body = json.decode(res.body) as Map<String, dynamic>;
      final tag = body['tag_name'] as String?;
      final notes = (body['body'] as String?) ?? '';
      if (tag == null) {
        return const Result.error(HttpException('Missing tag_name/body in response'));
      }
      debugPrint('[UpdateCheck] tag=$tag notes=$notes');
      return Result.ok((tag, notes));
    } else {
      return Result.error(HttpException('Error ${res.statusCode}: Get latest release failed. Try again later.'));
    }
  } on SocketException catch (_) {
    return Result.error(Exception('Get latest release failed. No internet connection.'));
  } on TimeoutException catch (_) {
    return Result.error(Exception('Get latest release failed. Request timeout.'));
  } on Exception catch (e) {
    return Result.error(e);
  }
}
