import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/main.dart';
import 'package:satreelight/screens/leaflet_map/components/osm_contribution.dart';
import 'package:satreelight/widgets/stat_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller/map_controller.dart';

class LeafletMap extends ConsumerStatefulWidget {
  final List<City> cities;
  const LeafletMap({required this.cities, Key? key}) : super(key: key);

  @override
  ConsumerState<LeafletMap> createState() => _LeafletMapState();
}

class _LeafletMapState extends ConsumerState<LeafletMap>
    with TickerProviderStateMixin {
  bool mapReady = false;
  bool inBackground = true;
  bool enabled = true;
  double initZoom = 3;
  double endZoom = 4;
  final LatLng usaCenter = LatLng(38, -97);
  MapController mapController = MapController();
  List<Marker> markers = [];

  late StatefulMapController statefulMapController;
  late StreamSubscription<StatefulMapControllerStateChange> mapStateChange;
  late AnimationController zoomController;

  void initZoomAnim({bool zoomOut = false}) {
    zoomController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    final zoomAnim = CurvedAnimation(
        parent: zoomController,
        curve: zoomOut ? Curves.fastOutSlowIn.flipped : Curves.fastOutSlowIn);
    zoomAnim.addListener(() {
      if (zoomOut) {
        final pos = LatLng(
            usaCenter.latitude -
                (1 - zoomAnim.value) *
                    (usaCenter.latitude - mapController.center.latitude),
            usaCenter.longitude -
                (1 - zoomAnim.value) *
                    (usaCenter.longitude - mapController.center.longitude));
        final zoom =
            initZoom + (1 - zoomAnim.value) * (mapController.zoom - initZoom);
        mapController.move(pos, zoom);
      } else {
        mapController.move(
            usaCenter, initZoom + zoomAnim.value * (endZoom - initZoom));
      }
    });
  }

  void setMarkers() {
    for (final city in widget.cities) {
      double markerSize = 40;
      final marker = Marker(
        point: city.center,
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: markerSize,
        width: markerSize,
        builder: (context) => Icon(
          Icons.pin_drop,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).primaryColor,
          size: markerSize,
        ),
      );
      markers.add(marker);
    }
  }

  void toBackground() {
    zoomController.dispose();
    initZoomAnim(zoomOut: true);
    zoomController.forward();
  }

  void toForeground() {
    zoomController.dispose();
    initZoomAnim();
    zoomController.forward();
  }

  @override
  void initState() {
    super.initState();
    setMarkers();
    initZoomAnim();
    statefulMapController = StatefulMapController(mapController: mapController);
    mapStateChange = statefulMapController.changeFeed.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    inBackground = ref.watch(mapInBackgroundProvider).mapInBackground;
    ref.listen(mapZoomInProvider, (_old, _new) {
      toForeground();
    });
    ref.listen(mapZoomOutProvider, (_old, _new) {
      toBackground();
    });

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            interactiveFlags: enabled && !inBackground
                ? InteractiveFlag.all
                : InteractiveFlag.none,
            enableScrollWheel: enabled && !inBackground,
            center: usaCenter,
            zoom: initZoom,
            maxZoom: 18.25,
            plugins: [
              MarkerClusterPlugin(),
            ],
            slideOnBoundaries: true,
          ),
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
            ),
            if (enabled && !inBackground)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  showPolygon: false,
                  maxClusterRadius: 120,
                  size: Size(MediaQuery.of(context).textScaleFactor * 55,
                      MediaQuery.of(context).textScaleFactor * 30),
                  markers: markers,
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
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(200),
                  ),
                  zoomToBoundsOnClick: true,
                  centerMarkerOnClick: true,
                  onMarkerTap: (marker) async {
                    City city = widget.cities[markers.indexOf(marker)];
                    await city.loadData();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: WillPopScope(
                            onWillPop: () async {
                              setState(() {
                                enabled = true;
                              });
                              return enabled;
                            },
                            child: SimpleDialog(
                              title: Row(
                                children: [
                                  Text(
                                    city.name + ', ' + city.stateLong,
                                    style:
                                        Theme.of(context).textTheme.headline4,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              children: [StatPopup(city: city)],
                            ),
                          ),
                        );
                      },
                    );
                    setState(() {
                      enabled = false;
                    });
                  },
                ),
              ),
          ],
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: OSMContribution(),
        )
      ],
    );
  }
}
