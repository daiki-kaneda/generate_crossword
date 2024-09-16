import 'dart:developer';
import 'dart:math' hide log;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:generate_crossword/model.dart';
import 'package:generate_crossword/providers.dart';
import 'package:generate_crossword/utils.dart';

final _random = Random();

// 重い処理をcomputeを使って、バックグラウンドで行っている
Stream<Crossword> exploreCrosswordSolutions(
    Crossword crossword, BuiltSet<String> words) async* {
  final start = DateTime.now();
  while (crossword.characters.length < crossword.width * crossword.height * 0.8) {
    debugPrint('words count: ${crossword.words.length}');
    final word = words.randomElement();
    final direction = _random.nextBool() ? Direction.across : Direction.down;
    final location =
        Location.at(_random.nextInt(crossword.width), _random.nextInt(crossword.height));
    try {
      final candidate =
          await compute(((String, Direction, Location) wordToAdd) {
        final (word, direction, location) = wordToAdd;
        return crossword.addWord(
            word: word, direction: direction, location: location);
      }, (word, direction, location));

      if(candidate!=null){
        debugPrint('Added word: $word');
        crossword = candidate;
        yield crossword;
      }else{
        debugPrint('Failed to add word: $word');
      }
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }
  debugPrint('${crossword.width} x ${crossword.height} Crossword generated in '
      '${DateTime.now().difference(start).formatted}');
}
