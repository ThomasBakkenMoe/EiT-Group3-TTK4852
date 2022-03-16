import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class LeafletMap extends StatelessWidget {
  const LeafletMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        point: LatLng(38, -97),
        builder: (context) => IconButton(
          icon: const Icon(Icons.pin_drop),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      'Simple dialog',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(38, -97),
          zoom: 5,
          plugins: [MarkerClusterPlugin()],
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              size: const Size(40, 40),
              maxClusterRadius: 120,
              markers: markers,
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
          )
        ],
      ),
    );
  }
}
