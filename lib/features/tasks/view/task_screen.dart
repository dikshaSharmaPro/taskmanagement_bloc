import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/routes.dart';
import 'package:taskmanager/features/tasks/bloc/task_bloc.dart';
import 'package:taskmanager/features/tasks/bloc/task_managementlogic.dart';
import 'package:taskmanager/features/tasks/bloc/task_state.dart';
import 'package:taskmanager/features/tasks/widgets/sorting.dart';
import 'package:taskmanager/features/tasks/widgets/task_pie_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskmanager/features/tasks/data/task_model.dart';

import '../widgets/animated_task_list.dart';

import 'dart:async';
import 'package:taskmanager/core/auth_service.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> insertedIds = [];
  final _authService = AuthService();
  StreamSubscription? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _realtimeSubscription = Supabase.instance.client
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((List<Map<String, dynamic>> data) {
          final taskList = data.map((json) => Task.fromJson(json)).toList();
          if (mounted) {
            context.read<TaskBloc>().add(SetTasksEvent(taskList));
            // Note: Animated list sync logic could go here if needed,
            // but for simplicity we rely on the BLoC update.
          }
        });
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Future<void> _onRefresh() async {
    // With real-time streams, manual refresh is technically redundant
    // but we can keep it for user satisfaction or to force a re-fetch.
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('tasks')
        .select()
        .eq('user_id', userId);

    final taskList = (response as List).map((e) => Task.fromJson(e)).toList();
    if (mounted) {
      context.read<TaskBloc>().add(SetTasksEvent(taskList));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 16, 22),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 16, 22),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          onPressed: _handleLogout,
        ),
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(67, 40, 123, 1),
                    Color.fromRGBO(75, 71, 184, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addTask);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/notask.png', height: 200),
                  const SizedBox(height: 20),
                  const Text(
                    'No tasks yet!',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ],
              ),
            );
          }

          int totalTasks = state.tasks.length;
          int completedTasks =
              state.tasks.where((task) => task.isCompleted).length;
          return Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 180,
                      child: TaskPieChart(
                        totalTasks: totalTasks,
                        completedTasks: completedTasks,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem(
                          color: const Color.fromRGBO(75, 71, 184, 1),
                          label: 'Completed',
                        ),
                        const SizedBox(height: 8),
                        buildLegendItem(
                          color: const Color.fromRGBO(189, 187, 232, 1),
                          label: 'Pending',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Tasks',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SortDropdown(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: AnimatedTaskList(
                    listKey: _listKey,
                    tasks: state.tasks,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget buildLegendItem({required Color color, required String label}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
    ],
  );
}
