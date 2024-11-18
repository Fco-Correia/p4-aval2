import 'package:flutter/material.dart';
import '../models/task.dart';

void AddTask_dialog(
  BuildContext context,
  Function(String, String, String, String, String) onSave,
  //parametros nomeados
  {
  required List<String> availableCategories, // Lista de categorias disponíveis
  bool isEditMode = false,
  Task? task,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _AddTaskDialog(
        onSave: onSave,
        availableCategories: availableCategories,
        isEditMode: isEditMode,
        task: task,
      );
    },
  );
}

class _AddTaskDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onSave;
  final List<String> availableCategories; // Lista de categorias
  final bool isEditMode;
  final Task? task;

  _AddTaskDialog({
    required this.onSave,
    required this.availableCategories, // Recebe as categorias
    this.isEditMode = false,
    this.task,
  });

  @override
  __AddTaskDialogState createState() => __AddTaskDialogState();
}

class __AddTaskDialogState extends State<_AddTaskDialog> {
  late String title;
  late String description;
  late String dueDate;
  late String selectedPriority;
  late String selectedCategory; // Categoria selecionada
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      dueDate = widget.task!.dueDate;
      selectedPriority = widget.task!.priority;
      selectedCategory = widget.task!.category;
      titleController.text = title;
      descriptionController.text = description;
      dueDateController.text = dueDate;
    } else {
      title = '';
      description = '';
      dueDate = '';
      selectedPriority = 'Baixo';
      selectedCategory = widget.availableCategories.isNotEmpty
          ? widget.availableCategories.first
          : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: const Color(0xFF1F1F1F),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditMode ? 'Editar Tarefa' : 'Nova Tarefa',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Título', titleController),
              const SizedBox(height: 10),
              _buildTextField('Descrição', descriptionController, maxLines: 4),
              const SizedBox(height: 10),
              _buildDateField(),
              const SizedBox(height: 10),
              _buildPrioritySelector(),
              const SizedBox(height: 10),
              _buildCategoryDropdown(), // Substitui o campo de texto pela dropdown
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categoria', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory.isNotEmpty ? selectedCategory : null,
          onChanged: (value) {
            setState(() {
              selectedCategory = value ?? '';
            });
          },
          items: widget.availableCategories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child:
                  Text(category, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: Colors.grey[800],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        if (label == 'Título') {
          title = value;
        } else if (label == 'Descrição') {
          description = value;
        } else if (label == 'Categoria') {
          selectedCategory = value;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: dueDateController,
      onTap: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null && selectedDate != DateTime.now()) {
          setState(() {
            dueDate = "${selectedDate.toLocal()}".split(' ')[0];
            dueDateController.text = dueDate;
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Data de Vencimento',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      readOnly: true,
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prioridade', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Baixo', 'Médio', 'Alto'].map((priority) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPriority = priority;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPriority == priority
                    ? _getPriorityColor(priority)
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  Text(priority, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
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

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (title.isNotEmpty &&
            description.isNotEmpty &&
            dueDate.isNotEmpty &&
            selectedCategory.isNotEmpty) {
          widget.onSave(
              title, description, dueDate, selectedPriority, selectedCategory);
          // Incluindo a categoria
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preencha todos os campos!')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Text('Salvar Tarefa',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
