import 'dart:convert';

import 'package:desktop_visualizer/constants/us_states_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class City {
  final String nameAndState;
  final List<LatLng> combinedPolygonPoints;
  final List<List<LatLng>> polygonsPoints;
  final Map<int, List<List<LatLng>>> polygonHolesPoints;
  final double vegFrac;
  final double happyScore;
  final int emoPhysRank;
  final int incomeEmpRank;
  final int communityEnvRank;

  City({
    required this.nameAndState,
    required this.vegFrac,
    required this.happyScore,
    required this.emoPhysRank,
    required this.incomeEmpRank,
    required this.communityEnvRank,
    required this.combinedPolygonPoints,
    required this.polygonsPoints,
    required this.polygonHolesPoints,
  });

  String get name {
    return nameAndState.split(',')[0];
  }

  String get stateShort {
    return nameAndState.split(', ')[1];
  }

  String get stateLong {
    // Finds the abbreviation for the state
    final abbr = nameAndState.split(', ')[1];
    return usStates[abbr] ?? abbr;
  }

  LatLng get center {
    return LatLngBounds.fromPoints(combinedPolygonPoints).center;
  }

  LatLng? get northEast {
    return LatLngBounds.fromPoints(combinedPolygonPoints).northEast;
  }

  LatLng? get southWest {
    return LatLngBounds.fromPoints(combinedPolygonPoints).southWest;
  }

  Polygon get polygon {
    return Polygon(
      points: polygon.points,
      color: Colors.grey.withAlpha(100),
      borderColor: Colors.black,
      borderStrokeWidth: 1,
      isDotted: true,
    );
  }

  List<Polygon> get polygons {
    return List<Polygon>.generate(
      polygonsPoints.length,
      (index) => Polygon(
        points: polygonsPoints[index],
        holePointsList: polygonHolesPoints[index] ?? [],
        color: Colors.grey.withAlpha(100),
        borderColor: Colors.black,
        borderStrokeWidth: 1,
        isDotted: true,
      ),
    );
  }

  LatLngBounds get bounds {
    return LatLngBounds.fromPoints(combinedPolygonPoints);
  }

  CenterZoom centerZoom(MapController mapController) {
    return mapController.centerZoomFitBounds(bounds);
  }

  Future<OverlayImage> getImage({String type = 'veg_overlay'}) async {
    String path =
        'assets/images_hl_veg_only/' + nameAndState + ' hl_veg_only.png';
    final manifest = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> assetMap = jsonDecode(manifest);
    if (!assetMap.containsKey(path.replaceAll(' ', '%20'))) {
      path = 'assets/transparent.png';
    }
    return OverlayImage(
      bounds: bounds,
      opacity: 0.5,
      imageProvider: AssetImage(path),
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
    final nameAndState =
        path.split('american_cities/').last.split('.json').first;
    for (Map<String, dynamic> cityData in data) {
      if (cityData['City'] == nameAndState) {
        final polygonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = jsonDecode(polygonString);
        List<dynamic> polygonList = [];
        if (jsonMap.containsKey('geometries')) {
          polygonList = jsonMap['geometries'][0]['coordinates'];
        } else {
          polygonList = jsonMap['coordinates'];
        }
        List<List<LatLng>> polygonsPoints = [];
        Map<int, List<List<LatLng>>> polygonHolesPoints = {};
        List<LatLng> combinedPolygonPoints = [];

        int index = 0;
        for (List polygon in polygonList) {
          List polygonPoints = [];
          int subIndex = 0;
          for (List points in polygon) {
            polygonPoints.addAll(points);

            List<LatLng> polygonLatLngs = List.generate(
              polygonPoints.length,
              (index) {
                final point = polygonPoints[index];
                double lat = point[1].toDouble();
                double lon = point[0].toDouble();
                return LatLng(lat, lon);
              },
            );
            if (subIndex == 0) {
              polygonsPoints.add(polygonLatLngs);
            } else {
              polygonHolesPoints.update(
                index,
                (value) => [...value, polygonLatLngs],
                ifAbsent: () => [polygonLatLngs],
              );
            }
            combinedPolygonPoints.addAll(polygonLatLngs);
            subIndex++;
          }
          index++;
        }

        final city = City(
          nameAndState: nameAndState,
          vegFrac: cityData['Vegetation %'],
          happyScore: cityData['Total Score'].toDouble(),
          emoPhysRank: cityData['Emotional and Physical Well-Being Rank'],
          incomeEmpRank: cityData['Income and Employment Rank'],
          communityEnvRank: cityData['Community and Environment Rank'],
          combinedPolygonPoints: combinedPolygonPoints,
          polygonsPoints: polygonsPoints,
          polygonHolesPoints: polygonHolesPoints,
        );
        cities.add(city);
        break;
      }
    }
  }

  return cities;
}
