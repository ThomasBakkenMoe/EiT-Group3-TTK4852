import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class BackgroundMap extends StatelessWidget {
  const BackgroundMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(38, -97),
        zoom: 3,
        allowPanning: false,
        enableScrollWheel: false,
        interactiveFlags: InteractiveFlag.none,
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
      ],
    );
  }
}
