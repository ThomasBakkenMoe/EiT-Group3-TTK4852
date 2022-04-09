import 'package:satreelight/app/satreelight.dart';
import 'package:satreelight/models/city.dart';
import 'package:satreelight/notifiers/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<City> cities;

final themeModeProvider = ChangeNotifierProvider((ref) => ThemeModeNotifier());
final schemeProvider = ChangeNotifierProvider((ref) => SchemeNotifier());
final mapInBackgroundProvider =
    ChangeNotifierProvider((ref) => MapBackgroundNotifier());
final mapZoomInProvider = ChangeNotifierProvider((ref) => MapZoomInNotifier());
final mapZoomOutProvider =
    ChangeNotifierProvider((ref) => MapZoomOutNotifier());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cities = await loadCities();

  runApp(
    ProviderScope(
      child: SaTreeLight(cities: cities),
    ),
  );
}
