import 'package:desktop_visualizer/models/city.dart';
import 'package:desktop_visualizer/screens/leaflet_map/leaflet_map.dart';
import 'package:desktop_visualizer/screens/splash/spalsh_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

late List<City> cities;

final themeModeProvider = ChangeNotifierProvider((ref) => ThemeModeNotifier());
final schemeProvider = ChangeNotifierProvider((ref) => SchemeNotifier());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cities = await loadCities();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class ThemeModeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class SchemeNotifier extends ChangeNotifier {
  FlexScheme _scheme = FlexScheme.green;
  FlexScheme get scheme => _scheme;

  void setThemeMode(FlexScheme scheme) {
    _scheme = scheme;
    notifyListeners();
  }

  void setThemeModeIndex(int index) {
    _scheme = FlexScheme.values[index];
    notifyListeners();
  }
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  final fontFamily = GoogleFonts.notoSansMono().fontFamily;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Helpful website for theming
    // https://rydmike.com/flexcolorschemeV4Tut5/#/

    final FlexScheme scheme = ref.watch(schemeProvider).scheme;
    final ThemeMode themeMode = ref.watch(themeModeProvider).themeMode;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        scheme: scheme,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.primary,
        appBarOpacity: 0.95,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        lightIsWhite: false,
        useSubThemes: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: fontFamily,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          fabUseShape: true,
          interactionEffects: true,
          bottomNavigationBarElevation: 0,
          bottomNavigationBarOpacity: 0.95,
          navigationBarOpacity: 0.95,
          navigationBarMutedUnselectedText: true,
          navigationBarMutedUnselectedIcon: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: true,
          blendOnColors: true,
          blendTextTheme: true,
          popupMenuOpacity: 0.95,
        ),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: scheme,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.95,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        darkIsTrueBlack: false,
        useSubThemes: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: fontFamily,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          fabUseShape: true,
          interactionEffects: true,
          bottomNavigationBarElevation: 0,
          bottomNavigationBarOpacity: 0.95,
          navigationBarOpacity: 0.95,
          navigationBarMutedUnselectedText: true,
          navigationBarMutedUnselectedIcon: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: true,
          blendOnColors: true,
          blendTextTheme: true,
          popupMenuOpacity: 0.95,
        ),
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      themeMode: themeMode,

      home: SplashPage(cities: cities),
    );
  }
}
