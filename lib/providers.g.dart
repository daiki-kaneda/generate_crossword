// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListHash() => r'8e3e9cd4555ba4baa045ccddd8dd45a25cfb6653';

/// See also [wordList].
@ProviderFor(wordList)
final wordListProvider = AutoDisposeFutureProvider<BuiltSet<String>>.internal(
  wordList,
  name: r'wordListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$wordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$crossWordHash() => r'dd9172a32a36aec20e41b014c48182a00a6400d0';

/// See also [crossWord].
@ProviderFor(crossWord)
final crossWordProvider = AutoDisposeStreamProvider<model.Crossword>.internal(
  crossWord,
  name: r'crossWordProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$crossWordHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CrossWordRef = AutoDisposeStreamProviderRef<model.Crossword>;
String _$workQueueHash() => r'090646049fcaf5044e28f57f755ae81f2ab7dca8';

/// See also [workQueue].
@ProviderFor(workQueue)
final workQueueProvider = AutoDisposeStreamProvider<model.WorkQueue>.internal(
  workQueue,
  name: r'workQueueProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$workQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkQueueRef = AutoDisposeStreamProviderRef<model.WorkQueue>;
String _$expectedRemainingTimeHash() =>
    r'1d054d63860240169de82ae4cdca3fc408d1d6f9';

/// See also [expectedRemainingTime].
@ProviderFor(expectedRemainingTime)
final expectedRemainingTimeProvider = AutoDisposeProvider<Duration>.internal(
  expectedRemainingTime,
  name: r'expectedRemainingTimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expectedRemainingTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpectedRemainingTimeRef = AutoDisposeProviderRef<Duration>;
String _$sizeHash() => r'19e5ef7c20a2b64a277a60a0912756c04eda8b2d';

/// See also [Size].
@ProviderFor(Size)
final sizeProvider = NotifierProvider<Size, CrossWordSize>.internal(
  Size.new,
  name: r'sizeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Size = Notifier<CrossWordSize>;
String _$startTimeHash() => r'5b637a624a48eed021215571ff83a4a2405691c3';

/// See also [StartTime].
@ProviderFor(StartTime)
final startTimeProvider = NotifierProvider<StartTime, DateTime?>.internal(
  StartTime.new,
  name: r'startTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$startTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StartTime = Notifier<DateTime?>;
String _$endTimeHash() => r'7acd30f633755ae938883bcb0ba25a40387194df';

/// See also [EndTime].
@ProviderFor(EndTime)
final endTimeProvider = NotifierProvider<EndTime, DateTime?>.internal(
  EndTime.new,
  name: r'endTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$endTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EndTime = Notifier<DateTime?>;
String _$showDisplayInfoHash() => r'7c44d576d2ae4324e600e23a18c1427a2caa7647';

/// A provider that holds whether to display info.
///
/// Copied from [ShowDisplayInfo].
@ProviderFor(ShowDisplayInfo)
final showDisplayInfoProvider =
    NotifierProvider<ShowDisplayInfo, bool>.internal(
  ShowDisplayInfo.new,
  name: r'showDisplayInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showDisplayInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowDisplayInfo = Notifier<bool>;
String _$displayInfoHash() => r'6516f6bf346baa6914fdfffad1ccee8a5345a137';

/// A provider that summarise the DisplayInfo from a [model.WorkQueue].
///
/// Copied from [DisplayInfo].
@ProviderFor(DisplayInfo)
final displayInfoProvider =
    AutoDisposeNotifierProvider<DisplayInfo, model.DisplayInfo>.internal(
  DisplayInfo.new,
  name: r'displayInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$displayInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DisplayInfo = AutoDisposeNotifier<model.DisplayInfo>;
String _$workerCountHash() => r'8f22ce20c3a28278d9cbb0719500a69751e7a2e3';

/// A provider that holds the current number of background workers to use.
///
/// Copied from [WorkerCount].
@ProviderFor(WorkerCount)
final workerCountProvider =
    NotifierProvider<WorkerCount, BackgroundWorkers>.internal(
  WorkerCount.new,
  name: r'workerCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$workerCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkerCount = Notifier<BackgroundWorkers>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
