import 'package:flutter/material.dart';

Future<void> Confirmation_dialog(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
