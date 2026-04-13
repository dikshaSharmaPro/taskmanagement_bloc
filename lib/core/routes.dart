import 'package:flutter/material.dart';
import 'package:taskmanager/features/auth/view/login_screen.dart';
import 'package:taskmanager/features/auth/view/signup_screen.dart';
import 'package:taskmanager/features/tasks/view/add_task_screen.dart';
import 'package:taskmanager/features/tasks/view/splash.dart';
import 'package:taskmanager/features/tasks/view/task_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String task = '/tasks';
  static const String addTask = '/add-task';
  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    task: (_) => const TaskScreen(),
    addTask: (_) => const AddTaskScreen(),
  };
}
