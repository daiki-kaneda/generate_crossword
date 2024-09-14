import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generate_crossword/model.dart';
import 'package:generate_crossword/providers.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class CrossWordWidget extends ConsumerWidget {
  const CrossWordWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.none,
      cellBuilder: _cellBuilder,
      columnCount: size.height,
      columnBuilder:(index) => _spanBuilder(context, index), 
      rowCount: size.width,
      rowBuilder:(index) => _spanBuilder(context, index), );
  }

  TableViewCell _cellBuilder(BuildContext context,TableVicinity vincinity){
    return TableViewCell(
      child: Consumer(builder:(context, ref, child) {
        final location = Location.at(vincinity.xIndex, vincinity.yIndex);
        final character = ref.watch(crossWordProvider.select(
          (crosswordAsync){
            return crosswordAsync.when(
              data:(crossword) => crossword.characters[location]?.character, 
              error:(error, stackTrace) => null, 
              loading:() => null,);
          }
          ));

        if(character!=null){
          return Container(
            color: Theme.of(context).colorScheme.onPrimary,
            child: Center(
              child: Text(
                character,
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary
              ),),
            ),
          );
        }

        return ColoredBox(color: Theme.of(context).colorScheme.primaryContainer);
      },));
  }

  TableSpan _spanBuilder(BuildContext context,int index){
    return TableSpan(
      extent: const FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
          trailing: BorderSide(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
    );
  }
}