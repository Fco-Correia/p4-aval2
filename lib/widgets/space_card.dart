import 'package:flutter/material.dart';
import '../models/space.dart';

class SpaceCard extends StatelessWidget {
  final Space space;
  final VoidCallback onEdit;

  const SpaceCard({
    super.key,
    required this.space,
    required this.onEdit,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'Ativo':
        return Colors.greenAccent;
      case 'Inativo':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: space.status == 'Inativo' ? Colors.grey.shade800 : const Color(0xFF1F1F1F),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        title: Text(
          space.nomeEspaco, // Exibe o nome do espaço
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe a capacidade
            Text(
              'Capacidade: ${space.capacidade}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            // Exibe a disponibilidade
            Text(
              'Disponibilidade: ${space.disponibilidade}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            // Exibe o status
            Text(
              'Status: ${space.status}',
              style: TextStyle(
                color: getStatusColor(space.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            )
          ],
        ),
      ),
    );
  }
}
