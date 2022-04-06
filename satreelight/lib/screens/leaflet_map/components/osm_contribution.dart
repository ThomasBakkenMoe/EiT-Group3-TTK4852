import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OSMContribution extends StatelessWidget {
  const OSMContribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: '© ', style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                  text: 'OpenStreetMap',
                  style: Theme.of(context).textTheme.bodySmall
                    ?..copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white,
                      decorationThickness: 10,
                    ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://www.openstreetmap.org/copyright';
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    }),
              TextSpan(
                text: ' contributors',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
