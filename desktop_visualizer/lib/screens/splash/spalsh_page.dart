import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/screens/credits/credits_page.dart';
import 'package:desktop_visualizer/screens/how_to/how_to_page.dart';
import 'package:desktop_visualizer/screens/leaflet_map/leaflet_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final List<City> cities;

  const SplashPage({required this.cities, Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Home Page'),
        leading: IconButton(
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
          icon: const Icon(Icons.map),
        ),
        actions: [
          ToggleButtons(
            children: <Widget>[
              Icon(Icons.sunny),
              Icon(Icons.nightlight),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
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
