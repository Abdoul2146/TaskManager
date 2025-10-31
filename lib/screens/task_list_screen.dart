import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'add_new_task.dart';
import 'task_detail_screen.dart';
import '../providers/theme_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the task list state (including loading/error/data)
    final taskState = ref.watch(taskListProvider);
    final search = ref.watch(searchProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Show loading indicator while tasks are being loaded
    if (taskState.status == TaskListStatus.loading) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'My Tasks',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF4C8DFF)),
          ),
          actions: [
            // Theme toggle button (sun/moon)
            IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.wb_sunny_rounded
                    : Icons.nights_stay,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              tooltip: themeMode == ThemeMode.dark ? 'Light mode' : 'Dark mode',
              onPressed: () {
                final notifier = ref.read(themeModeProvider.notifier);
                notifier.setTheme(
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
            ),
            const SizedBox(width: 12),
          ],
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 24,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error message if loading tasks failed
    if (taskState.status == TaskListStatus.error) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'My Tasks',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF4C8DFF)),
          ),
          actions: [
            IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.wb_sunny_rounded
                    : Icons.nights_stay,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              tooltip: themeMode == ThemeMode.dark ? 'Light mode' : 'Dark mode',
              onPressed: () {
                final notifier = ref.read(themeModeProvider.notifier);
                notifier.setTheme(
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
            ),
            const SizedBox(width: 12),
          ],
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 24,
        ),
        body: Center(
          child: Text(
            'Error: ${taskState.error}',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Filter tasks based on search query (case-insensitive, matches title or description)
    final filteredTasks = taskState.tasks.where((task) {
      final query = search.toLowerCase();
      return task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'My Tasks',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: const Color(0xFF4C8DFF)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.wb_sunny_rounded
                  : Icons.nights_stay,
              color: themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            tooltip: themeMode == ThemeMode.dark ? 'Light mode' : 'Dark mode',
            onPressed: () {
              final notifier = ref.read(themeModeProvider.notifier);
              notifier.setTheme(
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          const SizedBox(width: 12),
        ],
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 24,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            TaskSearchBar(),
            const SizedBox(height: 24),
            // Show placeholder if no tasks, else show filtered list
            if (filteredTasks.isEmpty)
              const EmptyTaskListPlaceholder()
            else
              ...filteredTasks.map((task) => TaskListItem(task: task)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add new task screen, then reload tasks on return
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewTaskScreen()),
          );
          ref.read(taskListProvider.notifier).loadTasks();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class TaskSearchBar extends ConsumerWidget {
  const TaskSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE0E5F0),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: (value) => ref.read(searchProvider.notifier).state = value,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xFFA5B0C2),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white54 : const Color(0xFFA5B0C2),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 0,
          ),
          filled: true,
          fillColor: cardColor,
        ),
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }
}

class EmptyTaskListPlaceholder extends StatelessWidget {
  const EmptyTaskListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder image for empty state
            Image.asset('assets/no_task.png', width: 200, height: 250),
            const SizedBox(height: 30),
            Text(
              'Tap on the + button to add task',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListItem extends ConsumerWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // Navigate to task detail screen, then reload tasks on return
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
        );
        ref.read(taskListProvider.notifier).loadTasks();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // Only show shadow in light mode for better dark mode appearance
              if (Theme.of(context).brightness == Brightness.light)
                BoxShadow(
                  color: Colors.grey.shade500.withOpacity(0.08),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Checkbox for marking task as complete/incomplete
              GestureDetector(
                onTap: () async {
                  await ref
                      .read(taskListProvider.notifier)
                      .updateTask(
                        task.copyWith(isCompleted: !task.isCompleted),
                      );
                },
                child: Icon(
                  task.isCompleted
                      ? Icons.check_box
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted
                      ? const Color(0xFF78C37C)
                      : Colors.black54,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Task title (strikethrough if completed)
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Show "Overdue" label if task is past due and not completed
                        if (task.dueDate != null &&
                            task.dueDate!.isBefore(DateTime.now()) &&
                            !task.isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Overdue',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        // Delete button for removing the task
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
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
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true && task.id != null) {
                              await ref
                                  .read(taskListProvider.notifier)
                                  .deleteTask(task.id!);
                            }
                          },
                        ),
                      ],
                    ),
                    // Show description if present
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          task.description,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          // Priority badge with color based on priority
                          if (task.priority.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: task.priority == 'High'
                                    ? Colors.red
                                    : task.priority == 'Medium'
                                    ? Colors.yellow[700]
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.priority,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          // Show due date if present
                          if (task.dueDate != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
