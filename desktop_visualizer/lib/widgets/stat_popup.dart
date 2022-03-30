import 'package:desktop_visualizer/models/city.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatPopup extends StatefulWidget {
  const StatPopup({required this.vegFrac, Key? key}) : super(key: key);

  final double vegFrac;

  @override
  State<StatefulWidget> createState() => _StatPopup();
}

class _StatPopup extends State<StatPopup> {
  @override
  Widget build(BuildContext context) {
    Color cardColor = Color.fromARGB(31, 199, 184, 152);
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: screenSize.height * 0.6,
        width: screenSize.width * 0.7,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("Vegetation Percent:"),
                        ),
                        CircularPercentIndicator(
                          radius: screenSize.height * 0.055,
                          lineWidth: 15.0,
                          percent: widget.vegFrac,
                          center: Text(
                              (widget.vegFrac * 100).toStringAsFixed(1) + "%"),
                          progressColor: Colors.blueGrey,
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
                  ),
                  Container(
                    color: cardColor,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("72"),
                          ),
                        ]),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Total Happiness Score", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        )
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
