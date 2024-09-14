import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generate_crossword/crossword_generator_app.dart';
import 'package:generate_crossword/providers.dart';

void main() {
    runApp(
    ProviderScope (
      child: MaterialApp(
        title: 'Crossword Builder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        home: CrosswordGeneratorApp()
      ),
    ),
  );
}


