import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../core/design_system.dart';
import '../../providers/user_provider.dart';
import '../../data/database_helper.dart';
import '../../data/models.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  void _loadNote() async {
    final provider = context.read<UserProvider>();
    final note = await DatabaseHelper.instance.getNote(provider.currentUser!.id!, provider.selectedDate);
    _noteController.text = note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Spiritual Calendar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassContainer(
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: provider.selectedDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(provider.selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  provider.setSelectedDate(selectedDay);
                  _loadNote();
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDailySummary(provider),
            const SizedBox(height: 20),
            _buildNoteSection(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary(UserProvider provider) {
    final target = provider.calculateDailyTarget(provider.selectedDate);
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Count', provider.dailyCount.toString()),
          _buildStat('Target', target.toString()),
          _buildStat('Progress', '${(provider.progress * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildNoteSection(UserProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daily Reflection / Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'How was your connection with Allah today?',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (val) {
            DatabaseHelper.instance.saveNote(DailyNote(
              userId: provider.currentUser!.id!,
              date: provider.selectedDate,
              content: val,
            ));
          },
        ),
      ],
    );
  }
}
