import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
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
      color: task.isCompleted ? Colors.grey.shade800 : const Color(0xFF1F1F1F),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none, // Risco no texto
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(
                color: Colors.grey,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vence em: ${task.dueDate}',
              style: TextStyle(
                color: Colors.grey,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            // Categoria exibida aqui
            Text(
              'Categoria: ${task.category}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getPriorityColor(task.priority),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                task.priority,
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
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: onToggleComplete,
            ),
          ],
        ),
      ),
    );
  }
}
