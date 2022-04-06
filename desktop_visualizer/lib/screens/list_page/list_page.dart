import 'dart:ui';

import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/widgets/stat_popup.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final List<City> cities;
  const ListPage({Key? key, required this.cities}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<City> cities = [];
  List<String> sortings = ['Vegetation', 'Happiness', 'Alphabetically'];
  String sortedBy = 'Alphabetically';

  void sortByVeg() {
    setState(() {
      sortedBy = 'Vegetation';
      cities.sort(
        (a, b) => b.vegFrac.compareTo(a.vegFrac),
      );
    });
  }

  void sortAlphabetically() {
    setState(() {
      sortedBy = 'Alphabetically';
      cities.sort(
        (a, b) => a.name.compareTo(b.name),
      );
    });
  }

  void sortByHappiness() {
    setState(() {
      sortedBy = 'Happiness';
      cities.sort(
        (a, b) => b.happyScore.compareTo(a.happyScore),
      );
    });
  }

  void sort(int index) {
    index == 0
        ? sortByVeg()
        : index == 1
            ? sortByHappiness()
            : sortAlphabetically();
  }

  void reverse() {
    setState(() {
      cities = cities.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    cities = widget.cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'City List',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                'Sort by',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              fillColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : null,
              selectedColor: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).primaryColor
                  : null,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : null,
              borderColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : null,
              selectedBorderColor:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : null,
              onPressed: (index) => sort(index),
              children: const [
                Icon(Icons.grass),
                Icon(Icons.sentiment_satisfied),
                Icon(Icons.sort_by_alpha),
              ],
              isSelected: List.generate(
                  sortings.length, (index) => sortedBy == sortings[index]),
            ),
          ),
          IconButton(
            onPressed: reverse,
            icon: const Icon(Icons.import_export),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(8),
          )
        ],
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final sortByText = sortedBy == 'Vegetation'
              ? '\nVegetation: ' +
                  (100 * city.vegFrac).toStringAsPrecision(3) +
                  '%'
              : sortedBy == 'Happiness'
                  ? '\nHappiness score: ' + city.happyScore.toString()
                  : '';
          final buttonText = city.nameAndState + sortByText;
          return ElevatedButton(
            key: UniqueKey(),
            onPressed: () async {
              await city.loadData();
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
                                Navigator.of(context).pop();
                              }),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        children: [StatPopup(city: city)],
                      ),
                    );
                  });
            },
            child: Text(buttonText),
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    );
  }
}