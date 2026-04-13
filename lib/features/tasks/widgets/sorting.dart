import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/features/tasks/bloc/task_bloc.dart';
import 'package:taskmanager/features/tasks/bloc/task_managementlogic.dart';
import 'package:taskmanager/features/tasks/bloc/task_state.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 30, 31, 42),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SortOption>(
              value: state.sortOption,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
              ),
              dropdownColor: const Color.fromARGB(255, 40, 41, 54),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(12),
              onChanged: (SortOption? newOption) {
                if (newOption != null) {
                  context.read<TaskBloc>().add(
                    UpdateSortOptionEvent(newOption),
                  );
                }
              },
              items:
                  SortOption.values.map((SortOption option) {
                    return DropdownMenuItem<SortOption>(
                      value: option,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _getOptionText(option),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _getOptionText(SortOption option) {
    switch (option) {
      case SortOption.dateNewest:
        return 'Newest First';
      case SortOption.dateOldest:
        return 'Oldest First';
      case SortOption.completed:
        return 'Completed';
      case SortOption.pending:
        return 'Pending';
    }
  }
}
