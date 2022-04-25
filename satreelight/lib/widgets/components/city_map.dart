import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/screens/leaflet_map/components/osm_contribution.dart';
import 'package:satreelight/screens/leaflet_map/components/themed_tiles_container.dart';

class CityMap extends StatefulWidget {
  final City city;
  const CityMap({Key? key, required this.city}) : super(key: key);

  @override
  State<CityMap> createState() => _CityMapState();
}

class _CityMapState extends State<CityMap> {
  final MapController mapController = MapController();
  double minZoom = 3;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        minZoom = widget.city.centerZoom(mapController).zoom;
      },
    );

    OverlayImage placeholderImage = OverlayImage(
      bounds: widget.city.bounds,
      imageProvider: const AssetImage('assets/transparent.png'),
    );

    return FutureBuilder<OverlayImage>(
      future: widget.city.getImage(),
      initialData: placeholderImage,
      builder: (context, snapshot) {
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                center: widget.city.center,
                maxZoom: 18.25,
                minZoom: minZoom,
                swPanBoundary: widget.city.southWest,
                nePanBoundary: widget.city.northEast,
                enableScrollWheel: true,
                bounds: widget.city.bounds,
                boundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(20),
                ),
              ),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    tilesContainerBuilder: (context, tilesContainer, tiles) =>
                        ThemedTilesContainer(tilesContainer: tilesContainer),
                  ),
                ),
                PolygonLayerWidget(
                  options: PolygonLayerOptions(
                    polygons: widget.city.polygons,
                  ),
                ),
                OverlayImageLayerWidget(
                  options: OverlayImageLayerOptions(
                    overlayImages: [
                      snapshot.data ?? placeholderImage,
                    ],
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: OSMContribution(),
            ),
          ],
        );
      },
    );
  }
}
