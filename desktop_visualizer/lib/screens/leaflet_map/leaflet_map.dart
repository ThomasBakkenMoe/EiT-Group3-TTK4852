import 'dart:async';
import 'dart:ui';

import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/main.dart';
import 'package:desktop_visualizer/screens/leaflet_map/components/osm_contribution.dart';
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

class _LeafletMapState extends State<LeafletMap>
    with SingleTickerProviderStateMixin {
  bool enabled = true;
  double initZoom = 3;
  double endZoom = 4;
  final LatLng usaCenter = LatLng(38, -97);
  MapController mapController = MapController();
  Map<String, StatefulMarker> markers = {};

  late StatefulMapController statefulMapController;
  late StreamSubscription<StatefulMapControllerStateChange> mapStateChange;
  late AnimationController animationController;

  void initAnim() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    final initZoomAnim = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    initZoomAnim.addListener(() {
      mapController.move(
          usaCenter, initZoomAnim.value * (endZoom - initZoom) + initZoom);
    });
  }

  void setMarkers() {
    for (final city in cities) {
      double markerSize = 40;
      final marker = StatefulMarker(
        state: {'city': city, 'active': false},
        point: city.center,
        height: markerSize,
        width: markerSize,
        builder: (context, state) => Icon(
          Icons.pin_drop,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).primaryColor,
          size: markerSize,
        ),
        anchorAlign: AnchorAlign.center,
      );
      markers[city.nameAndState] = marker;
    }
  }

  @override
  void initState() {
    super.initState();
    initAnim();
    setMarkers();
    statefulMapController = StatefulMapController(mapController: mapController);
    mapStateChange = statefulMapController.changeFeed.listen((event) {
      setState(() {});
    });
    statefulMapController.addStatefulMarkers(markers);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      animationController.forward();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
            interactiveFlags:
                enabled ? InteractiveFlag.all : InteractiveFlag.none,
            enableScrollWheel: enabled,
            center: usaCenter,
            zoom: initZoom,
            maxZoom: 18.25,
            plugins: [
              MarkerClusterPlugin(),
            ],
            slideOnBoundaries: true,
            onTap: (tapPos, latLng) {
              setState(() {
                enabled = true;
              });
            }),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (context) => const OSMContribution(),
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
              zoomToBoundsOnClick: true,
              centerMarkerOnClick: false,
              onMarkerTap: (marker) {
                setState(() {
                  enabled = false;
                });

                City city = statefulMapController.statefulMarkers.values
                    .firstWhere(
                        (element) => element.marker.point == marker.point)
                    .state['city'];
                showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: SimpleDialog(
                        title: Row(
                          children: [
                            Text(
                              city.name + ', ' + city.stateLong,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            CloseButton(
                              onPressed: (() {
                                setState(() {
                                  enabled = true;
                                });
                                Navigator.of(context).pop();
                              }),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        children: [StatPopup(city: city)],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
