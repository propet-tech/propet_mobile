import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatefulWidget {
  final Widget? title;
  final Widget? content;
  final Future<void> future;
  const LoadingDialog({
    super.key,
    this.title,
    this.content,
    required this.future,
  });

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();

  static show(BuildContext ctx, {Widget? title, Widget? content, required Future<void> future}) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (context) {
        return LoadingDialog(
          title: title,
          content: content,
          future: future,
        );
      },
    );
  }
}

class _LoadingDialogState extends State<LoadingDialog> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    widget.future.whenComplete(() => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 10,
            ),
            Text("Carregando...")
          ],
        ),
      );
    }

    return AlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("OK"),
        )
      ],
    );
  }
}
