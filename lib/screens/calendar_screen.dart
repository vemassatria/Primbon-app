import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/theme.dart';
import '../utils/weton_calculator.dart';
import '../models/weton_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEventsForMonth(_focusedDay);
    });
  }

  void _loadEventsForMonth(DateTime month) {
    final newEvents = <DateTime, List<dynamic>>{};
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    for (DateTime day = firstDayOfMonth;
        day.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      final weton = WetonCalculator.calculateWeton(day);
      List<String> activities = [];

      if (weton.totalNeptu >= 14) {
        activities.addAll(['Mengadakan Acara Besar', 'Upacara Adat']);
      }
      if (weton.pasaranName == 'Legi') {
        activities.addAll(['Memulai Usaha Baru', 'Perdagangan']);
      }
      if (weton.dayName == 'Jumat' && weton.pasaranName == 'Kliwon') {
        activities.addAll(['Ritual Spiritual', 'Ziarah']);
      }
      if (weton.dayName == 'Senin' || weton.dayName == 'Kamis') {
        activities.add('Puasa Sunnah');
      }
      if (weton.goodDays.contains('Selasa')) {
        activities.add('Melakukan Perjalanan Jauh');
      }

      switch (weton.dayName) {
        case 'Minggu':
          activities.add('Istirahat dan Berkumpul Keluarga');
          break;
        case 'Rabu':
          activities.add('Memulai Proyek Penting');
          break;
      }

      if (activities.isNotEmpty) {
        DateTime normalizedDay = DateTime(day.year, day.month, day.day);
        newEvents[normalizedDay] = activities;
      }
    }

    if (newEvents.isNotEmpty ||
        _events.keys.where((key) => key.month == month.month && key.year == month.year).isEmpty) {
      setState(() {
        Map<DateTime, List<dynamic>> updatedEvents = {..._events};
        updatedEvents.removeWhere((key, _) => key.month == month.month && key.year == month.year);
        updatedEvents.addAll(newEvents);
        _events = updatedEvents;
      });
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  String _getWetonForDate(DateTime date) {
    final weton = WetonCalculator.calculateWeton(date);
    return '${weton.dayName} ${weton.pasaranName} (Neptu: ${weton.totalNeptu})';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Jawa'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() => _calendarFormat = format);
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  _loadEventsForMonth(focusedDay);
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  canMarkersOverflow: true,
                  markersMaxCount: 1,
                ),
                headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  titleCentered: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedDay != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Hari Terpilih:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDay!),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _getWetonForDate(_selectedDay!),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hari Baik Untuk:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _getEventsForDay(_selectedDay!).isNotEmpty
                          ? ListView.builder(
                              itemCount: _getEventsForDay(_selectedDay!).length,
                              itemBuilder: (context, index) {
                                final event = _getEventsForDay(_selectedDay!)[index];
                                return Card(
                                  elevation: 1.5,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.goodDayColor,
                                    ),
                                    title: Text(event.toString()),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: Colors.grey[400], size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tidak ada aktivitas khusus yang tercatat\n'
                                    'untuk hari ini berdasarkan perhitungan sederhana.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ] else
                    const Center(child: Text('Pilih tanggal untuk melihat informasi hari.')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
