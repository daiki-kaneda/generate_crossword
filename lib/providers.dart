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
  //await rootBundle.loadString('assets/basic_eng_words_3000.txt');
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
  yield* exploreCrosswordSolutions3(emptyCrossword, wordList);
}

@riverpod
Stream<model.WorkQueue> workQueue(WorkQueueRef ref) async*{
  final size = ref.watch(sizeProvider);
  final wordList = await ref.watch(wordListProvider.future);
  final emptyCrossword = model.Crossword.crossword(width: size.width, height: size.height);
  final workerCount = ref.watch(workerCountProvider);

  ref.read(startTimeProvider.notifier).start();
  ref.read(endTimeProvider.notifier).clear();
  yield* exploreCrosswordSolutions5(crossword: emptyCrossword,wordList: wordList,maxWorkerCount: workerCount.count);
  ref.read(endTimeProvider.notifier).end();
}

@Riverpod(keepAlive: true)                                 // Add from here to end of file
class StartTime extends _$StartTime {
  @override
  DateTime? build() => _start;

  DateTime? _start;

  void start() {
    _start = DateTime.now();
    ref.invalidateSelf();
  }
}

@Riverpod(keepAlive: true)
class EndTime extends _$EndTime {
  @override
  DateTime? build() => _end;

  DateTime? _end;

  void clear() {
    _end = null;
    ref.invalidateSelf();
  }

  void end() {
    _end = DateTime.now();
    ref.invalidateSelf();
  }
}

const _estimatedTotalCoverage = 0.54;

@riverpod
Duration expectedRemainingTime(ExpectedRemainingTimeRef ref) {
  final startTime = ref.watch(startTimeProvider);
  final endTime = ref.watch(endTimeProvider);
  final workQueueAsync = ref.watch(workQueueProvider);

  return workQueueAsync.when(
    data: (workQueue) {
      if (startTime == null || endTime != null || workQueue.isCompleted) {
        return Duration.zero;
      }
      try {
        final soFar = DateTime.now().difference(startTime);
        final completedPercentage = min(
            0.99,
            (workQueue.crossword.characters.length /
                (workQueue.crossword.width * workQueue.crossword.height) /
                _estimatedTotalCoverage));
        final expectedTotal = soFar.inSeconds / completedPercentage;
        final expectedRemaining = expectedTotal - soFar.inSeconds;
        return Duration(seconds: expectedRemaining.toInt());
      } catch (e) {
        return Duration.zero;
      }
    },
    error: (error, stackTrace) => Duration.zero,
    loading: () => Duration.zero,
  );
}

/// A provider that holds whether to display info.
@Riverpod(keepAlive: true)
class ShowDisplayInfo extends _$ShowDisplayInfo {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }
}

/// A provider that summarise the DisplayInfo from a [model.WorkQueue].
@riverpod
class DisplayInfo extends _$DisplayInfo {
  @override
  model.DisplayInfo build() => ref.watch(workQueueProvider).when(
        data: (workQueue) => model.DisplayInfo.from(workQueue: workQueue),
        error: (error, stackTrace) => model.DisplayInfo.empty,
        loading: () => model.DisplayInfo.empty,
      );
}

enum BackgroundWorkers {                                
  one(1),
  two(2),
  four(4),
  eight(8),
  sixteen(16),
  thirtyTwo(32),
  sixtyFour(64),
  oneTwentyEight(128);

  const BackgroundWorkers(this.count);

  final int count;
  String get label => count.toString();
}

/// A provider that holds the current number of background workers to use.
@Riverpod(keepAlive: true)
class WorkerCount extends _$WorkerCount {
  var _count = BackgroundWorkers.four;

  @override
  BackgroundWorkers build() => _count;

  void setCount(BackgroundWorkers count) {
    _count = count;
    ref.invalidateSelf();
  }
}   
