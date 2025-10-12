import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timegrid/models/course_chips_model.dart';
import 'package:timegrid/models/course_model.dart';
import 'package:timegrid/models/storage_service.dart';
import 'package:timegrid/models/time_cell_model.dart';
import 'package:timegrid/provider.dart';
import 'package:timegrid/schedule.dart';
import 'package:timegrid/setting_page.dart';
import 'package:timegrid/theme/Theme.dart';
import 'package:timegrid/widget_bridge.dart';

import 'about_page.dart';
import 'components/file_io_json.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(CourseChipsModelAdapter());
  Hive.registerAdapter(TimeCellModelAdapter());

  final storage = await StorageService.create();
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(ProviderScope(overrides: [
    storageProvider.overrideWithValue(storage),
  ], child: MyApp(version: packageInfo.version)));
}

class MyApp extends StatelessWidget {
  final String version;

  const MyApp({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeGrid',
      theme: ThemeData(
        colorScheme: darkColorScheme,
        fontFamily: 'Poppins',
        useMaterial3: true,
        chipTheme: ChipThemeData(
          backgroundColor: darkColorScheme.secondaryContainer,
          selectedColor: Colors.transparent,
          side: BorderSide.none,
        ),
      ),
      home: MyHomePage(version: version),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  final String version;
  const MyHomePage({super.key, required this.version});

  final String title = 'My Schedule';

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  int selectedIndex = 0;
  bool _editMode = false;

  void _switchEditMode() => setState(() => _editMode = !_editMode);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startWidgetAutoTick();
      pushWidgetCourse(ref);
    });

    final cs = Theme.of(context).colorScheme;
    final scheduleController = ref.watch(scheduleProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int idx) async {
          Navigator.of(context).pop();
          await Future.delayed(const Duration(milliseconds: 250));
          if (!mounted) return;

          // Back to Course Page
          if (idx == 0) {
            setState(() => selectedIndex = 0);
            return;
          }

          Widget pageToPush;
          switch (idx) {
            case 1:
              pageToPush = const SettingPage();
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming Soon')));
              return;
            case 3:
              pageToPush = AboutPage(version: widget.version);
              break;
            default:
              pageToPush = const SizedBox.shrink();
              return;
          }

          Navigator.of(context).push(MaterialPageRoute(builder: (_) => pageToPush));
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Text(
              'TimeGrid',
              style: TextStyle(color: cs.primary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1, color: cs.outline),
          const SizedBox(height: 8),
          const NavigationDrawerDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: Text('Courses'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(CupertinoIcons.heart),
            selectedIcon: Icon(CupertinoIcons.heart_solid),
            label: Text('Sponsor'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: Text('About'),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(widget.title),
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                icon: const Icon(FontAwesomeIcons.ellipsisVertical, size: 20.0),
                onPressed: () {
                  controller.open();
                },
              );
            },
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(FontAwesomeIcons.download, size: 18.0),
                style: MenuItemButton.styleFrom(backgroundColor: cs.surfaceContainerHighest),
                child: const Text('Export to file (.json)'),
                onPressed: () {
                  MenuController.maybeOf(context)?.close();
                  exportJsonToSystemShare(context, ref);
                },
              ),
              MenuItemButton(
                leadingIcon: const Icon(FontAwesomeIcons.upload, size: 18.0),
                style: MenuItemButton.styleFrom(backgroundColor: cs.surfaceContainerHighest),
                child: const Text('Import from file (.json)'),
                onPressed: () {
                  MenuController.maybeOf(context)?.close();
                  importJsonFromSystemFile(context, ref);
                },
              )
            ],
          )
        ],
      ),

      // Course Body
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ScheduleBody(isEditMode: _editMode, controller: scheduleController)),
            // const SizedBox(height: 50),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          // Edit tool bar
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _editMode
                ? Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration:
                        BoxDecoration(color: cs.tertiaryContainer, borderRadius: BorderRadius.circular(50), boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(128), // Shadow color with opacity
                        spreadRadius: 5, // Extent to which the shadow spreads
                        blurRadius: 7, // Amount of blur applied to the shadow
                        offset: const Offset(0, 3), // Offset of the shadow from the box (x, y)
                      )
                    ]),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => scheduleController.addRow(),
                            tooltip: 'New a row',
                            icon: overlayIcon(Icons.table_rows_outlined, true, cs.tertiaryContainer)),
                        IconButton(
                            onPressed: () => scheduleController.removeRow(),
                            tooltip: 'Remove a row',
                            icon: overlayIcon(Icons.table_rows_outlined, false, cs.tertiaryContainer)),
                        IconButton(
                            onPressed: () => scheduleController.addDay(),
                            tooltip: 'New a column',
                            icon: overlayIcon(Icons.view_column_outlined, true, cs.tertiaryContainer)),
                        IconButton(
                            onPressed: () => scheduleController.removeDay(),
                            tooltip: 'Remove a column',
                            icon: overlayIcon(Icons.view_column_outlined, false, cs.tertiaryContainer)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Edit Mode Button
          FloatingActionButton(
            backgroundColor: _editMode ? cs.tertiary : cs.primary,
            onPressed: _switchEditMode,
            tooltip: 'Edit Mode',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_editMode ? 50 : 16),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _editMode
                  ? const Icon(Icons.check, size: 30, key: ValueKey('fab-check'))
                  : const Icon(Icons.edit, size: 30, key: ValueKey('fab-edit')),
            ),
          ),
        ],
      ),
    );
  }
}

Widget overlayIcon(IconData base, bool isAdd, Color accent) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Icon(base),
      Positioned(
        right: -5,
        top: -6,
        child: CircleAvatar(
          radius: 8,
          backgroundColor: accent,
          child: Icon(isAdd ? Icons.add : Icons.remove, size: 12, color: Colors.white),
        ),
      ),
    ],
  );
}
