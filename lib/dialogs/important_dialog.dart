import 'package:flutter/material.dart';
import '../models/task.dart';

void showImportantTasksDialog(BuildContext context, List<Task> tasks) {
  DateTime now = DateTime.now();
  DateTime tomorrow = now.add(Duration(days: 1));

  List<Task> importantTasks = tasks.where((task) {
    DateTime taskDate = DateTime.parse(task.dueDate);
    return (taskDate.year == now.year &&
            taskDate.month == now.month &&
            taskDate.day == now.day) || 
           (taskDate.year == tomorrow.year &&
            taskDate.month == tomorrow.month &&
            taskDate.day == tomorrow.day);
  }).toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Lembretes Importantes (Hoje e Amanhã)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: importantTasks.isEmpty
            ? const Text('Não há lembretes para hoje ou amanhã.')
            : SingleChildScrollView(
                child: Column(
                  children: importantTasks.map((task) {
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Prioridade: ${task.priority}'),
                      trailing: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.warning,
                        color: task.isCompleted ? Colors.green : Colors.red,
                      ),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
