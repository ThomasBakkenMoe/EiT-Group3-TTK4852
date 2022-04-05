import 'dart:ui';

import 'package:desktop_visualizer/main.dart';
import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/screens/credits/credits_page.dart';
import 'package:desktop_visualizer/screens/how_to/how_to_page.dart';
import 'package:desktop_visualizer/screens/leaflet_map/leaflet_map.dart';
import 'package:desktop_visualizer/screens/splash/components/background_map.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  final List<City> cities;

  const SplashPage({required this.cities, Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
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
            padding: const EdgeInsets.all(8),
            tooltip: 'Light/Dark mode',
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
          PopupMenuButton<int>(
            onSelected: (int index) {
              ref.read(schemeProvider).setThemeModeIndex(index);
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
              for (int i = 0; i < FlexColor.schemesList.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: ListTile(
                    leading: Icon(Icons.lens,
                        color: Theme.of(context).brightness == Brightness.light
                            ? FlexColor.schemesList[i].light.primary
                            : FlexColor.schemesList[i].dark.primary,
                        size: 35),
                    title: Text(FlexColor.schemesList[i].name),
                  ),
                )
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.lens,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Theme.of(context).appBarTheme.backgroundColor,
                    size: 40,
                  ),
                  Icon(
                    Icons.color_lens,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            const BackgroundMap(),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'SaTreeLight',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).primaryColorDark
                              : null,
                        ),
                  ),
                  Divider(indent: 300, endIndent: 300),
                  ElevatedButton(
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
                  ElevatedButton(
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditsPage(),
                        ),
                      );
                    },
                    child: Text('Credits'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
