import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MultiSelectBottomModalOptions {
  final String title;
  final int itemCount;
  final int initialSelect;
  final Widget Function(BuildContext context, int index, bool isSelected)
      itemBuilder;

  const MultiSelectBottomModalOptions({
    required this.title,
    required this.initialSelect,
    required this.itemCount,
    required this.itemBuilder,
  });
}

Future<int?> showMultiSelectBottomModal(
    BuildContext context, MultiSelectBottomModalOptions options) async {
  return showModalBottomSheet<int?>(
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return MultiSelectBottomModal(
        title: options.title,
        initialSelect: options.initialSelect,
        itemCount: options.itemCount,
        itemBuilder: options.itemBuilder,
      );
    },
  );
}

class BottomModalHeader extends StatelessWidget {
  final Widget child;
  final String title;

  const BottomModalHeader({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxHeight: screen.width * 0.5,
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                height: 8,
                width: screen.width * 0.3,
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
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class MultiSelectBottomModal extends StatelessWidget {
  final String title;

  final int itemCount;
  final int initialSelect;
  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
  ) itemBuilder;

  const MultiSelectBottomModal({
    required this.title,
    super.key,
    required this.initialSelect,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BottomModalHeader(
      title: title,
      child: MultiSelectBottomModalList(
        initialSelect: initialSelect,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      ),
    );
  }
}

class MultiSelectBottomModalList extends StatefulWidget {
  final int itemCount;
  final int initialSelect;
  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
  ) itemBuilder;

  const MultiSelectBottomModalList({
    super.key,
    required this.initialSelect,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<MultiSelectBottomModalList> createState() => _MultiSelectBottomModalListState();
}

class _MultiSelectBottomModalListState extends State<MultiSelectBottomModalList> {
  late int select = 0;

  @override
  void initState() {
    select = widget.initialSelect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        bool isSelected = index == select;
        return GestureDetector(
          child: widget.itemBuilder(context, index, isSelected),
          onTap: () {
            setState(() {
              select = index;
              context.pop<int>(index);
            });
          },
        );
      },
    );
  }
}

class ModalValue<T> {
  final Widget child;
  final T value;

  ModalValue({required this.child, required this.value});
}

// Separar
class ModalItem extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final Alignment? alignment;

  const ModalItem({
    super.key,
    required this.isSelected,
    required this.child,
    this.alignment
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).dialogTheme.backgroundColor,
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.onBackground,
            ),
        child: child,
      ),
    );
  }
}

// class ModalItem extends ModalItem2 {
//   factory ModalItem.icon() = ModalItem2;
// }
