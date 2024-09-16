import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_crossword/isolates.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:math' hide log;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';

import 'model.dart' as model;
import 'utils.dart';

part 'providers.g.dart';

@riverpod
Future<BuiltSet<String>> wordList(WordListRef ref) async {
  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');

  return const LineSplitter().convert(words).toBuiltSet().rebuild((b) => b
    ..map((word) => word.toLowerCase().trim())
    ..where((word) => word.length > 2)
    ..where((word) => re.hasMatch(word)));
}

// クロスワードのサイズを表すEnum型
enum CrossWordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrossWordSize({required this.width, required this.height});
  final int width;
  final int height;

  String get label => '$width x $height';
}

// 生成するクロスワードのサイズを保持するprovider

@Riverpod(keepAlive: true)
class Size extends _$Size {
  @override
  CrossWordSize build() {
    return CrossWordSize.small;
  }

  void setSize(CrossWordSize size) {
    state = size;
  }
}

final _random = Random();

@riverpod
Stream<model.Crossword> crossWord(CrossWordRef ref) async* {
  final size = ref.watch(sizeProvider);
  final wordList = await ref.watch(wordListProvider.future);

  final emptyCrossword = model.Crossword.crossword(width: size.width, height: size.height);
  yield* exploreCrosswordSolutions(emptyCrossword, wordList);
}
