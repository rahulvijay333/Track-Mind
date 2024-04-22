import 'package:flutter/material.dart';
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
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)))),
      home: const ScreenSplash(),
    );
  }
}
