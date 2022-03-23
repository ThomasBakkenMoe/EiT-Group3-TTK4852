import 'package:desktop_visualizer/visualization_widgets/stat_card.dart';
import 'package:flutter/material.dart';

class StatDashboard extends StatefulWidget {
  const StatDashboard({Key? key, this.title = ""}) : super(key: key);

  final String title;
  
  @override
  _StatDashboard createState() => _StatDashboard();
}

class _StatDashboard extends State<StatDashboard>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Row(children: <Widget>[
            StatCard(),
            StatCard(),
        ]),
      ),
    );
  }
}
