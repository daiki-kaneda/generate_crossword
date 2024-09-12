import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:built_collection/built_collection.dart';

part 'providers.g.dart';

@riverpod
Future<BuiltSet<String>> wordList(WordListRef ref) async{
  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');

  return const LineSplitter().convert(words).toBuiltSet().rebuild(
    (b) => b..map(
      (word) => word.toLowerCase().trim())
      ..where((word) => word.length>2)
      ..where((word) => re.hasMatch(word))
    );
}