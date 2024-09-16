import 'dart:developer';
import 'dart:math' hide log;

import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:generate_crossword/model.dart';
import 'package:generate_crossword/providers.dart';
import 'package:generate_crossword/utils.dart';

final _random = Random();

/*
途中経過を表すUIを作るために、Streamの型をCrosswordからWorkQueueに変更する
*/
// TODO: change: Stream<CrossWord>->Stream<WorkQueue>
Stream<Crossword> exploreCrosswordSolutions4(
    Crossword crossword, BuiltSet<String> words) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: words,
    startLocation: Location.at(0, 0),
  );
  while (!workQueue.isCompleted) {
    final location = workQueue.locationsToTry.keys.toBuiltSet().randomElement();
    try {
      final crossword = await compute(((WorkQueue, Location) workMessage) {
        final (workQueue, location) = workMessage;
        final direction = workQueue.locationsToTry[location]!;
        final target = workQueue.crossword.characters[location];
        if (target == null) {
          return workQueue.crossword.addWord(
            direction: direction,
            location: location,
            word: workQueue.candidateWords.randomElement(),
          );
        }
        var words = workQueue.candidateWords.toBuiltList().rebuild((b) => b
          ..where((b) => b.characters.contains(target.character))
          ..shuffle());
        int tryCount = 0;
        for (final word in words) {
          tryCount++;
          for (final (index, character) in word.characters.indexed) {
            if (character != target.character) continue;

            final candidate = workQueue.crossword.addWord(
              location: switch (direction) {
                Direction.across => location.leftOffset(index),
                Direction.down => location.upOffset(index),
              },
              word: word,
              direction: direction,
            );
            if (candidate != null) {
              return candidate;
            }
          }
          if (tryCount > 1000) {
            break;
          }
        }
      }, (workQueue, location));
      if (crossword != null) {
        workQueue = workQueue.updateFrom(crossword);
        yield crossword;
      } else {
        workQueue = workQueue.remove(location);
      }
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }
  debugPrint('${crossword.width} x ${crossword.height} Crossword generated in '
      '${DateTime.now().difference(start).formatted}');
}

/*
クロスワードの８０%以上のセルをランダムな単語で埋める。ただし、一般的な次のようなクロスワードの制約を適用する
制約：すべての単語は文字を少なくともひとつ共有しなくてはならない。ただし、各文字について、それを含む単語は水平方向、垂直方向の単語のたかだか二つでなければならない
また、追加する単語の内容、位置、向きを完全にランダムに探索するのではなく、位置と向きの候補のリストを作って、そこから抽出されたものでトライし、なければ、探索しない場所として記録する

メモ：CrossWordをWorkQueueというデータモデルに拡張することで効率化を実現している。WorkQueueはCrosswordの値の他に
探索をトライする場所と向きのMapであるlocationsToTry,探索しない場所のSetであるbadLocation,探索する単語のリストcandidateWordsを持つ

WorkQueueの更新についてのメモ
- crossWordが更新されるたびにupdateFromメソッドによって、locationsToTryなどを更新する
- updateFromは、受け取ったcrossWordがEmptyの時はlocationToTryに原点のみを格納。また、candidateWordsを全体のワードのうち、クロスワードのサイズに入るもののみ格納する
  crossWordがEmptyでない時は、そのcrossWordのcharactersの文字の位置のうち、新しい単語の一部となりうるものをlocationsToTryに格納する。また、すでにcrosswordにある単語をcandidateWordから除外する

一言でまとめれば、すでにあるクロスワード内の文字のうち、新しい単語の一部となりそうなものを抽出して、その文字を含む
単語をランダムに選んで追加することをトライすることで効率化している。これに必要なプロパティなどはCrosswordを拡張したWorkQueueを定義して実装している
*/
Stream<Crossword> exploreCrosswordSolutions3(
    Crossword crossword, BuiltSet<String> words) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: words,
    startLocation: Location.at(0, 0),
  );
  while (!workQueue.isCompleted) {
    final location = workQueue.locationsToTry.keys.toBuiltSet().randomElement();
    try {
      final crossword = await compute(((WorkQueue, Location) workMessage) {
        final (workQueue, location) = workMessage;
        final direction = workQueue.locationsToTry[location]!;
        final target = workQueue.crossword.characters[location];
        if (target == null) {
          return workQueue.crossword.addWord(
            direction: direction,
            location: location,
            word: workQueue.candidateWords.randomElement(),
          );
        }
        var words = workQueue.candidateWords.toBuiltList().rebuild((b) => b
          ..where((b) => b.characters.contains(target.character))
          ..shuffle());
        int tryCount = 0;
        for (final word in words) {
          tryCount++;
          for (final (index, character) in word.characters.indexed) {
            if (character != target.character) continue;

            final candidate = workQueue.crossword.addWord(
              location: switch (direction) {
                Direction.across => location.leftOffset(index),
                Direction.down => location.upOffset(index),
              },
              word: word,
              direction: direction,
            );
            if (candidate != null) {
              return candidate;
            }
          }
          if (tryCount > 1000) {
            break;
          }
        }
      }, (workQueue, location));
      if (crossword != null) {
        workQueue = workQueue.updateFrom(crossword);
        yield crossword;
      } else {
        workQueue = workQueue.remove(location);
      }
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }
  debugPrint('${crossword.width} x ${crossword.height} Crossword generated in '
      '${DateTime.now().difference(start).formatted}');
}

