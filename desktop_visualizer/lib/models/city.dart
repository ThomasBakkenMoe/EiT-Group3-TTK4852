import 'dart:convert';

import 'package:desktop_visualizer/constants/us_states_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class City {
  final String name;
  final Polygon polygon;
  final LatLng centroid;
  final double vegFrac;
  final double happyScore;
  final int emoPhysRank;
  final int incomeEmpRank;
  final int communityEnvRank;

  City(
      {required this.name,
      required this.vegFrac,
      required this.happyScore,
      required this.emoPhysRank,
      required this.incomeEmpRank,
      required this.communityEnvRank,
      required this.polygon,
      required this.centroid});

  String getName() {
    return name.split(',')[0];
  }

  String getStateShort() {
    return name.split(', ')[1];
  }

  String getStateLong() {
    // Finds the abbreviation for the state
    final abbr = name.split(', ')[1];
    return usStates[abbr] ?? abbr;
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

  Future<OverlayImage> getImage() async {
    String path = 'assets/images_hl_veg_only/' + name + ' hl_veg_only.png';
    final manifest = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> assetMap = jsonDecode(manifest);
    if (!assetMap.containsKey(path.replaceAll(' ', '%20'))) {
      path = 'assets/transparent.png';
    }
    return OverlayImage(
      bounds: LatLngBounds.fromPoints(polygon.points),
      opacity: 0.5,
      imageProvider: AssetImage(path),
    );
  }

  String toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['name'] = name;
    jsonMap['vegFrac'] = vegFrac;
    jsonMap['happyScore'] = happyScore;
    jsonMap['emoPhysRank'] = emoPhysRank;
    jsonMap['incomeEmpRank'] = incomeEmpRank;
    jsonMap['communityEnvRank'] = communityEnvRank;
    jsonMap['centroid'] = centroid.toJson();
    jsonMap['polygon'] = List.generate(
      polygon.points.length,
      (index) => polygon.points[index].toJson(),
    );
    const encoder = JsonEncoder.withIndent('    ');
    return encoder.convert(jsonMap);
  }
}

Future<List<City>> loadCities() async {
  final dataFile = await rootBundle.loadString('assets/city_data.json');
  List<dynamic> data = await jsonDecode(dataFile);

  List<City> cities = [];
  final manifest = await rootBundle.loadString('AssetManifest.json');

  Map<String, dynamic> assetMap = jsonDecode(manifest);

  if (kDebugMode) {
    const int citiesToRead = 182;
    Map<String, dynamic> newMap = {};
    newMap.addEntries(
      assetMap.entries
          .where(
            (element) => element.key.contains('american_cities'),
          )
          .takeWhile(
            (value) => newMap.length < citiesToRead,
          ),
    );
    assetMap = newMap;
  }

  for (String file in assetMap.keys.where(
    (element) => element.contains('american_cities'),
  )) {
    final path = file.replaceAll('%20', ' ');
    final name = path.split('american_cities/').last.split('.json').first;
    for (Map<String, dynamic> cityData in data) {
      if (cityData['City'] == name) {
        final polygonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = jsonDecode(polygonString);
        List<dynamic> polygonList = [];
        if (jsonMap.containsKey('geometries')) {
          polygonList = jsonMap['geometries'][0]['coordinates'];
        } else {
          polygonList = jsonMap['coordinates'];
        }
        /* if (polygonList.length > 1) {
          print(name + ', Polygons: ' + polygonList.length.toString());
        } */
        List pointList = [];
        for (List polygon in polygonList) {
          for (List points in polygon) {
            pointList.addAll(points);
          }
        }
        List<LatLng> points = List.generate(
          pointList.length,
          (index) {
            final point = pointList[index];
            double lat = point[1].toDouble();
            double lon = point[0].toDouble();
            return LatLng(lat, lon);
          },
        );

        final polygon = Polygon(
          points: points,
          color: Colors.grey.withAlpha(100),
          borderColor: Colors.black,
          borderStrokeWidth: 10,
          isDotted: true,
        );
        final centroid = LatLngBounds.fromPoints(points).center;
        /* if (kDebugMode) {
          print(path);
        } */

        final city = City(
            name: name,
            vegFrac: cityData['Vegetation %'],
            happyScore: cityData['Total Score'].toDouble(),
            emoPhysRank: cityData['Emotional and Physical Well-Being Rank'],
            incomeEmpRank: cityData['Income and Employment Rank'],
            communityEnvRank: cityData['Community and Environment Rank'],
            polygon: polygon,
            centroid: centroid);
        cities.add(city);
        break;
      }
    }
  }

  return cities;
}
