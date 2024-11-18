import 'package:flutter/material.dart';
import '../dialogs/Confirmation_dialong.dart';
import '../dialogs/important_dialog.dart';
import '../dialogs/AddTask_dialog.dart';
import '../screens/CategoryManagement.dart';
import '../models/task.dart';
import '../widgets/category_filter.dart';
import '../widgets/task_filter.dart';
import '../widgets/task_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  List<String> categories = ['Todas'];

  String currentCategory = 'Todas';
  String currentFilter = 'Nenhum';
  bool showOnlyIncomplete = false;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesFromFirebase();
    _fetchTasksFromFirebase();
  }

  // Função que busca as categorias do Firebase
  Future<void> _fetchCategoriesFromFirebase() async {
    const url =
        'https://to-do-list-276e6-default-rtdb.firebaseio.com/categories.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<String> fetchedCategories = ['Todas'];

          data.forEach((key, categoryData) {
            fetchedCategories.add(categoryData['name']);
          });

          setState(() {
            categories = fetchedCategories; // Atualiza a lista de categorias.
          });
        }
      } else {
        print('Erro ao buscar categorias: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer GET: $error');
    }
  }

  Future<void> _fetchTasksFromFirebase() async {
    const url =
        'https://to-do-list-276e6-default-rtdb.firebaseio.com/tasks.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Task> fetchedTasks = [];

          data.forEach((key, taskData) {
            fetchedTasks.add(Task(
              key: key,
              title: taskData['title'] ?? 'Sem título',
              description: taskData['description'] ?? '',
              category: taskData['category'] ?? 'Sem Categoria',
              dueDate: taskData['dueDate'] ?? '',
              priority: taskData['priority'] ?? 'Baixo',
              isCompleted: taskData['isCompleted'] ?? false,
            ));
          });

          setState(() {
            tasks = fetchedTasks;
          });
        }
      } else {
        print('Erro ao buscar tarefas: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer GET: $error');
    }
  }

  void _editTask(Task task) {
    AddTask_dialog(
      context,
      isEditMode: true,
      task: task,
      availableCategories: categories,
      (title, description, dueDate, priority, category) {
        setState(() {
          task.title = title;
          task.description = description;
          task.dueDate = dueDate;
          task.priority = priority;
          task.category = category;
        });

        // Atualiza a tarefa no Firebase
        _updateTaskInFirebase(task);
      },
    );
  }

  void _deleteTask(Task task) {
    Confirmation_dialog(
      context,
      title: 'Confirmar exclusão',
      content: 'Você tem certeza que deseja excluir esta tarefa?',
      onConfirm: () async {
        await _deleteTaskFromFirebase(task);
        setState(() {
          tasks.remove(task);
        });
      },
    );
  }

  void _filterTasks(String filterType) {
    setState(() {
      currentFilter = filterType;
    });

    if (filterType == 'Prioridade') {
      final priorityOrder = {'Alto': 1, 'Médio': 2, 'Baixo': 3};

      tasks.sort((a, b) {
        // Primeiro, compara as prioridades
        int priorityComparison =
            priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);

        if (priorityComparison != 0) {
          return priorityComparison;
        }

        // Se as prioridades forem iguais, compara as datas (mais recentes primeiro)
        return DateTime.parse(a.dueDate).compareTo(DateTime.parse(b.dueDate));
      });
    } else if (filterType == 'Data') {
      tasks.sort((a, b) =>
          DateTime.parse(a.dueDate).compareTo(DateTime.parse(b.dueDate)));
    }
  }

  void _toggleTaskComplete(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  Future<void> _addTaskToFirebase(Task task) async {
    const url =
        'https://to-do-list-276e6-default-rtdb.firebaseio.com/tasks.json';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'category': task.category,
          'dueDate': task.dueDate,
          'priority': task.priority,
          'isCompleted': task.isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final newTask = Task(
          key: responseData['name'], // A chave gerada está no campo 'name'
          title: task.title,
          description: task.description,
          category: task.category,
          dueDate: task.dueDate,
          priority: task.priority,
          isCompleted: task.isCompleted,
        );

        setState(() {
          tasks.add(newTask);
        });

        print('Tarefa adicionada com sucesso!');
      } else {
        print('Erro ao adicionar tarefa: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer POST: $error');
    }
  }

  Future<void> _deleteTaskFromFirebase(Task task) async {
    final url =
        'https://to-do-list-276e6-default-rtdb.firebaseio.com/tasks/${task.key}.json';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Tarefa excluída com sucesso!');
      } else {
        print('Erro ao excluir tarefa: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer DELETE: $error');
    }
  }

  Future<void> _updateTaskInFirebase(Task task) async {
    final url =
        'https://to-do-list-276e6-default-rtdb.firebaseio.com/tasks/${task.key}.json';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'category': task.category,
          'dueDate': task.dueDate,
          'priority': task.priority,
          'isCompleted': task.isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        print('Tarefa atualizada com sucesso!');
      } else {
        print('Erro ao atualizar tarefa: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer PUT: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = tasks.where((task) {
      if (showOnlyIncomplete && task.isCompleted) return false;
      return currentCategory == 'Todas' || task.category == currentCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          Row(
            children: [
              const Text(
                'Nova Categoria',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.white),
                tooltip: 'Adicionar Categoria',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryManagement(
                        onCategoryUpdated:
                            _fetchCategoriesFromFirebase,
                      ),
                    ),
                  );
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
            padding: const EdgeInsets.fromLTRB(25, 20, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categoria: $currentCategory',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        showOnlyIncomplete
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      tooltip: showOnlyIncomplete
                          ? 'Mostrar todas as tarefas'
                          : 'Mostrar apenas incompletas',
                      onPressed: () {
                        setState(() {
                          showOnlyIncomplete = !showOnlyIncomplete;
                        });
                      },
                    ),
                    CategoryFilter(
                      currentCategory: currentCategory,
                      onCategoryChanged: (category) {
                        setState(() {
                          currentCategory = category;
                        });
                      },
                      categories: categories,
                    ),
                    TaskFilter(
                      onFilterSelected: _filterTasks,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredTasks.length) {
                  // Adiciona o espaço ao final da lista
                  return const SizedBox(
                    height:
                        80,
                  );
                }
                
                return TaskCard(
                  task: filteredTasks[index],
                  onEdit: () => _editTask(filteredTasks[index]),
                  onDelete: () => _deleteTask(filteredTasks[index]),
                  onToggleComplete: () =>
                      _toggleTaskComplete(filteredTasks[index]),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 30,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'importantTasks',
              onPressed: () {
                showImportantTasksDialog(context, tasks);
              },
              tooltip: 'Tarefas importantes',
              child: const Icon(Icons.notifications),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: FloatingActionButton.extended(
              heroTag: 'newTask',
              icon: const Icon(Icons.add),
              label: const Text('Nova Tarefa'),
              onPressed: () {
                AddTask_dialog(
                  context,
                  (title, description, dueDate, priority, category) {
                    final newTask = Task(
                      key: '',
                      title: title,
                      description: description,
                      category: category.isEmpty ? 'Sem Categoria' : category,
                      dueDate: dueDate,
                      priority: priority,
                      isCompleted: false, // Tarefa inicia como incompleta
                    );
                    
                    _addTaskToFirebase(newTask);
                  },
                  availableCategories:
                      categories,
                  isEditMode: false,
                  task: null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