/*
クロスワードの８０%以上のセルをランダムな単語で埋める。ただし、一般的な次のようなクロスワードの制約を適用する
制約：すべての単語は文字を少なくともひとつ共有しなくてはならない。ただし、各文字について、それを含む単語は水平方向、垂直方向の単語のたかだか二つでなければならない

メモ：クロスワードの制約をつけているが、ランダムに加えた単語が運よく制約を満たす場合にのみ出力しているので、効率は甚だ良くない
*/
Stream<Crossword> exploreCrosswordSolutions2(
    Crossword crossword, BuiltSet<String> words) async* {
  final start = DateTime.now();
  var result = crossword;
  while(result.characters.length < crossword.width*crossword.height*0.8){
    final word = words.randomElement();
    final direction = _random.nextBool() ? Direction.across:Direction.down;
    final location = Location.at(_random.nextInt(crossword.width), _random.nextInt(crossword.height));
    try{
    final candidate = await compute(((String,Direction,Location) wordToAdd){
      final (word,direction,location) = wordToAdd;
      return result.addWord(location: location, word: word, direction: direction);
    }, (word,direction,location));

    if(candidate!=null){
      result = candidate;
      yield result;
      debugPrint('Added word:$word');
    }else{
      debugPrint('Failed to add word:$word');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    }catch(e){
      debugPrint('Error occur running isolate :$e');
    }
  }
  debugPrint('${crossword.width} x ${crossword.height} Crossword generated in '
      '${DateTime.now().difference(start).formatted}');
}

/*
クロスワードの８０%以上のセルをランダムな文字で埋める。ただし、重複をしても上書きをする。
メモ：クロスワードの制約をつけていないが、非常にシンプルな実装で済んでいる
*/
Stream<Crossword> exploreCrosswordSolutions1(
    Crossword crossword, BuiltSet<String> words) async* {
  final start = DateTime.now();
  while(crossword.characters.length < crossword.width*crossword.height*0.8){
    final randomLocation = Location.at(_random.nextInt(crossword.width), _random.nextInt(crossword.height));
    final randomCharacter = ['a','b','c'][_random.nextInt(3)];

    crossword = crossword.rebuild(
      (b) => b.words..add(
        CrosswordWord.word(word: randomCharacter, location: randomLocation, direction: Direction.across)
      ));
    yield crossword;
    await Future.delayed(const Duration(milliseconds: 100));
  }
  debugPrint('${crossword.width} x ${crossword.height} Crossword generated in '
      '${DateTime.now().difference(start).formatted}');
}
