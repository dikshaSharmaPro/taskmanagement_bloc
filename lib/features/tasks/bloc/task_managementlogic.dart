import 'package:taskmanager/features/tasks/data/task_model.dart';
import 'package:taskmanager/features/tasks/bloc/task_bloc.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  DeleteTaskEvent(this.id);
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String id;
  ToggleTaskCompletionEvent(this.id);
}

class UpdateTaskEvent extends TaskEvent {
  final Task updatedTask;
  UpdateTaskEvent(this.updatedTask);
}

class SetTasksEvent extends TaskEvent {
  final List<Task> tasks;
  SetTasksEvent(this.tasks);
}

class UpdateSortOptionEvent extends TaskEvent {
  final SortOption option;
  UpdateSortOptionEvent(this.option);
}
