import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/space.dart';

final spacesProvider =
    StateNotifierProvider<SpacesNotifier, List<Space>>((ref) {
  return SpacesNotifier();
});

class SpacesNotifier extends StateNotifier<List<Space>> {
  bool isUser = true;
  bool isLoading = false;

  SpacesNotifier() : super([]) {
    fetchSpacesFromFirebase();
  }

  Future<void> fetchSpacesFromFirebase() async {
    isLoading = true;
    state = List.from(state);

    const url =
        'https://reservas-45109-default-rtdb.firebaseio.com/spaces.json';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Space> fetchedSpaces = [];
          data.forEach((key, spaceData) {
            fetchedSpaces.add(Space(
              key: key,
              nomeEspaco: spaceData['nomeEspaco'] ?? 'Sem nome',
              capacidade: spaceData['capacidade'] ?? 0,
              disponibilidade:
                  int.tryParse(spaceData['disponibilidade'].toString()) ?? 0,
              status: spaceData['status'] ?? 'Inativo',
              horarios: Map<String, bool>.from(spaceData['horarios'] ?? {}),
            ));
          });

          state = fetchedSpaces;
        }
      } else {
        print('Erro ao buscar espaços: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer GET: $error');
    } finally {
      isLoading = false;
      state = List.from(state);
    }
  }

  // Atualiza o espaço no Firebase
  Future<void> updateSpaceInFirebase(Space space) async {
    final url =
        'https://reservas-45109-default-rtdb.firebaseio.com/spaces/${space.key}.json';

    try {
      isLoading = true;

      // Atualiza a disponibilidade
      space.disponibilidade = _calculateAvailableTimes(space);

      final response = await http.put(
        Uri.parse(url),
        body: json.encode({
          'nomeEspaco': space.nomeEspaco,
          'capacidade': space.capacidade,
          'disponibilidade': space.disponibilidade,
          'status': space.status,
          'horarios': space.horarios,
        }),
      );

      if (response.statusCode == 200) {
        print('Espaço atualizado com sucesso!');
        fetchSpacesFromFirebase();
      } else {
        print('Erro ao atualizar espaço: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer PUT: $error');
    } finally {
      isLoading = false;
    }
  }

  // Calcula a quantidade de horários disponíveis
  int _calculateAvailableTimes(Space space) {
    int availableCount = 7; // Número inicial de horários disponíveis

    // Conta os horários disponíveis
    space.horarios.forEach((key, value) {
      if (!value) availableCount--; // Se o horário for marcado como indisponível, diminui
    });

    return availableCount;
  }

  void toggleUserRole() {
    isUser = !isUser;
    state = List.from(state);
  }
}
