import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/space.dart';
import '../providers/spaces_provider.dart';

class SpaceDetailsScreen extends ConsumerWidget {
  final Space space;

  const SpaceDetailsScreen({super.key, required this.space});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                _showAvailableTimes(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Cor do fundo do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Borda arredondada
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Escolha seu horário',
                style: TextStyle(
                  color: Colors.white, // Cor do texto
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailableTimes(BuildContext context, WidgetRef ref) {
    final spacesNotifier = ref.read(spacesProvider.notifier);
    final isLoading = spacesNotifier.isLoading;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Horários disponíveis'),
          content: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Exibe o loading enquanto carrega
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: space.horarios.entries.map((entry) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.value ? 'Disponível' : 'Indisponível',
                            style: TextStyle(
                              color: entry.value ? Colors.green : Colors.red,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: !entry.value,
                        shape: const CircleBorder(),
                        activeColor: Colors.green,
                        onChanged: (bool? newValue) async {
                          space.horarios[entry.key] = !(newValue ?? false);

                          // Atualiza a disponibilidade
                          await spacesNotifier.updateSpaceInFirebase(space);

                          // Fechar o diálogo e chamar novamente para atualizar a lista
                          Navigator.pop(context);
                          _showAvailableTimes(context, ref);
                        },
                      ),
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
