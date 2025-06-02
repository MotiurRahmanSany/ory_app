import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:ory/core/common/widgets/shimmer_loader.dart';
import 'package:ory/core/utils/utils.dart';
import 'package:ory/features/scheduler/presentation/schedule_controller.dart';
import 'package:ory/features/scheduler/presentation/event_details_screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/common/widgets/animated_ai_logo.dart';
import '../../../core/services/ai_scheduler_service.dart';
import '../models/calendar_event.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _taskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> _generateSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);

    ref.read(scheduleProvider.notifier).setLoading(true);
    try {
      // Get existing events for the selected day
      final existingEvents =
          ref.read(scheduleProvider).events[_selectedDay!] ?? [];

      // Use the AI Scheduler Service to get a suggestion
      final aiService = AISchedulerService();
      printLog.w('Generating schedule for ${_taskController.text}');
      final suggestion = await aiService.getScheduleSuggestion(
        userPrompt: _taskController.text,
        existingEvents: existingEvents,
      );
      printLog.i('Generated suggestion: $suggestion');
      // Convert the suggestion into a CalendarEvent
      final event = CalendarEvent(
        title: suggestion.title,
        description: suggestion.description,
        startTime: suggestion.startTime,
        endTime: suggestion.endTime,
        date: suggestion.date,
        reason: suggestion.reason,
        color: Colors.blue, // or adjust based on suggestion if needed
      );
      ref.read(scheduleProvider.notifier).addEvent(_selectedDay!, event);
    } catch (e) {
      Logger().e('Failed to generate schedule: ${e.toString()}');
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to generate schedule: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      ref.read(scheduleProvider.notifier).setLoading(false);
      _taskController.clear();
    }
  }

  void _deleteEvent(CalendarEvent event) {
    if (_selectedDay == null) return;
    ref.read(scheduleProvider.notifier).deleteEvent(_selectedDay!, event);
  }

  void _instructToSelectDate() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Please select a date from the calendar'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _showScheduleTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Task To Complete'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _taskController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Describe your task',
                    hintText:
                        'e.g. "Need 2 hours for project meeting tomorrow"',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(DateFormat('MMM dd, yyyy').format(_selectedDay!)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _generateSchedule();
              },
              child: const Text('Generate Schedule'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleProvider);
    final selectedDateEvents =
        _selectedDay != null ? scheduleState.events[_selectedDay!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedAiLogo(isAnimating: false, size: 35),
            const SizedBox(width: 8),
            const Text('Sync Me'),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body:
          scheduleState.isLoading
              ? ShimmerLoader(loadingText: 'Loading your schedule...')
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    Text(
                      'let AI organize your tasks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: _focusedDay,
                        selectedDayPredicate:
                            (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Scheduled Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (selectedDateEvents.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedDateEvents.length,
                        itemBuilder: (context, index) {
                          final event = selectedDateEvents[index];
                          return _ScheduleEventItem(
                            event: event,
                            onDelete: () => _deleteEvent(event),
                          );
                        },
                      ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            _selectedDay != null
                ? _showScheduleTaskDialog
                : _instructToSelectDate,
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Schedule Task'),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(Icons.schedule, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No tasks scheduled',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}

class _ScheduleEventItem extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback onDelete;

  const _ScheduleEventItem({required this.event, required this.onDelete});

  String _formatTime(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(width: 4, height: 40, color: event.color),
        title: Text(event.title),
        subtitle: Text(
          '${_formatTime(event.startTime, context)} - ${_formatTime(event.endTime, context)}',
        ),
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
          onSelected: (_) => onDelete(),
        ),
        onTap: () {
          EventDetailsScreen.route(context, event);
        },
      ),
    );
  }
}
