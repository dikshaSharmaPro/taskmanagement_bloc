import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/features/tasks/bloc/task_managementlogic.dart';

// import '../data/shared_pref.dart';
import '../data/task_model.dart';

import 'task_state.dart';

enum SortOption { dateNewest, dateOldest, completed, pending }

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Set<String> _pendingDeletions = {};

  TaskBloc() : super(const TaskState()) {
    on<LoadTasksEvent>((event, emit) async {
      // final tasks = await SharedPreferencesHelper.loadTasks();
      // emit(state.copyWith(tasks: tasks));
    });

    on<SetTasksEvent>((event, emit) async {
      // Filter out tasks that are currently being deleted locally
      final filteredTasks = event.tasks.where((task) => !_pendingDeletions.contains(task.id)).toList();
      
      // Apply existing sorting logic to the new task list
      final sortedTasks = _sortTasks(filteredTasks, state.sortOption);
      emit(state.copyWith(tasks: sortedTasks));
    });

    on<AddTaskEvent>((event, emit) async {
      final updated = [event.task, ...state.tasks];
      // await SharedPreferencesHelper.saveTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<DeleteTaskEvent>((event, emit) async {
      // Add to pending deletions to ignore it if the stream emits it before it's gone
      _pendingDeletions.add(event.id);
      
      // Remove after 3 seconds, which should be plenty for the stream to catch up
      Future.delayed(const Duration(seconds: 3), () {
        _pendingDeletions.remove(event.id);
      });

      final updated = state.tasks.where((t) => t.id != event.id).toList();
      // await SharedPreferencesHelper.saveTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<ToggleTaskCompletionEvent>((event, emit) async {
      final updated = state.tasks.map((task) {
        if (task.id == event.id) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      // await SharedPreferencesHelper.saveTasks(updated);
      emit(state.copyWith(tasks: updated));
    });

    on<UpdateTaskEvent>((event, emit) async {
      final updated = List<Task>.from(state.tasks);
      final index = updated.indexWhere((t) => t.id == event.updatedTask.id);
      if (index != -1) {
        updated[index] = event.updatedTask;
        // await SharedPreferencesHelper.saveTasks(updated);
        emit(state.copyWith(tasks: updated));
      }
    });

    on<UpdateSortOptionEvent>((event, emit) {
      final sortedTasks = _sortTasks(state.tasks, event.option);
      emit(state.copyWith(tasks: sortedTasks, sortOption: event.option));
    });
  }

  List<Task> _sortTasks(List<Task> tasks, SortOption option) {
    List<Task> sortedTasks = List.from(tasks);
    switch (option) {
      case SortOption.dateNewest:
        sortedTasks.sort((a, b) => b.datetime.compareTo(a.datetime));
        break;
      case SortOption.dateOldest:
        sortedTasks.sort((a, b) => a.datetime.compareTo(b.datetime));
        break;
      case SortOption.completed:
        sortedTasks.sort(
          (a, b) => (b.isCompleted ? 1 : 0) - (a.isCompleted ? 1 : 0),
        );
        break;
      case SortOption.pending:
        sortedTasks.sort(
          (a, b) => (a.isCompleted ? 1 : 0) - (b.isCompleted ? 1 : 0),
        );
        break;
    }
    return sortedTasks;
  }
}
