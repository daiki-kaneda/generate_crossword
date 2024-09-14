
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generate_crossword/providers.dart';
import 'package:generate_crossword/widgets/crossword_widget.dart';

class CrosswordGeneratorApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      Scaffold(
      appBar: AppBar(
        title: Text(
          'crossword generator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
        actions: [_CrosswordGeneratorMenu()],
      ),
      body: const SafeArea(child: 
      CrossWordWidget()
      )
    )
    );
  }
}
class _EagerInitialization extends ConsumerWidget{
  const _EagerInitialization(this.child);

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

class _CrosswordGeneratorMenu extends ConsumerWidget {        // Add from here
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
        menuChildren: [
          for (final entry in CrossWordSize.values)
            MenuItemButton(
              onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
              leadingIcon: entry == ref.watch(sizeProvider)
                  ? Icon(Icons.radio_button_checked_outlined)
                  : Icon(Icons.radio_button_unchecked_outlined),
              child: Text(entry.label),
            ),
        ],
        builder: (context, controller, child) => IconButton(
          onPressed: () => controller.open(),
          icon: Icon(Icons.settings),
        ),
      );                                                      // To here.
}