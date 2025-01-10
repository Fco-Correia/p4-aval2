class Space {
  String key;
  String title;
  String description;
  String category;
  String dueDate;
  String priority;
  bool isCompleted;

  Space({
    required this.key,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });
}
