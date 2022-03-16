import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class StatCard extends StatefulWidget {
  StatCard({
    Key? key,
  }) : super(key: key);
  @override
  _StatCard createState() => _StatCard();
}

class _StatCard extends State<StatCard> {
  //static var dataCsv = File('../../US-cities-vegetation.csv').openRead();
  //static var dataList = dataCsv.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  static const data = [
    {'category': 'Shirts', 'sales': 5},
    {'category': 'Cardigans', 'sales': 20},
    {'category': 'Chiffons', 'sales': 36},
    {'category': 'Pants', 'sales': 10},
    {'category': 'Heels', 'sales': 10},
    {'category': 'Socks', 'sales': 20},
  ];
  static const double height = 500;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      child: Card(
        child: Chart(
          data: data,
          variables: {
            'category': Variable(
              accessor: (Map map) => map['category'] as String,
            ),
            'sales': Variable(
              accessor: (Map map) => map['sales'] as num,
            ),
          },
          elements: [
            IntervalElement(
              color: ColorAttr(
                variable: 'category',
                values: Defaults.colors10,
              ),
              label: LabelAttr(
                encoder: (tuple) => Label(
                  tuple['category'].toString(),
                ),
              ),
            )
          ],
          coord: PolarCoord(),
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
        ),
      ),
    );
  }
}
