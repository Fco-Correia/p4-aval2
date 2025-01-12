import 'package:flutter/material.dart';
import '../models/space.dart';

class SpaceCard extends StatelessWidget {
  final Space space;
  final VoidCallback onEdit;
  final VoidCallback onDetails; // Adiciona callback para detalhes
  final bool isUser; // Indica se o papel atual é de "Usuário"

  const SpaceCard({
    super.key,
    required this.space,
    required this.onEdit,
    required this.onDetails,
    required this.isUser,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              space.nomeEspaco,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Capacidade: ${space.capacidade}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              space.disponibilidadeFormatada,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(space.status),
                borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isUser)
                  ElevatedButton.icon(
                    onPressed: onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    label: const Text(
                      'Editar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!isUser &&
                    space.status == 'Ativo') // Exibe apenas se estiver "Ativo"
                  ElevatedButton.icon(
                    onPressed: onDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orange, // Cor mais chamativa para o botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_today,
                        color: Colors.white, size: 18), // Ícone atualizado
                    label: const Text(
                      'Faça sua Reserva',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ), // Texto atualizado
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
