import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryManagement extends StatefulWidget {
  final Function onCategoryUpdated;

  const CategoryManagement({super.key, required this.onCategoryUpdated});

  @override
  _CategoryManagementState createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  List<String> categories = [];
  final TextEditingController _controller = TextEditingController();

  final String firebaseUrl =
      'https://to-do-list-276e6-default-rtdb.firebaseio.com/categories.json';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Função para resgatar categorias
  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            categories = data.values
                .map((value) => value['name'] as String)
                .toList();
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar categorias: $e');
    }
  }

  // Função para adicionar categoria
  Future<void> _addCategory() async {
    if (_controller.text.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(firebaseUrl),
          body: jsonEncode({
            'name': _controller.text,
            'createdAt': DateTime.now().toIso8601String(),
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            categories.add(_controller.text);
          });
          _controller.clear();

          // Chamar a função passada para atualizar a tela Home
          widget.onCategoryUpdated(); // Chama a função de atualização
        }
      } catch (e) {
        print('Erro ao adicionar categoria: $e');
      }
    }
  }

  // Função para deletar categoria
  Future<void> _deleteCategory(String category) async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>?;

        if (data != null) {
          String? categoryKey;
          data.forEach((key, value) {
            if (value['name'] == category) {
              categoryKey = key;
            }
          });

          if (categoryKey != null) {
            final deleteResponse = await http.delete(
              Uri.parse(
                  'https://to-do-list-276e6-default-rtdb.firebaseio.com/categories/$categoryKey.json'),
            );

            if (deleteResponse.statusCode == 200) {
              setState(() {
                categories.remove(category);
              });

              // Chamar a função passada para atualizar a tela Home
              widget.onCategoryUpdated(); // Chama a função de atualização
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao deletar categoria: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Categorias')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nova Categoria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Adicionar Categoria'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteCategory(categories[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
