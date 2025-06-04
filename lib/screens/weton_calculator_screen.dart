// screens/weton_calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';
import '../utils/weton_calculator.dart';
import '../models/weton_model.dart';
import '../widgets/weton_result_card.dart';

class WetonCalculatorScreen extends StatefulWidget {
  const WetonCalculatorScreen({Key? key}) : super(key: key);

  @override
  _WetonCalculatorScreenState createState() => _WetonCalculatorScreenState();
}

class _WetonCalculatorScreenState extends State<WetonCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');
  
  WetonModel? _wetonResult;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('Selected Date: $_selectedDate');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Weton'),
        centerTitle: true,
      ),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Input Form
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masukkan Tanggal Lahir',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          
                          // Nama
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              hintText: 'Masukkan nama lengkap',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Tanggal Lahir
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Tanggal Lahir',
                                  hintText: 'Pilih tanggal lahir',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text: _selectedDate != null
                                      ? _dateFormat.format(_selectedDate!)
                                      : '',
                                ),
                                validator: (value) {
                                  if (_selectedDate == null) {
                                    return 'Tanggal lahir harus diisi';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Jam Lahir (opsional)
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Jam Lahir (opsional)',
                                  hintText: 'Pilih jam lahir',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                                controller: TextEditingController(
                                  text: _selectedTime != null
                                      ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                      : '',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '* Jam lahir digunakan untuk perhitungan yang lebih detail',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Calculate Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _calculateWeton,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Hitung Weton'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Results
                if (_showResult && _wetonResult != null)
                  WetonResultCard(weton: _wetonResult!, name: _nameController.text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _calculateWeton() {
    if (_formKey.currentState!.validate()) {
      // Calculate weton based on birth date
      final result = WetonCalculator.calculateWeton(_selectedDate!);
      
      setState(() {
        _wetonResult = result;
        _showResult = true;
      });
      
      // Scroll to results
      Future.delayed(Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(
          _formKey.currentContext!,
          alignment: 0.0,
          duration: Duration(milliseconds: 400),
        );
      });
    }
  }
}