import 'package:flutter/material.dart';

class ModalBottomSheetHeader extends StatelessWidget {
  final String title;

  const ModalBottomSheetHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  height: 8,
                  width: constraints.maxWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ModalBottomSheet<T> extends StatelessWidget {
  final List<ModalBottomSheetAction> actions;
  final String title;
  final int initialSelect;

  const ModalBottomSheet({
    super.key,
    required this.actions,
    required this.title,
    required this.initialSelect,
  });

  static void show<T>(
    BuildContext ctx, {
    Key? key,
    required List<ModalBottomSheetAction> actions,
    required String title,
    required int initialSelect,
  }) {
    showModalBottomSheet(
      context: ctx,
      useRootNavigator: true,
      builder: (context) {
        return ModalBottomSheet(
          actions: actions,
          title: title,
          initialSelect: initialSelect,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModalBottomSheetHeader(
          title: title,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: index == initialSelect
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
              child: actions[index],
            );
          },
        )
      ],
    );
  }
}

class ModalBottomSheetAction extends StatelessWidget {
  final String title;
  final Function(BuildContext ctx) onChanged;

  const ModalBottomSheetAction({
    super.key,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(title, textAlign: TextAlign.center,),
      ),
    );
  }
}
