import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/screens/leaflet_map/components/osm_contribution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatPopup extends StatefulWidget {
  const StatPopup({required this.city, Key? key}) : super(key: key);

  final City city;

  @override
  State<StatefulWidget> createState() => _StatPopup();
}

class _StatPopup extends State<StatPopup> {
  final MapController mapController = MapController();
  double minZoom = 3;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final centerZoom = widget.city.centerZoom(mapController);
      minZoom = centerZoom.zoom;
      mapController.fitBounds(widget.city.bounds);
    });

    Color cardColor = Theme.of(context).dividerColor;
    var screenSize = MediaQuery.of(context).size;

    OverlayImage placeholderImage = OverlayImage(
      bounds: widget.city.bounds,
      imageProvider: const AssetImage('assets/transparent.png'),
    );

    return Builder(builder: (context) {
      return FutureBuilder<OverlayImage>(
        future: widget.city.getImage(),
        initialData: placeholderImage,
        builder: ((context, snapshot) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        child: Container(
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: widget.city.center,
                              zoom: 10,
                              minZoom: minZoom,
                              maxZoom: 18.25,
                              swPanBoundary: widget.city.southWest,
                              nePanBoundary: widget.city.northEast,
                            ),
                            children: [
                              TileLayerWidget(
                                options: TileLayerOptions(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: ['a', 'b', 'c'],
                                  attributionBuilder: (context) =>
                                      const OSMContribution(),
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
                          height: screenSize.height * 0.58,
                          width: screenSize.width * 0.52,
                          color: cardColor,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            child: SizedBox(
                              height: screenSize.height * 0.185,
                              width: screenSize.width * 0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularPercentIndicator(
                                    curve: Curves.easeInOutSine,
                                    animation: true,
                                    animationDuration: 1000,
                                    radius: screenSize.height * 0.08,
                                    lineWidth: 16.0,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    percent: widget.city.vegFrac,
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text((widget.city.vegFrac * 100)
                                                .toStringAsFixed(1) +
                                            "%"),
                                        Text(
                                          "Vegetation",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                    progressColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor:
                                        Theme.of(context).dialogBackgroundColor,
                                  ),
                                ],
                              ),
                            ),
                            color: cardColor,
                          ),
                          Card(
                            child: Container(
                              color: cardColor,
                              height: screenSize.height * 0.185,
                              width: screenSize.width * 0.15,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "Happiness Rank:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            "Emotional and Physical Well-being Rank",
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline,
                                          ),
                                        ),
                                        Text(
                                          "#" +
                                              widget.city.emoPhysRank
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            "Income and Employment Rank",
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline,
                                          ),
                                        ),
                                        Text(
                                          "#" +
                                              widget.city.incomeEmpRank
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            "Community and Enviorment Rank",
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline,
                                          ),
                                        ),
                                        Text(
                                          "#" +
                                              widget.city.communityEnvRank
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              color: cardColor,
                              height: screenSize.height * 0.185,
                              width: screenSize.width * 0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Total Happiness Score:",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            widget.city.happyScore.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        Icon(
                                          widget.city.happyScore > 64
                                              ? Icons
                                                  .sentiment_very_satisfied_rounded
                                              : widget.city.happyScore > 57
                                                  ? Icons
                                                      .sentiment_satisfied_alt_rounded
                                                  : widget.city.happyScore > 47
                                                      ? Icons
                                                          .sentiment_neutral_rounded
                                                      : widget.city.happyScore >
                                                              40
                                                          ? Icons
                                                              .sentiment_dissatisfied
                                                          : Icons
                                                              .sentiment_very_dissatisfied_rounded,
                                          size: 50,
                                          color: widget.city.happyScore > 64
                                              ? Colors.green
                                              : widget.city.happyScore > 57
                                                  ? Colors.lightGreen
                                                  : widget.city.happyScore > 47
                                                      ? Colors.yellow
                                                      : widget.city.happyScore >
                                                              40
                                                          ? Colors.orange
                                                          : Colors.red,
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
