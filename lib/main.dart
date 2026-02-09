import 'package:flutter/material.dart';
import 'package:track_mind/constants/cons.dart';
import 'package:track_mind/db/notes_db.dart';
import 'package:track_mind/screens/splash_screen/screen_splash.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackMind',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccentColor,
          brightness: Brightness.dark,
          surface: kBackgroundColor,
          onSurface: kTextColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: kTextColor, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: kTextColor),
          bodyMedium: TextStyle(color: kTextColor),
          titleMedium: TextStyle(color: kTextMutedColor),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
          iconTheme: IconThemeData(color: kTextColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // More Uber-like square corners
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      home: const ScreenSplash(),
    );
  }
}
