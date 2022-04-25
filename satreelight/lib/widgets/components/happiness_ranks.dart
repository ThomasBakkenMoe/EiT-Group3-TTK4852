import 'package:flutter/material.dart';
import 'package:satreelight/models/city.dart';

class HappinessRanks extends StatelessWidget {
  final City city;
  final int numberOfCities;
  const HappinessRanks({Key? key, required this.city, this.numberOfCities = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: [
            Flexible(
              child: Text(
                "Happiness Rank: ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "#" + city.happinessRank.toString(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (numberOfCities > 0)
              Text(
                ' of ' + numberOfCities.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
          ],
        ),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: ImageIcon(
                AssetImage(
                    'assets/graphics/Emotional and Physical Well-Being.png'),
                size: 35,
              ),
            ),
            Flexible(
              child: Text(
                "Emotional and Physical \nWell-being Rank ",
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Text(
              "#" + city.emoPhysRank.toString(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: ImageIcon(
                AssetImage('assets/graphics/Income and Employer.png'),
                size: 35,
              ),
            ),
            Flexible(
              child: Text(
                "Income and Employment Rank ",
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Text(
              "#" + city.incomeEmpRank.toString(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 6.0),
              child: ImageIcon(
                AssetImage('assets/graphics/Community and Environment.png'),
                size: 35,
              ),
            ),
            Flexible(
              child: Text(
                "Community and Enviorment Rank ",
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "#" + city.communityEnvRank.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
