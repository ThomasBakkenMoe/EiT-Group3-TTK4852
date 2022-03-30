import 'dart:async';

import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/main.dart';
import 'package:desktop_visualizer/widgets/stat_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller/map_controller.dart';

class LeafletMap extends StatefulWidget {
  final List<City> cities;
  const LeafletMap({required this.cities, Key? key}) : super(key: key);

  @override
  State<LeafletMap> createState() => _LeafletMapState();
}

class _LeafletMapState extends State<LeafletMap> {
  Map<String, StatefulMarker> markers = {};
  Map<City, OverlayImage> overlayImages = {};

  MapController mapController = MapController();
  late StatefulMapController statefulMapController;
  late StreamSubscription<StatefulMapControllerStateChange> mapStateChange;

  PopupController popupController = PopupController();

  @override
  void initState() {
    super.initState();
    for (final city in cities) {
      double markerSize = 40;
      final marker = StatefulMarker(
        state: {'city': city, 'active': false},
        point: city.centroid,
        height: markerSize,
        width: markerSize,
        builder: (context, state) => Icon(
          Icons.pin_drop,
          color: state['active']
              ? Colors.transparent
              : Theme.of(context).primaryColor,
          size: markerSize,
        ),
        anchorAlign: AnchorAlign.center,
      );
      markers[city.name] = marker;
    }
    statefulMapController = StatefulMapController(mapController: mapController);
    mapStateChange = statefulMapController.changeFeed.listen((event) {
      setState(() {});
    });
    statefulMapController.addStatefulMarkers(markers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
            center: LatLng(38, -97),
            zoom: 4,
            plugins: [
              MarkerClusterPlugin(),
            ],
            slideOnBoundaries: true,
            onTap: (tapPos, latLng) {
              popupController.hideAllPopups();
              setState(() {
                overlayImages.clear();
                for (City city in cities) {
                  statefulMapController.mutateMarker(
                      name: city.name, property: 'active', value: false);
                }
                statefulMapController.namedPolygons.clear();
              });
            }),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ),
          PolygonLayerWidget(
            options: PolygonLayerOptions(
              polygons: statefulMapController.polygons,
            ),
          ),
          OverlayImageLayerWidget(
            options: OverlayImageLayerOptions(
              overlayImages: overlayImages.values.toList(),
            ),
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
                showPolygon: false,
                maxClusterRadius: 120,
                size: Size(MediaQuery.of(context).textScaleFactor * 55,
                    MediaQuery.of(context).textScaleFactor * 30),
                markers: statefulMapController.markers,
                builder: (context, localMarkers) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Center(
                      child: Text(localMarkers.length.toString(),
                          style: Theme.of(context).textTheme.headline6),
                    ),
                  );
                },
                popupOptions: PopupOptions(
                  markerTapBehavior: MarkerTapBehavior.custom(
                    (marker, popupController) async {
                      City city = statefulMapController.statefulMarkers.values
                          .firstWhere(
                              (element) => element.marker.point == marker.point)
                          .state['city'];

                      if (!popupController.selectedMarkers.contains(marker)) {
                        if (!overlayImages.containsKey(city)) {
                          overlayImages[city] = await city.getImage();
                        }
                        setState(() {
                          statefulMapController.addPolygon(
                            name: city.name,
                            points: city.polygon.points,
                            color: Colors.grey.withAlpha(100),
                            borderColor: Colors.black.withAlpha(100),
                            borderWidth: 1,
                          );

                          statefulMapController.mutateMarker(
                              name: city.name, property: 'active', value: true);
                        });
                        statefulMapController.zoomTo(11);
                      } else {
                        setState(() {
                          statefulMapController.namedPolygons.remove(city.name);
                          overlayImages.remove(city);
                        });
                        statefulMapController.mutateMarker(
                            name: city.name, property: 'active', value: false);
                      }

                      popupController.togglePopup(marker);
                    },
                  ),
                  popupSnap: PopupSnap.mapRight,
                  popupAnimation: const PopupAnimation.fade(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                  popupController: popupController,
                  popupBuilder: (context, marker) {
                    City city = statefulMapController.statefulMarkers.values
                        .firstWhere(
                            (element) => element.marker.point == marker.point)
                        .state['city'];
                    // TODO: Replace with our visualization
                    return Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).scaffoldBackgroundColor),
                      padding: const EdgeInsets.all(8),
                      child: StatPopup(city: city),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
