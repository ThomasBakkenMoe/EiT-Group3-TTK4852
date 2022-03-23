import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class LeafletMap extends StatefulWidget {
  final List<City> cities;
  const LeafletMap({required this.cities, Key? key}) : super(key: key);

  @override
  State<LeafletMap> createState() => LeafletMapState();
}

class LeafletMapState extends State<LeafletMap> {
  Set<City> polygons = {};
  Set<City> markers = {};

  void addPolygon(City city) {
    polygons.add(city);
  }

  void removePolygon(City city) {
    polygons.remove(city);
  }

  void addMarker(City city) {
    markers.add(city);
  }

  void removeMarker(City city) {
    markers.remove(city);
  }

  @override
  void initState() {
    super.initState();
    markers.addAll(cities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(38, -97),
          zoom: 4,
          plugins: [MarkerClusterPlugin()],
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ),
          PolygonLayerWidget(
            options: PolygonLayerOptions(
              polygons: List.generate(polygons.length,
                  (index) => polygons.elementAt(index).getPolygon(context)),
            ),
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              onMarkerTap: (p0) {
                print(p0.key);
              },
              showPolygon: false,
              maxClusterRadius: 120,
              markers: List.generate(markers.length, (index) {
                City city = markers.elementAt(index);
                return city.makeMarker(context, this);
              }),
              builder: (context, localMarkers) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      localMarkers.length.toString(),
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
