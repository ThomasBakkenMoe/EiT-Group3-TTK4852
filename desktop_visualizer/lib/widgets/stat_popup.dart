import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatPopup extends StatefulWidget {
  const StatPopup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatPopup();
}

class _StatPopup extends State<StatPopup> {
  @override
  Widget build(BuildContext context) {
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
                color: Colors.blueGrey,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    color: Colors.blueGrey,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                  ),
                  Container(
                    color: Colors.blueGrey,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                  ),
                  Container(
                    color: Colors.blueGrey,
                    height: screenSize.height * 0.185,
                    width: screenSize.width * 0.15,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
