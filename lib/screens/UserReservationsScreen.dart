import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/spaces_provider.dart';

class UserReservationsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(spacesProvider);
    
    // Filtra os horários para o usuário
    final reservedTimes = <String, String>{};
    
    for (var space in spaces) {
      space.horarios.forEach((time, isAvailable) {
        if (!isAvailable) {
          reservedTimes[space.nomeEspaco] = time;
        }
      });
    }

    if (reservedTimes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Suas Reservas'),
        ),
        body: const Center(
          child: Text('Você não tem reservas feitas.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Reservas'),
      ),
      body: ListView.builder(
        itemCount: reservedTimes.length,
        itemBuilder: (context, index) {
          String spaceName = reservedTimes.keys.elementAt(index);
          String reservedTime = reservedTimes[spaceName] ?? '';
          
          return ListTile(
            title: Text(spaceName),
            subtitle: Text('Horário: $reservedTime'),
            leading: const Icon(Icons.calendar_today),
          );
        },
      ),
    );
  }
}
