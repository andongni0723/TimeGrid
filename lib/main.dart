import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timegrid/schedule.dart';
import 'package:timegrid/theme/Theme.dart'; // 你的 color scheme 檔

void main() => runApp(const MyApp());

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
  int _counter = 0;
  int _selectedIndex = 0; // For bottom navigation bar

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 18.0), // Adjust size as needed
            onPressed: () {}, // Add your search functionality here
          )
        ],
      ),
      body: const ScheduleBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add, size: 30,),
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