import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ElevatedLoadButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final Future<void> Function() onPressed;
  final ButtonStyle? style;

  const ElevatedLoadButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed,
      this.style});

  @override
  State<ElevatedLoadButton> createState() => _ElevatedLoadButtonState();
}

class _ElevatedLoadButtonState extends State<ElevatedLoadButton> {
  bool loading = false;
  final _statesController = MaterialStatesController();

  Future<void> onPressed() async {
    setState(() {
      loading = true;
      _statesController.update(MaterialState.disabled, true);
    });

    await widget.onPressed();

    setState(() {
      loading = false;
      _statesController.update(MaterialState.disabled, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.textScaleFactorOf(context);
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, min(scale - 1, 1))!;
    final List<Widget> rowChildren;

    if (!loading) {
      rowChildren = [widget.icon, SizedBox(width: gap), Text(widget.label)];
    } else {
      rowChildren = [
        SizedBox(
          height: IconTheme.of(context).size,
          width: IconTheme.of(context).size,
          child: const CircularProgressIndicator(),
        ),
      ];
    }

    return ElevatedButton(
      style: widget.style,
      onPressed: onPressed,
      statesController: _statesController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: rowChildren,
      ),
    );
  }
}
