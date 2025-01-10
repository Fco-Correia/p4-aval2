import 'package:flutter/material.dart';
import '../models/space.dart';
import '../widgets/space_filter.dart';
import '../widgets/space_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Space> spaces = [];

  String currentFilter = 'Nenhum';
  bool showOnlyIncomplete = false;

  @override
  void initState() {
    super.initState();
    spaces = _mockSpaces();
  }

  List<Space> _mockSpaces() {
    return [
      Space(
        key: '1',
        nomeEspaco: 'Espaço 1',
        capacidade: 10,
        disponibilidade: '3 horários disponíveis',
        status: 'Ativo',
      ),
      Space(
        key: '2',
        nomeEspaco: 'Espaço 2',
        capacidade: 20,
        disponibilidade: '5 horários disponíveis',
        status: 'Inativo',
      ),
      Space(
        key: '3',
        nomeEspaco: 'Espaço 3',
        capacidade: 15,
        disponibilidade: '2 horários disponíveis',
        status: 'Ativo',
      ),
    ];
  }

  Future<void> _fetchSpacesFromFirebase() async {
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
              disponibilidade: spaceData['disponibilidade'] ?? 'Indisponível',
              status: spaceData['status'] ?? 'Inativo',
            ));
          });

          setState(() {
            spaces = _mockSpaces();
          });
        }
      } else {
        print('Erro ao buscar espaços: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer GET: $error');
    }
  }

  void _editSpace(Space space) {
    // a Colocar
  }

  void _filterSpaces(String filterType) {
    setState(() {
      if (filterType == 'Ativo') {
        spaces.sort((a, b) => a.status == 'Ativo' ? -1 : 1);
      } else if (filterType == 'Inativo') {
        spaces.sort((a, b) => a.status == 'Inativo' ? -1 : 1);
      } else {
        // Retorna à lista original se o filtro for "Nenhum"
        spaces = _mockSpaces();
      }
    });
  }

  Future<void> _addSpaceToFirebase(Space space) async {
    const url =
        'https://reservas-45109-default-rtdb.firebaseio.com/spaces.json';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'nomeEspaco': space.nomeEspaco,
          'capacidade': space.capacidade,
          'disponibilidade': space.disponibilidade,
          'status': space.status,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final newSpace = Space(
          key: responseData['name'], // A chave gerada está no campo 'name'
          nomeEspaco: space.nomeEspaco,
          capacidade: space.capacidade,
          disponibilidade: space.disponibilidade,
          status: space.status,
        );

        setState(() {
          spaces.add(newSpace);
        });

        print('Espaço adicionado com sucesso!');
      } else {
        print('Erro ao adicionar espaço: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer POST: $error');
    }
  }

  Future<void> _deleteSpaceFromFirebase(Space space) async {
    final url =
        'https://reservas-45109-default-rtdb.firebaseio.com/spaces/${space.key}.json';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Espaço excluído com sucesso!');
      } else {
        print('Erro ao excluir espaço: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer DELETE: $error');
    }
  }

  Future<void> _updateSpaceInFirebase(Space space) async {
    final url =
        'https://reservas-45109-default-rtdb.firebaseio.com/spaces/${space.key}.json';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({
          'nomeEspaco': space.nomeEspaco,
          'capacidade': space.capacidade,
          'disponibilidade': space.disponibilidade,
          'status': space.status,
        }),
      );

      if (response.statusCode == 200) {
        print('Espaço atualizado com sucesso!');
      } else {
        print('Erro ao atualizar espaço: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer PUT: $error');
    }
  }

  void _addMockSpaceToFirebase() {
    // Criar um espaço fictício para testar
    final newSpace = Space(
      key: DateTime.now().toString(), // Gerar uma chave única temporária
      nomeEspaco: 'Espaço Teste ${DateTime.now().millisecondsSinceEpoch}',
      capacidade: 10,
      disponibilidade: 'Disponível',
      status: 'Ativo',
    );

    _addSpaceToFirebase(newSpace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reservas'),
          actions: [
            Row(
              children: [
                const Text(
                  'Usuario',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  tooltip: 'Adicionar Espaço de Teste',
                  onPressed: () {
                    _addMockSpaceToFirebase();
                  },
                )
              ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SpaceFilter(
                        onFilterSelected: _filterSpaces,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: spaces.length + 1,
                itemBuilder: (context, index) {
                  if (index == spaces.length) {
                    // Adiciona o espaço ao final da lista
                    return const SizedBox(
                      height: 80,
                    );
                  }

                  return SpaceCard(
                    space: spaces[index],
                    onEdit: () => _editSpace(spaces[index]),
                  );
                },
              ),
            )
          ],
        ));
  }
}
