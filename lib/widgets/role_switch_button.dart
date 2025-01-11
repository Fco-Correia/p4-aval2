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
        child: Row(
          mainAxisSize: MainAxisSize.min, // Impede que o Row ocupe toda a largura
          children: [
            const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8), // Espaço entre o ícone do usuário e o texto
            Text(
              isUser ? 'Administrador' : 'Usuário',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8), // Espaço entre o texto e o ícone de troca
            const Icon(
              Icons.swap_horiz,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 48, 29, 101), // Cor ajustada para um azul suave
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
