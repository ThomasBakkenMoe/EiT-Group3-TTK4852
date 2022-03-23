import 'dart:convert';

import 'package:desktop_visualizer/constants/us_states_map.dart';
import 'package:desktop_visualizer/screens/leaflet_map/leaflet_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class City {
  late String name;
  late Polygon polygon;
  late LatLng centroid;
  late double vegFrac;
  late double happyScore;
  late int emoPhysRank;
  late int incomeEmpRank;
  late int communityEnvRank;

  City.fromJSON(String path) {
    _fromJSON(path);
  }

  void setData(
      {required double vegFrac,
      required double happyScore,
      required int emoPhysRank,
      required int incomeEmpRank,
      required int communityEnvRank}) {
    this.vegFrac = vegFrac;
    this.happyScore = happyScore;
    this.emoPhysRank = emoPhysRank;
    this.incomeEmpRank = incomeEmpRank;
    this.communityEnvRank = communityEnvRank;
  }

  String getName() {
    return name.split(',')[0];
  }

  String getStateShort() {
    return name.split(', ')[1];
  }

  String getStateLong() {
    // Add state map
    final abbr = name.split(', ')[1];
    return usStates[abbr] ?? abbr;
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
                    getName() + ', ' + getStateLong(),
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
  final dataFile = await rootBundle.loadString('assets/city_data.json');
  List<dynamic> data = await jsonDecode(dataFile);

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
    City city = City.fromJSON(file);
    for (Map<String, dynamic> cityData in data) {
      if (cityData['City'] == city.name) {
        city.setData(
            vegFrac: cityData['Vegetation %'],
            happyScore: cityData['Total Score'],
            emoPhysRank: cityData['Emotional and Physical Well-Being Rank'],
            incomeEmpRank: cityData['Income and Employment Rank'],
            communityEnvRank: cityData['Community and Environment Rank']);
      }
    }

    cities.add(city);
  }

  return cities;
}
