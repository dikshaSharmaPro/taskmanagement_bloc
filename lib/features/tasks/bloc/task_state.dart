import 'package:taskmanager/features/tasks/bloc/task_bloc.dart';

import '../data/task_model.dart';

class TaskState {
  final List<Task> tasks;
  final SortOption sortOption;
  const TaskState({
    this.tasks = const [],
    this.sortOption = SortOption.dateNewest,
  });

  TaskState copyWith({List<Task>? tasks, SortOption? sortOption}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
