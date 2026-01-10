import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:timegrid/utils/result_dart.dart';
import 'package:timegrid/utils/utils-function.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showUpdateVersionDialog(BuildContext context) async {
  debugPrint('[UpdateCheck] show dialog');

  final String currentVersion = await getAppVersion();
  final String? latestVersion;
  final String? latestBody;
  final int? size;
  final String? filename;
  final result = await fetchLatestReleaseTag();
  switch (result) {
    case Ok<(String, String, String, int)>():
      latestVersion = result.value.$1;
      latestBody = result.value.$2;
      filename = result.value.$3;
      size = result.value.$4;
      break;
    case Error():
      debugPrint('[UpdateCheck] fetch failed: ${result.error}');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error.toString())),
      );
      return;
  }
  if (!isUpdateAvailable(currentVersion, latestVersion)) return;
  if (!context.mounted) return;

  final ts = Theme.of(context).textTheme;
  final cs = Theme.of(context).colorScheme;
  const releasePath = 'https://github.com/andongni0723/timegrid/releases/latest/';
  final downloadPath =
      'https://github.com/andongni0723/timegrid/releases/download/$latestVersion/$filename';

  void clickToJump(String uri_str) {
    final uri = Uri.parse(uri_str);
    launchUrl(uri, mode: LaunchMode.externalApplication).then((ok) {
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open release page')),
        );
      }
    });
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 50,
            children: [
              // New Version Title
              Container(
                // margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'New Version $latestVersion',
                  style: ts.headlineMedium?.copyWith(color: cs.primaryFixed),
                ),
              ),

              // Update Content
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(latestBody ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),

              // Download Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  spacing: 8,
                  children: [
                    OutlineButtonWithTheme(
                        title: filename ?? 'app-release.apk',
                        subtitle: '${bytesToMiB(size ?? 0).toStringAsFixed(2)} MB',
                        icon: FontAwesomeIcons.download,
                        onPressed: () => clickToJump(downloadPath)),
                    OutlineButtonWithTheme(
                        title: 'Github Release ',
                        subtitle: latestVersion.toString(),
                        icon: FontAwesomeIcons.github,
                        onPressed: () => clickToJump(releasePath))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget OutlineButtonWithTheme({
  required String title,
  String subtitle = '',
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      alignment: Alignment.centerLeft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    onPressed: onPressed,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w400)),
    ),
  );
}

bool isUpdateAvailable(String currentVersion, String latestVersion) {
  var current = currentVersion.trim().removePrefix("v");
  var latest = latestVersion.trim().removePrefix("v");
  debugPrint('[UpdateCheck] current=$current latest=$latest');
  debugPrint('[UpdateCheck] result: ${compareVersion(current, latest) < 0}');
  return compareVersion(current, latest) < 0;
}


/// Fetch github.com to get latest release tag.
///
/// Return a version name and a change log.
Future<Result<(String, String, String, int)>> fetchLatestReleaseTag() async {
  final url = Uri.parse("https://api.github.com/repos/andongni0723/timegrid/releases/latest");
  try {
    // Fetch latest release
    var res = await http.get(url).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      return Result.error(HttpException('Error ${res.statusCode}: Get latest release failed. Try again later.'));
    }
    // Decode detail
    var body = json.decode(res.body) as Map<String, dynamic>;
    final tag = body['tag_name'] as String?;
    final notes = (body['body'] as String?) ?? '';
    final assets = (body['assets'] as List).cast<Map<String, dynamic>>();
    final name = assets.isNotEmpty ? (assets[0]['name'] as String?) : null;
    final size = assets.isNotEmpty ? (assets[0]['size'] as num?)?.toInt() : null;

    if (tag == null || name == null || size == null) {
      return const Result.error(HttpException('Missing tag_name/body in response'));
    }
    debugPrint('[UpdateCheck] tag=$tag notes=$notes');
    return Result.ok((tag, notes, name, size));
  } on SocketException catch (_) {
    return Result.error(Exception('Get latest release failed. No internet connection.'));
  } on TimeoutException catch (_) {
    return Result.error(Exception('Get latest release failed. Request timeout.'));
  } on Exception catch (e) {
    return Result.error(e);
  }
}