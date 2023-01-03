import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safewayappproject/product/constans/project_colors.dart';
import 'package:safewayappproject/view/home/track/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeWayApp001-B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: ApplicationColors.dataColors,
        colorScheme: const ColorScheme(
          outline: ApplicationColors.goldCrest,
          brightness: Brightness.light,
          primary: ApplicationColors.dataColors,
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.redAccent,
          background: Colors.white,
          onBackground: Colors.white,
          surface: ApplicationColors.aboutTextColor,
          onSurface: ApplicationColors.dataColors,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(6.0),
              side: const BorderSide(
                  color: ApplicationColors.dataColors, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              )),
        ),
        dialogTheme: DialogTheme(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            titleTextStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      home: Track(),
    );
  }
}
