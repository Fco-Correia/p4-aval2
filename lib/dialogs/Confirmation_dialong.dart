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
            Navigator.pop(context); // Fecha o diálogo
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Chama a função de confirmação
            Navigator.pop(context); // Fecha o diálogo
          },
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
