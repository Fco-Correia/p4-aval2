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
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 48, 29, 101),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUser ? Icons.person : Icons.admin_panel_settings,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isUser ? 'Trocar para Usuário' : 'Trocar para Administrador',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.swap_horiz,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
