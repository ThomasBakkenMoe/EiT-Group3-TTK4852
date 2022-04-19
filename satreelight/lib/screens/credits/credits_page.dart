import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('EiT Group 3', style: Theme.of(context).textTheme.headline1),
            const Divider(indent: 300, endIndent: 300),
            Text('Team members:', style: Theme.of(context).textTheme.headline3),
            Text('Gaute Hagen', style: Theme.of(context).textTheme.bodyText1),
            Text('Victor Pierre Hamran',
                style: Theme.of(context).textTheme.bodyText1),
            Text('Trym Jørgensen',
                style: Theme.of(context).textTheme.bodyText1),
            Text('Thomas Bakken Moe',
                style: Theme.of(context).textTheme.bodyText1),
            Text('Sofie Trovik', style: Theme.of(context).textTheme.bodyText1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Software licenses'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LicensePage(
                      applicationName: 'SaTreeLight',
                      applicationIcon: Image(
                        image:
                            AssetImage('assets/graphics/satreelight_logo.png'),
                      ),
                      applicationVersion: '1.0',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
