import 'package:flutter/material.dart';

class DividerWithoutMargin extends StatelessWidget {
  const DividerWithoutMargin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
    );
  }
}
