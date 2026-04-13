import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/routes.dart';
import 'package:taskmanager/features/tasks/bloc/task_bloc.dart';
import 'package:taskmanager/features/tasks/widgets/animatedlogo.dart';
import '../bloc/task_managementlogic.dart';

import 'package:taskmanager/core/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    checkAuthAndNavigate();
  }

  void checkAuthAndNavigate() async {
    // Small delay for the logo animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final session = _authService.currentSession;
    if (session != null) {
      context.read<TaskBloc>().add(LoadTasksEvent());
      Navigator.pushReplacementNamed(context, AppRoutes.task);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(208, 187, 41, 129),
              Color.fromRGBO(75, 71, 184, 1),
              Color.fromRGBO(124, 106, 250, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedLogo(),
              const SizedBox(height: 20),
              const Text(
                'Task Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(208, 227, 119, 184),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.task);
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
