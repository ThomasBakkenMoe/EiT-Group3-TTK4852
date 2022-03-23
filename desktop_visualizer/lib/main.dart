import 'package:desktop_visualizer/stat_dashboard.dart';
import 'package:desktop_visualizer/visualization_widgets/stat_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StatDashboard(title: "Hello"),
        ),
      ),
    );
  }
}
