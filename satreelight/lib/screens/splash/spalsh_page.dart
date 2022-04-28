import 'dart:ui';

import 'package:satreelight/main.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/screens/credits/credits_page.dart';
import 'package:satreelight/screens/how_to/how_to_page.dart';
import 'package:satreelight/screens/leaflet_map/leaflet_map.dart';
import 'package:satreelight/screens/list_page/list_page.dart';
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
  final logo = Image.asset(
    'assets/graphics/satreelight_logo.png',
    height: 300,
  );

  @override
  void initState() {
    super.initState();
    ref.read(themeModeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final mapInBackground = ref.watch(mapInBackgroundProvider).mapInBackground;
    return Scaffold(
      appBar: AppBar(
        title: !mapInBackground ? const Text('Map') : const Text('Home'),
        leading: !mapInBackground
            ? BackButton(onPressed: () {
                ref.read(mapInBackgroundProvider).setMapInBackground(true);
                ref.read(mapZoomOutProvider).start();
              })
            : null,
        actions: [
          IconButton(
            padding: const EdgeInsets.all(8),
            tooltip: 'Light/Dark mode',
            onPressed: () {
              ref.read(themeModeProvider).setThemeMode(
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
            },
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          PopupMenuButton<int>(
            onSelected: (int index) {
              ref.read(schemeProvider).setThemeModeIndex(index);
            },
            initialValue:
                FlexScheme.values.indexOf(ref.read(schemeProvider).scheme),
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          LeafletMap(cities: cities),
          if (mapInBackground)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  logo,
                  Text(
                    'SaTreeLight',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                      shadows: [
                        const Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 0,
                        ),
                      ],
                      color: const Color.fromRGBO(84, 130, 53, 1),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 250, maxHeight: 400),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Card(
                            elevation: 10,
                            child: Tooltip(
                              message: 'Open and explore the map',
                              waitDuration: const Duration(milliseconds: 250),
                              child: ListTile(
                                  title: const Text('Start'),
                                  leading: const Icon(Icons.map),
                                  onTap: () {
                                    ref
                                        .read(mapInBackgroundProvider)
                                        .setMapInBackground(false);
                                    ref.read(mapZoomInProvider).start();
                                  }),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Tooltip(
                              message: 'How to use the app',
                              waitDuration: const Duration(milliseconds: 250),
                              child: ListTile(
                                title: const Text('How it works'),
                                leading: const Icon(Icons.help),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HowToPage(
                                      city: cities.firstWhere((element) =>
                                          element.name == "Los Angeles"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Tooltip(
                              message: 'Browse a sortable list of cities',
                              waitDuration: const Duration(milliseconds: 250),
                              child: ListTile(
                                title: const Text('Cities'),
                                leading: const Icon(Icons.list_alt),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListPage(cities: cities),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Tooltip(
                              message: 'View the honourable contributors',
                              waitDuration: const Duration(milliseconds: 250),
                              child: ListTile(
                                title: const Text('Credits'),
                                leading: const Icon(Icons.people),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreditsPage(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
