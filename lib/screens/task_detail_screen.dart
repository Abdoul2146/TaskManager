import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'add_new_task.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(taskListProvider.notifier);

    return Scaffold(
      // Use themed background color for consistency
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C8DFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF4C8DFF),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task title
                        Expanded(
                          child: Text(
                            task.title,
                            style: textTheme.headlineMedium?.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        // Show "Overdue" label if task is past due and not completed
                        if (task.dueDate != null &&
                            task.dueDate!.isBefore(DateTime.now()) &&
                            !task.isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Text(
                              'Overdue',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        // Switch to toggle completion status
                        Switch(
                          value: task.isCompleted,
                          onChanged: (bool value) async {
                            // Update completion status and return to previous screen
                            await notifier.updateTask(
                              task.copyWith(isCompleted: value),
                            );
                            Navigator.pop(context);
                          },
                          activeColor: colorScheme.primary,
                          inactiveThumbColor: isDark
                              ? Colors.white24
                              : Colors.white,
                          inactiveTrackColor: isDark
                              ? Colors.white12
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Show due date
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Due Date',
                      value: task.dueDate != null
                          ? DateFormat('MMM d, yyyy').format(task.dueDate!)
                          : 'No date',
                      isPriority: false,
                    ),
                    const SizedBox(height: 16),
                    // Show priority badge
                    _buildDetailRow(
                      context,
                      icon: Icons.flag_outlined,
                      label: 'Priority',
                      value: '${task.priority} Priority',
                      isPriority: true,
                    ),
                    const SizedBox(height: 30),
                    // Description section
                    Text(
                      'Description',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.description.isNotEmpty
                          ? task.description
                          : 'No description.',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Action buttons (edit, delete) at the bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Navigate to edit screen, then return to previous screen
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddNewTaskScreen(task: task),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Edit Task',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Show confirmation dialog before deleting
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Task?'),
                            content: const Text(
                              'Are you sure you want to delete this task?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && task.id != null) {
                          await notifier.deleteTask(task.id!);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cardColor,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white12 : Colors.grey.shade300,
                          width: 1,
                        ),
                        elevation: 2,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFEF5350),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a row for displaying detail info (due date, priority)
  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isPriority,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: isDark ? Colors.white54 : Colors.black54, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        const Spacer(),
        if (!isPriority)
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.red[900] : const Color(0xFFF9E8E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFEF5350).withOpacity(0.5),
                width: 0.5,
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFFEF5350),
              ),
            ),
          ),
      ],
    );
  }
}
