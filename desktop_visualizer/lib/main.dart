import 'package:desktop_visualizer/app/satreelight.dart';
import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/notifiers/theme_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<City> cities;

final themeModeProvider = ChangeNotifierProvider((ref) => ThemeModeNotifier());
final schemeProvider = ChangeNotifierProvider((ref) => SchemeNotifier());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cities = await loadCities();

  runApp(
    ProviderScope(
      child: SaTreeLight(cities: cities),
    ),
  );
}
