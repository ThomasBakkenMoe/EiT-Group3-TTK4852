import 'dart:ui';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/widgets/stat_popup.dart';

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
            Text('Click on the location pin',
                style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 100),
            IconButton(
              iconSize: 60,
              alignment: Alignment.center,
              onPressed: () async {
                await city.loadData();
                showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: SimpleDialog(
                        backgroundColor:
                            Theme.of(context).dialogBackgroundColor,
                        title: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: city.name + '\n',
                                style: Theme.of(context).textTheme.headline4,
                                children: [
                                  TextSpan(
                                    text: city.stateLong,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
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
                  },
                );
              },
              icon: DecoratedIcon(
                Icons.pin_drop,
                color: Theme.of(context).primaryColor,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius:
                        Theme.of(context).brightness == Brightness.dark ? 2 : 1,
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
