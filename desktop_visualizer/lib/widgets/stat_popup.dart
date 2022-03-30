import 'package:desktop_visualizer/models/city.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatPopup extends StatefulWidget {
  const StatPopup({required this.city, Key? key}) : super(key: key);

  final City city;

  @override
  State<StatefulWidget> createState() => _StatPopup();
}

class _StatPopup extends State<StatPopup> {
  @override
  Widget build(BuildContext context) {
    Color cardColor = Theme.of(context).dividerColor;
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: screenSize.height * 0.60,
        width: screenSize.width * 0.70,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: screenSize.height * 0.58,
                width: screenSize.width * 0.52,
                color: cardColor,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: screenSize.height * 0.08,
                          lineWidth: 16.0,
                          percent: widget.city.vegFrac,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((widget.city.vegFrac * 100)
                                      .toStringAsFixed(1) +
                                  "%"),
                              Text(
                                "Vegetation",
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    color: cardColor,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                  ),
                  Container(
                    color: cardColor,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "Happiness Rank:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Emotional and Physical Well-being Rank",
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ),
                              Text(
                                "#" + widget.city.emoPhysRank.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Income and Employment Rank",
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ),
                              Text(
                                "#" + widget.city.incomeEmpRank.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  "Community and Enviorment Rank",
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ),
                              Text(
                                "#" + widget.city.communityEnvRank.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.city.happyScore.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Image.asset(
                                widget.city.happyScore > 60
                                    ? "assets/images/happiness-reaction/smileface.png"
                                    : widget.city.happyScore > 45
                                        ? "assets/images/happiness-reaction/neutralface.png"
                                        : "assets/images/happiness-reaction/sadface.png",
                                height: 50,
                                width: 50,
                              ),
                            ]),
                      ],
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
