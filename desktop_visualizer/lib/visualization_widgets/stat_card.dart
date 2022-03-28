import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class StatCard extends StatefulWidget {
  const StatCard({
    Key? key,
    this.city = "Akron, OH",
  }) : super(key: key);

  final String city;

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
  static const double HeiWid = 200;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: HeiWid,
      width: HeiWid,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Text('Hello'),
          ),
          Expanded(
            flex: 10,
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
        ],
      ),
    );
  }
}
