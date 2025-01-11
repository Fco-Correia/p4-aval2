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
        return const Color(0xFF8B0000);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: space.status == 'Inativo'
          ? const Color(0xFF4B0000)
          : const Color(0xFF1F1F1F),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        title: Text(
          space.nomeEspaco,
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
              space.disponibilidadeFormatada,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            // Exibe o status em uma "caixinha"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(space.status),
                borderRadius: BorderRadius.circular(10),
                border: space.status == 'Inativo'
                    ? Border.all(color: Colors.black, width: 1) // Realça borda
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    space.status == 'Inativo' ? Icons.error : Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    space.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
