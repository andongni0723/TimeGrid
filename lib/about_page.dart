import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timegrid/utils/utils-function.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String version;
  const AboutPage({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme
        .of(context)
        .colorScheme;
    final textTheme = Theme
        .of(context)
        .textTheme;

    Widget header() {
      return Center(
        child: Column(
          children: [
            Card(
              elevation: 8,
              child: Image.asset(
                'assets/icon/big_icon.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            Text('TimeGrid', style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
            // Text('v$version', style: textTheme.headlineSmall?.copyWith(color: cs.tertiary)),
          ],
        ),
      );
    }

    Widget footer() {
      return Center(
        child: Column(
          children: [
            Text('Made by Andongni0723', style: textTheme.labelLarge?.copyWith(color: cs.outlineVariant)),
            const SizedBox(height: 50,)
          ],
        ),
      );
    }

    Widget aboutListTile({
      required IconData icon,
      required String title,
      required String subtitle,
      Function()? onTap,
    }) {
      final titleStyle = textTheme.titleMedium;
      final subtitleStyle = textTheme.labelLarge?.copyWith(fontWeight: null, color: cs.tertiary);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(icon, size: 24, color: cs.primary),
          title: Text(title, style: titleStyle),
          subtitle: Text(subtitle, style: subtitleStyle),
          onTap: onTap,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: cs.surface,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          spacing: 32,
          children: [
            header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: <Widget>[
                    aboutListTile(
                      icon: FontAwesomeIcons.code,
                      title: 'Version',
                      subtitle: version,
                    ),
                    aboutListTile(
                      icon: FontAwesomeIcons.github,
                      title: 'GitHub',
                      subtitle: 'https://github.com/andongni0723/TimeGrid',
                      onTap: () => openExternalUrl(context, 'https://github.com/andongni0723/TimeGrid'),
                    ),
                    aboutListTile(
                        icon: FontAwesomeIcons.earthAmericas,
                        title: 'Website',
                        subtitle: 'https://timegrid.andongni.com',
                        onTap: () =>
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming Soon')))
                    ),
                    aboutListTile(
                      icon: Icons.info_outline,
                      title: 'Made by Andongni0723',
                      subtitle: 'https://andongni.com',
                      onTap: () => openExternalUrl(context, 'https://andongni.com'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}