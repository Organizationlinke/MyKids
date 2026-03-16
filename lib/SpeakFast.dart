// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // // // // // import 'dart:async';

// // // // // // // // // // ==========================================
// // // // // // // // // // 1. الإعدادات والربط مع Supabase
// // // // // // // // // // تم استخدام بياناتك المرفقة
// // // // // // // // // // ==========================================
// // // // // // // // // // const String supabaseUrl = 'https://qsvhdpitcljewzqjqhbe.supabase.co';
// // // // // // // // // // const String supabaseAnnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzdmhkcGl0Y2xqZXd6cWpxaGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDYwMTksImV4cCI6MjA2OTUyMjAxOX0.YH-RR0w03qgYcpHQM-eygczVuheNljrbvXm6i-9uSwM';

// // // // // // // // // // void main() async {
// // // // // // // // // //   WidgetsFlutterBinding.ensureInitialized();

// // // // // // // // // //   await Supabase.initialize(
// // // // // // // // // //     url: supabaseUrl,
// // // // // // // // // //     anonKey: supabaseAnnonKey,
// // // // // // // // // //   );

// // // // // // // // // //   runApp(const SpeakFastApp());
// // // // // // // // // // }

// // // // // // // // // class SpeakFastApp extends StatelessWidget {
// // // // // // // // //   const SpeakFastApp({super.key});

// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     return MaterialApp(
// // // // // // // // //       title: 'SpeakFast',
// // // // // // // // //       theme: ThemeData(
// // // // // // // // //         primarySwatch: Colors.indigo,
// // // // // // // // //         scaffoldBackgroundColor: Colors.grey[100],
// // // // // // // // //         fontFamily: 'Roboto',
// // // // // // // // //       ),
// // // // // // // // //       home: const ScenariosScreen(),
// // // // // // // // //       debugShowCheckedModeBanner: false,
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 2. شاشة السيناريوهات (الصفحة الرئيسية)
// // // // // // // // // // ==========================================
// // // // // // // // // class ScenariosScreen extends StatefulWidget {
// // // // // // // // //   const ScenariosScreen({super.key});

// // // // // // // // //   @override
// // // // // // // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // // // // // // }

// // // // // // // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // // // //   List<dynamic> _scenarios = [];
// // // // // // // // //   bool _isLoading = true;

// // // // // // // // //   @override
// // // // // // // // //   void initState() {
// // // // // // // // //     super.initState();
// // // // // // // // //     _fetchScenarios();
// // // // // // // // //   }

// // // // // // // // //   Future<void> _fetchScenarios() async {
// // // // // // // // //     try {
// // // // // // // // //       final response = await _supabase.from('AA_scenarios').select();
// // // // // // // // //       setState(() {
// // // // // // // // //         _scenarios = response;
// // // // // // // // //         _isLoading = false;
// // // // // // // // //       });
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint('Error: $e');
// // // // // // // // //     }
// // // // // // // // //   }

// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     return Scaffold(
// // // // // // // // //       appBar: AppBar(
// // // // // // // // //         title: const Text('SpeakFast Training', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // // //         centerTitle: true,
// // // // // // // // //         elevation: 0,
// // // // // // // // //       ),
// // // // // // // // //       body: _isLoading
// // // // // // // // //           ? const Center(child: CircularProgressIndicator())
// // // // // // // // //           : ListView.builder(
// // // // // // // // //               padding: const EdgeInsets.all(16),
// // // // // // // // //               itemCount: _scenarios.length,
// // // // // // // // //               itemBuilder: (context, index) {
// // // // // // // // //                 final scenario = _scenarios[index];
// // // // // // // // //                 return Card(
// // // // // // // // //                   elevation: 2,
// // // // // // // // //                   margin: const EdgeInsets.only(bottom: 12),
// // // // // // // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // // // // // // // //                   child: ListTile(
// // // // // // // // //                     contentPadding: const EdgeInsets.all(16),
// // // // // // // // //                     leading: CircleAvatar(
// // // // // // // // //                       backgroundColor: Colors.indigo[100],
// // // // // // // // //                       child: const Icon(Icons.chat_bubble_outline, color: Colors.indigo),
// // // // // // // // //                     ),
// // // // // // // // //                     title: Text(scenario['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
// // // // // // // // //                     subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // // // // // // //                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // // // //                     onTap: () {
// // // // // // // // //                       Navigator.push(
// // // // // // // // //                         context,
// // // // // // // // //                         MaterialPageRoute(
// // // // // // // // //                           builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // // // // // // //                         ),
// // // // // // // // //                       );
// // // // // // // // //                     },
// // // // // // // // //                   ),
// // // // // // // // //                 );
// // // // // // // // //               },
// // // // // // // // //             ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }

// // // // // // // // // // ==========================================
// // // // // // // // // // 3. شاشة التدريب (المنطق الأساسي للتطبيق)
// // // // // // // // // // ==========================================
// // // // // // // // // enum TrainingState { reading, rapidFire, retelling, finished }

// // // // // // // // // class TrainingScreen extends StatefulWidget {
// // // // // // // // //   final int scenarioId;
// // // // // // // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // // // // // // //   @override
// // // // // // // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // // // // // // }

// // // // // // // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // // // // // // //   final _supabase = Supabase.instance.client;

// // // // // // // // //   TrainingState _currentState = TrainingState.reading;

// // // // // // // // //   Map<String, dynamic>? _paragraph;
// // // // // // // // //   List<dynamic> _questions = [];
// // // // // // // // //   int _currentQuestionIndex = 0;

// // // // // // // // //   Timer? _timer;
// // // // // // // // //   int _timeLeft = 0;
// // // // // // // // //   int _hesitationCount = 0; // لحساب التلعثم

// // // // // // // // //   bool _isLoading = true;

// // // // // // // // //   @override
// // // // // // // // //   void initState() {
// // // // // // // // //     super.initState();
// // // // // // // // //     _fetchTrainingData();
// // // // // // // // //   }

// // // // // // // // //   Future<void> _fetchTrainingData() async {
// // // // // // // // //     try {
// // // // // // // // //       // جلب الفقرة
// // // // // // // // //       final paraResponse = await _supabase
// // // // // // // // //           .from('AA_paragraphs')
// // // // // // // // //           .select()
// // // // // // // // //           .eq('scenario_id', widget.scenarioId)
// // // // // // // // //           .single();

// // // // // // // // //       // جلب الأسئلة
// // // // // // // // //       final quesResponse = await _supabase
// // // // // // // // //           .from('AA_questions')
// // // // // // // // //           .select()
// // // // // // // // //           .eq('paragraph_id', paraResponse['id'])
// // // // // // // // //           .order('id', ascending: true);

// // // // // // // // //       setState(() {
// // // // // // // // //         _paragraph = paraResponse;
// // // // // // // // //         _questions = quesResponse;
// // // // // // // // //         _isLoading = false;
// // // // // // // // //       });
// // // // // // // // //     } catch (e) {
// // // // // // // // //       debugPrint('Error: $e');
// // // // // // // // //     }
// // // // // // // // //   }

// // // // // // // // //   void _startRapidFire() {
// // // // // // // // //     setState(() {
// // // // // // // // //       _currentState = TrainingState.rapidFire;
// // // // // // // // //       _currentQuestionIndex = 0;
// // // // // // // // //       _hesitationCount = 0;
// // // // // // // // //     });
// // // // // // // // //     _askCurrentQuestion();
// // // // // // // // //   }

// // // // // // // // //   void _askCurrentQuestion() {
// // // // // // // // //     if (_currentQuestionIndex >= _questions.length) {
// // // // // // // // //       // انتهت الأسئلة، ننتقل لإعادة سرد القصة
// // // // // // // // //       setState(() {
// // // // // // // // //         _currentState = TrainingState.retelling;
// // // // // // // // //       });
// // // // // // // // //       return;
// // // // // // // // //     }

// // // // // // // // //     final currentQues = _questions[_currentQuestionIndex];
// // // // // // // // //     setState(() {
// // // // // // // // //       _timeLeft = currentQues['time_limit_seconds'] ?? 5;
// // // // // // // // //     });

// // // // // // // // //     _timer?.cancel();
// // // // // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// // // // // // // // //       setState(() {
// // // // // // // // //         if (_timeLeft > 0) {
// // // // // // // // //           _timeLeft--;
// // // // // // // // //         } else {
// // // // // // // // //           // انتهى الوقت = تلعثم/تأخير
// // // // // // // // //           _timer?.cancel();
// // // // // // // // //           _hesitationCount++;
// // // // // // // // //           _showPressureMessage();
// // // // // // // // //         }
// // // // // // // // //       });
// // // // // // // // //     });
// // // // // // // // //   }

// // // // // // // // //   void _showPressureMessage() {
// // // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // // //       const SnackBar(
// // // // // // // // //         content: Text('Faster please! Think in English!', style: TextStyle(fontSize: 16)),
// // // // // // // // //         backgroundColor: Colors.redAccent,
// // // // // // // // //         duration: Duration(seconds: 1),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //     // الانتقال للسؤال التالي حتى لو لم يجب (يخلق ضغطاً)
// // // // // // // // //     _nextQuestion();
// // // // // // // // //   }

// // // // // // // // //   void _nextQuestion() {
// // // // // // // // //     _timer?.cancel();
// // // // // // // // //     setState(() {
// // // // // // // // //       _currentQuestionIndex++;
// // // // // // // // //     });
// // // // // // // // //     _askCurrentQuestion();
// // // // // // // // //   }

// // // // // // // // //   // محاكاة للإجابة الصوتية (يُستبدل بـ speech_to_text لاحقاً)
// // // // // // // // //   void _simulateVoiceAnswer() {
// // // // // // // // //     _nextQuestion();
// // // // // // // // //   }

// // // // // // // // //   @override
// // // // // // // // //   void dispose() {
// // // // // // // // //     _timer?.cancel();
// // // // // // // // //     super.dispose();
// // // // // // // // //   }

// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     if (_isLoading) {
// // // // // // // // //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
// // // // // // // // //     }

// // // // // // // // //     return Scaffold(
// // // // // // // // //       appBar: AppBar(
// // // // // // // // //         title: const Text('Training Session'),
// // // // // // // // //         backgroundColor: _currentState == TrainingState.rapidFire ? Colors.red[800] : Colors.indigo,
// // // // // // // // //       ),
// // // // // // // // //       body: SafeArea(
// // // // // // // // //         child: Padding(
// // // // // // // // //           padding: const EdgeInsets.all(24.0),
// // // // // // // // //           child: Column(
// // // // // // // // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // // // // // //             children: [
// // // // // // // // //               if (_currentState == TrainingState.reading) _buildReadingPhase(),
// // // // // // // // //               if (_currentState == TrainingState.rapidFire) _buildRapidFirePhase(),
// // // // // // // // //               if (_currentState == TrainingState.retelling) _buildRetellingPhase(),
// // // // // // // // //             ],
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   // 1. مرحلة القراءة والفهم
// // // // // // // // //   Widget _buildReadingPhase() {
// // // // // // // // //     return Expanded(
// // // // // // // // //       child: Column(
// // // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // // //         children: [
// // // // // // // // //           const Icon(Icons.menu_book, size: 60, color: Colors.indigo),
// // // // // // // // //           const SizedBox(height: 20),
// // // // // // // // //           const Text('Read & Understand', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// // // // // // // // //           const SizedBox(height: 20),
// // // // // // // // //           Container(
// // // // // // // // //             padding: const EdgeInsets.all(20),
// // // // // // // // //             decoration: BoxDecoration(
// // // // // // // // //               color: Colors.white,
// // // // // // // // //               borderRadius: BorderRadius.circular(15),
// // // // // // // // //               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
// // // // // // // // //             ),
// // // // // // // // //             child: Text(
// // // // // // // // //               _paragraph!['content'],
// // // // // // // // //               style: const TextStyle(fontSize: 20, height: 1.5),
// // // // // // // // //               textAlign: TextAlign.center,
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //           const Spacer(),
// // // // // // // // //           ElevatedButton(
// // // // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // // // //               padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // // // // //               backgroundColor: Colors.indigo,
// // // // // // // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// // // // // // // // //             ),
// // // // // // // // //             onPressed: _startRapidFire,
// // // // // // // // //             child: const Text('Start Rapid Questions', style: TextStyle(fontSize: 18, color: Colors.white)),
// // // // // // // // //           )
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   // 2. مرحلة الضغط والأسئلة السريعة
// // // // // // // // //   Widget _buildRapidFirePhase() {
// // // // // // // // //     final currentQues = _questions[_currentQuestionIndex];
// // // // // // // // //     return Expanded(
// // // // // // // // //       child: Column(
// // // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // // //         children: [
// // // // // // // // //           Text('Question ${_currentQuestionIndex + 1} / ${_questions.length}',
// // // // // // // // //               style: const TextStyle(fontSize: 16, color: Colors.grey)),
// // // // // // // // //           const SizedBox(height: 20),

// // // // // // // // //           // التايمر (الضغط)
// // // // // // // // //           Stack(
// // // // // // // // //             alignment: Alignment.center,
// // // // // // // // //             children: [
// // // // // // // // //               SizedBox(
// // // // // // // // //                 width: 100,
// // // // // // // // //                 height: 100,
// // // // // // // // //                 child: CircularProgressIndicator(
// // // // // // // // //                   value: _timeLeft / (currentQues['time_limit_seconds'] ?? 5),
// // // // // // // // //                   strokeWidth: 10,
// // // // // // // // //                   backgroundColor: Colors.grey[300],
// // // // // // // // //                   color: _timeLeft <= 2 ? Colors.red : Colors.green,
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //               Text('$_timeLeft', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
// // // // // // // // //             ],
// // // // // // // // //           ),
// // // // // // // // //           const SizedBox(height: 40),

// // // // // // // // //           Text(
// // // // // // // // //             currentQues['question_text'],
// // // // // // // // //             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// // // // // // // // //             textAlign: TextAlign.center,
// // // // // // // // //           ),
// // // // // // // // //           const Spacer(),

// // // // // // // // //           // زر التحدث (Hold to speak)
// // // // // // // // //           GestureDetector(
// // // // // // // // //             onTapDown: (_) => print("بدأ التسجيل"), // هنا نضع كود بدأ التسجيل
// // // // // // // // //             onTapUp: (_) => _simulateVoiceAnswer(), // هنا نضع كود إيقاف التسجيل والتحقق
// // // // // // // // //             child: Container(
// // // // // // // // //               height: 80,
// // // // // // // // //               width: 80,
// // // // // // // // //               decoration: BoxDecoration(
// // // // // // // // //                 color: Colors.red[600],
// // // // // // // // //                 shape: BoxShape.circle,
// // // // // // // // //                 boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
// // // // // // // // //               ),
// // // // // // // // //               child: const Icon(Icons.mic, color: Colors.white, size: 40),
// // // // // // // // //             ),
// // // // // // // // //           ),
// // // // // // // // //           const SizedBox(height: 20),
// // // // // // // // //           const Text('Hold to Speak', style: TextStyle(color: Colors.grey)),
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   // 3. مرحلة إعادة سرد القصة (تختبر القدرة على الإنتاج الكامل)
// // // // // // // // //   Widget _buildRetellingPhase() {
// // // // // // // // //     return Expanded(
// // // // // // // // //       child: Column(
// // // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // // //         children: [
// // // // // // // // //           const Icon(Icons.record_voice_over, size: 80, color: Colors.indigo),
// // // // // // // // //           const SizedBox(height: 30),
// // // // // // // // //           const Text('Retell the Story', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// // // // // // // // //           const SizedBox(height: 15),
// // // // // // // // //           const Text(
// // // // // // // // //             'In your own words, what happened?',
// // // // // // // // //             style: TextStyle(fontSize: 18, color: Colors.grey),
// // // // // // // // //           ),
// // // // // // // // //           const SizedBox(height: 40),
// // // // // // // // //           Text(
// // // // // // // // //             'Hesitations during questions: $_hesitationCount',
// // // // // // // // //             style: TextStyle(fontSize: 18, color: _hesitationCount > 2 ? Colors.red : Colors.green),
// // // // // // // // //           ),
// // // // // // // // //           const Spacer(),
// // // // // // // // //           ElevatedButton.icon(
// // // // // // // // //             icon: const Icon(Icons.mic, color: Colors.white),
// // // // // // // // //             label: const Text('Start Recording', style: TextStyle(color: Colors.white)),
// // // // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // // // //               padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // // // // //               backgroundColor: Colors.indigo,
// // // // // // // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// // // // // // // // //             ),
// // // // // // // // //             onPressed: () {
// // // // // // // // //               // هنا ينتهي التدريب وتظهر شاشة النتيجة
// // // // // // // // //               Navigator.pop(context);
// // // // // // // // //             },
// // // // // // // // //           )
// // // // // // // // //         ],
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // // // // import 'package:flutter_tts/flutter_tts.dart'; // حزمة الصوت
// // // // // // // // import 'package:google_generative_ai/google_generative_ai.dart'; // حزمة جيميناي
// // // // // // // // import 'dart:async';
// // // // // // // // import 'dart:convert';

// // // // // // // // // ==========================================
// // // // // // // // // 1. الإعدادات ومفاتيح الـ API
// // // // // // // // // ==========================================

// // // // // // // // // ضع مفتاح Gemini API الخاص بك هنا
// // // // // // // // const String aaa1='AIzaSyCzfQLh';
// // // // // // // // const String aaa2='hE3HsAFlRtCFVny';
// // // // // // // // const String aaa3='3JPaVNAS-c5E';
// // // // // // // // const String geminiApiKey ='$aaa1$aaa2$aaa3';
// // // // // // // // const String geminiModel = 'gemini-2.5-flash';

