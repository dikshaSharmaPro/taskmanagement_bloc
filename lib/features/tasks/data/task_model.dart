class Task {
  final String id;
  final String title;
  final String description;
  final String datetime;
  final bool isCompleted;
  final String? userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.datetime,
    this.isCompleted = false,
    this.userId,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? datetime,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'datetime': datetime,
        'isCompleted': isCompleted,
        'user_id': userId,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        datetime: json['datetime'] ?? '',
        isCompleted: json['isCompleted'] ?? false,
        userId: json['user_id'],
      );
}
