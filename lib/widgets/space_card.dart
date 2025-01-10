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

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Alto':
        return Colors.redAccent;
      case 'Médio':
        return Colors.amber;
      case 'Baixo':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: space.isCompleted ? Colors.grey.shade800 : const Color(0xFF1F1F1F),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        title: Text(
          space.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            decoration: space.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none, // Risco no texto
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              space.description,
              style: TextStyle(
                color: Colors.grey,
                decoration: space.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vence em: ${space.dueDate}',
              style: TextStyle(
                color: Colors.grey,
                decoration: space.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            // Categoria exibida aqui
            Text(
              'Categoria: ${space.category}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getPriorityColor(space.priority),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                space.priority,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
