import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddNewTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const AddNewTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends ConsumerState<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and fields with existing task data if editing
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedPriority = widget.task?.priority ?? 'Medium';
    _selectedDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Opens a date picker dialog and updates the selected date if user picks one.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Validates the form and saves the task (add or update).
  void _saveTask() async {
    if (_formKey.currentState?.validate() != true) return;
    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      dueDate: _selectedDate,
      priority: _selectedPriority,
    );
    final notifier = ref.read(taskListProvider.notifier);
    if (widget.task == null) {
      // Add new task
      await notifier.addTask(task);
    } else {
      // Update existing task
      await notifier.updateTask(task);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        // Use themed color for back button and title
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4C8DFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.task == null ? 'Add New Task' : 'Edit Task',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Task Title', textTheme, isDark),
                    const SizedBox(height: 8),
                    // Title input field
                    TextFormField(
                      controller: _titleController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                      decoration: InputDecoration(
                        hintText: 'e.g., Finish UI design plan',
                        filled: true,
                        fillColor: cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Description', textTheme, isDark),
                    const SizedBox(height: 8),
                    // Description input field
                    TextFormField(
                      controller: _descController,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Add a description...',
                        filled: true,
                        fillColor: cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Priority', textTheme, isDark),
                    const SizedBox(height: 12),
                    // Priority selection row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['Low', 'Medium', 'High'].map((priority) {
                        bool isSelected = _selectedPriority == priority;
                        Color priorityColor;
                        if (priority == 'High') {
                          priorityColor = Colors.red;
                        } else if (priority == 'Medium') {
                          priorityColor = Colors.yellow[700]!;
                        } else {
                          priorityColor = Colors.blue;
                        }
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: priority == 'High' ? 0 : 10.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPriority = priority;
                                });
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? priorityColor : cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? priorityColor
                                        : (isDark
                                              ? Colors.white12
                                              : const Color(0xFFE0E0E0)),
                                  ),
                                ),
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: isSelected
                                        ? (priority == 'Medium'
                                              ? Colors.black
                                              : Colors.white)
                                        : (isDark
                                              ? Colors.white
                                              : Colors.black87),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Due Date', textTheme, isDark),
                    const SizedBox(height: 8),
                    // Due date picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? Colors.white12
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: isDark ? Colors.white54 : Colors.black54,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate == null
                                  ? 'Select a date'
                                  : DateFormat(
                                      'MMM d, yyyy',
                                    ).format(_selectedDate!),
                              style: TextStyle(
                                color: _selectedDate == null
                                    ? (isDark ? Colors.white54 : Colors.grey)
                                    : (isDark ? Colors.white : Colors.black87),
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Save/Update button at the bottom
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
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    widget.task == null ? 'Save Task' : 'Update Task',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build section labels with theme-aware color
  Widget _buildLabel(String text, TextTheme textTheme, bool isDark) {
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