// // // // // // // // class SpeakFastApp extends StatelessWidget {
// // // // // // // //   const SpeakFastApp({super.key});

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return MaterialApp(
// // // // // // // //       title: 'SpeakFast',
// // // // // // // //       theme: ThemeData(
// // // // // // // //         primarySwatch: Colors.indigo,
// // // // // // // //         scaffoldBackgroundColor: Colors.grey[100],
// // // // // // // //         fontFamily: 'Roboto',
// // // // // // // //       ),
// // // // // // // //       home: const ScenariosScreen(),
// // // // // // // //       debugShowCheckedModeBanner: false,
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 2. شاشة السيناريوهات (الرئيسية)
// // // // // // // // // ==========================================
// // // // // // // // class ScenariosScreen extends StatefulWidget {
// // // // // // // //   const ScenariosScreen({super.key});

// // // // // // // //   @override
// // // // // // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // // // // // }

// // // // // // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // // //   List<dynamic> _scenarios = [];
// // // // // // // //   bool _isLoading = true;

// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     _fetchScenarios();
// // // // // // // //   }

// // // // // // // //   Future<void> _fetchScenarios() async {
// // // // // // // //     try {
// // // // // // // //       final response = await _supabase.from('AA_scenarios').select();
// // // // // // // //       setState(() {
// // // // // // // //         _scenarios = response;
// // // // // // // //         _isLoading = false;
// // // // // // // //       });
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error: $e');
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: AppBar(
// // // // // // // //         title: const Text('SpeakFast Training', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // //         centerTitle: true,
// // // // // // // //         elevation: 0,
// // // // // // // //         actions: [
// // // // // // // //           // زر للانتقال لشاشة توليد المحتوى بالذكاء الاصطناعي
// // // // // // // //           IconButton(
// // // // // // // //             icon: const Icon(Icons.auto_awesome),
// // // // // // // //             tooltip: 'توليد بالذكاء الاصطناعي',
// // // // // // // //             onPressed: () async {
// // // // // // // //               await Navigator.push(
// // // // // // // //                 context,
// // // // // // // //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// // // // // // // //               );
// // // // // // // //               _fetchScenarios(); // تحديث القائمة بعد العودة
// // // // // // // //             },
// // // // // // // //           )
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //       body: _isLoading
// // // // // // // //           ? const Center(child: CircularProgressIndicator())
// // // // // // // //           : _scenarios.isEmpty
// // // // // // // //               ? const Center(child: Text('لا توجد سيناريوهات، قم بتوليد بعضها من زر النجمة بالأعلى!'))
// // // // // // // //               : ListView.builder(
// // // // // // // //               padding: const EdgeInsets.all(16),
// // // // // // // //               itemCount: _scenarios.length,
// // // // // // // //               itemBuilder: (context, index) {
// // // // // // // //                 final scenario = _scenarios[index];
// // // // // // // //                 return Card(
// // // // // // // //                   elevation: 2,
// // // // // // // //                   margin: const EdgeInsets.only(bottom: 12),
// // // // // // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // // // // // // //                   child: ListTile(
// // // // // // // //                     contentPadding: const EdgeInsets.all(16),
// // // // // // // //                     leading: CircleAvatar(
// // // // // // // //                       backgroundColor: Colors.indigo[100],
// // // // // // // //                       child: const Icon(Icons.chat_bubble_outline, color: Colors.indigo),
// // // // // // // //                     ),
// // // // // // // //                     title: Text(scenario['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
// // // // // // // //                     subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // // // // // //                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // // //                     onTap: () {
// // // // // // // //                       Navigator.push(
// // // // // // // //                         context,
// // // // // // // //                         MaterialPageRoute(
// // // // // // // //                           builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // // // // // //                         ),
// // // // // // // //                       );
// // // // // // // //                     },
// // // // // // // //                   ),
// // // // // // // //                 );
// // // // // // // //               },
// // // // // // // //             ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 3. شاشة التدريب (المنطق الأساسي + الصوت)
// // // // // // // // // ==========================================
// // // // // // // // enum TrainingState { reading, rapidFire, retelling, finished }

// // // // // // // // class TrainingScreen extends StatefulWidget {
// // // // // // // //   final int scenarioId;
// // // // // // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // // // // // //   @override
// // // // // // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // // // // // }

// // // // // // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // // //   final FlutterTts flutterTts = FlutterTts(); // تهيئة محرك الصوت

// // // // // // // //   TrainingState _currentState = TrainingState.reading;

// // // // // // // //   Map<String, dynamic>? _paragraph;
// // // // // // // //   List<dynamic> _questions = [];
// // // // // // // //   int _currentQuestionIndex = 0;

// // // // // // // //   Timer? _timer;
// // // // // // // //   int _timeLeft = 0;
// // // // // // // //   int _hesitationCount = 0;

// // // // // // // //   bool _isLoading = true;

// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     _initTts();
// // // // // // // //     _fetchTrainingData();
// // // // // // // //   }

// // // // // // // //   // إعدادات الصوت الإنجليزية
// // // // // // // //   Future<void> _initTts() async {
// // // // // // // //     await flutterTts.setLanguage("en-US");
// // // // // // // //     await flutterTts.setSpeechRate(0.5); // سرعة مناسبة للمتعلمين
// // // // // // // //     await flutterTts.setVolume(1.0);
// // // // // // // //     await flutterTts.setPitch(1.0);
// // // // // // // //   }

// // // // // // // //   Future<void> _speakText(String text) async {
// // // // // // // //     await flutterTts.speak(text);
// // // // // // // //   }

// // // // // // // //   Future<void> _stopSpeaking() async {
// // // // // // // //     await flutterTts.stop();
// // // // // // // //   }

// // // // // // // //   Future<void> _fetchTrainingData() async {
// // // // // // // //     try {
// // // // // // // //       final paraResponse = await _supabase
// // // // // // // //           .from('AA_paragraphs')
// // // // // // // //           .select()
// // // // // // // //           .eq('scenario_id', widget.scenarioId)
// // // // // // // //           .single();

// // // // // // // //       final quesResponse = await _supabase
// // // // // // // //           .from('AA_questions')
// // // // // // // //           .select()
// // // // // // // //           .eq('paragraph_id', paraResponse['id'])
// // // // // // // //           .order('id', ascending: true);

// // // // // // // //       setState(() {
// // // // // // // //         _paragraph = paraResponse;
// // // // // // // //         _questions = quesResponse;
// // // // // // // //         _isLoading = false;
// // // // // // // //       });
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error: $e');
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   void _startRapidFire() async {
// // // // // // // //     await _stopSpeaking(); // إيقاف أي صوت شغال
// // // // // // // //     setState(() {
// // // // // // // //       _currentState = TrainingState.rapidFire;
// // // // // // // //       _currentQuestionIndex = 0;
// // // // // // // //       _hesitationCount = 0;
// // // // // // // //     });
// // // // // // // //     _askCurrentQuestion();
// // // // // // // //   }

// // // // // // // //   void _askCurrentQuestion() {
// // // // // // // //     if (_currentQuestionIndex >= _questions.length) {
// // // // // // // //       setState(() {
// // // // // // // //         _currentState = TrainingState.retelling;
// // // // // // // //       });
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     final currentQues = _questions[_currentQuestionIndex];
// // // // // // // //     setState(() {
// // // // // // // //       _timeLeft = currentQues['time_limit_seconds'] ?? 5;
// // // // // // // //     });

// // // // // // // //     // نطق السؤال تلقائياً عند ظهوره
// // // // // // // //     _speakText(currentQues['question_text']);

// // // // // // // //     _timer?.cancel();
// // // // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// // // // // // // //       setState(() {
// // // // // // // //         if (_timeLeft > 0) {
// // // // // // // //           _timeLeft--;
// // // // // // // //         } else {
// // // // // // // //           _timer?.cancel();
// // // // // // // //           _hesitationCount++;
// // // // // // // //           _showPressureMessage();
// // // // // // // //         }
// // // // // // // //       });
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _showPressureMessage() {
// // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //       const SnackBar(
// // // // // // // //         content: Text('Faster please! Think in English!', style: TextStyle(fontSize: 16)),
// // // // // // // //         backgroundColor: Colors.redAccent,
// // // // // // // //         duration: Duration(seconds: 1),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //     _nextQuestion();
// // // // // // // //   }

// // // // // // // //   void _nextQuestion() async {
// // // // // // // //     await _stopSpeaking();
// // // // // // // //     _timer?.cancel();
// // // // // // // //     setState(() {
// // // // // // // //       _currentQuestionIndex++;
// // // // // // // //     });
// // // // // // // //     _askCurrentQuestion();
// // // // // // // //   }

// // // // // // // //   void _simulateVoiceAnswer() {
// // // // // // // //     _nextQuestion();
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   void dispose() {
// // // // // // // //     _timer?.cancel();
// // // // // // // //     flutterTts.stop();
// // // // // // // //     super.dispose();
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     if (_isLoading) {
// // // // // // // //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
// // // // // // // //     }

// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: AppBar(
// // // // // // // //         title: const Text('Training Session'),
// // // // // // // //         backgroundColor: _currentState == TrainingState.rapidFire ? Colors.red[800] : Colors.indigo,
// // // // // // // //       ),
// // // // // // // //       body: SafeArea(
// // // // // // // //         child: Padding(
// // // // // // // //           padding: const EdgeInsets.all(24.0),
// // // // // // // //           child: Column(
// // // // // // // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // // // // //             children: [
// // // // // // // //               if (_currentState == TrainingState.reading) _buildReadingPhase(),
// // // // // // // //               if (_currentState == TrainingState.rapidFire) _buildRapidFirePhase(),
// // // // // // // //               if (_currentState == TrainingState.retelling) _buildRetellingPhase(),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildReadingPhase() {
// // // // // // // //     return Expanded(
// // // // // // // //       child: Column(
// // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //         children: [
// // // // // // // //           const Icon(Icons.menu_book, size: 60, color: Colors.indigo),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           const Text('Read & Understand', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           Container(
// // // // // // // //             padding: const EdgeInsets.all(20),
// // // // // // // //             decoration: BoxDecoration(
// // // // // // // //               color: Colors.white,
// // // // // // // //               borderRadius: BorderRadius.circular(15),
// // // // // // // //               boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
// // // // // // // //             ),
// // // // // // // //             child: Column(
// // // // // // // //               children: [
// // // // // // // //                 Text(
// // // // // // // //                   _paragraph!['content'],
// // // // // // // //                   style: const TextStyle(fontSize: 20, height: 1.5),
// // // // // // // //                   textAlign: TextAlign.center,
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 15),
// // // // // // // //                 // زر الاستماع للنص
// // // // // // // //                 IconButton(
// // // // // // // //                   icon: const Icon(Icons.volume_up, size: 35, color: Colors.indigo),
// // // // // // // //                   onPressed: () => _speakText(_paragraph!['content']),
// // // // // // // //                 ),
// // // // // // // //                 const Text('استمع للقصة', style: TextStyle(color: Colors.grey)),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           const Spacer(),
// // // // // // // //           ElevatedButton(
// // // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // // //               padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // // // //               backgroundColor: Colors.indigo,
// // // // // // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// // // // // // // //             ),
// // // // // // // //             onPressed: _startRapidFire,
// // // // // // // //             child: const Text('Start Rapid Questions', style: TextStyle(fontSize: 18, color: Colors.white)),
// // // // // // // //           )
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildRapidFirePhase() {
// // // // // // // //     final currentQues = _questions[_currentQuestionIndex];
// // // // // // // //     return Expanded(
// // // // // // // //       child: Column(
// // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //         children: [
// // // // // // // //           Text('Question ${_currentQuestionIndex + 1} / ${_questions.length}',
// // // // // // // //               style: const TextStyle(fontSize: 16, color: Colors.grey)),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           Stack(
// // // // // // // //             alignment: Alignment.center,
// // // // // // // //             children: [
// // // // // // // //               SizedBox(
// // // // // // // //                 width: 100,
// // // // // // // //                 height: 100,
// // // // // // // //                 child: CircularProgressIndicator(
// // // // // // // //                   value: _timeLeft / (currentQues['time_limit_seconds'] ?? 5),
// // // // // // // //                   strokeWidth: 10,
// // // // // // // //                   backgroundColor: Colors.grey[300],
// // // // // // // //                   color: _timeLeft <= 2 ? Colors.red : Colors.green,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               Text('$_timeLeft', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 40),
// // // // // // // //           Text(
// // // // // // // //             currentQues['question_text'],
// // // // // // // //             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// // // // // // // //             textAlign: TextAlign.center,
// // // // // // // //           ),
// // // // // // // //           // زر إعادة نطق السؤال إذا احتاجه المستخدم
// // // // // // // //           IconButton(
// // // // // // // //             icon: const Icon(Icons.replay_circle_filled, color: Colors.indigo, size: 40),
// // // // // // // //             onPressed: () => _speakText(currentQues['question_text']),
// // // // // // // //           ),
// // // // // // // //           const Spacer(),
// // // // // // // //           GestureDetector(
// // // // // // // //             onTapDown: (_) => print("بدأ التسجيل"),
// // // // // // // //             onTapUp: (_) => _simulateVoiceAnswer(),
// // // // // // // //             child: Container(
// // // // // // // //               height: 80,
// // // // // // // //               width: 80,
// // // // // // // //               decoration: BoxDecoration(
// // // // // // // //                 color: Colors.red[600],
// // // // // // // //                 shape: BoxShape.circle,
// // // // // // // //                 boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
// // // // // // // //               ),
// // // // // // // //               child: const Icon(Icons.mic, color: Colors.white, size: 40),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           const Text('Hold to Speak', style: TextStyle(color: Colors.grey)),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildRetellingPhase() {
// // // // // // // //     return Expanded(
// // // // // // // //       child: Column(
// // // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //         children: [
// // // // // // // //           const Icon(Icons.record_voice_over, size: 80, color: Colors.indigo),
// // // // // // // //           const SizedBox(height: 30),
// // // // // // // //           const Text('Retell the Story', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// // // // // // // //           const SizedBox(height: 15),
// // // // // // // //           const Text(
// // // // // // // //             'In your own words, what happened?',
// // // // // // // //             style: TextStyle(fontSize: 18, color: Colors.grey),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 40),
// // // // // // // //           Text(
// // // // // // // //             'Hesitations during questions: $_hesitationCount',
// // // // // // // //             style: TextStyle(fontSize: 18, color: _hesitationCount > 2 ? Colors.red : Colors.green),
// // // // // // // //           ),
// // // // // // // //           const Spacer(),
// // // // // // // //           ElevatedButton.icon(
// // // // // // // //             icon: const Icon(Icons.mic, color: Colors.white),
// // // // // // // //             label: const Text('Finish Recording', style: TextStyle(color: Colors.white)),
// // // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // // //               padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // // // //               backgroundColor: Colors.indigo,
// // // // // // // //             ),
// // // // // // // //             onPressed: () {
// // // // // // // //               Navigator.pop(context);
// // // // // // // //             },
// // // // // // // //           )
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // // ==========================================
// // // // // // // // // 4. شاشة توليد البيانات باستخدام جيميناي
// // // // // // // // // ==========================================
// // // // // // // // class AIGeneratorScreen extends StatefulWidget {
// // // // // // // //   const AIGeneratorScreen({super.key});

// // // // // // // //   @override
// // // // // // // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // // // // // // }

// // // // // // // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // // //   bool _isGenerating = false;
// // // // // // // //   String _statusMessage = 'اضغط على الزر لتوليد سيناريو جديد بالذكاء الاصطناعي';

// // // // // // // //   Future<void> _generateAndSaveData() async {
// // // // // // // //     if (geminiApiKey == '$aaa1$aaa2$aaa3') {
// // // // // // // //       setState(() => _statusMessage = 'خطأ: يرجى وضع مفتاح API الخاص بجيميناي في الكود!');
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     setState(() {
// // // // // // // //       _isGenerating = true;
// // // // // // // //       _statusMessage = 'جاري الاتصال بجيميناي وتأليف القصة...';
// // // // // // // //     });

// // // // // // // //     try {
// // // // // // // //       // 1. الاتصال بـ Gemini
// // // // // // // //       final model = GenerativeModel(model: geminiModel, apiKey: geminiApiKey);

// // // // // // // //       // نطلب منه إرجاع JSON صالح فقط ليسهل حفضه في قاعدة البيانات
// // // // // // // //       final prompt = '''
// // // // // // // //       Act as an expert English language teacher. Generate a single English learning scenario.
// // // // // // // //       Respond ONLY with a valid JSON object matching this exact structure, nothing else:
// // // // // // // //       {
// // // // // // // //         "title": "Scenario title (e.g. At the Restaurant)",
// // // // // // // //         "category": "Daily Life or Travel or Work",
// // // // // // // //         "difficulty": "Beginner or Intermediate",
// // // // // // // //         "paragraph": "A 3-sentence short story about the topic.",
// // // // // // // //         "questions": [
// // // // // // // //           {"text": "Fact question 1?", "type": "fact", "time": 4},
// // // // // // // //           {"text": "Fact question 2?", "type": "fact", "time": 4},
// // // // // // // //           {"text": "Rephrase question 1?", "type": "rephrase", "time": 3},
// // // // // // // //           {"text": "Rephrase question 2?", "type": "rephrase", "time": 3},
// // // // // // // //           {"text": "Personal question 1?", "type": "personal", "time": 8},
// // // // // // // //           {"text": "Personal question 2?", "type": "personal", "time": 8}
// // // // // // // //         ]
// // // // // // // //       }
// // // // // // // //       ''';

// // // // // // // //       final content = [Content.text(prompt)];
// // // // // // // //       final response = await model.generateContent(content);

// // // // // // // //       String responseText = response.text ?? '';
// // // // // // // //       // تنظيف النص في حال أعاد جيميناي علامات ```json
// // // // // // // //       responseText = responseText.replaceAll('```json', '').replaceAll('```', '').trim();

// // // // // // // //       setState(() => _statusMessage = 'تم التأليف! جاري الحفظ في قاعدة البيانات...');

// // // // // // // //       // 2. تحويل الرد إلى Map (JSON)
// // // // // // // //       final data = json.decode(responseText);

// // // // // // // //       // 3. الحفظ في جدول AA_scenarios
// // // // // // // //       final scenarioRes = await _supabase.from('AA_scenarios').insert({
// // // // // // // //         'title': data['title'],
// // // // // // // //         'category': data['category'],
// // // // // // // //         'difficulty': data['difficulty'],
// // // // // // // //       }).select().single();

// // // // // // // //       final int scenarioId = scenarioRes['id'];

// // // // // // // //       // 4. الحفظ في جدول AA_paragraphs
// // // // // // // //       final paragraphRes = await _supabase.from('AA_paragraphs').insert({
// // // // // // // //         'scenario_id': scenarioId,
// // // // // // // //         'content': data['paragraph'],
// // // // // // // //       }).select().single();

// // // // // // // //       final int paragraphId = paragraphRes['id'];

// // // // // // // //       // 5. الحفظ في جدول AA_questions
// // // // // // // //       final List<Map<String, dynamic>> questionsToInsert = [];
// // // // // // // //       for (var q in data['questions']) {
// // // // // // // //         questionsToInsert.add({
// // // // // // // //           'paragraph_id': paragraphId,
// // // // // // // //           'question_text': q['text'],
// // // // // // // //           'question_type': q['type'],
// // // // // // // //           'time_limit_seconds': q['time'],
// // // // // // // //         });
// // // // // // // //       }
// // // // // // // //       await _supabase.from('AA_questions').insert(questionsToInsert);

// // // // // // // //       setState(() {
// // // // // // // //         _isGenerating = false;
// // // // // // // //         _statusMessage = 'تم توليد وحفظ السيناريو بنجاح! 🎉';
// // // // // // // //       });

// // // // // // // //     } catch (e) {
// // // // // // // //       setState(() {
// // // // // // // //         _isGenerating = false;
// // // // // // // //         _statusMessage = 'حدث خطأ: $e';
// // // // // // // //       });
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: AppBar(title: const Text('AI Data Generator')),
// // // // // // // //       body: Center(
// // // // // // // //         child: Padding(
// // // // // // // //           padding: const EdgeInsets.all(20.0),
// // // // // // // //           child: Column(
// // // // // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //             children: [
// // // // // // // //               const Icon(Icons.smart_toy, size: 100, color: Colors.indigo),
// // // // // // // //               const SizedBox(height: 30),
// // // // // // // //               Text(
// // // // // // // //                 _statusMessage,
// // // // // // // //                 textAlign: TextAlign.center,
// // // // // // // //                 style: const TextStyle(fontSize: 18),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 40),
// // // // // // // //               if (_isGenerating)
// // // // // // // //                 const CircularProgressIndicator()
// // // // // // // //               else
// // // // // // // //                 ElevatedButton.icon(
// // // // // // // //                   icon: const Icon(Icons.auto_awesome, color: Colors.white),
// // // // // // // //                   label: const Text('توليد سيناريو جديد', style: TextStyle(color: Colors.white, fontSize: 18)),
// // // // // // // //                   style: ElevatedButton.styleFrom(
// // // // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
// // // // // // // //                     backgroundColor: Colors.indigo,
// // // // // // // //                   ),
// // // // // // // //                   onPressed: _generateAndSaveData,
// // // // // // // //                 ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // // // import 'package:flutter_tts/flutter_tts.dart';
// // // // // // // import 'package:google_generative_ai/google_generative_ai.dart';
// // // // // // // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // // // // // // import 'dart:async';
// // // // // // // import 'dart:convert';
// // // // // // // import 'package:flutter/foundation.dart' show kIsWeb;

// // // // // // // // ==========================================
// // // // // // // // 1. الإعدادات ومفاتيح الـ API
// // // // // // // // ==========================================
// // // // // // // const String aaa1='AIzaSyCzfQLh';
// // // // // // // const String aaa2='hE3HsAFlRtCFVny';
// // // // // // // const String aaa3='3JPaVNAS-c5E';
// // // // // // // const String geminiApiKey = '$aaa1$aaa2$aaa3'; // ضع مفتاحك هنا
// // // // // // // const String geminiModel = 'gemini-2.5-flash';

// // // // // // // void main() async {
// // // // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // // // //   // ملاحظة: تأكد من إضافة إعدادات Supabase هنا
// // // // // // //   runApp(const SpeakFastApp());
// // // // // // // }

// // // // // // // class SpeakFastApp extends StatelessWidget {
// // // // // // //   const SpeakFastApp({super.key});

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return MaterialApp(
// // // // // // //       title: 'SpeakFast AI - Web Version',
// // // // // // //       theme: ThemeData(
// // // // // // //         useMaterial3: true,
// // // // // // //         colorSchemeSeed: Colors.indigo,
// // // // // // //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// // // // // // //       ),
// // // // // // //       home: const ScenariosScreen(),
// // // // // // //       debugShowCheckedModeBanner: false,
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 2. شاشة السيناريوهات الرئيسية
// // // // // // // // ==========================================
// // // // // // // class ScenariosScreen extends StatefulWidget {
// // // // // // //   const ScenariosScreen({super.key});

// // // // // // //   @override
// // // // // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // // // // }

// // // // // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // //   List<dynamic> _scenarios = [];
// // // // // // //   bool _isLoading = true;

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _fetchScenarios();
// // // // // // //   }

// // // // // // //   Future<void> _fetchScenarios() async {
// // // // // // //     try {
// // // // // // //       final response = await _supabase.from('AA_scenarios').select().order('id', ascending: false);
// // // // // // //       if (mounted) {
// // // // // // //         setState(() {
// // // // // // //           _scenarios = response;
// // // // // // //           _isLoading = false;
// // // // // // //         });
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Error fetching scenarios: $e');
// // // // // // //     }
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return Scaffold(
// // // // // // //       appBar: AppBar(
// // // // // // //         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // // //         centerTitle: true,
// // // // // // //         actions: [
// // // // // // //           IconButton(
// // // // // // //             icon: const Icon(Icons.auto_awesome),
// // // // // // //             tooltip: 'Generate with AI',
// // // // // // //             onPressed: () async {
// // // // // // //               await Navigator.push(
// // // // // // //                 context,
// // // // // // //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// // // // // // //               );
// // // // // // //               _fetchScenarios();
// // // // // // //             },
// // // // // // //           )
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       body: _isLoading
// // // // // // //           ? const Center(child: CircularProgressIndicator())
// // // // // // //           : RefreshIndicator(
// // // // // // //               onRefresh: _fetchScenarios,
// // // // // // //               child: _scenarios.isEmpty
// // // // // // //                   ? const Center(child: Text('Generate your first scenario using AI!'))
// // // // // // //                   : ListView.builder(
// // // // // // //                       padding: const EdgeInsets.all(16),
// // // // // // //                       itemCount: _scenarios.length,
// // // // // // //                       itemBuilder: (context, index) {
// // // // // // //                         final scenario = _scenarios[index];
// // // // // // //                         return Card(
// // // // // // //                           margin: const EdgeInsets.only(bottom: 12),
// // // // // // //                           elevation: 0,
// // // // // // //                           shape: RoundedRectangleBorder(
// // // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // // //                             side: BorderSide(color: Colors.grey.shade200),
// // // // // // //                           ),
// // // // // // //                           child: ListTile(
// // // // // // //                             contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // // // // // //                             title: Text(scenario['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // // // //                             subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // // // // //                             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // //                             onTap: () => Navigator.push(
// // // // // // //                               context,
// // // // // // //                               MaterialPageRoute(
// // // // // // //                                 builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         );
// // // // // // //                       },
// // // // // // //                     ),
// // // // // // //             ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 3. شاشة التدريب - محسنة للويب
// // // // // // // // ==========================================
// // // // // // // enum TrainingState { reading, rapidFire, finished }

// // // // // // // class TrainingScreen extends StatefulWidget {
// // // // // // //   final int scenarioId;
// // // // // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // // // // //   @override
// // // // // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // // // // }

// // // // // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // //   final FlutterTts flutterTts = FlutterTts();
// // // // // // //   final stt.SpeechToText _speech = stt.SpeechToText();

// // // // // // //   TrainingState _currentState = TrainingState.reading;
// // // // // // //   Map<String, dynamic>? _paragraph;
// // // // // // //   List<dynamic> _questions = [];
// // // // // // //   int _currentQuestionIndex = 0;

// // // // // // //   bool _isListening = false;
// // // // // // //   String _lastWords = "";
// // // // // // //   Timer? _timer;
// // // // // // //   int _timeLeft = 0;
// // // // // // //   bool _isSpeechInitialized = false;
// // // // // // //   bool _isTtsReady = false;

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _initTts();
// // // // // // //     _fetchTrainingData();
// // // // // // //   }

// // // // // // //   Future<void> _initTts() async {
// // // // // // //     try {
// // // // // // //       await flutterTts.setLanguage("en-US");
// // // // // // //       await flutterTts.setSpeechRate(0.5);
// // // // // // //       await flutterTts.setVolume(1.0);
// // // // // // //       if (mounted) setState(() => _isTtsReady = true);
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('TTS Initialization Error: $e');
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // تهيئة الصوت عند الحاجة (Lazy Init) لتجنب مشاكل الويب
// // // // // // //   Future<bool> _ensureSpeechReady() async {
// // // // // // //     if (_isSpeechInitialized) return true;
// // // // // // //     try {
// // // // // // //       bool available = await _speech.initialize(
// // // // // // //         onStatus: (status) => debugPrint('Speech Status: $status'),
// // // // // // //         onError: (error) => debugPrint('Speech Error: $error'),
// // // // // // //         finalTimeout: const Duration(milliseconds: 1500),
// // // // // // //       );
// // // // // // //       if (mounted) setState(() => _isSpeechInitialized = available);
// // // // // // //       return available;
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Speech Init Error: $e');
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> _fetchTrainingData() async {
// // // // // // //     try {
// // // // // // //       final para = await _supabase.from('AA_paragraphs').select().eq('scenario_id', widget.scenarioId).single();
// // // // // // //       final ques = await _supabase.from('AA_questions').select().eq('paragraph_id', para['id']).order('id', ascending: true);
// // // // // // //       if (mounted) {
// // // // // // //         setState(() {
// // // // // // //           _paragraph = para;
// // // // // // //           _questions = ques;
// // // // // // //         });
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Fetch Error: $e');
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void _listen() async {
// // // // // // //     bool ready = await _ensureSpeechReady();
// // // // // // //     if (!ready) return;

// // // // // // //     if (!_isListening) {
// // // // // // //       setState(() => _isListening = true);
// // // // // // //       _speech.listen(
// // // // // // //         onResult: (val) {
// // // // // // //           if (mounted) {
// // // // // // //             setState(() {
// // // // // // //               _lastWords = val.recognizedWords;
// // // // // // //               if (val.finalResult) {
// // // // // // //                 _isListening = false;
// // // // // // //                 // تأخير بسيط قبل الانتقال للسؤال التالي للسماح للمستخدم برؤية إجابته
// // // // // // //                 Future.delayed(const Duration(milliseconds: 800), () => _nextQuestion());
// // // // // // //               }
// // // // // // //             });
// // // // // // //           }
// // // // // // //         },
// // // // // // //       );
// // // // // // //     } else {
// // // // // // //       setState(() => _isListening = false);
// // // // // // //       _speech.stop();
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void _startRapidFire() {
// // // // // // //     setState(() {
// // // // // // //       _currentState = TrainingState.rapidFire;
// // // // // // //       _currentQuestionIndex = 0;
// // // // // // //     });
// // // // // // //     // تأخير بسيط لضمان انتهاء الفوكس والأنيميشن قبل بدء التحدث
// // // // // // //     Future.delayed(const Duration(milliseconds: 300), () => _askQuestion());
// // // // // // //   }

// // // // // // //   void _askQuestion() {
// // // // // // //     if (_currentQuestionIndex >= _questions.length) {
// // // // // // //       if (mounted) setState(() => _currentState = TrainingState.finished);
// // // // // // //       return;
// // // // // // //     }

// // // // // // //     final q = _questions[_currentQuestionIndex];
// // // // // // //     if (mounted) {
// // // // // // //       setState(() {
// // // // // // //         _timeLeft = q['time_limit_seconds'] ?? 5;
// // // // // // //         _lastWords = "";
// // // // // // //       });
// // // // // // //     }

// // // // // // //     if (_isTtsReady) {
// // // // // // //       flutterTts.speak(q['question_text']);
// // // // // // //     }

// // // // // // //     _timer?.cancel();
// // // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // // // //       if (!mounted) {
// // // // // // //         t.cancel();
// // // // // // //         return;
// // // // // // //       }
// // // // // // //       if (_timeLeft > 0) {
// // // // // // //         setState(() => _timeLeft--);
// // // // // // //       } else {
// // // // // // //         t.cancel();
// // // // // // //         _nextQuestion();
// // // // // // //       }
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _nextQuestion() {
// // // // // // //     _timer?.cancel();
// // // // // // //     _speech.stop();
// // // // // // //     if (mounted) {
// // // // // // //       setState(() {
// // // // // // //         _isListening = false;
// // // // // // //         _currentQuestionIndex++;
// // // // // // //       });
// // // // // // //       _askQuestion();
// // // // // // //     }
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   void dispose() {
// // // // // // //     _timer?.cancel();
// // // // // // //     flutterTts.stop();
// // // // // // //     _speech.stop();
// // // // // // //     super.dispose();
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

// // // // // // //     return Scaffold(
// // // // // // //       appBar: AppBar(title: Text(_currentState == TrainingState.rapidFire ? 'Rapid Fire' : 'Read & Prepare')),
// // // // // // //       body: Center(
// // // // // // //         child: Container(
// // // // // // //           constraints: const BoxConstraints(maxWidth: 600), // تحسين العرض للويب
// // // // // // //           padding: const EdgeInsets.all(24),
// // // // // // //           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildReading() {
// // // // // // //     return Column(
// // // // // // //       children: [
// // // // // // //         Expanded(
// // // // // // //           child: Container(
// // // // // // //             padding: const EdgeInsets.all(20),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: Colors.white,
// // // // // // //               borderRadius: BorderRadius.circular(16),
// // // // // // //               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
// // // // // // //             ),
// // // // // // //             child: SingleChildScrollView(
// // // // // // //               child: Text(
// // // // // // //                 _paragraph!['content'],
// // // // // // //                 style: const TextStyle(fontSize: 20, height: 1.6),
// // // // // // //                 textAlign: TextAlign.center
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 30),
// // // // // // //         SizedBox(
// // // // // // //           width: double.infinity,
// // // // // // //           height: 60,
// // // // // // //           child: ElevatedButton.icon(
// // // // // // //             onPressed: _startRapidFire,
// // // // // // //             icon: const Icon(Icons.flash_on),
// // // // // // //             label: const Text('Start Rapid Fire Session', style: TextStyle(fontSize: 18)),
// // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // //               backgroundColor: Colors.indigo,
// // // // // // //               foregroundColor: Colors.white,
// // // // // // //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         )
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildRapidFire() {
// // // // // // //     if (_currentState == TrainingState.finished) {
// // // // // // //       return Column(
// // // // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //         children: [
// // // // // // //           const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
// // // // // // //           const SizedBox(height: 20),
// // // // // // //           const Text('Session Completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// // // // // // //           const SizedBox(height: 10),
// // // // // // //           const Text('You are getting faster every day.', style: TextStyle(color: Colors.grey)),
// // // // // // //           const SizedBox(height: 40),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             child: const Text('Back to Home'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       );
// // // // // // //     }

// // // // // // //     final q = _questions[_currentQuestionIndex];
// // // // // // //     return Column(
// // // // // // //       children: [
// // // // // // //         LinearProgressIndicator(
// // // // // // //           value: _timeLeft / (q['time_limit_seconds'] ?? 5),
// // // // // // //           minHeight: 10,
// // // // // // //           borderRadius: BorderRadius.circular(5),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 10),
// // // // // // //         Text('Time Left: $_timeLeft s', style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // // // //         const Spacer(),
// // // // // // //         Text(
// // // // // // //           q['question_text'],
// // // // // // //           style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
// // // // // // //           textAlign: TextAlign.center
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 40),
// // // // // // //         Container(
// // // // // // //           width: double.infinity,
// // // // // // //           padding: const EdgeInsets.all(20),
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             color: Colors.indigo.withOpacity(0.05),
// // // // // // //             borderRadius: BorderRadius.circular(15),
// // // // // // //             border: Border.all(color: Colors.indigo.withOpacity(0.1)),
// // // // // // //           ),
// // // // // // //           child: Text(
// // // // // // //             _lastWords.isEmpty ? "Wait for the question, then speak..." : _lastWords,
// // // // // // //             style: TextStyle(
// // // // // // //               color: _lastWords.isEmpty ? Colors.grey : Colors.indigo,
// // // // // // //               fontSize: 20,
// // // // // // //               fontStyle: FontStyle.italic
// // // // // // //             ),
// // // // // // //             textAlign: TextAlign.center,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const Spacer(),
// // // // // // //         GestureDetector(
// // // // // // //           onTap: _listen,
// // // // // // //           child: AnimatedContainer(
// // // // // // //             duration: const Duration(milliseconds: 300),
// // // // // // //             padding: const EdgeInsets.all(30),
// // // // // // //             decoration: BoxDecoration(
// // // // // // //               color: _isListening ? Colors.red : Colors.indigo,
// // // // // // //               shape: BoxShape.circle,
// // // // // // //               boxShadow: [
// // // // // // //                 BoxShadow(
// // // // // // //                   color: (_isListening ? Colors.red : Colors.indigo).withOpacity(0.3),
// // // // // // //                   blurRadius: 20,
// // // // // // //                   spreadRadius: 5,
// // // // // // //                 )
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 40),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 16),
// // // // // // //         Text(
// // // // // // //           _isListening ? "I'm listening..." : "Tap to Answer",
// // // // // // //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 40),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // ==========================================
// // // // // // // // 4. شاشة توليد البيانات بالذكاء الاصطناعي
// // // // // // // // ==========================================
// // // // // // // class AIGeneratorScreen extends StatefulWidget {
// // // // // // //   const AIGeneratorScreen({super.key});

// // // // // // //   @override
// // // // // // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // // // // // }

// // // // // // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // // // // // //   final _supabase = Supabase.instance.client;
// // // // // // //   bool _isGenerating = false;
// // // // // // //   String _status = 'Ready to generate a new scenario';

// // // // // // //   Future<void> _generate() async {
// // // // // // //     if (_isGenerating) return;

// // // // // // //     setState(() {
// // // // // // //       _isGenerating = true;
// // // // // // //       _status = '🤖 Gemini is thinking...';
// // // // // // //     });

// // // // // // //     try {
// // // // // // //       final model = GenerativeModel(
// // // // // // //         model: geminiModel,
// // // // // // //         apiKey: geminiApiKey,
// // // // // // //         generationConfig: GenerationConfig(responseMimeType: 'application/json'),
// // // // // // //       );

// // // // // // //       const prompt = '''
// // // // // // //       Create an ESL Fluency Practice.
// // // // // // //       JSON format:
// // // // // // //       {
// // // // // // //         "title": "Short title",
// // // // // // //         "category": "Daily Life/Business/Travel",
// // // // // // //         "difficulty": "Intermediate",
// // // // // // //         "paragraph": "A story about someone doing something (30-40 words).",
// // // // // // //         "questions": [
// // // // // // //           {"text": "Simple factual question about the text?", "type": "fact", "time": 7},
// // // // // // //           {"text": "Personal opinion question?", "type": "personal", "time": 12}
// // // // // // //         ]
// // // // // // //       }
// // // // // // //       ''';

// // // // // // //       final response = await model.generateContent([Content.text(prompt)]);
// // // // // // //       final data = json.decode(response.text!);

// // // // // // //       // Save to Supabase
// // // // // // //       final scenario = await _supabase.from('AA_scenarios').insert({
// // // // // // //         'title': data['title'],
// // // // // // //         'category': data['category'],
// // // // // // //         'difficulty': data['difficulty'],
// // // // // // //       }).select().single();

// // // // // // //       final paragraph = await _supabase.from('AA_paragraphs').insert({
// // // // // // //         'scenario_id': scenario['id'],
// // // // // // //         'content': data['paragraph'],
// // // // // // //       }).select().single();

// // // // // // //       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
// // // // // // //         'paragraph_id': paragraph['id'],
// // // // // // //         'question_text': q['text'],
// // // // // // //         'question_type': q['type'],
// // // // // // //         'time_limit_seconds': q['time'],
// // // // // // //       }).toList();

// // // // // // //       await _supabase.from('AA_questions').insert(questions);

// // // // // // //       if (mounted) {
// // // // // // //         setState(() {
// // // // // // //           _isGenerating = false;
// // // // // // //           _status = '✅ Scenario Generated Successfully!';
// // // // // // //         });
// // // // // // //         Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       if (mounted) {
// // // // // // //         setState(() {
// // // // // // //           _isGenerating = false;
// // // // // // //           _status = 'Error: $e';
// // // // // // //         });
// // // // // // //       }
// // // // // // //     }
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return Scaffold(
// // // // // // //       appBar: AppBar(title: const Text('AI Generator')),
// // // // // // //       body: Padding(
// // // // // // //         padding: const EdgeInsets.all(30),
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             _isGenerating
// // // // // // //               ? const CircularProgressIndicator()
// // // // // // //               : const Icon(Icons.auto_awesome, size: 80, color: Colors.indigo),
// // // // // // //             const SizedBox(height: 30),
// // // // // // //             Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
// // // // // // //             const SizedBox(height: 50),
// // // // // // //             if (!_isGenerating)
// // // // // // //               SizedBox(
// // // // // // //                 width: double.infinity,
// // // // // // //                 height: 55,
// // // // // // //                 child: ElevatedButton(
// // // // // // //                   onPressed: _generate,
// // // // // // //                   child: const Text('Generate New Lesson'),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // // import 'package:flutter_tts/flutter_tts.dart';
// // // // // // import 'package:google_generative_ai/google_generative_ai.dart';
// // // // // // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // // // // // import 'dart:async';
// // // // // // import 'dart:convert';

// // // // // // // ==========================================
// // // // // // // 1. الإعدادات ومفاتيح الـ API
// // // // // // // ==========================================
// // // // // // const String aaa1='AIzaSyBdZ6s';
// // // // // // const String aaa2='rcslwJbUl2LaSb';
// // // // // // const String aaa3='8G2sXhOi70nU-o';
// // // // // // const String geminiApiKey = '$aaa1$aaa2$aaa3'; // ضع مفتاحك هنا
// // // // // // const String geminiModel = 'gemini-2.5-flash';
// // // // // // // const String geminiApiKey = ''; // ضع مفتاحك هنا
// // // // // // // const String geminiModel = 'gemini-2.5-flash-preview-09-2025';

// // // // // // void main() async {
// // // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // // //   runApp(const SpeakFastApp());
// // // // // // }

// // // // // // class SpeakFastApp extends StatelessWidget {
// // // // // //   const SpeakFastApp({super.key});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return MaterialApp(
// // // // // //       title: 'SpeakFast AI - Web v2',
// // // // // //       theme: ThemeData(
// // // // // //         useMaterial3: true,
// // // // // //         colorSchemeSeed: Colors.indigo,
// // // // // //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// // // // // //       ),
// // // // // //       home: const ScenariosScreen(),
// // // // // //       debugShowCheckedModeBanner: false,
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 2. شاشة السيناريوهات الرئيسية
// // // // // // // ==========================================
// // // // // // class ScenariosScreen extends StatefulWidget {
// // // // // //   const ScenariosScreen({super.key});

// // // // // //   @override
// // // // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // // // }

// // // // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // // // //   final _supabase = Supabase.instance.client;
// // // // // //   List<dynamic> _scenarios = [];
// // // // // //   bool _isLoading = true;

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _fetchScenarios();
// // // // // //   }

// // // // // //   Future<void> _fetchScenarios() async {
// // // // // //     try {
// // // // // //       final response = await _supabase.from('AA_scenarios').select().order('id', ascending: false);
// // // // // //       if (mounted) {
// // // // // //         setState(() {
// // // // // //           _scenarios = response;
// // // // // //           _isLoading = false;
// // // // // //         });
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       debugPrint('Error fetching scenarios: $e');
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(
// // // // // //         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // //         centerTitle: true,
// // // // // //         actions: [
// // // // // //           IconButton(
// // // // // //             icon: const Icon(Icons.auto_awesome),
// // // // // //             onPressed: () async {
// // // // // //               await Navigator.push(
// // // // // //                 context,
// // // // // //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// // // // // //               );
// // // // // //               _fetchScenarios();
// // // // // //             },
// // // // // //           )
// // // // // //         ],
// // // // // //       ),
// // // // // //       body: _isLoading
// // // // // //           ? const Center(child: CircularProgressIndicator())
// // // // // //           : ListView.builder(
// // // // // //               padding: const EdgeInsets.all(16),
// // // // // //               itemCount: _scenarios.length,
// // // // // //               itemBuilder: (context, index) {
// // // // // //                 final scenario = _scenarios[index];
// // // // // //                 return Card(
// // // // // //                   margin: const EdgeInsets.only(bottom: 12),
// // // // // //                   child: ListTile(
// // // // // //                     title: Text(scenario['title']),
// // // // // //                     subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // // // //                     onTap: () => Navigator.push(
// // // // // //                       context,
// // // // // //                       MaterialPageRoute(
// // // // // //                         builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 );
// // // // // //               },
// // // // // //             ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 3. شاشة التدريب (تحكم يدوي + عرض إجابات)
// // // // // // // ==========================================
// // // // // // enum TrainingState { reading, rapidFire, finished }

// // // // // // class TrainingScreen extends StatefulWidget {
// // // // // //   final int scenarioId;
// // // // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // // // //   @override
// // // // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // // // }

// // // // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // // // //   final _supabase = Supabase.instance.client;
// // // // // //   final FlutterTts flutterTts = FlutterTts();
// // // // // //   final stt.SpeechToText _speech = stt.SpeechToText();

// // // // // //   TrainingState _currentState = TrainingState.reading;
// // // // // //   Map<String, dynamic>? _paragraph;
// // // // // //   List<dynamic> _questions = [];
// // // // // //   int _currentQuestionIndex = 0;

// // // // // //   bool _isListening = false;
// // // // // //   String _lastWords = "";
// // // // // //   Timer? _timer;
// // // // // //   int _timeLeft = 0;
// // // // // //   bool _showModelAnswer = false;
// // // // // //   bool _isSpeechInitialized = false;

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _initTts();
// // // // // //     _fetchTrainingData();
// // // // // //   }

// // // // // //   Future<void> _initTts() async {
// // // // // //     await flutterTts.setLanguage("en-US");
// // // // // //     await flutterTts.setSpeechRate(0.5);
// // // // // //   }

// // // // // //   Future<void> _fetchTrainingData() async {
// // // // // //     final para = await _supabase.from('AA_paragraphs').select().eq('scenario_id', widget.scenarioId).single();
// // // // // //     final ques = await _supabase.from('AA_questions').select().eq('paragraph_id', para['id']).order('id', ascending: true);
// // // // // //     setState(() {
// // // // // //       _paragraph = para;
// // // // // //       _questions = ques;
// // // // // //     });
// // // // // //   }

// // // // // //   Future<bool> _ensureSpeechReady() async {
// // // // // //     if (_isSpeechInitialized) return true;
// // // // // //     bool available = await _speech.initialize();
// // // // // //     setState(() => _isSpeechInitialized = available);
// // // // // //     return available;
// // // // // //   }

// // // // // //   void _listen() async {
// // // // // //     if (_showModelAnswer) return; // منع التحدث بعد ظهور الإجابة
// // // // // //     bool ready = await _ensureSpeechReady();
// // // // // //     if (!ready) return;

// // // // // //     if (!_isListening) {
// // // // // //       setState(() => _isListening = true);
// // // // // //       _speech.listen(onResult: (val) {
// // // // // //         setState(() => _lastWords = val.recognizedWords);
// // // // // //       });
// // // // // //     } else {
// // // // // //       setState(() => _isListening = false);
// // // // // //       _speech.stop();
// // // // // //     }
// // // // // //   }

// // // // // //   void _startRapidFire() {
// // // // // //     setState(() => _currentState = TrainingState.rapidFire);
// // // // // //     _loadQuestion();
// // // // // //   }

// // // // // //   void _loadQuestion() {
// // // // // //     final q = _questions[_currentQuestionIndex];
// // // // // //     setState(() {
// // // // // //       _timeLeft = q['time_limit_seconds'] ?? 10;
// // // // // //       _showModelAnswer = false;
// // // // // //       _lastWords = "";
// // // // // //     });

// // // // // //     flutterTts.speak(q['question_text']);

// // // // // //     _timer?.cancel();
// // // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // // //       if (_timeLeft > 0) {
// // // // // //         setState(() => _timeLeft--);
// // // // // //       } else {
// // // // // //         t.cancel();
// // // // // //         _handleTimeUp();
// // // // // //       }
// // // // // //     });
// // // // // //   }

// // // // // //   void _handleTimeUp() {
// // // // // //     setState(() {
// // // // // //       _showModelAnswer = true;
// // // // // //       _isListening = false;
// // // // // //     });
// // // // // //     _speech.stop();
// // // // // //     // قراءة الإجابة النموذجية
// // // // // //     final modelAnswer = _questions[_currentQuestionIndex]['answer'] ?? "No answer provided";
// // // // // //     flutterTts.speak("Time's up. The suggested answer is: $modelAnswer");
// // // // // //   }

// // // // // //   void _nextQuestion() {
// // // // // //     if (_currentQuestionIndex < _questions.length - 1) {
// // // // // //       setState(() => _currentQuestionIndex++);
// // // // // //       _loadQuestion();
// // // // // //     } else {
// // // // // //       setState(() => _currentState = TrainingState.finished);
// // // // // //     }
// // // // // //   }

// // // // // //   void _previousQuestion() {
// // // // // //     if (_currentQuestionIndex > 0) {
// // // // // //       setState(() => _currentQuestionIndex--);
// // // // // //       _loadQuestion();
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     _timer?.cancel();
// // // // // //     flutterTts.stop();
// // // // // //     _speech.stop();
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(title: const Text('SpeakFast Training')),
// // // // // //       body: Center(
// // // // // //         child: Container(
// // // // // //           constraints: const BoxConstraints(maxWidth: 600),
// // // // // //           padding: const EdgeInsets.all(24),
// // // // // //           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildReading() {
// // // // // //     return Column(
// // // // // //       children: [
// // // // // //         Expanded(child: Center(child: SingleChildScrollView(child: Text(_paragraph!['content'], style: const TextStyle(fontSize: 22), textAlign: TextAlign.center)))),
// // // // // //         const SizedBox(height: 20),
// // // // // //         SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: _startRapidFire, child: const Text('Start Rapid Fire Session'))),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildRapidFire() {
// // // // // //     if (_currentState == TrainingState.finished) return const Center(child: Text('Training Complete!', style: TextStyle(fontSize: 24)));

// // // // // //     final q = _questions[_currentQuestionIndex];
// // // // // //     return Column(
// // // // // //       children: [
// // // // // //         Row(
// // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //           children: [
// // // // // //             Text('Question ${_currentQuestionIndex + 1} of ${_questions.length}', style: const TextStyle(color: Colors.grey)),
// // // // // //             Text('Time: $_timeLeft s', style: TextStyle(color: _timeLeft < 3 ? Colors.red : Colors.indigo, fontWeight: FontWeight.bold)),
// // // // // //           ],
// // // // // //         ),
// // // // // //         const SizedBox(height: 10),
// // // // // //         LinearProgressIndicator(value: _timeLeft / (q['time_limit_seconds'] ?? 10)),
// // // // // //         const Spacer(),
// // // // // //         Text(q['question_text'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
// // // // // //         const SizedBox(height: 30),

// // // // // //         // عرض الإجابة المسجلة (Model Answer) عند انتهاء الوقت
// // // // // //         if (_showModelAnswer)
// // // // // //           Container(
// // // // // //             padding: const EdgeInsets.all(16),
// // // // // //             decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
// // // // // //             child: Column(
// // // // // //               children: [
// // // // // //                 const Text("Suggested Answer:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
// // // // // //                 const SizedBox(height: 8),
// // // // // //                 Text(q['answer'] ?? "N/A", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
// // // // // //               ],
// // // // // //             ),
// // // // // //           )
// // // // // //         else
// // // // // //           Container(
// // // // // //             padding: const EdgeInsets.all(16),
// // // // // //             decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
// // // // // //             child: Text(_lastWords.isEmpty ? "Start speaking..." : _lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo), textAlign: TextAlign.center),
// // // // // //           ),

// // // // // //         const Spacer(),

// // // // // //         // التحكم بالميكروفون
// // // // // //         GestureDetector(
// // // // // //           onTap: _listen,
// // // // // //           child: CircleAvatar(
// // // // // //             radius: 40,
// // // // // //             backgroundColor: _isListening ? Colors.red : Colors.indigo,
// // // // // //             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 40),

// // // // // //         // أزرار التنقل اليدوي
// // // // // //         Row(
// // // // // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // //           children: [
// // // // // //             ElevatedButton.icon(onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null, icon: const Icon(Icons.arrow_back), label: const Text('Previous')),
// // // // // //             ElevatedButton.icon(onPressed: _nextQuestion, icon: const Icon(Icons.arrow_forward), label: Text(_currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next')),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // // ==========================================
// // // // // // // 4. شاشة توليد البيانات (دعم عمود answer + 15 سؤال)
// // // // // // // ==========================================
// // // // // // class AIGeneratorScreen extends StatefulWidget {
// // // // // //   const AIGeneratorScreen({super.key});

// // // // // //   @override
// // // // // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // // // // }

// // // // // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // // // // //   final _supabase = Supabase.instance.client;
// // // // // //   bool _isGenerating = false;
// // // // // //   String _status = 'Generate 15-question challenge';

// // // // // //   Future<void> _generate() async {
// // // // // //     setState(() { _isGenerating = true; _status = '🤖 Crafting 15 questions and model answers...'; });

// // // // // //     try {
// // // // // //       final model = GenerativeModel(
// // // // // //         model: geminiModel,
// // // // // //         apiKey: geminiApiKey,
// // // // // //         generationConfig: GenerationConfig(responseMimeType: 'application/json'),
// // // // // //       );

// // // // // //       const prompt = '''
// // // // // //       Create a comprehensive ESL Fluency Scenario.
// // // // // //       - Generate a paragraph (approx 50 words).
// // // // // //       - Generate EXACTLY 15 questions about this paragraph.
// // // // // //       - Variety: Include literal facts, inferences, and personal opinions related to the theme.
// // // // // //       - For EACH question, provide a "model answer" (a perfect natural sentence).

// // // // // //       Return JSON:
// // // // // //       {
// // // // // //         "title": "Topic Title",
// // // // // //         "category": "Topic",
// // // // // //         "difficulty": "Intermediate",
// // // // // //         "paragraph": "The story text...",
// // // // // //         "questions": [
// // // // // //           {
// // // // // //             "text": "The question?",
// // // // // //             "answer": "The perfect model answer.",
// // // // // //             "time": 8
// // // // // //           }
// // // // // //           // ... repeat until 15 questions
// // // // // //         ]
// // // // // //       }
// // // // // //       ''';

// // // // // //       final response = await model.generateContent([Content.text(prompt)]);
// // // // // //       final data = json.decode(response.text!);

// // // // // //       final scenario = await _supabase.from('AA_scenarios').insert({
// // // // // //         'title': data['title'],
// // // // // //         'category': data['category'],
// // // // // //         'difficulty': data['difficulty'],
// // // // // //       }).select().single();

// // // // // //       final paragraph = await _supabase.from('AA_paragraphs').insert({
// // // // // //         'scenario_id': scenario['id'],
// // // // // //         'content': data['paragraph'],
// // // // // //       }).select().single();

// // // // // //       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
// // // // // //         'paragraph_id': paragraph['id'],
// // // // // //         'question_text': q['text'],
// // // // // //         'answer': q['answer'], // حفظ الإجابة النموذجية
// // // // // //         'time_limit_seconds': q['time'],
// // // // // //       }).toList();

// // // // // //       await _supabase.from('AA_questions').insert(questions);

// // // // // //       setState(() { _isGenerating = false; _status = '✅ Generated 15 questions successfully!'; });
// // // // // //       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// // // // // //     } catch (e) {
// // // // // //       print('error :$e');
// // // // // //       setState(() { _isGenerating = false; _status = 'Error: $e'; });
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(title: const Text('AI Scenario Generator')),
// // // // // //       body: Center(
// // // // // //         child: Column(
// // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // //           children: [
// // // // // //             if (_isGenerating) const CircularProgressIndicator() else const Icon(Icons.auto_awesome, size: 80, color: Colors.indigo),
// // // // // //             const SizedBox(height: 20),
// // // // // //             Text(_status, textAlign: TextAlign.center),
// // // // // //             const SizedBox(height: 40),
// // // // // //             if (!_isGenerating) ElevatedButton(onPressed: _generate, child: const Text('Generate Intensive Lesson')),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // import 'package:flutter_tts/flutter_tts.dart';
// // // // // import 'package:google_generative_ai/google_generative_ai.dart';
// // // // // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // // // // import 'dart:async';
// // // // // import 'dart:convert';

// // // // // // ==========================================
// // // // // // 1. الإعدادات ومفاتيح الـ API
// // // // // // ==========================================
// // // // // const String aaa1='AIzaSyBdZ6s';
// // // // // const String aaa2='rcslwJbUl2LaSb';
// // // // // const String aaa3='8G2sXhOi70nU-o';
// // // // // const String geminiApiKey = '$aaa1$aaa2$aaa3'; // ضع مفتاحك هنا
// // // // // const String geminiModel = 'gemini-2.5-flash';
// // // // // // const String geminiApiKey = ''; // ضع مفتاحك هنا
// // // // // // const String geminiModel = 'gemini-2.5-flash-preview-09-2025';

// // // // // void main() async {
// // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // //   runApp(const SpeakFastApp());
// // // // // }

// // // // // class SpeakFastApp extends StatelessWidget {
// // // // //   const SpeakFastApp({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       title: 'SpeakFast AI - Web v2',
// // // // //       theme: ThemeData(
// // // // //         useMaterial3: true,
// // // // //         colorSchemeSeed: Colors.indigo,
// // // // //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// // // // //       ),
// // // // //       home: const ScenariosScreen(),
// // // // //       debugShowCheckedModeBanner: false,
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 2. شاشة السيناريوهات الرئيسية
// // // // // // ==========================================
// // // // // class ScenariosScreen extends StatefulWidget {
// // // // //   const ScenariosScreen({super.key});

// // // // //   @override
// // // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // // }

// // // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // // //   final _supabase = Supabase.instance.client;
// // // // //   List<dynamic> _scenarios = [];
// // // // //   bool _isLoading = true;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchScenarios();
// // // // //   }

// // // // //   Future<void> _fetchScenarios() async {
// // // // //     try {
// // // // //       final response = await _supabase.from('AA_scenarios').select().order('id', ascending: false);
// // // // //       if (mounted) {
// // // // //         setState(() {
// // // // //           _scenarios = response;
// // // // //           _isLoading = false;
// // // // //         });
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching scenarios: $e');
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // //         centerTitle: true,
// // // // //         actions: [
// // // // //           IconButton(
// // // // //             icon: const Icon(Icons.auto_awesome),
// // // // //             onPressed: () async {
// // // // //               await Navigator.push(
// // // // //                 context,
// // // // //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// // // // //               );
// // // // //               _fetchScenarios();
// // // // //             },
// // // // //           )
// // // // //         ],
// // // // //       ),
// // // // //       body: _isLoading
// // // // //           ? const Center(child: CircularProgressIndicator())
// // // // //           : ListView.builder(
// // // // //               padding: const EdgeInsets.all(16),
// // // // //               itemCount: _scenarios.length,
// // // // //               itemBuilder: (context, index) {
// // // // //                 final scenario = _scenarios[index];
// // // // //                 return Card(
// // // // //                   margin: const EdgeInsets.only(bottom: 12),
// // // // //                   child: ListTile(
// // // // //                     title: Text(scenario['title']),
// // // // //                     subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // // //                     onTap: () => Navigator.push(
// // // // //                       context,
// // // // //                       MaterialPageRoute(
// // // // //                         builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 );
// // // // //               },
// // // // //             ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 3. شاشة التدريب (تحكم يدوي + عرض إجابات)
// // // // // // ==========================================
// // // // // enum TrainingState { reading, rapidFire, finished }

// // // // // class TrainingScreen extends StatefulWidget {
// // // // //   final int scenarioId;
// // // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // // //   @override
// // // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // // }

// // // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // // //   final _supabase = Supabase.instance.client;
// // // // //   final FlutterTts flutterTts = FlutterTts();
// // // // //   final stt.SpeechToText _speech = stt.SpeechToText();

// // // // //   TrainingState _currentState = TrainingState.reading;
// // // // //   Map<String, dynamic>? _paragraph;
// // // // //   List<dynamic> _questions = [];
// // // // //   int _currentQuestionIndex = 0;

// // // // //   bool _isListening = false;
// // // // //   String _lastWords = "";
// // // // //   Timer? _timer;
// // // // //   int _timeLeft = 0;
// // // // //   bool _showModelAnswer = false;
// // // // //   bool _isSpeechInitialized = false;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _initTts();
// // // // //     _fetchTrainingData();
// // // // //   }

// // // // //   Future<void> _initTts() async {
// // // // //     await flutterTts.setLanguage("en-US");
// // // // //     await flutterTts.setSpeechRate(0.5);
// // // // //   }

// // // // //   Future<void> _fetchTrainingData() async {
// // // // //     final para = await _supabase.from('AA_paragraphs').select().eq('scenario_id', widget.scenarioId).single();
// // // // //     final ques = await _supabase.from('AA_questions').select().eq('paragraph_id', para['id']).order('id', ascending: true);
// // // // //     setState(() {
// // // // //       _paragraph = para;
// // // // //       _questions = ques;
// // // // //     });
// // // // //   }

// // // // //   Future<bool> _ensureSpeechReady() async {
// // // // //     if (_isSpeechInitialized) return true;
// // // // //     bool available = await _speech.initialize();
// // // // //     setState(() => _isSpeechInitialized = available);
// // // // //     return available;
// // // // //   }

// // // // //   void _listen() async {
// // // // //     if (_showModelAnswer) return; // منع التحدث بعد ظهور الإجابة
// // // // //     bool ready = await _ensureSpeechReady();
// // // // //     if (!ready) return;

// // // // //     if (!_isListening) {
// // // // //       setState(() => _isListening = true);
// // // // //       _speech.listen(onResult: (val) {
// // // // //         setState(() => _lastWords = val.recognizedWords);
// // // // //       });
// // // // //     } else {
// // // // //       setState(() => _isListening = false);
// // // // //       _speech.stop();
// // // // //     }
// // // // //   }

// // // // //   void _startRapidFire() {
// // // // //     setState(() => _currentState = TrainingState.rapidFire);
// // // // //     _loadQuestion();
// // // // //   }

// // // // //   void _loadQuestion() {
// // // // //     final q = _questions[_currentQuestionIndex];
// // // // //     setState(() {
// // // // //       _timeLeft = q['time_limit_seconds'] ?? 10;
// // // // //       _showModelAnswer = false;
// // // // //       _lastWords = "";
// // // // //     });

// // // // //     flutterTts.speak(q['question_text']);

// // // // //     _timer?.cancel();
// // // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // // //       if (_timeLeft > 0) {
// // // // //         setState(() => _timeLeft--);
// // // // //       } else {
// // // // //         t.cancel();
// // // // //         _handleTimeUp();
// // // // //       }
// // // // //     });
// // // // //   }

// // // // //   void _handleTimeUp() {
// // // // //     setState(() {
// // // // //       _showModelAnswer = true;
// // // // //       _isListening = false;
// // // // //     });
// // // // //     _speech.stop();
// // // // //     // قراءة الإجابة النموذجية
// // // // //     final modelAnswer = _questions[_currentQuestionIndex]['answer'] ?? "No answer provided";
// // // // //     flutterTts.speak("Time's up. The suggested answer is: $modelAnswer");
// // // // //   }

// // // // //   void _nextQuestion() {
// // // // //     if (_currentQuestionIndex < _questions.length - 1) {
// // // // //       setState(() => _currentQuestionIndex++);
// // // // //       _loadQuestion();
// // // // //     } else {
// // // // //       setState(() => _currentState = TrainingState.finished);
// // // // //     }
// // // // //   }

// // // // //   void _previousQuestion() {
// // // // //     if (_currentQuestionIndex > 0) {
// // // // //       setState(() => _currentQuestionIndex--);
// // // // //       _loadQuestion();
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _timer?.cancel();
// // // // //     flutterTts.stop();
// // // // //     _speech.stop();
// // // // //     super.dispose();
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: const Text('SpeakFast Training')),
// // // // //       body: Center(
// // // // //         child: Container(
// // // // //           constraints: const BoxConstraints(maxWidth: 600),
// // // // //           padding: const EdgeInsets.all(24),
// // // // //           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildReading() {
// // // // //     return Column(
// // // // //       children: [
// // // // //         Expanded(child: Center(child: SingleChildScrollView(child: Text(_paragraph!['content'], style: const TextStyle(fontSize: 22), textAlign: TextAlign.center)))),
// // // // //         const SizedBox(height: 20),
// // // // //         SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: _startRapidFire, child: const Text('Start Rapid Fire Session'))),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget _buildRapidFire() {
// // // // //     if (_currentState == TrainingState.finished) return const Center(child: Text('Training Complete!', style: TextStyle(fontSize: 24)));

// // // // //     final q = _questions[_currentQuestionIndex];
// // // // //     return Column(
// // // // //       children: [
// // // // //         Row(
// // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //           children: [
// // // // //             Text('Question ${_currentQuestionIndex + 1} of ${_questions.length}', style: const TextStyle(color: Colors.grey)),
// // // // //             Text('Time: $_timeLeft s', style: TextStyle(color: _timeLeft < 3 ? Colors.red : Colors.indigo, fontWeight: FontWeight.bold)),
// // // // //           ],
// // // // //         ),
// // // // //         const SizedBox(height: 10),
// // // // //         LinearProgressIndicator(value: _timeLeft / (q['time_limit_seconds'] ?? 10)),
// // // // //         const Spacer(),
// // // // //         Text(q['question_text'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
// // // // //         const SizedBox(height: 30),

// // // // //         // عرض الإجابة المسجلة (Model Answer) عند انتهاء الوقت
// // // // //         if (_showModelAnswer)
// // // // //           Container(
// // // // //             padding: const EdgeInsets.all(16),
// // // // //             decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
// // // // //             child: Column(
// // // // //               children: [
// // // // //                 const Text("Suggested Answer:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
// // // // //                 const SizedBox(height: 8),
// // // // //                 Text(q['answer'] ?? "N/A", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
// // // // //               ],
// // // // //             ),
// // // // //           )
// // // // //         else
// // // // //           Container(
// // // // //             padding: const EdgeInsets.all(16),
// // // // //             decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
// // // // //             child: Text(_lastWords.isEmpty ? "Start speaking..." : _lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo), textAlign: TextAlign.center),
// // // // //           ),

// // // // //         const Spacer(),

// // // // //         // التحكم بالميكروفون
// // // // //         GestureDetector(
// // // // //           onTap: _listen,
// // // // //           child: CircleAvatar(
// // // // //             radius: 40,
// // // // //             backgroundColor: _isListening ? Colors.red : Colors.indigo,
// // // // //             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 40),

// // // // //         // أزرار التنقل اليدوي
// // // // //         Row(
// // // // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // //           children: [
// // // // //             ElevatedButton.icon(onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null, icon: const Icon(Icons.arrow_back), label: const Text('Previous')),
// // // // //             ElevatedButton.icon(onPressed: _nextQuestion, icon: const Icon(Icons.arrow_forward), label: Text(_currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next')),
// // // // //           ],
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }

// // // // // // ==========================================
// // // // // // 4. شاشة توليد البيانات (دعم عمود answer + 15 سؤال)
// // // // // // ==========================================
// // // // // class AIGeneratorScreen extends StatefulWidget {
// // // // //   const AIGeneratorScreen({super.key});

// // // // //   @override
// // // // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // // // }

// // // // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // // // //   final _supabase = Supabase.instance.client;
// // // // //   bool _isGenerating = false;
// // // // //   String _status = 'Generate 15-question challenge';

// // // // //   Future<void> _generate() async {
// // // // //     setState(() { _isGenerating = true; _status = '🤖 Crafting 15 questions and model answers...'; });

// // // // //     try {
// // // // //       final model = GenerativeModel(
// // // // //         model: geminiModel,
// // // // //         apiKey: geminiApiKey,
// // // // //         generationConfig: GenerationConfig(responseMimeType: 'application/json'),
// // // // //       );

// // // // //       const prompt = '''
// // // // //       Create a comprehensive ESL Fluency Scenario.
// // // // //       - Generate a paragraph (approx 50 words).
// // // // //       - Generate EXACTLY 15 questions about this paragraph.
// // // // //       - Variety: Include literal facts, inferences, and personal opinions related to the theme.
// // // // //       - For EACH question, provide a "model answer" (a perfect natural sentence).
// // // // //       - For EACH question, specify a "type" (e.g., 'fact', 'inference', or 'opinion').

// // // // //       Return JSON:
// // // // //       {
// // // // //         "title": "Topic Title",
// // // // //         "category": "Topic",
// // // // //         "difficulty": "Intermediate",
// // // // //         "paragraph": "The story text...",
// // // // //         "questions": [
// // // // //           {
// // // // //             "text": "The question?",
// // // // //             "answer": "The perfect model answer.",
// // // // //             "type": "fact",
// // // // //             "time": 8
// // // // //           }
// // // // //           // ... repeat until 15 questions
// // // // //         ]
// // // // //       }
// // // // //       ''';

// // // // //       final response = await model.generateContent([Content.text(prompt)]);
// // // // //       final data = json.decode(response.text!);

// // // // //       final scenario = await _supabase.from('AA_scenarios').insert({
// // // // //         'title': data['title'],
// // // // //         'category': data['category'],
// // // // //         'difficulty': data['difficulty'],
// // // // //       }).select().single();

// // // // //       final paragraph = await _supabase.from('AA_paragraphs').insert({
// // // // //         'scenario_id': scenario['id'],
// // // // //         'content': data['paragraph'],
// // // // //       }).select().single();

// // // // //       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
// // // // //         'paragraph_id': paragraph['id'],
// // // // //         'question_text': q['text'],
// // // // //         'question_type': q['type'] ?? 'fact', // تم إضافة الحقل لحل مشكلة الـ Not-null constraint
// // // // //         'answer': q['answer'],
// // // // //         'time_limit_seconds': q['time'],
// // // // //       }).toList();

// // // // //       await _supabase.from('AA_questions').insert(questions);

// // // // //       setState(() { _isGenerating = false; _status = '✅ Generated 15 questions successfully!'; });
// // // // //       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// // // // //     } catch (e) {
// // // // //       debugPrint('Generation Error: $e');
// // // // //       setState(() { _isGenerating = false; _status = 'Error: $e'; });
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(title: const Text('AI Scenario Generator')),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // //           children: [
// // // // //             if (_isGenerating) const CircularProgressIndicator() else const Icon(Icons.auto_awesome, size: 80, color: Colors.indigo),
// // // // //             const SizedBox(height: 20),
// // // // //             Text(_status, textAlign: TextAlign.center),
// // // // //             const SizedBox(height: 40),
// // // // //             if (!_isGenerating) ElevatedButton(onPressed: _generate, child: const Text('Generate Intensive Lesson')),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:flutter_tts/flutter_tts.dart';
// // // import 'package:google_generative_ai/google_generative_ai.dart';
// // // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // // import 'dart:async';
// // // import 'dart:convert';

// // // // ==========================================
// // // // 1. الإعدادات ومفاتيح الـ API
// // // // ==========================================
// // // const String aaa1 = 'AIzaSyBC6V';
// // // const String aaa2 = 'nWzVHA-o5AzIyOW2';
// // // const String aaa3 = 'hqIdYXinM8eFI';
// // // const String geminiApiKey = '$aaa1$aaa2$aaa3'; // ضع مفتاحك هنا
// // // const String geminiModel = 'gemini-2.5-flash';
// // // // const String geminiApiKey = ''; // ضع مفتاحك هنا
// // // // const String geminiModel = 'gemini-2.5-flash-preview-09-2025';

// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   runApp(const SpeakFastApp());
// // // }

// // // class SpeakFastApp extends StatelessWidget {
// // //   const SpeakFastApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'SpeakFast AI - Web v2',
// // //       theme: ThemeData(
// // //         useMaterial3: true,
// // //         colorSchemeSeed: Colors.indigo,
// // //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// // //       ),
// // //       home: const ScenariosScreen(),
// // //       debugShowCheckedModeBanner: false,
// // //     );
// // //   }
// // // }

// // // // ==========================================
// // // // 2. شاشة السيناريوهات الرئيسية
// // // // ==========================================
// // // class ScenariosScreen extends StatefulWidget {
// // //   const ScenariosScreen({super.key});

// // //   @override
// // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // }

// // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // //   final _supabase = Supabase.instance.client;
// // //   List<dynamic> _scenarios = [];
// // //   bool _isLoading = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchScenarios();
// // //   }

// // //   Future<void> _fetchScenarios() async {
// // //     try {
// // //       final response = await _supabase
// // //           .from('AA_scenarios')
// // //           .select()
// // //           .order('id', ascending: false);
// // //       if (mounted) {
// // //         setState(() {
// // //           _scenarios = response;
// // //           _isLoading = false;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error fetching scenarios: $e');
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           'SpeakFast AI',
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         centerTitle: true,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.auto_awesome),
// // //             onPressed: () async {
// // //               await Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(
// // //                   builder: (context) => const AIGeneratorScreen(),
// // //                 ),
// // //               );
// // //               _fetchScenarios();
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: _isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : ListView.builder(
// // //               padding: const EdgeInsets.all(16),
// // //               itemCount: _scenarios.length,
// // //               itemBuilder: (context, index) {
// // //                 final scenario = _scenarios[index];
// // //                 return Card(
// // //                   margin: const EdgeInsets.only(bottom: 12),
// // //                   child: ListTile(
// // //                     title: Text(scenario['title']),
// // //                     subtitle: Text(
// // //                       '${scenario['category']} • ${scenario['difficulty']}',
// // //                     ),
// // //                     onTap: () => Navigator.push(
// // //                       context,
// // //                       MaterialPageRoute(
// // //                         builder: (context) =>
// // //                             TrainingScreen(scenarioId: scenario['id']),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //     );
// // //   }
// // // }

// // // // ==========================================
// // // // 3. شاشة التدريب (تحكم يدوي + عرض إجابات)
// // // // ==========================================
// // // enum TrainingState { reading, rapidFire, finished }

// // // class TrainingScreen extends StatefulWidget {
// // //   final int scenarioId;
// // //   const TrainingScreen({super.key, required this.scenarioId});

// // //   @override
// // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // }

// // // class _TrainingScreenState extends State<TrainingScreen> {
// // //   final _supabase = Supabase.instance.client;
// // //   final FlutterTts flutterTts = FlutterTts();
// // //   final stt.SpeechToText _speech = stt.SpeechToText();

// // //   TrainingState _currentState = TrainingState.reading;
// // //   Map<String, dynamic>? _paragraph;
// // //   List<dynamic> _questions = [];
// // //   int _currentQuestionIndex = 0;

// // //   bool _isListening = false;
// // //   String _lastWords = "";
// // //   Timer? _timer;
// // //   int _timeLeft = 0;
// // //   bool _showModelAnswer = false;
// // //   bool _isSpeechInitialized = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initTts();
// // //     _fetchTrainingData();
// // //   }

// // //   Future<void> _initTts() async {
// // //     await flutterTts.setLanguage("en-US");
// // //     await flutterTts.setSpeechRate(0.5);
// // //   }

// // //   Future<void> _fetchTrainingData() async {
// // //     final para = await _supabase
// // //         .from('AA_paragraphs')
// // //         .select()
// // //         .eq('scenario_id', widget.scenarioId)
// // //         .single();
// // //     final ques = await _supabase
// // //         .from('AA_questions')
// // //         .select()
// // //         .eq('paragraph_id', para['id'])
// // //         .order('id', ascending: true);
// // //     setState(() {
// // //       _paragraph = para;
// // //       _questions = ques;
// // //     });
// // //   }

// // //   Future<bool> _ensureSpeechReady() async {
// // //     if (_isSpeechInitialized) return true;
// // //     bool available = await _speech.initialize();
// // //     setState(() => _isSpeechInitialized = available);
// // //     return available;
// // //   }

// // //   void _listen() async {
// // //     if (_showModelAnswer) return;
// // //     bool ready = await _ensureSpeechReady();
// // //     if (!ready) return;

// // //     if (!_isListening) {
// // //       setState(() => _isListening = true);
// // //       _speech.listen(
// // //         onResult: (val) {
// // //           setState(() => _lastWords = val.recognizedWords);
// // //         },
// // //       );
// // //     } else {
// // //       setState(() => _isListening = false);
// // //       _speech.stop();
// // //     }
// // //   }

// // //   void _startRapidFire() {
// // //     setState(() => _currentState = TrainingState.rapidFire);
// // //     _loadQuestion();
// // //   }

// // //   void _loadQuestion() async {
// // //     final q = _questions[_currentQuestionIndex];
// // //     setState(() {
// // //       _timeLeft = q['time_limit_seconds'] ?? 10;
// // //       _showModelAnswer = false;
// // //       _lastWords = "";
// // //     });
// // //     await flutterTts.stop();
// // //     await flutterTts.speak(q['question_text']);
// // //     // flutterTts.speak(q['question_text']);

// // //     _timer?.cancel();
// // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // //       if (_timeLeft > 0) {
// // //         setState(() => _timeLeft--);
// // //       } else {
// // //         t.cancel();
// // //         _handleTimeUp();
// // //       }
// // //     });
// // //   }

// // //   void _handleTimeUp() {
// // //     setState(() {
// // //       _showModelAnswer = true;
// // //       _isListening = false;
// // //     });
// // //     _speech.stop();
// // //     final modelAnswer =
// // //         _questions[_currentQuestionIndex]['answer'] ?? "No answer provided";
// // //     flutterTts.speak("Time's up. The suggested answer is: $modelAnswer");
// // //   }

// // //   void _nextQuestion() {
// // //     if (_currentQuestionIndex < _questions.length - 1) {
// // //       setState(() => _currentQuestionIndex++);
// // //       _loadQuestion();
// // //     } else {
// // //       setState(() => _currentState = TrainingState.finished);
// // //     }
// // //   }

// // //   void _previousQuestion() {
// // //     if (_currentQuestionIndex > 0) {
// // //       setState(() => _currentQuestionIndex--);
// // //       _loadQuestion();
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _timer?.cancel();
// // //     flutterTts.stop();
// // //     _speech.stop();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     if (_paragraph == null)
// // //       return const Scaffold(body: Center(child: CircularProgressIndicator()));

// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('SpeakFast Training')),
// // //       body: Center(
// // //         child: Container(
// // //           constraints: const BoxConstraints(maxWidth: 600),
// // //           padding: const EdgeInsets.all(24),
// // //           child: _currentState == TrainingState.reading
// // //               ? _buildReading()
// // //               : _buildRapidFire(),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildReading() {
// // //     return Column(
// // //       children: [
// // //         Expanded(
// // //           child: Center(
// // //             child: SingleChildScrollView(
// // //               child: Text(
// // //                 _paragraph!['content'],
// // //                 style: const TextStyle(fontSize: 22),
// // //                 textAlign: TextAlign.center,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 20),
// // //         SizedBox(
// // //           width: double.infinity,
// // //           height: 60,
// // //           child: ElevatedButton(
// // //             onPressed: _startRapidFire,
// // //             child: const Text('Start Rapid Fire Session'),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildRapidFire() {
// // //     if (_currentState == TrainingState.finished)
// // //       return const Center(
// // //         child: Text('Training Complete!', style: TextStyle(fontSize: 24)),
// // //       );

// // //     final q = _questions[_currentQuestionIndex];
// // //     return Column(
// // //       children: [
// // //         Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //           children: [
// // //             Text(
// // //               'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
// // //               style: const TextStyle(color: Colors.grey),
// // //             ),
// // //             Text(
// // //               'Time: $_timeLeft s',
// // //               style: TextStyle(
// // //                 color: _timeLeft < 3 ? Colors.red : Colors.indigo,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 10),
// // //         LinearProgressIndicator(
// // //           value: _timeLeft / (q['time_limit_seconds'] ?? 10),
// // //         ),
// // //         const Spacer(),
// // //         Text(
// // //           q['question_text'],
// // //           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //           textAlign: TextAlign.center,
// // //         ),
// // //         const SizedBox(height: 30),

// // //         if (_showModelAnswer)
// // //           Container(
// // //             padding: const EdgeInsets.all(16),
// // //             decoration: BoxDecoration(
// // //               color: Colors.green.withOpacity(0.1),
// // //               borderRadius: BorderRadius.circular(12),
// // //               border: Border.all(color: Colors.green),
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 const Text(
// // //                   "Suggested Answer:",
// // //                   style: TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.green,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 Text(
// // //                   q['answer'] ?? "N/A",
// // //                   style: const TextStyle(
// // //                     fontSize: 18,
// // //                     fontStyle: FontStyle.italic,
// // //                   ),
// // //                   textAlign: TextAlign.center,
// // //                 ),
// // //               ],
// // //             ),
// // //           )
// // //         else
// // //           Container(
// // //             padding: const EdgeInsets.all(16),
// // //             decoration: BoxDecoration(
// // //               color: Colors.indigo.withOpacity(0.05),
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //             child: Text(
// // //               _lastWords.isEmpty ? "Start speaking..." : _lastWords,
// // //               style: const TextStyle(fontSize: 18, color: Colors.indigo),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //           ),

// // //         const Spacer(),

// // //         GestureDetector(
// // //           onTap: _listen,
// // //           child: CircleAvatar(
// // //             radius: 40,
// // //             backgroundColor: _isListening ? Colors.red : Colors.indigo,
// // //             child: Icon(
// // //               _isListening ? Icons.mic : Icons.mic_none,
// // //               color: Colors.white,
// // //               size: 30,
// // //             ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 40),

// // //         Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //           children: [
// // //             ElevatedButton.icon(
// // //               onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
// // //               icon: const Icon(Icons.arrow_back),
// // //               label: const Text('Previous'),
// // //             ),
// // //             ElevatedButton.icon(
// // //               onPressed: _nextQuestion,
// // //               icon: const Icon(Icons.arrow_forward),
// // //               label: Text(
// // //                 _currentQuestionIndex == _questions.length - 1
// // //                     ? 'Finish'
// // //                     : 'Next',
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // // ==========================================
// // // // 4. شاشة توليد البيانات (المقيدة بقائمة كلمات محددة)
// // // // ==========================================
// // // class AIGeneratorScreen extends StatefulWidget {
// // //   const AIGeneratorScreen({super.key});

// // //   @override
// // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // }

// // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // //   final _supabase = Supabase.instance.client;
// // //   bool _isGenerating = false;
// // //   String _status = 'Generate 20-question challenge';

// // //   Future<void> _generate() async {
// // //     setState(() {
// // //       _isGenerating = true;
// // //       _status = '🤖 Crafting 20 questions using only your word list...';
// // //     });

// // //     try {
// // //       final model = GenerativeModel(
// // //         model: geminiModel,
// // //         apiKey: geminiApiKey,
// // //         generationConfig: GenerationConfig(
// // //           responseMimeType: 'application/json',
// // //         ),
// // //       );

// // //       // قائمة الكلمات الخاصة بك
// // //       const String allowedWords =
// // //           "large,million,must,home,under,water,room,write,mother,area,national,money,story,young,fact,month,different,lot,study,book,eye,job,word,though,business,issue,side,kind,four,head,far,black,long,both,little,house,yes,since,provide,service,around,friend,important,father,sit,away,until,power,hour,game,often,yet,line,political,end,among,ever,stand,bad,lose,however,member,pay,law,meet,car,city,almost,include,continue,set,later,community,name,five,once,white,least,president,learn,real,change,team,minute,best,several,idea,kid,body,information,nothing,ago,lead,social,understand,whether,watch,together,follow,parent,stop,face,anything,create,public,already,speak,others,read,level,allow,add,office,spend,door,health,person,art,sure,war,history,party,within,grow,result,open,morning,walk,reason,low,win,research,girl,guy,early,food,moment,himself,air,teacher,force,offer,enough,education,across,although,remember,foot,second,boy,maybe,toward,able,age,policy,everything,love,process,music,including,consider,appear,actually,buy,probably,human,wait,serve,market,die,send,expect,sense,build,stay,fall,oh,nation,plan,cut,college,interest,death,course,someone,experience,behind,reach,local,kill,six,remain,effect,yeah,suggest,class,control,raise,care,perhaps,late,hard,field,else,pass,former,sell,major,sometimes,require,along,development,themselves,report,role,better,economic,effort,decide,rate,strong,possible,heart,drug,leader,light,voice,wife,whole,police,mind,finally,pull,return,free,military,price,less,according,decision,explain,son,hope,develop,view,relationship,carry,town,road,drive,arm,TRUE,federal,break,difference,thank,receive,value,international,building,action,full,model,join,season,society,tax,director,position,player,agree,especially,record,pick,wear,paper,special,space,ground,form,support,event,official,whose,matter,everyone,center,couple,site,project,hit,base,activity,star,table,court,produce,eat,teach,oil";

// // //       const prompt =
// // //           '''
// // //       You are an elite ESL Coach. Create a "Fluency Training Scenario".
      
// // //       CRITICAL INSTRUCTION:
// // //       - You MUST ONLY use words from the following list for the 'paragraph', 'questions', and 'answers':
// // //       $allowedWords
// // //       - You may use basic grammar words (a, an, the, is, are, was, were, to, of, in, on, at, by, for, with, I, you, he, she, it, we, they, my, your, etc.).
// // //       - ABSOLUTELY NO external nouns, verbs, or adjectives outside the list.
      
// // //       REQUIREMENTS:
// // //       1. Paragraph: Generate a story/text (approx 50 words).
// // //       2. Questions: Generate EXACTLY 20 questions about the text.
// // //       3. Answers: Provide a model answer for each question.
// // //       4. Metadata: Provide a title, category, and difficulty.

// // //       Return JSON:
// // //       {
// // //         "title": "Topic",
// // //         "category": "Topic",
// // //         "difficulty": "Level",
// // //         "paragraph": "...",
// // //         "questions": [
// // //           {
// // //             "text": "...",
// // //             "answer": "...",
// // //             "type": "fact",
// // //             "time": 8
// // //           }
// // //         ]
// // //       }
// // //       ''';

// // //       final response = await model.generateContent([Content.text(prompt)]);
// // //       final data = json.decode(response.text!);

// // //       final scenario = await _supabase
// // //           .from('AA_scenarios')
// // //           .insert({
// // //             'title': data['title'],
// // //             'category': data['category'],
// // //             'difficulty': data['difficulty'],
// // //           })
// // //           .select()
// // //           .single();

// // //       final paragraph = await _supabase
// // //           .from('AA_paragraphs')
// // //           .insert({'scenario_id': scenario['id'], 'content': data['paragraph']})
// // //           .select()
// // //           .single();

// // //       final List<Map<String, dynamic>> questions = (data['questions'] as List)
// // //           .map(
// // //             (q) => {
// // //               'paragraph_id': paragraph['id'],
// // //               'question_text': q['text'],
// // //               'question_type': q['type'] ?? 'fact',
// // //               'answer': q['answer'],
// // //               'time_limit_seconds': q['time'],
// // //             },
// // //           )
// // //           .toList();

// // //       await _supabase.from('AA_questions').insert(questions);

// // //       setState(() {
// // //         _isGenerating = false;
// // //         _status = '✅ Generated using your word list!';
// // //       });
// // //       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// // //     } catch (e) {
// // //       debugPrint('Generation Error: $e');
// // //       setState(() {
// // //         _isGenerating = false;
// // //         _status = 'Error: $e';
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Vocabulary Restricted AI')),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             if (_isGenerating)
// // //               const CircularProgressIndicator()
// // //             else
// // //               const Icon(Icons.spellcheck, size: 80, color: Colors.indigo),
// // //             const SizedBox(height: 20),
// // //             Text(_status, textAlign: TextAlign.center),
// // //             const SizedBox(height: 40),
// // //             if (!_isGenerating)
// // //               ElevatedButton(
// // //                 onPressed: _generate,
// // //                 child: const Text('Generate Intensive Lesson'),
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // import 'package:flutter_tts/flutter_tts.dart'; 
// // // // import 'package:google_generative_ai/google_generative_ai.dart'; 
// // // // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // // // import 'dart:async';
// // // // import 'dart:convert';

// // // // // ==========================================
// // // // // 1. الإعدادات ومفاتيح الـ API
// // // // // ==========================================
// // // // const String aaa1 = 'AIzaSyBC6V';
// // // // const String aaa2 = 'nWzVHA-o5AzIyOW2';
// // // // const String aaa3 = 'hqIdYXinM8eFI';
// // // // const String geminiApiKey = '$aaa1$aaa2$aaa3'; // ضع مفتاحك هنا
// // // // const String geminiModel = 'gemini-2.5-flash';
// // // // // const String geminiApiKey = ''; // ضع مفتاحك هنا
// // // // // const String geminiModel = 'gemini-2.5-flash-preview-09-2025'; 

// // // // void main() async {
// // // //   WidgetsFlutterBinding.ensureInitialized();
// // // //   runApp(const SpeakFastApp());
// // // // }

// // // // class SpeakFastApp extends StatelessWidget {
// // // //   const SpeakFastApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       title: 'SpeakFast AI - Web v2',
// // // //       theme: ThemeData(
// // // //         useMaterial3: true,
// // // //         colorSchemeSeed: Colors.indigo,
// // // //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// // // //       ),
// // // //       home: const ScenariosScreen(),
// // // //       debugShowCheckedModeBanner: false,
// // // //     );
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 2. شاشة السيناريوهات الرئيسية
// // // // // ==========================================
// // // // class ScenariosScreen extends StatefulWidget {
// // // //   const ScenariosScreen({super.key});

// // // //   @override
// // // //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // // // }

// // // // class _ScenariosScreenState extends State<ScenariosScreen> {
// // // //   final _supabase = Supabase.instance.client;
// // // //   List<dynamic> _scenarios = [];
// // // //   bool _isLoading = true;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchScenarios();
// // // //   }

// // // //   Future<void> _fetchScenarios() async {
// // // //     try {
// // // //       final response = await _supabase.from('AA_scenarios').select().order('id', ascending: false);
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           _scenarios = response;
// // // //           _isLoading = false;
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching scenarios: $e');
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
// // // //         centerTitle: true,
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: const Icon(Icons.auto_awesome),
// // // //             onPressed: () async {
// // // //               await Navigator.push(
// // // //                 context,
// // // //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// // // //               );
// // // //               _fetchScenarios();
// // // //             },
// // // //           )
// // // //         ],
// // // //       ),
// // // //       body: _isLoading
// // // //           ? const Center(child: CircularProgressIndicator())
// // // //           : ListView.builder(
// // // //               padding: const EdgeInsets.all(16),
// // // //               itemCount: _scenarios.length,
// // // //               itemBuilder: (context, index) {
// // // //                 final scenario = _scenarios[index];
// // // //                 return Card(
// // // //                   margin: const EdgeInsets.only(bottom: 12),
// // // //                   child: ListTile(
// // // //                     title: Text(scenario['title']),
// // // //                     subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// // // //                     onTap: () => Navigator.push(
// // // //                       context,
// // // //                       MaterialPageRoute(
// // // //                         builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //     );
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 3. شاشة التدريب (تحكم يدوي + عرض إجابات)
// // // // // ==========================================
// // // // enum TrainingState { reading, rapidFire, finished }

// // // // class TrainingScreen extends StatefulWidget {
// // // //   final int scenarioId;
// // // //   const TrainingScreen({super.key, required this.scenarioId});

// // // //   @override
// // // //   State<TrainingScreen> createState() => _TrainingScreenState();
// // // // }

// // // // class _TrainingScreenState extends State<TrainingScreen> {
// // // //   final _supabase = Supabase.instance.client;
// // // //   final FlutterTts flutterTts = FlutterTts();
// // // //   final stt.SpeechToText _speech = stt.SpeechToText();
  
// // // //   TrainingState _currentState = TrainingState.reading;
// // // //   Map<String, dynamic>? _paragraph;
// // // //   List<dynamic> _questions = [];
// // // //   int _currentQuestionIndex = 0;
  
// // // //   bool _isListening = false;
// // // //   String _lastWords = "";
// // // //   Timer? _timer;
// // // //   int _timeLeft = 0;
// // // //   bool _showModelAnswer = false;
// // // //   bool _isSpeechInitialized = false;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _initTts();
// // // //     _fetchTrainingData();
// // // //   }

// // // //   Future<void> _initTts() async {
// // // //     await flutterTts.setLanguage("en-US");
// // // //     await flutterTts.setSpeechRate(0.5);
// // // //   }

// // // //   Future<void> _fetchTrainingData() async {
// // // //     final para = await _supabase.from('AA_paragraphs').select().eq('scenario_id', widget.scenarioId).single();
// // // //     final ques = await _supabase.from('AA_questions').select().eq('paragraph_id', para['id']).order('id', ascending: true);
// // // //     setState(() {
// // // //       _paragraph = para;
// // // //       _questions = ques;
// // // //     });
// // // //   }

// // // //   Future<bool> _ensureSpeechReady() async {
// // // //     if (_isSpeechInitialized) return true;
// // // //     bool available = await _speech.initialize();
// // // //     setState(() => _isSpeechInitialized = available);
// // // //     return available;
// // // //   }

// // // //   void _listen() async {
// // // //     if (_showModelAnswer) return; 
// // // //     bool ready = await _ensureSpeechReady();
// // // //     if (!ready) return;

// // // //     if (!_isListening) {
// // // //       setState(() => _isListening = true);
// // // //       _speech.listen(onResult: (val) {
// // // //         setState(() => _lastWords = val.recognizedWords);
// // // //       });
// // // //     } else {
// // // //       setState(() => _isListening = false);
// // // //       _speech.stop();
// // // //     }
// // // //   }

// // // //   void _startRapidFire() {
// // // //     setState(() => _currentState = TrainingState.rapidFire);
// // // //     _loadQuestion();
// // // //   }

// // // //   void _loadQuestion() {
// // // //     final q = _questions[_currentQuestionIndex];
// // // //     setState(() {
// // // //       _timeLeft = q['time_limit_seconds'] ?? 10;
// // // //       _showModelAnswer = false;
// // // //       _lastWords = "";
// // // //     });

// // // //     flutterTts.speak(q['question_text']);
    
// // // //     _timer?.cancel();
// // // //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// // // //       if (_timeLeft > 0) {
// // // //         setState(() => _timeLeft--);
// // // //       } else {
// // // //         t.cancel();
// // // //         _handleTimeUp();
// // // //       }
// // // //     });
// // // //   }

// // // //   void _handleTimeUp() {
// // // //     setState(() {
// // // //       _showModelAnswer = true;
// // // //       _isListening = false;
// // // //     });
// // // //     _speech.stop();
// // // //     final modelAnswer = _questions[_currentQuestionIndex]['answer'] ?? "No answer provided";
// // // //     flutterTts.speak("Time's up. The suggested answer is: $modelAnswer");
// // // //   }

// // // //   void _nextQuestion() {
// // // //     if (_currentQuestionIndex < _questions.length - 1) {
// // // //       setState(() => _currentQuestionIndex++);
// // // //       _loadQuestion();
// // // //     } else {
// // // //       setState(() => _currentState = TrainingState.finished);
// // // //     }
// // // //   }

// // // //   void _previousQuestion() {
// // // //     if (_currentQuestionIndex > 0) {
// // // //       setState(() => _currentQuestionIndex--);
// // // //       _loadQuestion();
// // // //     }
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _timer?.cancel();
// // // //     flutterTts.stop();
// // // //     _speech.stop();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text('SpeakFast Training')),
// // // //       body: Center(
// // // //         child: Container(
// // // //           constraints: const BoxConstraints(maxWidth: 600),
// // // //           padding: const EdgeInsets.all(24),
// // // //           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildReading() {
// // // //     return Column(
// // // //       children: [
// // // //         Expanded(child: Center(child: SingleChildScrollView(child: Text(_paragraph!['content'], style: const TextStyle(fontSize: 22), textAlign: TextAlign.center)))),
// // // //         const SizedBox(height: 20),
// // // //         SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: _startRapidFire, child: const Text('Start Rapid Fire Session'))),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildRapidFire() {
// // // //     if (_currentState == TrainingState.finished) return const Center(child: Text('Training Complete!', style: TextStyle(fontSize: 24)));

// // // //     final q = _questions[_currentQuestionIndex];
// // // //     return Column(
// // // //       children: [
// // // //         Row(
// // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //           children: [
// // // //             Text('Question ${_currentQuestionIndex + 1} of ${_questions.length}', style: const TextStyle(color: Colors.grey)),
// // // //             Text('Time: $_timeLeft s', style: TextStyle(color: _timeLeft < 3 ? Colors.red : Colors.indigo, fontWeight: FontWeight.bold)),
// // // //           ],
// // // //         ),
// // // //         const SizedBox(height: 10),
// // // //         LinearProgressIndicator(value: _timeLeft / (q['time_limit_seconds'] ?? 10)),
// // // //         const Spacer(),
// // // //         Text(q['question_text'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
// // // //         const SizedBox(height: 30),
        
// // // //         if (_showModelAnswer)
// // // //           Container(
// // // //             padding: const EdgeInsets.all(16),
// // // //             decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
// // // //             child: Column(
// // // //               children: [
// // // //                 const Text("Suggested Answer:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
// // // //                 const SizedBox(height: 8),
// // // //                 Text(q['answer'] ?? "N/A", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
// // // //               ],
// // // //             ),
// // // //           )
// // // //         else
// // // //           Container(
// // // //             padding: const EdgeInsets.all(16),
// // // //             decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
// // // //             child: Text(_lastWords.isEmpty ? "Start speaking..." : _lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo), textAlign: TextAlign.center),
// // // //           ),

// // // //         const Spacer(),
        
// // // //         GestureDetector(
// // // //           onTap: _listen,
// // // //           child: CircleAvatar(
// // // //             radius: 40,
// // // //             backgroundColor: _isListening ? Colors.red : Colors.indigo,
// // // //             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
// // // //           ),
// // // //         ),
// // // //         const SizedBox(height: 40),

// // // //         Row(
// // // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // //           children: [
// // // //             ElevatedButton.icon(onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null, icon: const Icon(Icons.arrow_back), label: const Text('Previous')),
// // // //             ElevatedButton.icon(onPressed: _nextQuestion, icon: const Icon(Icons.arrow_forward), label: Text(_currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next')),
// // // //           ],
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }

// // // // // ==========================================
// // // // // 4. شاشة توليد البيانات (التفاعلية المقيدة بالكلمات)
// // // // // ==========================================
// // // // class AIGeneratorScreen extends StatefulWidget {
// // // //   const AIGeneratorScreen({super.key});

// // // //   @override
// // // //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // // // }

// // // // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// // // //   final _supabase = Supabase.instance.client;
// // // //   bool _isGenerating = false;
// // // //   String _status = 'Generate Interactive 15-question Challenge';

// // // //   Future<void> _generate() async {
// // // //     setState(() { _isGenerating = true; _status = '🤖 Designing deep speaking questions...'; });

// // // //     try {
// // // //       final model = GenerativeModel(
// // // //         model: geminiModel,
// // // //         apiKey: geminiApiKey,
// // // //         generationConfig: GenerationConfig(responseMimeType: 'application/json'),
// // // //       );

// // // //       const String allowedWords = "large,million,must,home,under,water,room,write,mother,area,national,money,story,young,fact,month,different,lot,study,book,eye,job,word,though,business,issue,side,kind,four,head,far,black,long,both,little,house,yes,since,provide,service,around,friend,important,father,sit,away,until,power,hour,game,often,yet,line,political,end,among,ever,stand,bad,lose,however,member,pay,law,meet,car,city,almost,include,continue,set,later,community,name,five,once,white,least,president,learn,real,change,team,minute,best,several,idea,kid,body,information,nothing,ago,lead,social,understand,whether,watch,together,follow,parent,stop,face,anything,create,public,already,speak,others,read,level,allow,add,office,spend,door,health,person,art,sure,war,history,party,within,grow,result,open,morning,walk,reason,low,win,research,girl,guy,early,food,moment,himself,air,teacher,force,offer,enough,education,across,although,remember,foot,second,boy,maybe,toward,able,age,policy,everything,love,process,music,including,consider,appear,actually,buy,probably,human,wait,serve,market,die,send,expect,sense,build,stay,fall,oh,nation,plan,cut,college,interest,death,course,someone,experience,behind,reach,local,kill,six,remain,effect,yeah,suggest,class,control,raise,care,perhaps,late,hard,field,else,pass,former,sell,major,sometimes,require,along,development,themselves,report,role,better,economic,effort,decide,rate,strong,possible,heart,drug,leader,light,voice,wife,whole,police,mind,finally,pull,return,free,military,price,less,according,decision,explain,son,hope,develop,view,relationship,carry,town,road,drive,arm,TRUE,federal,break,difference,thank,receive,value,international,building,action,full,model,join,season,society,tax,director,position,player,agree,especially,record,pick,wear,paper,special,space,ground,form,support,event,official,whose,matter,everyone,center,couple,site,project,hit,base,activity,star,table,court,produce,eat,teach,oil";

// // // //       const prompt = '''
// // // //       You are an expert ESL Speaking Coach. Your goal is to train fluency and deep thinking.
      
// // // //       CRITICAL VOCABULARY RULE:
// // // //       - Use ONLY these words: $allowedWords
// // // //       - Basic grammar words (the, is, to, are, etc.) are allowed.
// // // //       - ABSOLUTELY NO external words.

// // // //       TASK:
// // // //       1. Create a Paragraph (approx 50 words) using only allowed words.
// // // //       2. Generate EXACTLY 15 Speaking Questions based on the text.

// // // //       QUESTION DISTRIBUTION:
// // // //       - 3 Factual (Recall details)
// // // //       - 4 Reasoning (Why/How, logical deduction)
// // // //       - 4 Rephrasing (Ask to explain a part of the story in their own words)
// // // //       - 4 Personal Speaking (Relate the story theme to the user's life)

// // // //       PROMPTING RULES:
// // // //       - AVOID "Yes/No" questions. They are forbidden.
// // // //       - Questions must be open-ended (What, Why, How, Tell me about, Explain).
// // // //       - Each "answer" in the JSON must be a natural, full sentence (at least 6-10 words).
// // // //       - Do NOT just copy sentences from the paragraph into the questions.
// // // //       - Each question should encourage the user to speak for several seconds.

// // // //       Return JSON:
// // // //       {
// // // //         "title": "Topic Title",
// // // //         "category": "Topic",
// // // //         "difficulty": "Intermediate",
// // // //         "paragraph": "...",
// // // //         "questions": [
// // // //           {
// // // //             "text": "The open-ended question",
// // // //             "answer": "A perfect model answer of 6+ words.",
// // // //             "type": "fact|reasoning|rephrase|personal",
// // // //             "time": 12
// // // //           }
// // // //         ]
// // // //       }
// // // //       ''';

// // // //       final response = await model.generateContent([Content.text(prompt)]);
// // // //       final data = json.decode(response.text!);

// // // //       final scenario = await _supabase.from('AA_scenarios').insert({
// // // //         'title': data['title'],
// // // //         'category': data['category'],
// // // //         'difficulty': data['difficulty'],
// // // //       }).select().single();

// // // //       final paragraph = await _supabase.from('AA_paragraphs').insert({
// // // //         'scenario_id': scenario['id'],
// // // //         'content': data['paragraph'],
// // // //       }).select().single();

// // // //       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
// // // //         'paragraph_id': paragraph['id'],
// // // //         'question_text': q['text'],
// // // //         'question_type': q['type'] ?? 'fact',
// // // //         'answer': q['answer'], 
// // // //         'time_limit_seconds': q['time'] ?? 10,
// // // //       }).toList();

// // // //       await _supabase.from('AA_questions').insert(questions);

// // // //       setState(() { _isGenerating = false; _status = '✅ Deep Speaking Lesson Created!'; });
// // // //       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// // // //     } catch (e) {
// // // //       debugPrint('Generation Error: $e');
// // // //       setState(() { _isGenerating = false; _status = 'Error: $e'; });
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text('Interactive AI Generator')),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             if (_isGenerating) const CircularProgressIndicator() else const Icon(Icons.forum, size: 80, color: Colors.indigo),
// // // //             const SizedBox(height: 20),
// // // //             Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
// // // //             const SizedBox(height: 40),
// // // //             if (!_isGenerating) 
// // // //               ElevatedButton.icon(
// // // //                 onPressed: _generate, 
// // // //                 icon: const Icon(Icons.auto_awesome),
// // // //                 label: const Text('Generate 15 Deep Questions'),
// // // //                 style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:google_generative_ai/google_generative_ai.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'dart:async';
// // import 'dart:convert';

// // // ==========================================
// // // 1. الإعدادات ومفاتيح الـ API
// // // ==========================================
// // const String aaa1 = 'AIzaSyBC6V';
// // const String aaa2 = 'nWzVHA-o5AzIyOW2';
// // const String aaa3 = 'hqIdYXinM8eFI';
// // const String geminiApiKey = '$aaa1$aaa2$aaa3'; 
// // const String geminiModel = 'gemini-2.5-flash';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   // تأكد من تهيئة Supabase هنا في مشروعك الحقيقي
// //   // await Supabase.initialize(url: 'YOUR_URL', anonKey: 'YOUR_KEY');
// //   runApp(const SpeakFastApp());
// // }

// // class SpeakFastApp extends StatelessWidget {
// //   const SpeakFastApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'SpeakFast AI',
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorSchemeSeed: Colors.indigo,
// //         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
// //       ),
// //       home: const ScenariosScreen(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // // ==========================================
// // // 2. شاشة السيناريوهات الرئيسية
// // // ==========================================
// // class ScenariosScreen extends StatefulWidget {
// //   const ScenariosScreen({super.key});

// //   @override
// //   State<ScenariosScreen> createState() => _ScenariosScreenState();
// // }

// // class _ScenariosScreenState extends State<ScenariosScreen> {
// //   final _supabase = Supabase.instance.client;
// //   List<dynamic> _scenarios = [];
// //   bool _isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchScenarios();
// //   }

// //   Future<void> _fetchScenarios() async {
// //     try {
// //       final response = await _supabase
// //           .from('AA_scenarios')
// //           .select()
// //           .order('id', ascending: false);
// //       if (mounted) {
// //         setState(() {
// //           _scenarios = response;
// //           _isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching scenarios: $e');
// //       setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.auto_awesome),
// //             onPressed: () async {
// //               await Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
// //               );
// //               _fetchScenarios();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : _scenarios.isEmpty 
// //               ? const Center(child: Text("No scenarios found. Create one!"))
// //               : ListView.builder(
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: _scenarios.length,
// //                   itemBuilder: (context, index) {
// //                     final scenario = _scenarios[index];
// //                     return Card(
// //                       margin: const EdgeInsets.only(bottom: 12),
// //                       child: ListTile(
// //                         title: Text(scenario['title']),
// //                         subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
// //                         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// //                         onTap: () => Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => TrainingScreen(scenarioId: scenario['id']),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //     );
// //   }
// // }

// // // ==========================================
// // // 3. شاشة التدريب (قراءة + أسئلة سريعة)
// // // ==========================================
// // enum TrainingState { reading, rapidFire, finished }

// // class TrainingScreen extends StatefulWidget {
// //   final int scenarioId;
// //   const TrainingScreen({super.key, required this.scenarioId});

// //   @override
// //   State<TrainingScreen> createState() => _TrainingScreenState();
// // }

// // class _TrainingScreenState extends State<TrainingScreen> {
// //   final _supabase = Supabase.instance.client;
// //   final FlutterTts flutterTts = FlutterTts();
// //   final stt.SpeechToText _speech = stt.SpeechToText();

// //   TrainingState _currentState = TrainingState.reading;
// //   Map<String, dynamic>? _paragraph;
// //   List<dynamic> _questions = [];
// //   int _currentQuestionIndex = 0;

// //   bool _isListening = false;
// //   String _lastWords = "";
// //   Timer? _timer;
// //   int _timeLeft = 0;
// //   bool _showModelAnswer = false;
// //   bool _isSpeechInitialized = false;
  
// //   // حالة التحكم في قراءة البراجراف
// //   bool _isReadingParagraph = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initTts();
// //     _fetchTrainingData();
// //   }

// //   Future<void> _initTts() async {
// //     await flutterTts.setLanguage("en-US");
// //     await flutterTts.setSpeechRate(0.5);
    
// //     // عند انتهاء القراءة تلقائياً نغير حالة الأيقونة
// //     flutterTts.setCompletionHandler(() {
// //       if (mounted) setState(() => _isReadingParagraph = false);
// //     });

// //     flutterTts.setErrorHandler((msg) {
// //       if (mounted) setState(() => _isReadingParagraph = false);
// //     });
// //   }

// //   Future<void> _fetchTrainingData() async {
// //     try {
// //       final para = await _supabase
// //           .from('AA_paragraphs')
// //           .select()
// //           .eq('scenario_id', widget.scenarioId)
// //           .single();
      
// //       final ques = await _supabase
// //           .from('AA_questions')
// //           .select()
// //           .eq('paragraph_id', para['id'])
// //           .order('id', ascending: true);
      
// //       if (mounted) {
// //         setState(() {
// //           _paragraph = para;
// //           _questions = ques;
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching training data: $e');
// //     }
// //   }

// //   // دالة تشغيل/إيقاف قراءة النص
// //   void _toggleParagraphReading() async {
// //     if (_isReadingParagraph) {
// //       await flutterTts.stop();
// //       setState(() => _isReadingParagraph = false);
// //     } else {
// //       if (_paragraph != null) {
// //         setState(() => _isReadingParagraph = true);
// //         await flutterTts.speak(_paragraph!['content']);
// //       }
// //     }
// //   }

// //   Future<bool> _ensureSpeechReady() async {
// //     if (_isSpeechInitialized) return true;
// //     bool available = await _speech.initialize();
// //     setState(() => _isSpeechInitialized = available);
// //     return available;
// //   }

// //   void _listen() async {
// //     if (_showModelAnswer) return;
// //     bool ready = await _ensureSpeechReady();
// //     if (!ready) return;

// //     if (!_isListening) {
// //       setState(() => _isListening = true);
// //       _speech.listen(onResult: (val) => setState(() => _lastWords = val.recognizedWords));
// //     } else {
// //       setState(() => _isListening = false);
// //       _speech.stop();
// //     }
// //   }

// //   void _startRapidFire() async {
// //     await flutterTts.stop(); // إيقاف أي قراءة حالية
// //     setState(() {
// //       _isReadingParagraph = false;
// //       _currentState = TrainingState.rapidFire;
// //     });
// //     _loadQuestion();
// //   }

// //   void _loadQuestion() async {
// //     if (_questions.isEmpty) return;
// //     final q = _questions[_currentQuestionIndex];
// //     setState(() {
// //       _timeLeft = q['time_limit_seconds'] ?? 10;
// //       _showModelAnswer = false;
// //       _lastWords = "";
// //     });
    
// //     await flutterTts.stop();
// //     await flutterTts.speak(q['question_text']);

// //     _timer?.cancel();
// //     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
// //       if (_timeLeft > 0) {
// //         setState(() => _timeLeft--);
// //       } else {
// //         t.cancel();
// //         _handleTimeUp();
// //       }
// //     });
// //   }

// //   void _handleTimeUp() {
// //     setState(() {
// //       _showModelAnswer = true;
// //       _isListening = false;
// //     });
// //     _speech.stop();
// //     final modelAnswer = _questions[_currentQuestionIndex]['answer'] ?? "No answer";
// //     flutterTts.speak("Time's up. Suggested answer: $modelAnswer");
// //   }

// //   void _nextQuestion() {
// //     if (_currentQuestionIndex < _questions.length - 1) {
// //       setState(() => _currentQuestionIndex++);
// //       _loadQuestion();
// //     } else {
// //       setState(() => _currentState = TrainingState.finished);
// //     }
// //   }

// //   void _previousQuestion() {
// //     if (_currentQuestionIndex > 0) {
// //       setState(() => _currentQuestionIndex--);
// //       _loadQuestion();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     flutterTts.stop();
// //     _speech.stop();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Training Session')),
// //       body: Center(
// //         child: Container(
// //           constraints: const BoxConstraints(maxWidth: 600),
// //           padding: const EdgeInsets.all(24),
// //           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildReading() {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             Text(_isReadingParagraph ? "Stop" : "Read Aloud", style: const TextStyle(fontWeight: FontWeight.bold)),
// //             const SizedBox(width: 8),
// //             IconButton.filledTonal(
// //               onPressed: _toggleParagraphReading,
// //               icon: Icon(_isReadingParagraph ? Icons.stop_circle : Icons.play_circle_filled),
// //               color: Colors.indigo,
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 10),
// //         Expanded(
// //           child: Center(
// //             child: SingleChildScrollView(
// //               child: Text(
// //                 _paragraph!['content'],
// //                 style: const TextStyle(fontSize: 22, height: 1.5),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         SizedBox(
// //           width: double.infinity,
// //           height: 60,
// //           child: ElevatedButton(
// //             onPressed: _startRapidFire,
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
// //             child: const Text('Start Rapid Fire Session', style: TextStyle(fontSize: 18)),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRapidFire() {
// //     if (_currentState == TrainingState.finished) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
// //             const SizedBox(height: 20),
// //             const Text('Training Complete!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 30),
// //             ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Back to Scenarios")),
// //           ],
// //         ),
// //       );
// //     }

// //     final q = _questions[_currentQuestionIndex];
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Q: ${_currentQuestionIndex + 1}/${_questions.length}'),
// //             Text('Time: $_timeLeft s', style: TextStyle(color: _timeLeft < 3 ? Colors.red : Colors.indigo, fontWeight: FontWeight.bold)),
// //           ],
// //         ),
// //         const SizedBox(height: 10),
// //         LinearProgressIndicator(value: _timeLeft / (q['time_limit_seconds'] ?? 10)),
// //         const Spacer(),
// //         Text(q['question_text'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
// //         const SizedBox(height: 30),
// //         if (_showModelAnswer)
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
// //             child: Text(q['answer'] ?? "N/A", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
// //           )
// //         else
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
// //             child: Text(_lastWords.isEmpty ? "Listening..." : _lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo), textAlign: TextAlign.center),
// //           ),
// //         const Spacer(),
// //         GestureDetector(
// //           onTap: _listen,
// //           child: CircleAvatar(
// //             radius: 40,
// //             backgroundColor: _isListening ? Colors.red : Colors.indigo,
// //             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
// //           ),
// //         ),
// //         const SizedBox(height: 40),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: [
// //             IconButton(onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null, icon: const Icon(Icons.arrow_back_ios)),
// //             ElevatedButton(onPressed: _nextQuestion, child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next Question')),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ==========================================
// // // 4. شاشة توليد البيانات بالذكاء الاصطناعي
// // // ==========================================
// // class AIGeneratorScreen extends StatefulWidget {
// //   const AIGeneratorScreen({super.key});

// //   @override
// //   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// // }

// // class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
// //   final _supabase = Supabase.instance.client;
// //   bool _isGenerating = false;
// //   String _status = 'Generate 20-question challenge';

// //   Future<void> _generate() async {
// //     setState(() {
// //       _isGenerating = true;
// //       _status = '🤖 Creating content using Gemini AI...';
// //     });

// //     try {
// //       final model = GenerativeModel(model: geminiModel, apiKey: geminiApiKey, generationConfig: GenerationConfig(responseMimeType: 'application/json'));

// //       const String allowedWords = "large,million,must,home,under,water,room,write,mother,area,national,money,story,young,fact,month,different,lot,study,book,eye,job,word,though,business,issue,side,kind,four,head,far,black,long,both,little,house,yes,since,provide,service,around,friend,important,father,sit,away,until,power,hour,game,often,yet,line,political,end,among,ever,stand,bad,lose,however,member,pay,law,meet,car,city,almost,include,continue,set,later,community,name,five,once,white,least,president,learn,real,change,team,minute,best,several,idea,kid,body,information,nothing,ago,lead,social,understand,whether,watch,together,follow,parent,stop,face,anything,create,public,already,speak,others,read,level,allow,add,office,spend,door,health,person,art,sure,war,history,party,within,grow,result,open,morning,walk,reason,low,win,research,girl,guy,early,food,moment,himself,air,teacher,force,offer,enough,education,across,although,remember,foot,second,boy,maybe,toward,able,age,policy,everything,love,process,music,including,consider,appear,actually,buy,probably,human,wait,serve,market,die,send,expect,sense,build,stay,fall,oh,nation,plan,cut,college,interest,death,course,someone,experience,behind,reach,local,kill,six,remain,effect,yeah,suggest,class,control,raise,care,perhaps,late,hard,field,else,pass,former,sell,major,sometimes,require,along,development,themselves,report,role,better,economic,effort,decide,rate,strong,possible,heart,drug,leader,light,voice,wife,whole,police,mind,finally,pull,return,free,military,price,less,according,decision,explain,son,hope,develop,view,relationship,carry,town,road,drive,arm,TRUE,federal,break,difference,thank,receive,value,international,building,action,full,model,join,season,society,tax,director,position,player,agree,especially,record,pick,wear,paper,special,space,ground,form,support,event,official,whose,matter,everyone,center,couple,site,project,hit,base,activity,star,table,court,produce,eat,teach,oil";

// //       final prompt = '''
// //       Create a "Fluency Training Scenario".
// //       - Use ONLY words from: $allowedWords
// //       - Grammar words (is, the, etc.) are allowed.
// //       - Return JSON:
// //       {
// //         "title": "Title",
// //         "category": "Topic",
// //         "difficulty": "Level",
// //         "paragraph": "A story around 50 words",
// //         "questions": [{"text": "...", "answer": "...", "type": "fact", "time": 10}]
// //       }
// //       Generate EXACTLY 5 questions for this demo (or 20 as requested).
// //       ''';

// //       final response = await model.generateContent([Content.text(prompt)]);
// //       final data = json.decode(response.text!);

// //       final scenario = await _supabase.from('AA_scenarios').insert({
// //         'title': data['title'],
// //         'category': data['category'],
// //         'difficulty': data['difficulty'],
// //       }).select().single();

// //       final paragraph = await _supabase.from('AA_paragraphs').insert({
// //         'scenario_id': scenario['id'],
// //         'content': data['paragraph']
// //       }).select().single();

// //       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
// //         'paragraph_id': paragraph['id'],
// //         'question_text': q['text'],
// //         'question_type': q['type'] ?? 'fact',
// //         'answer': q['answer'],
// //         'time_limit_seconds': q['time'] ?? 10,
// //       }).toList();

// //       await _supabase.from('AA_questions').insert(questions);

// //       setState(() {
// //         _isGenerating = false;
// //         _status = '✅ Success!';
// //       });
// //       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
// //     } catch (e) {
// //       setState(() {
// //         _isGenerating = false;
// //         _status = 'Error: $e';
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('AI Content Generator')),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             if (_isGenerating) const CircularProgressIndicator() else const Icon(Icons.bolt, size: 80, color: Colors.amber),
// //             const SizedBox(height: 20),
// //             Text(_status),
// //             const SizedBox(height: 40),
// //             if (!_isGenerating) ElevatedButton(onPressed: _generate, child: const Text('Generate Lesson')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'dart:async';
// import 'dart:convert';

// // ==========================================
// // 1. الإعدادات
// // ==========================================
// const String geminiModel = 'gemini-2.5-flash';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // تأكد من تهيئة Supabase هنا في مشروعك الحقيقي
//   // await Supabase.initialize(url: 'YOUR_URL', anonKey: 'YOUR_KEY');
//   runApp(const SpeakFastApp());
// }

// class SpeakFastApp extends StatelessWidget {
//   const SpeakFastApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SpeakFast AI',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
//       ),
//       home: const ScenariosScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // ==========================================
// // 2. شاشة السيناريوهات الرئيسية
// // ==========================================
// class ScenariosScreen extends StatefulWidget {
//   const ScenariosScreen({super.key});

//   @override
//   State<ScenariosScreen> createState() => _ScenariosScreenState();
// }

// class _ScenariosScreenState extends State<ScenariosScreen> {
//   final _supabase = Supabase.instance.client;
//   List<dynamic> _scenarios = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchScenarios();
//   }

//   Future<void> _fetchScenarios() async {
//     try {
//       final response = await _supabase
//           .from('AA_scenarios')
//           .select()
//           .order('id', ascending: false);
//       if (mounted) {
//         setState(() {
//           _scenarios = response;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching scenarios: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.auto_awesome),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AIGeneratorScreen()),
//               );
//               _fetchScenarios();
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _scenarios.isEmpty 
//               ? const Center(child: Text("No scenarios found. Create one!"))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: _scenarios.length,
//                   itemBuilder: (context, index) {
//                     final scenario = _scenarios[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       child: ListTile(
//                         title: Text(scenario['title']),
//                         subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
//                         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                         onTap: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TrainingScreen(scenarioId: scenario['id']),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// // ==========================================
// // 3. شاشة التدريب (قراءة + أسئلة سريعة)
// // ==========================================
// enum TrainingState { reading, rapidFire, finished }

// class TrainingScreen extends StatefulWidget {
//   final int scenarioId;
//   const TrainingScreen({super.key, required this.scenarioId});

//   @override
//   State<TrainingScreen> createState() => _TrainingScreenState();
// }

// class _TrainingScreenState extends State<TrainingScreen> {
//   final _supabase = Supabase.instance.client;
//   final FlutterTts flutterTts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();

//   TrainingState _currentState = TrainingState.reading;
//   Map<String, dynamic>? _paragraph;
//   List<dynamic> _questions = [];
//   int _currentQuestionIndex = 0;

//   bool _isListening = false;
//   String _lastWords = "";
//   Timer? _timer;
//   int _timeLeft = 0;
//   bool _showModelAnswer = false;
//   bool _isSpeechInitialized = false;
  
//   bool _isReadingParagraph = false;

//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//     _fetchTrainingData();
//   }

//   Future<void> _initTts() async {
//     await flutterTts.setLanguage("en-US");
//     await flutterTts.setSpeechRate(0.5);
    
//     flutterTts.setCompletionHandler(() {
//       if (mounted) setState(() => _isReadingParagraph = false);
//     });

//     flutterTts.setErrorHandler((msg) {
//       if (mounted) setState(() => _isReadingParagraph = false);
//     });
//   }

//   Future<void> _fetchTrainingData() async {
//     try {
//       final para = await _supabase
//           .from('AA_paragraphs')
//           .select()
//           .eq('scenario_id', widget.scenarioId)
//           .single();
      
//       final ques = await _supabase
//           .from('AA_questions')
//           .select()
//           .eq('paragraph_id', para['id'])
//           .order('id', ascending: true);
      
//       if (mounted) {
//         setState(() {
//           _paragraph = para;
//           _questions = ques;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching training data: $e');
//     }
//   }

//   void _toggleParagraphReading() async {
//     if (_isReadingParagraph) {
//       await flutterTts.stop();
//       setState(() => _isReadingParagraph = false);
//     } else {
//       if (_paragraph != null) {
//         setState(() => _isReadingParagraph = true);
//         await flutterTts.speak(_paragraph!['content']);
//       }
//     }
//   }

//   Future<bool> _ensureSpeechReady() async {
//     if (_isSpeechInitialized) return true;
//     bool available = await _speech.initialize();
//     setState(() => _isSpeechInitialized = available);
//     return available;
//   }

//   void _listen() async {
//     if (_showModelAnswer) return;
//     bool ready = await _ensureSpeechReady();
//     if (!ready) return;

//     if (!_isListening) {
//       setState(() => _isListening = true);
//       _speech.listen(onResult: (val) => setState(() => _lastWords = val.recognizedWords));
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   void _startRapidFire() async {
//     await flutterTts.stop();
//     setState(() {
//       _isReadingParagraph = false;
//       _currentState = TrainingState.rapidFire;
//     });
//     _loadQuestion();
//   }

//   void _loadQuestion() async {
//     if (_questions.isEmpty) return;
//     final q = _questions[_currentQuestionIndex];
//     setState(() {
//       _timeLeft = q['time_limit_seconds'] ?? 10;
//       _showModelAnswer = false;
//       _lastWords = "";
//     });
    
//     await flutterTts.stop();
//     await flutterTts.speak(q['question_text']);

//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (_timeLeft > 0) {
//         setState(() => _timeLeft--);
//       } else {
//         t.cancel();
//         _handleTimeUp();
//       }
//     });
//   }

//   void _handleTimeUp() {
//     setState(() {
//       _showModelAnswer = true;
//       _isListening = false;
//     });
//     _speech.stop();
//     final modelAnswer = _questions[_currentQuestionIndex]['answer'] ?? "No answer";
//     flutterTts.speak("Time's up. Suggested answer: $modelAnswer");
//   }

//   void _nextQuestion() {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() => _currentQuestionIndex++);
//       _loadQuestion();
//     } else {
//       setState(() => _currentState = TrainingState.finished);
//     }
//   }

//   void _previousQuestion() {
//     if (_currentQuestionIndex > 0) {
//       setState(() => _currentQuestionIndex--);
//       _loadQuestion();
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     flutterTts.stop();
//     _speech.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       appBar: AppBar(title: const Text('Training Session')),
//       body: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 600),
//           padding: const EdgeInsets.all(24),
//           child: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
//         ),
//       ),
//     );
//   }

//   Widget _buildReading() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(_isReadingParagraph ? "Stop" : "Read Aloud", style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(width: 8),
//             IconButton.filledTonal(
//               onPressed: _toggleParagraphReading,
//               icon: Icon(_isReadingParagraph ? Icons.stop_circle : Icons.play_circle_filled),
//               color: Colors.indigo,
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Expanded(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Text(
//                 _paragraph!['content'],
//                 style: const TextStyle(fontSize: 22, height: 1.5),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           width: double.infinity,
//           height: 60,
//           child: ElevatedButton(
//             onPressed: _startRapidFire,
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
//             child: const Text('Start Rapid Fire Session', style: TextStyle(fontSize: 18)),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRapidFire() {
//     if (_currentState == TrainingState.finished) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
//             const SizedBox(height: 20),
//             const Text('Training Complete!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 30),
//             ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Back to Scenarios")),
//           ],
//         ),
//       );
//     }

//     final q = _questions[_currentQuestionIndex];
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Q: ${_currentQuestionIndex + 1}/${_questions.length}'),
//             Text('Time: $_timeLeft s', style: TextStyle(color: _timeLeft < 3 ? Colors.red : Colors.indigo, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         const SizedBox(height: 10),
//         LinearProgressIndicator(value: _timeLeft / (q['time_limit_seconds'] ?? 10)),
//         const Spacer(),
//         Text(q['question_text'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//         const SizedBox(height: 30),
//         if (_showModelAnswer)
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
//             child: Text(q['answer'] ?? "N/A", style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
//           )
//         else
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
//             child: Text(_lastWords.isEmpty ? "Listening..." : _lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo), textAlign: TextAlign.center),
//           ),
//         const Spacer(),
//         GestureDetector(
//           onTap: _listen,
//           child: CircleAvatar(
//             radius: 40,
//             backgroundColor: _isListening ? Colors.red : Colors.indigo,
//             child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
//           ),
//         ),
//         const SizedBox(height: 40),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null, icon: const Icon(Icons.arrow_back_ios)),
//             ElevatedButton(onPressed: _nextQuestion, child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Finish' : 'Next Question')),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ==========================================
// // 4. شاشة توليد البيانات بالذكاء الاصطناعي
// // ==========================================
// class AIGeneratorScreen extends StatefulWidget {
//   const AIGeneratorScreen({super.key});

//   @override
//   State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
// }

// class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
//   final _supabase = Supabase.instance.client;
  
//   bool _isLoadingKeys = true;
//   bool _isGenerating = false;
//   String _status = 'Choose an API key to start';
  
//   List<Map<String, dynamic>> _apiKeys = [];
//   String? _selectedApiKey;

//   @override
//   void initState() {
//     super.initState();
//     _fetchApiKeys();
//   }

//   Future<void> _fetchApiKeys() async {
//     try {
//       final response = await _supabase.from('AA_api').select();
//       if (mounted) {
//         setState(() {
//           _apiKeys = List<Map<String, dynamic>>.from(response);
//           if (_apiKeys.isNotEmpty) {
//             _selectedApiKey = _apiKeys.first['api'];
//           }
//           _isLoadingKeys = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching API keys: $e');
//       if (mounted) setState(() => _isLoadingKeys = false);
//     }
//   }

//   Future<void> _generate() async {
//     if (_selectedApiKey == null) {
//       setState(() => _status = '❌ Please select an API key first');
//       return;
//     }

//     setState(() {
//       _isGenerating = true;
//       _status = '🤖 Creating content using Gemini AI...';
//     });

//     try {
//       final model = GenerativeModel(
//         model: geminiModel, 
//         apiKey: _selectedApiKey!, 
//         generationConfig: GenerationConfig(responseMimeType: 'application/json')
//       );

//       const String allowedWords = "large,million,must,home,under,water,room,write,mother,area,national,money,story,young,fact,month,different,lot,study,book,eye,job,word,though,business,issue,side,kind,four,head,far,black,long,both,little,house,yes,since,provide,service,around,friend,important,father,sit,away,until,power,hour,game,often,yet,line,political,end,among,ever,stand,bad,lose,however,member,pay,law,meet,car,city,almost,include,continue,set,later,community,name,five,once,white,least,president,learn,real,change,team,minute,best,several,idea,kid,body,information,nothing,ago,lead,social,understand,whether,watch,together,follow,parent,stop,face,anything,create,public,already,speak,others,read,level,allow,add,office,spend,door,health,person,art,sure,war,history,party,within,grow,result,open,morning,walk,reason,low,win,research,girl,guy,early,food,moment,himself,air,teacher,force,offer,enough,education,across,although,remember,foot,second,boy,maybe,toward,able,age,policy,everything,love,process,music,including,consider,appear,actually,buy,probably,human,wait,serve,market,die,send,expect,sense,build,stay,fall,oh,nation,plan,cut,college,interest,death,course,someone,experience,behind,reach,local,kill,six,remain,effect,yeah,suggest,class,control,raise,care,perhaps,late,hard,field,else,pass,former,sell,major,sometimes,require,along,development,themselves,report,role,better,economic,effort,decide,rate,strong,possible,heart,drug,leader,light,voice,wife,whole,police,mind,finally,pull,return,free,military,price,less,according,decision,explain,son,hope,develop,view,relationship,carry,town,road,drive,arm,TRUE,federal,break,difference,thank,receive,value,international,building,action,full,model,join,season,society,tax,director,position,player,agree,especially,record,pick,wear,paper,special,space,ground,form,support,event,official,whose,matter,everyone,center,couple,site,project,hit,base,activity,star,table,court,produce,eat,teach,oil";

//       final prompt = '''
//       Create a "Fluency Training Scenario".
//       - Use ONLY words from: $allowedWords
//       - Grammar words (is, the, etc.) are allowed.
//       - Return JSON:
//       {
//         "title": "Title",
//         "category": "Topic",
//         "difficulty": "Level",
//         "paragraph": "A story around 50 words",
//         "questions": [{"text": "...", "answer": "...", "type": "fact", "time": 10}]
//       }
//       Generate EXACTLY 20 questions for this demo.
//       ''';

//       final response = await model.generateContent([Content.text(prompt)]);
//       final data = json.decode(response.text!);

//       final scenario = await _supabase.from('AA_scenarios').insert({
//         'title': data['title'],
//         'category': data['category'],
//         'difficulty': data['difficulty'],
//       }).select().single();

//       final paragraph = await _supabase.from('AA_paragraphs').insert({
//         'scenario_id': scenario['id'],
//         'content': data['paragraph']
//       }).select().single();

//       final List<Map<String, dynamic>> questions = (data['questions'] as List).map((q) => {
//         'paragraph_id': paragraph['id'],
//         'question_text': q['text'],
//         'question_type': q['type'] ?? 'fact',
//         'answer': q['answer'],
//         'time_limit_seconds': q['time'] ?? 10,
//       }).toList();

//       await _supabase.from('AA_questions').insert(questions);

//       setState(() {
//         _isGenerating = false;
//         _status = '✅ Success!';
//       });
//       Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
//     } catch (e) {
//       print(e);
//       setState(() {
//         _isGenerating = false;
//         _status = 'Error: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AI Content Generator')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (_isGenerating) 
//                 const CircularProgressIndicator() 
//               else 
//                 const Icon(Icons.bolt, size: 80, color: Colors.amber),
              
//               const SizedBox(height: 20),
//               Text(_status, textAlign: TextAlign.center),
//               const SizedBox(height: 40),
              
//               if (!_isGenerating && !_isLoadingKeys) ...[
//                 const Text("Select Gemini API Key:", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   value: _selectedApiKey,
//                   isExpanded: true,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                   ),
//                   items: _apiKeys.map((keyObj) {
//                     String apiKey = keyObj['api'] ?? '';
//                     // عرض جزء بسيط من المفتاح للخصوصية
//                     String display = apiKey.length > 10 ? '${apiKey.substring(0, 10)}...' : apiKey;
//                     return DropdownMenuItem<String>(
//                       value: apiKey,
//                       child: Text(display),
//                     );
//                   }).toList(),
//                   onChanged: (val) => setState(() => _selectedApiKey = val),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _generate, 
//                     child: const Text('Generate Lesson')
//                   ),
//                 ),
//               ],
              
//               if (_isLoadingKeys) const Text("Fetching available API keys..."),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';

// ==========================================
// 1. الإعدادات والكلمات المسموحة
// ==========================================
const String geminiModel = 'gemini-2.5-flash';
const String supabaseUrl = 'https://qsvhdpitcljewzqjqhbe.supabase.co';
const String supabaseAnnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzdmhkcGl0Y2xqZXd6cWpxaGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDYwMTksImV4cCI6MjA2OTUyMjAxOX0.YH-RR0w03qgYcpHQM-eygczVuheNljrbvXm6i-9uSwM';

const String allowedWords = "large,million,must,home,under,water,room,write,mother,area,national,money,story,young,fact,month,different,lot,study,book,eye,job,word,though,business,issue,side,kind,four,head,far,black,long,both,little,house,yes,since,provide,service,around,friend,important,father,sit,away,until,power,hour,game,often,yet,line,political,end,among,ever,stand,bad,lose,however,member,pay,law,meet,car,city,almost,include,continue,set,later,community,name,five,once,white,least,president,learn,real,change,team,minute,best,several,idea,kid,body,information,nothing,ago,lead,social,understand,whether,watch,together,follow,parent,stop,face,anything,create,public,already,speak,others,read,level,allow,add,office,spend,door,health,person,art,sure,war,history,party,within,grow,result,open,morning,walk,reason,low,win,research,girl,guy,early,food,moment,himself,air,teacher,force,offer,enough,education,across,although,remember,foot,second,boy,maybe,toward,able,age,policy,everything,love,process,music,including,consider,appear,actually,buy,probably,human,wait,serve,market,die,send,expect,sense,build,stay,fall,oh,nation,plan,cut,college,interest,death,course,someone,experience,behind,reach,local,kill,six,remain,effect,yeah,suggest,class,control,raise,care,perhaps,late,hard,field,else,pass,former,sell,major,sometimes,require,along,development,themselves,report,role,better,economic,effort,decide,rate,strong,possible,heart,drug,leader,light,voice,wife,whole,police,mind,finally,pull,return,free,military,price,less,according,decision,explain,son,hope,develop,view,relationship,carry,town,road,drive,arm,TRUE,federal,break,difference,thank,receive,value,international,building,action,full,model,join,season,society,tax,director,position,player,agree,especially,record,pick,wear,paper,special,space,ground,form,support,event,official,whose,matter,everyone,center,couple,site,project,hit,base,activity,star,table,court,produce,eat,teach,oil";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
  );
  runApp(const SpeakFastApp());
}

class SpeakFastApp extends StatelessWidget {
  const SpeakFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakFast AI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const MainTabScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// شاشة التبويبات الرئيسية
// ==========================================
class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SpeakFast AI', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: "سيناريوهات"),
              Tab(icon: Icon(Icons.translate), text: "اختبار القواعد"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScenariosScreen(),
            GrammarListScreen(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. شاشة السيناريوهات
// ==========================================
class ScenariosScreen extends StatefulWidget {
  const ScenariosScreen({super.key});

  @override
  State<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends State<ScenariosScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _scenarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchScenarios();
  }

  Future<void> _fetchScenarios() async {
    try {
      final response = await _supabase.from('AA_scenarios').select().order('id', ascending: false);
      if (mounted) {
        setState(() {
          _scenarios = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AIGeneratorScreen()));
          _fetchScenarios();
        },
        child: const Icon(Icons.auto_awesome),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scenarios.isEmpty
              ? const Center(child: Text("لا توجد سيناريوهات. قم بإنشاء واحد!"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = _scenarios[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(scenario['title']),
                        subtitle: Text('${scenario['category']} • ${scenario['difficulty']}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainingScreen(scenarioId: scenario['id'])),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// ==========================================
// 3. شق القواعد (Grammar Section)
// ==========================================

class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({super.key});

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _mainGrammar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMainGrammar();
  }

  Future<void> _fetchMainGrammar() async {
    try {
      final response = await _supabase.from('AA_MainGrammer').select().order('id', ascending: false);
      if (mounted) setState(() { _mainGrammar = response; _isLoading = false; });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const GrammarGeneratorScreen()));
          _fetchMainGrammar();
        },
        child: const Icon(Icons.add_task),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mainGrammar.isEmpty
              ? const Center(child: Text("اضغط على الزر لتوليد جمل القواعد بالذكاء الاصطناعي"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _mainGrammar.length,
                  itemBuilder: (context, index) {
                    final item = _mainGrammar[index];
                    return Card(
                      child: ListTile(
                        title: Text(item['Sentences_ar'] ?? ''),
                        subtitle: Text(item['Sentences_en'] ?? ''),
                        trailing: const Icon(Icons.quiz),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GrammarQuizScreen(mainId: item['id'])),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class GrammarQuizScreen extends StatefulWidget {
  final int mainId;
  const GrammarQuizScreen({super.key, required this.mainId});

  @override
  State<GrammarQuizScreen> createState() => _GrammarQuizScreenState();
}

class _GrammarQuizScreenState extends State<GrammarQuizScreen> {
  final _supabase = Supabase.instance.client;
  final FlutterTts _flutterTts = FlutterTts(); 
  List<dynamic> _subs = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showAnswer = false;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSubs();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _fetchSubs() async {
    final response = await _supabase.from('AA_Subgrammer').select().eq('AA_MainGrammer_id', widget.mainId);
    setState(() { _subs = response; _isLoading = false; });
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_subs.isEmpty) return const Scaffold(body: Center(child: Text("لا توجد بيانات")));

    final current = _subs[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("اختبار الأزمنة (${_currentIndex + 1}/${_subs.length})")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Chip(label: Text(current['time'] ?? 'زمن غير معروف', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
            const SizedBox(height: 20),
            Text(current['Sentences_ar'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "اكتب الترجمة الإنجليزية هنا..."),
              maxLines: 2,
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                color: Colors.green.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "الإجابة الصحيحة: ${current['Sentences_en']}",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.green),
                      onPressed: () => _speak(current['Sentences_en'] ?? ''),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => setState(() => _showAnswer = !_showAnswer), child: Text(_showAnswer ? "إخفاء الحل" : "إظهار الحل")),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: _currentIndex > 0 ? () => setState(() { _currentIndex--; _showAnswer = false; _answerController.clear(); }) : null, icon: const Icon(Icons.arrow_back)),
                IconButton(onPressed: _currentIndex < _subs.length - 1 ? () => setState(() { _currentIndex++; _showAnswer = false; _answerController.clear(); }) : null, icon: const Icon(Icons.arrow_forward)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GrammarGeneratorScreen extends StatefulWidget {
  const GrammarGeneratorScreen({super.key});

  @override
  State<GrammarGeneratorScreen> createState() => _GrammarGeneratorScreenState();
}

class _GrammarGeneratorScreenState extends State<GrammarGeneratorScreen> {
  final _supabase = Supabase.instance.client;
  bool _isGenerating = false;
  String _status = "جاهز لتوليد جمل سياقية مقيدة بقائمة الكلمات";
  String? _selectedApiKey;

  Future<void> _generateGrammar() async {
    if (_selectedApiKey == null) return;
    setState(() { _isGenerating = true; _status = "🤖 جارِ التوليد والتدقيق اللغوي..."; });

    try {
      final model = GenerativeModel(model: geminiModel, apiKey: _selectedApiKey!, generationConfig: GenerationConfig(responseMimeType: 'application/json'));
      
      final prompt = '''
      Generate 10 lessons on English tenses. Each lesson covers 12 tenses.
      
      VOCABULARY CONSTRAINT:
      You MUST ONLY use words from this list: $allowedWords.
      Exception: You are allowed to use standard grammar "linking words" (e.g., and, because, so, when, before, after, but).

      STYLE REQUIREMENT:
      Use TWO-PART sentences to explain the context of the tense.
      Example: "I had finished the report before you arrived home".

      Return as JSON:
      {
        "items": [
          {
            "main_ar": "الموضوع باللغة العربية",
            "main_en": "Theme in English",
            "variations": [
              {"ar": "[Arabic explanation]", "en": "[English sentence]", "time": "Tense Name"}
            ]
          }
        ]
      }
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      final data = json.decode(response.text!);

      for (var item in data['items']) {
        final main = await _supabase.from('AA_MainGrammer').insert({
          'Sentences_en': item['main_en'],
          'Sentences_ar': item['main_ar'],
        }).select().single();

        final List<Map<String, dynamic>> subs = (item['variations'] as List).map((v) => {
          'AA_MainGrammer_id': main['id'],
          'Sentences_en': v['en'],
          'Sentences_ar': v['ar'],
          'time': v['time'],
        }).toList();

        await _supabase.from('AA_Subgrammer').insert(subs);
      }

      setState(() { _isGenerating = false; _status = "✅ تم بنجاح!"; });
      Navigator.pop(context);
    } catch (e) {
      setState(() { _isGenerating = false; _status = "❌ خطأ: $e"; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("توليد دروس القواعد")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              if (!_isGenerating) ...[
                ElevatedButton(
                  onPressed: () async {
                    final res = await _supabase.from('AA_api').select();
                    if (res.isNotEmpty) {
                      _selectedApiKey = res.first['api'];
                      _generateGrammar();
                    }
                  },
                  child: const Text("ابدأ التوليد المقيد"),
                )
              ] else const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. شاشة التدريب
// ==========================================
enum TrainingState { reading, rapidFire, finished }

class TrainingScreen extends StatefulWidget {
  final int scenarioId;
  const TrainingScreen({super.key, required this.scenarioId});
  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final _supabase = Supabase.instance.client;
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  TrainingState _currentState = TrainingState.reading;
  Map<String, dynamic>? _paragraph;
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isListening = false;
  String _lastWords = "";
  Timer? _timer;
  int _timeLeft = 0;
  bool _showModelAnswer = false;
  bool _isSpeechInitialized = false;
  double _speechRate = 0.5;

  @override
  void initState() {
    super.initState();
    _initTts();
    _fetchTrainingData();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(_speechRate);
  }

  Future<void> _fetchTrainingData() async {
    try {
      final para = await _supabase.from('AA_paragraphs').select().eq('scenario_id', widget.scenarioId).single();
      final ques = await _supabase.from('AA_questions').select().eq('paragraph_id', para['id']).order('id', ascending: true);
      if (mounted) setState(() { _paragraph = para; _questions = ques; });
    } catch (e) { debugPrint('Error: $e'); }
  }

  void _listen() async {
    if (_showModelAnswer) return;
    var status = await Permission.microphone.request();
    if (!status.isGranted) return;
    if (!_isSpeechInitialized) {
      _isSpeechInitialized = await _speech.initialize();
    }
    if (!_isListening) {
      setState(() => _isListening = true);
      await _speech.listen(onResult: (val) => setState(() => _lastWords = val.recognizedWords));
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  void _loadQuestion() async {
    if (_questions.isEmpty) return;
    final q = _questions[_currentQuestionIndex];
    setState(() { _timeLeft = q['time_limit_seconds'] ?? 10; _showModelAnswer = false; _lastWords = ""; });
    await flutterTts.speak(q['question_text']);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 0) setState(() => _timeLeft--);
      else { t.cancel(); setState(() => _showModelAnswer = true); }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_paragraph == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('جلسة التدريب')),
      body: _currentState == TrainingState.reading ? _buildReading() : _buildRapidFire(),
    );
  }

  Widget _buildReading() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Text(_paragraph!['content'], style: const TextStyle(fontSize: 20)))),
          ElevatedButton(onPressed: () { setState(() => _currentState = TrainingState.rapidFire); _loadQuestion(); }, child: const Text("بدء الأسئلة")),
        ],
      ),
    );
  }

  Widget _buildRapidFire() {
    if (_currentQuestionIndex >= _questions.length) return const Center(child: Text("انتهى!"));
    final q = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("الوقت: $_timeLeft", style: const TextStyle(fontSize: 20, color: Colors.red)),
          const SizedBox(height: 20),
          Text(q['question_text'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(_lastWords, style: const TextStyle(fontSize: 18, color: Colors.indigo)),
          IconButton(onPressed: _listen, icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 50)),
          const Spacer(),
          if (_showModelAnswer) Text("الحل: ${q['answer']}", style: const TextStyle(color: Colors.green)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: () { if(_currentQuestionIndex > 0) setState(() => _currentQuestionIndex--); _loadQuestion(); }, child: const Text("السابق")),
              ElevatedButton(onPressed: () { if(_currentQuestionIndex < _questions.length -1) setState(() => _currentQuestionIndex++); else Navigator.pop(context); _loadQuestion(); }, child: const Text("التالي")),
            ],
          )
        ],
      ),
    );
  }
}

// شاشة التوليد (تم حل مشكلة الـ question_type هنا)
class AIGeneratorScreen extends StatefulWidget {
  const AIGeneratorScreen({super.key});
  @override
  State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
}

class _AIGeneratorScreenState extends State<AIGeneratorScreen> {
  final _supabase = Supabase.instance.client;
  bool _isGenerating = false;
  
  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    final apiRes = await _supabase.from('AA_api').select();
    final model = GenerativeModel(model: geminiModel, apiKey: apiRes.first['api'], generationConfig: GenerationConfig(responseMimeType: 'application/json'));
    
    final prompt = '''
    Create a Fluency Training Scenario.
    VOCABULARY CONSTRAINT: Only use words from this list: $allowedWords. (Except linking words).
    JSON Format: {
      "title": "Short title",
      "category": "Topic",
      "difficulty": "Easy",
      "paragraph": "A story/paragraph using the words",
      "questions": [{"text": "Question?", "answer": "Answer", "time": 15}]
    }
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final data = json.decode(response.text!);
      
      final sc = await _supabase.from('AA_scenarios').insert({
        'title': data['title'],
        'category': data['category'],
        'difficulty': data['difficulty']
      }).select().single();
      
      final pg = await _supabase.from('AA_paragraphs').insert({
        'scenario_id': sc['id'],
        'content': data['paragraph']
      }).select().single();
      
      final List<Map<String, dynamic>> qs = (data['questions'] as List).map((q) => {
        'paragraph_id': pg['id'],
        'question_text': q['text'],
        'answer': q['answer'],
        'time_limit_seconds': q['time'],
        'question_type': 'general' // إضافة القيمة المفقودة لحل خطأ قاعدة البيانات
      }).toList();
      
      await _supabase.from('AA_questions').insert(qs);
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error during generation: $e");
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("توليد سيناريو مقيد")),
      body: Center(
        child: _isGenerating 
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text("جارِ التوليد باستخدام قائمة الكلمات المسموحة...")],
            ) 
          : ElevatedButton(onPressed: _generate, child: const Text("توليد سيناريو جديد")),
      ),
    );
  }
}