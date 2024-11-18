import 'package:flutter/material.dart';
import '../dialogs/Category_dialog.dart';

class CategoryFilter extends StatelessWidget {
  final String currentCategory;
  final Function(String) onCategoryChanged;
  final List<String> categories;
  const CategoryFilter({
    required this.currentCategory,
    required this.onCategoryChanged,
    required this.categories,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.category, color: Colors.grey),
          onPressed: () => {
            Category_dialog(context, onCategoryChanged, categories)
          },
        ),
      ],
    );
  }
}
