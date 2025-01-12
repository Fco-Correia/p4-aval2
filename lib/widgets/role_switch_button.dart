import 'package:flutter/material.dart';

class RoleSwitchButton extends StatelessWidget {
  final bool isUser;
  final VoidCallback onPressed;

  const RoleSwitchButton({
    Key? key,
    required this.isUser,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16), // Padding ajustado
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 48, 29, 101), // Cor ajustada para um azul suave
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Impede que o Row ocupe toda a largura
          children: [
            Icon(
              isUser ? Icons.person : Icons.admin_panel_settings, // Ícone alternado com operador ternário
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8), // Espaço entre o ícone e o texto
            Text(
              isUser ? 'Trocar para Usuário' : 'Trocar para Administrador', // Texto alternado com operador ternário
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8), // Espaço entre o texto e o ícone de troca
            const Icon(
              Icons.swap_horiz, // Outro ícone alternado (opcional)
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
