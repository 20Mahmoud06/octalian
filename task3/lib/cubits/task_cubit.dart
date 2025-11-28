import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task3/data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final Box<Task> taskBox = Hive.box<Task>('tasks');

  // Load all tasks
  void getTasks() {
    emit(TaskLoading());
    try {
      final tasks = taskBox.values.toList().cast<Task>();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to load tasks"));
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      await taskBox.add(task);
      getTasks();
    } catch (e) {
      emit(TaskError("Failed to add task"));
    }
  }

  // Update existing task
  Future<void> updateTask(Task task) async {
    try {
      await task.save();
      getTasks();
    } catch (e) {
      emit(TaskError("Failed to update task"));
    }
  }

  // Delete specific task
  Future<void> deleteTask(Task task) async {
    try {
      await task.delete();
      getTasks();
    } catch (e) {
      emit(TaskError("Failed to delete task"));
    }
  }

  // Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await taskBox.clear();
      getTasks();
    } catch (e) {
      emit(TaskError("Failed to delete all tasks"));
    }
  }
}