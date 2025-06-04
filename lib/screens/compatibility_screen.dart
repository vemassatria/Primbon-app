import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';
import '../utils/weton_calculator.dart';
import '../models/compatibility_model.dart';
import '../widgets/compatibility_result_card.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({Key? key}) : super(key: key);

  @override
  _CompatibilityScreenState createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');
  
  CompatibilityModel? _compatibilityResult;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kecocokan Jodoh'),
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
                            'Hitung Kecocokan Jodoh',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          
                          // Person 1
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.loveColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pasangan Pertama',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.loveColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Nama
                                TextFormField(
                                  controller: _name1Controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama',
                                    hintText: 'Masukkan nama',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                
                                // Tanggal Lahir
                                GestureDetector(
                                  onTap: () => _selectDate(context, 1),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Tanggal Lahir',
                                        hintText: 'Pilih tanggal lahir',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      controller: TextEditingController(
                                        text: _selectedDate1 != null
                                            ? _dateFormat.format(_selectedDate1!)
                                            : '',
                                      ),
                                      validator: (value) {
                                        if (_selectedDate1 == null) {
                                          return 'Tanggal lahir harus diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Person 2
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pasangan Kedua',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Nama
                                TextFormField(
                                  controller: _name2Controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama',
                                    hintText: 'Masukkan nama',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                
                                // Tanggal Lahir
                                GestureDetector(
                                  onTap: () => _selectDate(context, 2),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Tanggal Lahir',
                                        hintText: 'Pilih tanggal lahir',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      controller: TextEditingController(
                                        text: _selectedDate2 != null
                                            ? _dateFormat.format(_selectedDate2!)
                                            : '',
                                      ),
                                      validator: (value) {
                                        if (_selectedDate2 == null) {
                                          return 'Tanggal lahir harus diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Calculate Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _calculateCompatibility,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.loveColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Hitung Kecocokan'),
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
                if (_showResult && _compatibilityResult != null)
                  CompatibilityResultCard(compatibility: _compatibilityResult!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, int person) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: person == 1 ? _selectedDate1 ?? DateTime.now() : _selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: person == 1 ? AppColors.loveColor : Colors.blue,
              onPrimary: Colors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (person == 1) {
          _selectedDate1 = picked;
        } else {
          _selectedDate2 = picked;
        }
      });
    }
  }

  void _calculateCompatibility() {
    if (_formKey.currentState!.validate()) {
      // Calculate compatibility based on birth dates
      final result = WetonCalculator.calculateCompatibility(
        _name1Controller.text,
        _selectedDate1!,
        _name2Controller.text,
        _selectedDate2!,
      );
      
      setState(() {
        _compatibilityResult = result;
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
