class Item {
  int? id;
  String date;
  String type;
  double duration;
  String priority;
  String category;
  String description;

  Item({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.priority,
    required this.category,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'] as int?,
        date: json['date'] as String,
        type: json['type'] as String,
        duration: json['duration'].toDouble(),
        priority: json['priority'] as String,
        category: json['category'] as String,
        description: json['description'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'duration': duration,
      'priority': priority,
      'category': category,
      'description': description
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'date': date,
      'type': type,
      'duration': duration,
      'priority': priority,
      'category': category,
      'description': description
    };
  }

  Item copy({
    int? id,
    String? date,
    String? type,
    double? duration,
    String? priority,
    String? category,
    String? description,
  }) {
    return Item(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Task from date: $date, type: $type, duration: $duration, priority: $priority, category: $category, description: $description';
  }
}
