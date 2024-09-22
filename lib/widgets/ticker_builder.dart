import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:generate_crossword/providers.dart';

class TickerBuilder extends StatefulWidget {
  const TickerBuilder({super.key,required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder> with SingleTickerProviderStateMixin{

  late final Ticker? _ticker;
  @override
  void initState() {
    _ticker = createTicker(_handleTicker);
    super.initState();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _handleTicker(_){
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}