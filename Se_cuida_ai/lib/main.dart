import 'package:flutter/material.dart';

import 'login.dart';

void main() => runApp(
  MaterialApp(
    home: login(),
    theme: ThemeData(
      primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow)

    ),
    debugShowCheckedModeBanner: false,
  )
);