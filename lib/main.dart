import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FsocietyAlarmApp());
}

class FsocietyAlarmApp extends StatelessWidget {
  const FsocietyAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSOCIETY Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0C),
        primaryColor: const Color(0xFF00FF66),
      ),
      home: const AlarmHomeScreen(),
    );
  }
}

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 07, minute: 00);
  bool _isAlarmActive = false;
  Timer? _ticker;
  String _currentTimeStr = "";

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _currentTimeStr =
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      });

      // Проверка срабатывания будильника
      if (_isAlarmActive &&
          now.hour == _selectedTime.hour &&
          now.minute == _selectedTime.minute &&
          now.second == 0) {
        _triggerAlarm();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _triggerAlarm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AlarmRingingScreen(),
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00FF66),
              surface: Color(0xFF14151B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Шапка
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "FSOCIETY // ALARM",
                    style: TextStyle(
                      color: Color(0xFF00FF66),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14151B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.3)),
                    ),
                    child: Text(
                      _currentTimeStr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Карточка настройки времени
              Center(
                child: GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14151B),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _isAlarmActive
                            ? const Color(0xFF00FF66)
                            : Colors.white12,
                        width: 1.5,
                      ),
                      boxShadow: _isAlarmActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00FF66).withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "TARGET TIME",
                          style: TextStyle(
                            color: Colors.white38,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Нажмите, чтобы изменить",
                          style: TextStyle(color: Color(0xFF00FF66), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Тумблер включения
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14151B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          color: _isAlarmActive ? const Color(0xFF00FF66) : Colors.white38,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(
                              _isAlarmActive ? "БУДИЛЬНИК АКТИВЕН" : "БУДИЛЬНИК ВЫКЛЮЧЕН",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const Text(
                              "Защита математическим примером",
                              style: TextStyle(color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _isAlarmActive,
                      activeColor: const Color(0xFF00FF66),
                      onChanged: (val) {
                        setState(() {
                          _isAlarmActive = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Экран срабатывания будильника (Ringing Screen)
class AlarmRingingScreen extends StatefulWidget {
  const AlarmRingingScreen({super.key});

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen> {
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  final TextEditingController _answerController = TextEditingController();
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    final rng = Random();
    _num1 = rng.nextInt(40) + 10; // Генерация чисел от 10 до 49
    _num2 = rng.nextInt(40) + 10;
    _correctAnswer = _num1 + _num2;
  }

  void _checkAnswer() {
    int? userAns = int.tryParse(_answerController.text.trim());
    if (userAns == _correctAnswer) {
      Navigator.of(context).pop(); // Выключаем будильник (закрываем экран)
    } else {
      setState(() {
        _errorMessage = "Неверно! Попробуй еще раз.";
        _answerController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF180A0A), // Тёмно-красный фон предупреждения
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.alarm_on, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                "WAKE UP // WAKE UP",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'monospace',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Решите пример, чтобы отключить сигнал:",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Карточка с примером
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF14151B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Column(
                  children: [
                    Text(
                      "$_num1 + $_num2 = ?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _answerController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF00FF66),
                        fontSize: 24,
                        fontFamily: 'monospace',
                      ),
                      decoration: InputDecoration(
                        hintText: "Ответ",
                        hintStyle: const TextStyle(color: Colors.white24),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "ОТКЛЮЧИТЬ СИГНАЛ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
