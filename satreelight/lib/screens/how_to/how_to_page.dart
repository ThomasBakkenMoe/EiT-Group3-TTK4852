import 'dart:async';
import 'dart:ui';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/main.dart';
import 'package:satreelight/screens/leaflet_map/components/osm_contribution.dart';
import 'package:satreelight/screens/leaflet_map/components/themed_tiles_container.dart';
import 'package:satreelight/widgets/stat_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller/map_controller.dart';


class HowToPage extends StatelessWidget {
  final City city;
  const HowToPage({required this.city, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How it works'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Click on the location pin', style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 100),
            FlatButton(   
              onPressed: () async {
                await city.loadData();
                showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: SimpleDialog(
                        backgroundColor: Theme.of(context).dialogBackgroundColor,
                        title: Row(
                          children: [
                            Text(
                              city.name + ', ' + city.stateLong,
                              style:
                                  Theme.of(context).textTheme.headline4,
                            ),
                            CloseButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                            ),
                          ],
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                        ),
                        children: [StatPopup(city: city)],
                      ),
                    );
                  },
                );
              },
              shape: const CircleBorder(),
              hoverColor: const Color(0x00000000),
              child: DecoratedIcon(
                Icons.pin_drop,
                color: Theme.of(context).primaryColor,
                size: 60.0,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: Theme.of(context).brightness == Brightness.dark ? 2 : 1,
                  ),
                ],
              ),
            ),
            Text('Los Angeles', style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
/*
            DecoratedIcon(  
              Icons.pin_drop,
              color: Theme.of(context).primaryColor,
              size: markerSize,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: Theme.of(context).brightness == Brightness.dark ? 2 : 1,
                ),
              ],
            ),*/