import 'package:flutter/material.dart';
import '../models/space.dart';

class EditSpaceDialog extends StatefulWidget {
  final Space space;
  final Function(String) onStatusUpdated;

  const EditSpaceDialog({
    super.key,
    required this.space,
    required this.onStatusUpdated,
  });

  @override
  _EditSpaceDialogState createState() => _EditSpaceDialogState();
}

class _EditSpaceDialogState extends State<EditSpaceDialog> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.space.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar ${widget.space.nomeEspaco}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Selecione o status:'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = 'Ativo';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedStatus == 'Ativo'
                          ? Colors.greenAccent
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Ativo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = 'Inativo';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedStatus == 'Inativo'
                          ? const Color(0xFF8B0000)
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Inativo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onStatusUpdated(selectedStatus);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Salvar',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
