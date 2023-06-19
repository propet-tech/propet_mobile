import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final Widget? errorTitle;
  final Future<void> future;
  final void Function()? onSuccess;

  const LoadingDialog({
    super.key,
    this.title,
    this.errorTitle,
    this.content,
    required this.future,
    this.onSuccess,
  });

  static show(
    BuildContext ctx, {
    Widget? title,
    Widget? content,
    required Future<bool> future,
    void Function()? onSuccess,
  }) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (context) {
        return LoadingDialog(
          title: title,
          content: content,
          future: future,
          onSuccess: onSuccess,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return AlertDialog(
            title: errorTitle ?? const Text("Error"),
            content: content,
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

        if (snapshot.hasData) {
          return AlertDialog(
            title: title ?? const Text("Sucesso"),
            content: content,
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  if (onSuccess != null) {
                    onSuccess!();
                  }
                },
                child: const Text("OK"),
              )
            ],
          );
        }

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
      },
    );
  }
}

// class _LoadingDialogState extends State<LoadingDialog> {
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       
//     }
//
//     return AlertDialog(
//       title: !error ? widget.title : Text("Error"),
//       content: widget.content,
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             context.pop();
//           },
//           child: const Text("OK"),
//         )
//       ],
//     );
//   }
// }
