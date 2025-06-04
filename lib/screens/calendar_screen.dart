import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/theme.dart';
import '../utils/weton_calculator.dart'; // <--- TAMBAHKAN IMPORT INI
import '../models/weton_model.dart';   // <--- TAMBAHKAN IMPORT INI (jika ingin akses modelnya langsung)

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // final Map<DateTime, List<String>> _events = {}; // Komentari atau hapus jika tidak digunakan
  Map<DateTime, List<dynamic>> _events = {}; // Ubah tipe jika ingin menyimpan WetonModel atau objek lain

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsForMonth(_focusedDay); // Panggil untuk bulan awal
  }

  // Ubah _loadEvents menjadi lebih dinamis atau sesuai kebutuhan
  // Fungsi ini sekarang hanya contoh, idealnya Anda punya sumber data hari baik yang sebenarnya.
  void _loadEventsForMonth(DateTime month) {
    // Simulasi memuat event (hari baik) untuk bulan tertentu
    // Dalam aplikasi nyata, ini mungkin akan mengambil data dari database atau API
    // atau berdasarkan perhitungan primbon yang lebih kompleks.
    // Untuk sekarang, kita biarkan kosong atau dengan contoh statis jika diperlukan.
    // Contoh:
    // _events[DateTime(month.year, month.month, 3)] = ['Pernikahan'];
    // _events[DateTime(month.year, month.month, 5)] = ['Pindah Rumah'];
    setState(() {}); // Refresh UI jika ada perubahan event
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Normalisasi hari untuk menghindari masalah dengan jam, menit, detik
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Jawa'),
        centerTitle: true,
      ),
      body: Container( // Hapus child: dari Container ini jika tidak diperlukan
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
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
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    // Panggil _loadEventsForMonth jika Anda ingin memuat event per bulan
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
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    titleCentered: true,
                  ),
                ),
              ),
            ),

            // Event List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Hari',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedDay != null) ...[
                      Text(
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_selectedDay!), // Tambahkan locale 'id_ID'
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getWetonForDate(_selectedDay!), // <--- INI AKAN DIPERBAIKI
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold, // Tambahkan bold agar lebih terlihat
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Events for selected day
                      Text(
                        'Hari Baik Untuk:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: _getEventsForDay(_selectedDay!).isNotEmpty
                            ? ListView.builder(
                                itemCount: _getEventsForDay(_selectedDay!).length,
                                itemBuilder: (context, index) {
                                  final event = _getEventsForDay(_selectedDay!)[index];
                                  // Asumsikan event adalah String, sesuaikan jika tipe datanya beda
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.event_available,
                                        color: AppColors.primary,
                                      ),
                                      title: Text(event is String ? event : event.toString()), // Tampilkan event
                                      subtitle: Text('Cocok untuk aktivitas ini'),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'Tidak ada aktivitas khusus yang tercatat untuk hari ini.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi yang diperbaiki untuk mendapatkan Weton
  String _getWetonForDate(DateTime date) {
    // Menggunakan WetonCalculator yang sudah ada
    final WetonModel weton = WetonCalculator.calculateWeton(date);
    return '${weton.dayName} ${weton.pasaranName} (Neptu: ${weton.totalNeptu})';
  }
}