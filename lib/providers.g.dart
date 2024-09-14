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
String _$crossWordHash() => r'63a668338c30f015c8d53360afc723a68b4ba4ac';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
