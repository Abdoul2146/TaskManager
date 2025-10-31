import 'package:flutter_riverpod/legacy.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

enum TaskListStatus { loading, loaded, error }

class TaskListState {
  final List<Task> tasks;
  final TaskListStatus status;
  final String? error;

  TaskListState({
    required this.tasks,
    this.status = TaskListStatus.loaded,
    this.error,
  });

  TaskListState copyWith({
    List<Task>? tasks,
    TaskListStatus? status,
    String? error,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      error: error,
    );
  }
}

/// StateNotifier for managing the list of tasks, including loading and error states.
class TaskListNotifier extends StateNotifier<TaskListState> {
  TaskListNotifier()
    : super(TaskListState(tasks: [], status: TaskListStatus.loading)) {
    loadTasks();
  }

  /// Loads tasks from the database. Sets loading and error states as appropriate.
  Future<void> loadTasks() async {
    state = state.copyWith(status: TaskListStatus.loading, error: null);
    try {
      final tasks = await DatabaseService.instance.getTasks();
      state = state.copyWith(tasks: tasks, status: TaskListStatus.loaded);
    } catch (e) {
      state = state.copyWith(status: TaskListStatus.error, error: e.toString());
    }
  }

  /// Adds a new task and reloads the list.
  Future<void> addTask(Task task) async {
    state = state.copyWith(status: TaskListStatus.loading, error: null);
    try {
      await DatabaseService.instance.insertTask(task);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(status: TaskListStatus.error, error: e.toString());
    }
  }

  /// Updates an existing task and reloads the list.
  Future<void> updateTask(Task task) async {
    state = state.copyWith(status: TaskListStatus.loading, error: null);
    try {
      await DatabaseService.instance.updateTask(task);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(status: TaskListStatus.error, error: e.toString());
    }
  }

  /// Deletes a task by ID and reloads the list.
  Future<void> deleteTask(int id) async {
    state = state.copyWith(status: TaskListStatus.loading, error: null);
    try {
      await DatabaseService.instance.deleteTask(id);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(status: TaskListStatus.error, error: e.toString());
    }
  }
}

final taskListProvider = StateNotifierProvider<TaskListNotifier, TaskListState>(
  (ref) {
    return TaskListNotifier();
  },
);

final searchProvider = StateProvider<String>((ref) => '');
