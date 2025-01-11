import 'package:flutter/material.dart';
import '../models/space.dart';

class SpaceDetailsScreen extends StatelessWidget {
  final Space space;

  const SpaceDetailsScreen({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(space.nomeEspaco),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capacidade: ${space.capacidade}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${space.status}',
              style: TextStyle(
                fontSize: 18,
                color: space.status == 'Ativo' ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para exibir horários disponíveis
                _showAvailableTimes(context);
              },
              child: const Text('Ver horários disponíveis'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableTimes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Horários disponíveis'),
        content: const Text('Exemplo de horários disponíveis...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
