import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timegrid/models/course_chips_model.dart';
import 'package:timegrid/models/course_model.dart';
import 'package:timegrid/schedule.dart';
import 'package:timegrid/theme/Theme.dart';

import 'components/file_io_json.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(CourseChipsModelAdapter());

  await Hive.openBox<CourseModel>('courses_box');
  await Hive.openBox<CourseChipsModel>('chips_box');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeGrid',
      theme: ThemeData(
        colorScheme: darkColorScheme,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Schedule Grade 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _editMode = false;

  void _switchEditMode() => setState(() => _editMode = !_editMode);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 18.0),
          style: IconButton.styleFrom(
            backgroundColor: cs.secondaryContainer
          ),
          onPressed: () {}, // TODO: switch the schedules
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
                  exportJsonToSystemShare(context);
                },
              ),
              MenuItemButton(
                leadingIcon: const Icon(FontAwesomeIcons.upload, size: 18.0),
                style: MenuItemButton.styleFrom(backgroundColor: cs.surfaceContainerHighest),
                child: const Text('Import from file (.json)'),
                onPressed: () {
                  MenuController.maybeOf(context)?.close();
                  importJsonFromSystemFile(context);
                },
              )
            ]
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ScheduleBody(isEditMode: _editMode)),
            const SizedBox(height: 50)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _editMode ? cs.secondary : cs.primary,
        onPressed: _switchEditMode,
        tooltip: 'Edit Mode',
        child: _editMode
            ? const Icon(FontAwesomeIcons.check, size: 30)
            : const Icon(Icons.edit, size: 30),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: cs.surfaceContainerHighest,
        indicatorColor: cs.primaryContainer,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Other',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}