import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'login.dart';

void main() => runApp(
  MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
    home: login(),
    theme: ThemeData(
      primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow)

    ),
    debugShowCheckedModeBanner: false,
  )
);