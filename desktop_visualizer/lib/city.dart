import 'dart:convert';

import 'package:desktop_visualizer/leaflet_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class City {
  late String name;
  late Polygon polygon;
  late LatLng centroid;

  City.fromJSON(String path) {
    _fromJSON(path);
  }

  Future<void> _fromJSON(String path) async {
    path = path.replaceAll('%20', ' ');
    name = path.split('american_cities/').last.split('.json').first;
    final string = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = jsonDecode(string);
    List pointList = [];
    if (jsonMap.containsKey('geometries')) {
      pointList = jsonMap['geometries'][0]['coordinates'][0][0];
    } else {
      pointList = jsonMap['coordinates'][0][0];
    }
    List<LatLng> points = List.generate(
      pointList.length,
      (index) {
        final point = pointList[index];
        double lat = point[1] + 0.0;
        double lon = point[0] + 0.0;
        return LatLng(lat, lon);
      },
    );
    polygon = Polygon(
      points: points,
      color: Colors.grey.withAlpha(100),
      borderColor: Colors.black,
      borderStrokeWidth: 10,
      isDotted: true,
    );
    centroid = LatLngBounds.fromPoints(polygon.points).center;
    if (kDebugMode) {
      print(path);
    }
  }

  Polygon getPolygon(BuildContext context) {
    return Polygon(
      points: polygon.points,
      color: Colors.grey.withAlpha(100),
      borderColor: Colors.black,
      borderStrokeWidth: 1,
      isDotted: true,
    );
  }

  Marker makeMarker(BuildContext context, LeafletMapState state) {
    return Marker(
      anchorPos: AnchorPos.align(AnchorAlign.center),
      key: ValueKey(name),
      point: centroid,
      builder: (context) => IconButton(
        icon: Icon(
          Icons.pin_drop,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          // Dirty setState, pulling from the state of ancestor widget, should be changed
          // to a valueChangeNotifier or similar
          state.setState(() {
            state.addPolygon(this);
            state.removeMarker(this);
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Dirty setState, pulling from the state of ancestor widget, should be changed
                          // to a valueChangeNotifier or similar
                          state.setState(() {
                            state.removePolygon(this);
                            state.addMarker(this);
                          });
                        },
                        child: Text(
                          'Close',
                          style: Theme.of(context).textTheme.headline6,
                        ))
                  ],
                );
              });
        },
      ),
    );
  }
}

Future<List<City>> loadCities() async {
  List<City> cities = [];
  final manifest = await rootBundle.loadString('AssetManifest.json');

  Map<String, dynamic> assetMap = jsonDecode(manifest);

  if (kDebugMode) {
    const int citiesToRead = 5;
    Map<String, dynamic> newMap = {};
    newMap.addEntries(
      assetMap.entries
          .where(
            (element) => element.key.contains('.json'),
          )
          .takeWhile(
            (value) => newMap.length < citiesToRead,
          ),
    );
    assetMap = newMap;
  }

  for (String file in assetMap.keys.where(
    (element) => element.contains('.json'),
  )) {
    cities.add(City.fromJSON(file));
  }
  return cities;
}
