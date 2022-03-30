import 'package:desktop_visualizer/main.dart';
import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/screens/credits/credits_page.dart';
import 'package:desktop_visualizer/screens/how_to/how_to_page.dart';
import 'package:desktop_visualizer/screens/leaflet_map/leaflet_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  final List<City> cities;

  const SplashPage({required this.cities, Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  final List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    ref.read(themeModeProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Home Page'),

        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider).setThemeMode(
                  Theme.of(context).brightness == Brightness.light
                      ? ThemeMode.dark
                      : ThemeMode.light);
            },
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fantastic name of application',
              style: Theme.of(context).textTheme.headline1,
            ),
            Divider(indent: 300, endIndent: 300),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeafletMap(
                      cities: widget.cities,
                    ),
                  ),
                );
              },
              child: Text('Start'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HowToPage(),
                  ),
                );
              },
              child: Text('How it works'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreditsPage(),
                  ),
                );
              },
              child: Text('Credits'),
            )
          ],
        ),
        /* decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/graphics/placeholder.png'),
              fit: BoxFit.cover),
        ), */
      ),
    );
  }
}
