// lib/screens/task_list_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'login_screen.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  final _taskService = TaskService();
  final _authService = AuthService();

  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String _userEmail = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserAndTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndTasks() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      setState(() => _userEmail = user.username ?? '');
    }
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final result = await _taskService.getTasks();
    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _tasks = List<TaskModel>.from(result['tasks'] ?? []);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to load tasks'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  List<TaskModel> get _filteredTasks {
    switch (_tabController.index) {
      case 1:
        return _tasks.where((t) => !t.isCompleted).toList();
      case 2:
        return _tasks.where((t) => t.isCompleted).toList();
      default:
        return _tasks;
    }
  }

  Future<void> _openAddTask() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TaskFormScreen(),
    );
    if (result == true) {
      _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created! ✅')),
        );
      }
    }
  }

  Future<void> _openEditTask(TaskModel task) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskFormScreen(task: task),
    );
    if (result == true) {
      _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated! ✏️')),
        );
      }
    }
  }

  Future<void> _toggleTask(TaskModel task) async {
    // Optimistic update
    setState(() {
      final idx = _tasks.indexWhere((t) => t.objectId == task.objectId);
      if (idx != -1) {
        _tasks[idx] = task.copyWith(isCompleted: !task.isCompleted);
      }
    });

    final result = await _taskService.toggleTaskCompletion(task);
    if (result['success'] != true) {
      // Revert on failure
      setState(() {
        final idx = _tasks.indexWhere((t) => t.objectId == task.objectId);
        if (idx != -1) _tasks[idx] = task;
      });
    }
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Task?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"? This cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Optimistic remove
    final backup = List<TaskModel>.from(_tasks);
    setState(() => _tasks.removeWhere((t) => t.objectId == task.objectId));

    final result = await _taskService.deleteTask(task.objectId!);
    if (result['success'] != true) {
      setState(() => _tasks = backup);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to delete'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted 🗑️')),
      );
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Sign Out?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'You will be returned to the login screen.',
          style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  // ── UI ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pending = _tasks.where((t) => !t.isCompleted).length;
    final done = _tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Tasks',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            if (_userEmail.isNotEmpty)
              Text(
                _userEmail,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadTasks,
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.textPrimary),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppTheme.textPrimary,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats strip
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  _StatChip(
                    label: 'Total',
                    value: _tasks.length,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Pending',
                    value: pending,
                    color: const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    label: 'Done',
                    value: done,
                    color: AppTheme.completedColor,
                  ),
                ],
              ),
            ),
          ),

          // Tab bar
          Container(
            color: AppTheme.surface,
            child: TabBar(
              controller: _tabController,
              onTap: (_) => setState(() {}),
              labelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Done'),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  )
                : _filteredTasks.isEmpty
                    ? _EmptyState(tabIndex: _tabController.index)
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        color: AppTheme.primary,
                        child: AnimationLimiter(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: _filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = _filteredTasks[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50,
                                  child: FadeInAnimation(
                                    child: TaskCard(
                                      task: task,
                                      onToggle: () => _toggleTask(task),
                                      onEdit: () => _openEditTask(task),
                                      onDelete: () => _deleteTask(task),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Task',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int tabIndex;

  const _EmptyState({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final messages = [
      ('🎯', 'No tasks yet', 'Tap the button below to add your first task!'),
      ('✅', 'All done!', 'No pending tasks — great job!'),
      (
        '📭',
        'Nothing completed',
        'Complete some tasks and they will appear here.',
      ),
    ];
    final (emoji, title, sub) = messages[tabIndex];

    return Center(
      child: FadeInUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
