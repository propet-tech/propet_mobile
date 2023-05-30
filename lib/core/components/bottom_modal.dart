import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  final List<ModalBottomSheetAction<T>> actions;
  final String title;
  final int initialSelect;
  final Function(T? value) onChanged;
  final Alignment? alignment;

  const ModalBottomSheet({
    super.key,
    required this.actions,
    required this.title,
    required this.onChanged,
    required this.initialSelect,
    this.alignment,
  });

  void onTap(BuildContext ctx, int index) {
    onChanged(actions[index].value);
  }

  static void show<T>(
    BuildContext ctx, {
    Key? key,
    required List<ModalBottomSheetAction<T>> actions,
    required String title,
    required Function(T? value) onChanged,
    required int initialSelect,
  }) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return ModalBottomSheet(
          actions: actions,
          title: title,
          onChanged: (value) {
            onChanged(value);
            ctx.pop();
          },
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
            return GestureDetector(
              onTap: () => onTap(context, index),
              child: Align(
                alignment: alignment ?? Alignment.center,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: index == initialSelect
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                  child: actions[index],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class ModalBottomSheetAction<T> extends StatelessWidget {
  final T? value;
  final String title;

  const ModalBottomSheetAction({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(title),
    );
  }
}
