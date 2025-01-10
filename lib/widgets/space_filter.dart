import 'package:flutter/material.dart';

class SpaceFilter extends StatelessWidget {
  final Function(String) onFilterSelected;

  const SpaceFilter({required this.onFilterSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onFilterSelected,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'Prioridade',
            child: Text('Prioridade'),
          ),
          PopupMenuItem<String>(
            value: 'Data',
            child: Text('Data'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list, color: Colors.grey),
      tooltip: ''
    );
  }
}
