import 'package:flutter/material.dart';

void Category_dialog(
  BuildContext context, 
  Function(String) onCategoryChanged,
  List<String> categories,
  ) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Escolher Categoria',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...categories.map((category) {
                return ListTile(
                  title: Text(category, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    onCategoryChanged(category);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    ),
  );
}