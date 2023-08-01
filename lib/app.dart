import 'main_app.dart';
import 'presentation/utils/color_helpers.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnythingGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          secondary: primaryColor6,
          primary: primaryColor2,
          brightness: Brightness.light,
        ),
        textSelectionTheme: const TextSelectionThemeData().copyWith(
          cursorColor: primaryColor2,
        ),
      ),
      home: const MainApp(),
    );
  }
}
