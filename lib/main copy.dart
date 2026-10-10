// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mykids/SpeakFast.dart';
// import 'package:mykids/english.dart';
// import 'package:mykids/ocr.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';

// // --- (A) معلومات Supabase الخاصة بك ---
// // قم بلصق نفس المعلومات الموجودة في ملف HTML
// // const String supabaseUrl = 'https://qsvhdpitcljewzqjqhbe.supabase.co';
// // const String supabaseAnnonKey =
// //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzdmhkcGl0Y2xqZXd6cWpxaGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDYwMTksImV4cCI6MjA2OTUyMjAxOX0.YH-RR0w03qgYcpHQM-eygczVuheNljrbvXm6i-9uSwM';
// const String supabaseUrl = 'https://xozlmszjpnnojmwllmhn.supabase.co';
// const String supabaseAnnonKey ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhvemxtc3pqcG5ub2ptd2xsbWhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA1NTQ3MTQsImV4cCI6MjA5NjEzMDcxNH0.ph0rWg-JQPCjzEP-JZdJ-8OtH0sjNm9QILB5iBlewTY';
// // --- (B) الروابط الصوتية الثابتة ---
// const String correctAudioUrl =
//     'https://qsvhdpitcljewzqjqhbe.supabase.co/storage/v1/object/public/sounds/feedback_sounds/bravo_correct.wav';
// const String incorrectAudioUrl =
//     'https://qsvhdpitcljewzqjqhbe.supabase.co/storage/v1/object/public/sounds/feedback_sounds/error_try_again.wav';

// // --- الدالة الرئيسية لتشغيل التطبيق ---
// Future<void> main() async {
//   // تأكد من تهيئة Flutter
//   WidgetsFlutterBinding.ensureInitialized();

//   // تهيئة Supabase
//   await Supabase.initialize(
//     url: supabaseUrl,
//     anonKey: supabaseAnnonKey,
//   );

//   // تشغيل التطبيق مع مدير الحالة (Provider)
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AppState(),
//       child: const AlphabetApp(),
//     ),
//   );
// }

// // ===============================================
// // (1) نماذج البيانات (Data Models)
// // ===============================================

// // نموذج لجدول المستخدمين A_Alphabet_users
// class AppUser {
//   final int id;
//   final String userName;
//   final String? url;
//   final String depart1; // سيتم تخزينها كـ JSON String
//   final String depart2;
//   final String depart3;

//   AppUser({
//     required this.id,
//     required this.userName,
//     this.url,
//     required this.depart1,
//     required this.depart2,
//     required this.depart3,
//   });

//   factory AppUser.fromJson(Map<String, dynamic> json) {
//     return AppUser(
//       id: json['id'],
//       userName: json['user_name'] ?? 'مستخدم',
//       url: json['url'],
//       depart1: json['depart1'] ?? '[]',
//       depart2: json['depart2'] ?? '[]',
//       depart3: json['depart3'] ?? '[]',
//     );
//   }

//   // دالة لنسخ الكائن مع تعديلات (مفيدة عند حفظ الإعدادات)
//   AppUser copyWith({
//     String? depart1,
//     String? depart2,
//     String? depart3,
//   }) {
//     return AppUser(
//       id: id,
//       userName: userName,
//       url: url,
//       depart1: depart1 ?? this.depart1,
//       depart2: depart2 ?? this.depart2,
//       depart3: depart3 ?? this.depart3,
//     );
//   }
// }

// // نموذج لجدول الحروف A_Alphabet
// class AlphabetLetter {
//   final int id;
//   final String letter;
//   // يمكنك إضافة باقي الحقول إذا احتجت إليها

//   AlphabetLetter({required this.id, required this.letter});

//   factory AlphabetLetter.fromJson(Map<String, dynamic> json) {
//     return AlphabetLetter(
//       id: json['id'],
//       letter: json['letter'] ?? '؟',
//     );
//   }
// }

// // نموذج لجدول الأسئلة A_Alphabet_questions
// class Question {
//   final int id;
//   final int alphabetId;
//   final String questionText;
//   final String chose01;
//   final String chose02;
//   final String chose03;
//   final String chose04;
//   final String choseCorrect;
//   final String? mp3Url;
//   final String depart;

//   Question({
//     required this.id,
//     required this.alphabetId,
//     required this.questionText,
//     required this.chose01,
//     required this.chose02,
//     required this.chose03,
//     required this.chose04,
//     required this.choseCorrect,
//     this.mp3Url,
//     required this.depart,
//   });

//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       id: json['id'],
//       alphabetId: json['A_Alphabet_id'],
//       questionText: json['question'] ?? 'اختر الإجابة',
//       chose01: json['chose01'] ?? '1',
//       chose02: json['chose02'] ?? '2',
//       chose03: json['chose03'] ?? '3',
//       chose04: json['chose04'] ?? '4',
//       choseCorrect: json['chose_correct'] ?? '1',
//       mp3Url: json['mp3_url'],
//       depart: json['depart'] ?? '1',
//     );
//   }

//   // دالة لجلب الاختيارات مبعثرة
//   List<String> getShuffledChoices() {
//     final choices = [chose01, chose02, chose03, chose04];
//     choices.shuffle();
//     return choices;
//   }
// }

// // ===============================================
// // (2) مدير الحالة (AppState)
// // ===============================================

// class AppState extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   // --- (1) الحالة العامة للتطبيق ---
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;

//   String _loadingMessage = 'جاري تحميل التطبيق...';
//   String get loadingMessage => _loadingMessage;

//   List<AppUser> _allUsers = [];
//   List<AppUser> get allUsers => _allUsers;

//   List<AlphabetLetter> _allAlphabet = [];
//   List<AlphabetLetter> get allAlphabet => _allAlphabet;

//   AppUser? _currentUser;
//   AppUser? get currentUser => _currentUser;

//   // --- (2) حالة الاختبار ---
//   List<Question> _currentQuestionQueue = [];
//   Question? _currentQuestion;
//   Question? get currentQuestion => _currentQuestion;

//   List<String> _shuffledChoices = [];
//   List<String> get shuffledChoices => _shuffledChoices;

//   bool _isCheckingAnswer = false;
//   bool get isCheckingAnswer => _isCheckingAnswer;

//   bool? _lastAnswerWasCorrect;
//   bool? get lastAnswerWasCorrect => _lastAnswerWasCorrect;

//   // --- (3) مشغلات الصوت ---
//   final AudioPlayer _questionAudioPlayer = AudioPlayer();
//   final AudioPlayer _correctAudioPlayer = AudioPlayer();
//   final AudioPlayer _incorrectAudioPlayer = AudioPlayer();

//   AppState() {
//     _initAudioPlayers();
//   }

//   void _initAudioPlayers() {
//     // إعداد المصادر الثابتة
//     _correctAudioPlayer.setSource(UrlSource(correctAudioUrl));
//     _incorrectAudioPlayer.setSource(UrlSource(incorrectAudioUrl));
//     _correctAudioPlayer.setReleaseMode(ReleaseMode.stop);
//     _incorrectAudioPlayer.setReleaseMode(ReleaseMode.stop);
//   }

//   // --- (A) دوال تهيئة التطبيق ---

//   Future<void> initApp() async {
//     try {
//       _setLoading(true, 'جاري تحميل المستخدمين والحروف...');
//       final usersResponse =
//           await _supabase.from('A_Alphabet_users').select();
//       final alphabetResponse =
//           await _supabase.from('A_Alphabet').select('id, letter').order('id');

//       _allUsers = (usersResponse as List)
//           .map((json) => AppUser.fromJson(json))
//           .toList();
//       _allAlphabet = (alphabetResponse as List)
//           .map((json) => AlphabetLetter.fromJson(json))
//           .toList();

//       _setLoading(false);
//     } catch (e) {
//       _setLoading(true, 'خطأ في التحميل: ${e.toString()}');
//     }
//   }

//   void selectUser(AppUser user) {
//     _currentUser = user;
//     notifyListeners();
//   }

//   void logout() {
//     _currentUser = null;
//     notifyListeners();
//   }

//   // --- (B) دوال شاشة الإعدادات ---

//   Future<bool> saveSettings(
//       List<int> dept1Ids, List<int> dept2Ids, List<int> dept3Ids) async {
//     if (_currentUser == null) return false;

//     final String dept1Json = jsonEncode(dept1Ids);
//     final String dept2Json = jsonEncode(dept2Ids);
//     final String dept3Json = jsonEncode(dept3Ids);

//     try {
//       final response = await _supabase
//           .from('A_Alphabet_users')
//           .update({
//             'depart1': dept1Json,
//             'depart2': dept2Json,
//             'depart3': dept3Json,
//           })
//           .eq('id', _currentUser!.id)
//           .select() // .select() لإرجاع البيانات المحدثة
//           .single();

//       // تحديث المستخدم الحالي في الحالة
//       _currentUser = AppUser.fromJson(response);
//       notifyListeners();
//       return true;
//     } catch (e) {
//       debugPrint("Error saving settings: $e");
//       return false;
//     }
//   }

//   // --- (C) دوال منطق الاختبار (الأساسية) ---

//   Future<void> loadQuestionsForUser(int department) async {
//     if (_currentUser == null) return;

//     _setLoading(true, 'جاري تحميل الأسئلة...');
//     _currentQuestionQueue = [];

//     // 1. تحديد الحروف المسموحة للمستخدم
//     String jsonString = '[]';
//     if (department == 1) jsonString = _currentUser!.depart1;
//     if (department == 2) jsonString = _currentUser!.depart2;
//     if (department == 3) jsonString = _currentUser!.depart3;

//     List<int> allowedLetterIds = [];
//     try {
//       allowedLetterIds = (jsonDecode(jsonString) as List)
//           .map((id) => id as int)
//           .toList();
//     } catch (e) {
//       debugPrint("Error parsing depart JSON: $e");
//     }

//     if (allowedLetterIds.isEmpty) {
//       _setLoading(false); // لا توجد حروف، سيعرض شاشة الإكمال
//       return;
//     }

//     try {
//       // 2. جلب جميع الأسئلة المطابقة لهذه الحروف
//       final questionsResponse = await _supabase
//           .from('A_Alphabet_questions')
//           .select()
//           .eq('depart', department.toString())
//           .inFilter('A_Alphabet_id', allowedLetterIds);

//       final allQuestions = (questionsResponse as List)
//           .map((q) => Question.fromJson(q))
//           .toList();

//       // 3. جلب سجل إجابات المستخدم
//       final progressResponse = await _supabase
//           .from('A_Alphabet_questions_users')
//           .select('A_Alphabet_questions_id, is_true')
//           .eq('user_id', _currentUser!.id);

//       final progressData = progressResponse as List;

//       // 4. تصفية الأسئلة التي أجاب عليها "صحيح"
//       final answeredCorrectlyIds = progressData
//           .where((p) => p['is_true'] == true)
//           .map((p) => p['A_Alphabet_questions_id'] as int)
//           .toSet();

//       _currentQuestionQueue = allQuestions
//           .where((q) => !answeredCorrectlyIds.contains(q.id))
//           .toList();
//       _currentQuestionQueue.shuffle();

//       debugPrint(
//           "Loaded ${_currentQuestionQueue.length} unanswered questions.");
//     } catch (e) {
//       _setLoading(true, 'خطأ في تحميل الأسئلة: ${e.toString()}');
//     }

//     _setLoading(false);
//   }

//   // دالة لبدء الاختبار وعرض السؤال الأول
//   void showNextQuestion() {
//     if (_currentQuestionQueue.isEmpty) {
//       _currentQuestion = null; // لا توجد أسئلة متبقية
//     } else {
//       _currentQuestion = _currentQuestionQueue.removeAt(0);
//       _shuffledChoices = _currentQuestion!.getShuffledChoices();
//       playQuestionAudio(); // تشغيل صوت السؤال تلقائياً
//     }
//     _isCheckingAnswer = false;
//     _lastAnswerWasCorrect = null;
//     notifyListeners();
//   }

//   // دالة فحص الإجابة (النقطة الأهم)
//   Future<void> checkAnswer(String selectedChoice) async {
//     if (_isCheckingAnswer || _currentQuestion == null) return;

//     _isCheckingAnswer = true;
//     final bool isCorrect = selectedChoice == _currentQuestion!.choseCorrect;
//     _lastAnswerWasCorrect = isCorrect;
//     notifyListeners();

//     // 1. تحديث قاعدة البيانات بالنتيجة
//     // await _updateQuestionStatus(_currentQuestion!.id, isCorrect);

//     // 2. تشغيل الصوت (صحيح أو خطأ)
//     final audioPlayerToUse =
//         isCorrect ? _correctAudioPlayer : _incorrectAudioPlayer;

//     // استخدام Completer لمحاكاة حدث 'onEnded'
//     final audioCompleter = Completer<void>();
//     StreamSubscription? sub;
//     sub = audioPlayerToUse.onPlayerStateChanged.listen((state) {
//       if (state == PlayerState.completed) {
//         if (!audioCompleter.isCompleted) {
//           audioCompleter.complete();
//           sub?.cancel();
//         }
//       }
//     });

//     // تشغيل الصوت (إعادة التعيين للبداية أولاً)
//     await audioPlayerToUse.seek(Duration.zero);
//     await audioPlayerToUse.resume();

//     // 3. مؤقت احتياطي (كما في ملف JS)
//     final failsafeTimer = Timer(const Duration(seconds: 5), () {
//       if (!audioCompleter.isCompleted) {
//         audioCompleter.complete();
//         sub?.cancel();
//       }
//     });

//     // 4. انتظار انتهاء الصوت (أو 5 ثوانٍ)
//     await audioCompleter.future;
//     failsafeTimer.cancel(); // إلغاء المؤقت الاحتياطي
//     sub?.cancel(); // إلغاء المستمع

//     // 5. إذا كانت الإجابة خاطئة، أعد السؤال لآخر القائمة
//     if (!isCorrect) {
//       _currentQuestionQueue.add(_currentQuestion!);
//       _currentQuestionQueue.shuffle(); // (اختياري)
//     }

//     // 6. عرض السؤال التالي
//     showNextQuestion();
//   }

//   // دالة تشغيل صوت السؤال
//   void playQuestionAudio() async{
//     if (_currentQuestion?.mp3Url != null &&
//         _currentQuestion!.mp3Url!.isNotEmpty) {
//       await _questionAudioPlayer.play(UrlSource(_currentQuestion!.mp3Url!));
//     }
//   }

//   // دالة تحديث سجل المستخدم (UPSERT)
//   Future<void> _updateQuestionStatus(int questionId, bool status) async {
//     if (_currentUser == null) return;
//     final userId = _currentUser!.id;

//     try {
//       // 1. التحقق من وجود سجل
//       final existing = await _supabase
//           .from('A_Alphabet_questions_users')
//           .select('id')
//           .eq('user_id', userId)
//           .eq('A_Alphabet_questions_id', questionId)
//           .limit(1);

//       if ((existing as List).isNotEmpty) {
//         // 2. تحديث السجل
//         await _supabase
//             .from('A_Alphabet_questions_users')
//             .update({
//               'is_true': status,
//               'created_at': DateTime.now().toIso8601String()
//             })
//             .eq('id', existing[0]['id']);
//       } else {
//         // 3. إدراج سجل جديد
//         await _supabase.from('A_Alphabet_questions_users').insert({
//           'user_id': userId,
//           'A_Alphabet_questions_id': questionId,
//           'is_true': status
//         });
//       }
//     } catch (e) {
//       debugPrint("Error updating progress: $e");
//     }
//   }

//   // --- (D) دوال مساعدة ---
//   void _setLoading(bool loading, [String message = '']) {
//     _isLoading = loading;
//     if (loading) _loadingMessage = message;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _questionAudioPlayer.dispose();
//     _correctAudioPlayer.dispose();
//     _incorrectAudioPlayer.dispose();
//     super.dispose();
//   }
// }

// // ===============================================
// // (3) التطبيق والشاشات (Widgets)
// // ===============================================

// class AlphabetApp extends StatelessWidget {
//   const AlphabetApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'تعليم حروف الهجاء',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFFFFFBEB), // bg-yellow-50
//         textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)
//             .apply(bodyColor: Colors.blue[900]),
//         // إعدادات الخط الافتراضي
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             textStyle: const TextStyle(
//               fontFamily: 'Cairo',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       // تحديد الاتجاه من اليمين لليسار
//       // localizationsDelegates: const [
//       //   GlobalMaterialLocalizations.delegate,
//       //   GlobalWidgetsLocalizations.delegate,
//       //   GlobalCupertinoLocalizations.delegate,
//       // ],
//       // supportedLocales: const [
//       //   Locale('ar', ''), // العربية
//       // ],
//       home: const InitialLoadingScreen(),
//     );
//   }
// }

// // --- الشاشة 1: شاشة التحميل الأولية ---
// class InitialLoadingScreen extends StatefulWidget {
//   const InitialLoadingScreen({super.key});

//   @override
//   State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
// }

// class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // بدء تحميل البيانات عند فتح التطبيق
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AppState>().initApp();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // مراقبة حالة التحميل
//     final isLoading = context.watch<AppState>().isLoading;
//     final loadingMessage = context.watch<AppState>().loadingMessage;

//     // إذا انتهى التحميل، اذهب لشاشة اختيار المستخدم
//     if (!isLoading) {
//       // استخدام Future.microtask لتجنب استدعاء setState أثناء build
//       Future.microtask(() => Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (_) => const UserSelectionScreen()),
//           ));
//     }

//     // عرض شاشة التحميل
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircularProgressIndicator(),
//             const SizedBox(height: 20),
//             Text(
//               loadingMessage,
//               style:
//                   const TextStyle(fontSize: 18, color: Colors.blueGrey),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- الشاشة 2: شاشة اختيار المستخدم ---
// class UserSelectionScreen extends StatelessWidget {
//   const UserSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<AppState>();

//     return Scaffold(
//       floatingActionButton: IconButton(onPressed: (){
//           Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const OCRScannerScreen(userId: '10',)),
//             );
//       }, icon: Icon(Icons.abc)),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(onPressed: (){
//                    Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                      const LevelsScreen()
                                 
//                           ));
//                   // LevelsScreen();
//                 }, icon: Icon(Icons.abc_outlined)),
//                  IconButton(onPressed: (){
//                    Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                      const SpeakFastApp()
                                 
//                           ));
//                   // LevelsScreen();
//                 }, icon: Icon(Icons.abc_outlined)),
//                 Text(
//                   'من سيتعلم اليوم؟',
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.blue[900],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 if (state.isLoading)
//                   const CircularProgressIndicator()
//                 else
//                   Wrap(
//                     spacing: 20,
//                     runSpacing: 20,
//                     alignment: WrapAlignment.center,
//                     children: state.allUsers
//                         .map((user) =>
//                             UserSelectionCard(user: user))
//                         .toList(),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // بطاقة اختيار المستخدم
// class UserSelectionCard extends StatelessWidget {
//   final AppUser user;
//   const UserSelectionCard({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     // صورة افتراضية
//     final imageUrl = user.url ??
//         'https://placehold.co/150x150/7dd3fc/075985?text=${user.userName[0]}';

//     return GestureDetector(
//       onTap: () {
//         context.read<AppState>().selectUser(user);
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (_) => const MainMenuScreen(),
//         ));
//       },
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: Colors.white,
//             backgroundImage: NetworkImage(imageUrl),
//             onBackgroundImageError: (e, s) =>
//                 debugPrint('Failed to load image $e'),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             user.userName,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- الشاشة 3: القائمة الرئيسية ---
// class MainMenuScreen extends StatelessWidget {
//   const MainMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AppState>().currentUser;

//     if (user == null) {
//       // إذا فقدنا المستخدم (مستحيل نظرياً)، عد للبداية
//       Future.microtask(() => Navigator.of(context).popUntil((route) => route.isFirst));
//       return const Scaffold(body: Center(child: Text('خطأ. جاري العودة...')));
//     }

//     final imageUrl = user.url ??
//         'https://placehold.co/150x150/7dd3fc/075985?text=${user.userName[0]}';

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(imageUrl),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'أهلاً، ${user.userName}!',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[700],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     'اختر قسم',
//                     style: TextStyle(
//                       fontSize: 42,
//                       fontWeight: FontWeight.w900,
//                       color: Colors.blue[900],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // أزرار الأقسام
//                   MainMenuButton(
//                     text: 'القسم الأول: الحروف (أ)',
//                     color: Colors.green,
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (_) => const QuizScreen(department: 1),
//                       ));
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   MainMenuButton(
//                     text: 'القسم الثاني: الحركات (أَ)',
//                     color: Colors.orange,
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (_) => const QuizScreen(department: 2),
//                       ));
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   MainMenuButton(
//                     text: 'القسم الثالث: أشكال الحروف (ـأ)',
//                     color: Colors.purple,
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (_) => const QuizScreen(department: 3),
//                       ));
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   // أزرار الإعدادات وتغيير المستخدم
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TextButton(
//                         child: const Text('الإعدادات',
//                             style:
//                                 TextStyle(fontSize: 20, color: Colors.blue)),
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (_) => const SettingsScreen(),
//                           ));
//                         },
//                       ),
//                       TextButton(
//                         child: const Text('تغيير المستخدم',
//                             style:
//                                 TextStyle(fontSize: 20, color: Colors.grey)),
//                         onPressed: () {
//                           context.read<AppState>().logout();
//                           Navigator.of(context).pop(); // العودة لشاشة الاختيار
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // زر مخصص للقائمة الرئيسية
// class MainMenuButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final VoidCallback onPressed;

//   const MainMenuButton(
//       {super.key,
//       required this.text,
//       required this.color,
//       required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 80),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         textStyle: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'Cairo',
//         ),
//       ),
//       onPressed: onPressed,
//       child: Text(text),
//     );
//   }
// }

// // --- الشاشة 4: شاشة الإعدادات ---
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   late Set<int> _dept1Selected;
//   late Set<int> _dept2Selected;
//   late Set<int> _dept3Selected;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     final user = context.read<AppState>().currentUser!;
//     _dept1Selected = _parseIds(user.depart1);
//     _dept2Selected = _parseIds(user.depart2);
//     _dept3Selected = _parseIds(user.depart3);
//   }

//   // دالة مساعدة لتحويل JSON String إلى Set<int>
//   Set<int> _parseIds(String jsonString) {
//     try {
//       final list = jsonDecode(jsonString) as List;
//       return list.map((id) => id as int).toSet();
//     } catch (e) {
//       return {};
//     }
//   }

//   Future<void> _saveSettings() async {
//     setState(() => _isSaving = true);

//     final bool success = await context.read<AppState>().saveSettings(
//           _dept1Selected.toList(),
//           _dept2Selected.toList(),
//           _dept3Selected.toList(),
//         );

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(success ? 'تم حفظ الإعدادات!' : 'خطأ في الحفظ'),
//           backgroundColor: success ? Colors.green : Colors.red,
//         ),
//       );
//       if (success) {
//         Navigator.of(context).pop(); // العودة للقائمة الرئيسية
//       } else {
//         setState(() => _isSaving = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final allAlphabet = context.read<AppState>().allAlphabet;
//     final userName = context.read<AppState>().currentUser?.userName ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('إعدادات: $userName'),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//       ),
//       // استخدام FloatingActionButton لحفظ التغييرات
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: _isSaving
//           ? const CircularProgressIndicator()
//           : FloatingActionButton.extended(
//               icon: const Icon(Icons.save),
//               label: const Text('حفظ الإعدادات',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               backgroundColor: Colors.blue[600],
//               foregroundColor: Colors.white,
//               onPressed: _saveSettings,
//             ),
//       body: ListView(
//         padding:
//             const EdgeInsets.all(16.0).copyWith(bottom: 100), // لإظهار الزر
//         children: [
//           _buildSection(
//             title: 'القسم الأول: الحروف (أ)',
//             color: Colors.green,
//             alphabet: allAlphabet,
//             selectedSet: _dept1Selected,
//           ),
//           const SizedBox(height: 20),
//           _buildSection(
//             title: 'القسم الثاني: الحركات (أَ)',
//             color: Colors.orange,
//             alphabet: allAlphabet,
//             selectedSet: _dept2Selected,
//           ),
//           const SizedBox(height: 20),
//           _buildSection(
//             title: 'القسم الثالث: أشكال الحروف (ـأ)',
//             color: Colors.purple,
//             alphabet: allAlphabet,
//             selectedSet: _dept3Selected,
//           ),
//         ],
//       ),
//     );
//   }

//   // ويدجت لعرض قسم الإعدادات
//   Widget _buildSection({
//     required String title,
//     required Color color,
//     required List<AlphabetLetter> alphabet,
//     required Set<int> selectedSet,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 5,
//               spreadRadius: 2)
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: alphabet.map((letter) {
//                 final bool isSelected = selectedSet.contains(letter.id);
//                 return FilterChip(
//                   label: Text(
//                     letter.letter,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   selected: isSelected,
//                   selectedColor: Colors.blue[400],
//                   backgroundColor: Colors.grey[200],
//                   onSelected: (bool selected) {
//                     setState(() {
//                       if (selected) {
//                         selectedSet.add(letter.id);
//                       } else {
//                         selectedSet.remove(letter.id);
//                       }
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- الشاشة 5: شاشة الاختبار ---
// class QuizScreen extends StatefulWidget {
//   final int department;
//   const QuizScreen({super.key, required this.department});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // بدء تحميل الأسئلة وعرض السؤال الأول
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final state = context.read<AppState>();
//       await state.loadQuestionsForUser(widget.department);
//       // بعد التحميل، اعرض السؤال الأول (إذا كان موجوداً)
//       state.showNextQuestion();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // مراقبة الحالة
//     final state = context.watch<AppState>();

//     // تحديد ما سيتم عرضه
//     Widget body;
//     if (state.isLoading) {
//       body = Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircularProgressIndicator(),
//             const SizedBox(height: 20),
//             Text(state.loadingMessage, style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       );
//     } else if (state.currentQuestion == null && !state.isCheckingAnswer) {
//       // لا توجد أسئلة (إما لم يتم إعدادها أو اكتملت)
//       body = const CompletionScreenContent();
//     } else {
//       // عرض شاشة الاختبار الفعلية
//       body = const QuizContent();
//     }

//     return Scaffold(
//       body: SafeArea(
//         // استخدام Stack لعرض الطبقات فوق بعضها (التغذية الراجعة)
//         child: Stack(
//           children: [
//             body,
//             // طبقة الإجابة الصحيحة
//             if (state.isCheckingAnswer && state.lastAnswerWasCorrect == true)
//               const FeedbackOverlay(isCorrect: true),
//             // طبقة الإجابة الخاطئة
//             if (state.isCheckingAnswer && state.lastAnswerWasCorrect == false)
//               const FeedbackOverlay(isCorrect: false),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // محتوى شاشة الاختبار (لفصله عن منطق التحميل)
// class QuizContent extends StatelessWidget {
//   const QuizContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<AppState>();
//     final choices = state.shuffledChoices;

//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: [
//           // زر السماعة وزر العودة
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_forward,
//                     color: Colors.grey, size: 40),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               GestureDetector(
//                 onTap: state.playQuestionAudio,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           blurRadius: 5)
//                     ],
//                   ),
//                   child:
//                       const Icon(Icons.volume_up, color: Colors.blue, size: 50),
//                 ),
//               ),
//               // عنصر وهمي للمحاذاة
//               const SizedBox(width: 40),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // شبكة الاختيارات (تملأ باقي الشاشة)
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               // ضمان أن الأزرار تملأ المساحة
//               childAspectRatio: 0.9,
//               physics:
//                   const NeverScrollableScrollPhysics(), // منع التمرير
//               children: [
//                 QuizChoiceButton(
//                   text: choices.isNotEmpty ? choices[0] : '',
//                   color: const Color.fromARGB(255, 21, 3, 183),
//                   onPressed: () =>
//                       state.checkAnswer(choices[0]),
//                 ),
//                 QuizChoiceButton(
//                   text: choices.isNotEmpty ? choices[1] : '',
//                   color: const Color.fromARGB(255, 2, 98, 24),
//                   onPressed: () =>
//                       state.checkAnswer(choices[1]),
//                 ),
//                 QuizChoiceButton(
//                   text: choices.isNotEmpty ? choices[2] : '',
//                   color: const Color.fromARGB(255, 112, 102, 6),
//                   onPressed: () =>
//                       state.checkAnswer(choices[2]),
//                 ),
//                 QuizChoiceButton(
//                   text: choices.isNotEmpty ? choices[3] : '',
//                   color: const Color.fromARGB(255, 154, 2, 52),
//                   onPressed: () =>
//                       state.checkAnswer(choices[3]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // زر الاختيار (مع خط ضخم)
// class QuizChoiceButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final VoidCallback onPressed;

//   const QuizChoiceButton({
//     super.key,
//     required this.text,
//     required this.color,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDisabled = context.watch<AppState>().isCheckingAnswer;

//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color.withOpacity(isDisabled ? 0.7 : 1.0),
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         shadowColor: color.withOpacity(0.5),
//         elevation: 8,
//       ),
//       // تعطيل الزر أثناء فحص الإجابة
//       onPressed: isDisabled ? null : onPressed,
//       child: Center(
//         // استخدام FittedBox لجعل الخط يملأ المساحة
//         child: FittedBox(
//           fit: BoxFit.contain,
//           child: Text(
//             text,
//             style: const TextStyle(fontSize: 70,
//               fontWeight: FontWeight.w900,
//               color: Colors.white,
//               // الخط الضخم جداً سيتم التحكم به بواسطة FittedBox
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- الشاشة 6: شاشة الإكمال ---
// class CompletionScreenContent extends StatelessWidget {
//   const CompletionScreenContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text('🎉', style: TextStyle(fontSize: 100)),
//           const SizedBox(height: 20),
//           Text(
//             'ممتاز!',
//             style: TextStyle(
//               fontSize: 50,
//               fontWeight: FontWeight.w900,
//               color: Colors.green[700],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'لقد أكملت جميع الأسئلة المخصصة لك!',
//             style: TextStyle(fontSize: 22, color: Colors.grey[700]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 40),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               textStyle: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo'),
//             ),
//             child: const Text('العودة للقائمة'),
//             onPressed: () {
//               // العودة للقائمة الرئيسية
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- ويدجت إضافي: طبقة التغذية الراجعة ---
// class FeedbackOverlay extends StatelessWidget {
//   final bool isCorrect;
//   const FeedbackOverlay({super.key, required this.isCorrect});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.9),
//       child: Center(
//         child: Text(
//           isCorrect ? '👍' : '🔄',
//           style: const TextStyle(
//             fontSize: 150,
//             color: Colors.white,
//             decoration: TextDecoration.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // قم بتغيير هذه المفاتيح بمفاتيح مشروعك في Supabase
  await Supabase.initialize(
    url: 'https://kwzpmzvhndyalkrsahys.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3enBtenZobmR5YWxrcnNhaHlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE2MTc0NjQsImV4cCI6MjEwNzE5MzQ2NH0.h98FVvA920uCqpWidfQhMrrL39AQvqoFc5WOHhQpHhk', // ضع مفتاحك هنا
  );

  runApp(const SmartReadingApp());
}

class SmartReadingApp extends StatelessWidget {
  const SmartReadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أبطال القراءة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // يفضل إضافة خط عربي جميل في pubspec.yaml
      ),
      home: const ChildSelectionScreen(),
    );
  }
}

// ==========================================
// 1. شاشة اختيار الطفل (ملف التعريف)
// ==========================================
class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({Key? key}) : super(key: key);

  @override
  _ChildSelectionScreenState createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> childrenList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    try {
      final response = await supabase.from('children').select().order('created_at');
      setState(() {
        childrenList = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _addChild(String name) async {
    if (name.trim().isEmpty) return;
    await supabase.from('children').insert({'name': name.trim(), 'avatar': '👦'});
    _fetchChildren();
  }

  void _showAddChildDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة بطل جديد', textAlign: TextAlign.center),
        content: TextField(
          controller: nameController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(hintText: 'اسم البطل (مثال: حمزة)'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addChild(nameController.text);
              Navigator.pop(context);
            },
            child: const Text('حفظ', style: TextStyle(fontSize: 18, color: Colors.blue)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: const Text('أبطال القراءة', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, elevation: 0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20,
              ),
              itemCount: childrenList.length + 1,
              itemBuilder: (context, index) {
                if (index == childrenList.length) {
                  return InkWell(
                    onTap: _showAddChildDialog,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_circle, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text('إضافة بطل', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    ),
                  );
                }
                final child = childrenList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => LanguageSelectionScreen(childId: child['id'], childName: child['name']),
                    ));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(child['avatar'] ?? '👦', style: const TextStyle(fontSize: 50)),
                        const SizedBox(height: 10),
                        Text(child['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 2. شاشة اختيار اللغة
// ==========================================
class LanguageSelectionScreen extends StatelessWidget {
  final String childId;
  final String childName;

  const LanguageSelectionScreen({Key? key, required this.childId, required this.childName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أهلاً يا $childName! اختر اللغة'), centerTitle: true),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLangCard(context, 'العربية', 'ar', 'أ ب ت', Colors.green),
            _buildLangCard(context, 'English', 'en', 'A B C', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildLangCard(BuildContext context, String title, String langCode, String iconText, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => LevelSelectionScreen(childId: childId, language: langCode),
        ));
      },
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(iconText, style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. شاشة اختيار المستوى
// ==========================================
class LevelSelectionScreen extends StatefulWidget {
  final String childId;
  final String language;

  const LevelSelectionScreen({Key? key, required this.childId, required this.language}) : super(key: key);

  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> levels = [];

  @override
  void initState() {
    super.initState();
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    final response = await supabase
        .from('levels')
        .select()
        .eq('language', widget.language)
        .order('level_number');
    setState(() {
      levels = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر المستوى'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Text(level['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              subtitle: Text(level['description'] ?? '', style: const TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => StageSelectionScreen(
                    childId: widget.childId,
                    language: widget.language,
                    levelId: level['id'],
                    levelTitle: level['title'],
                  ),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. شاشة اختيار المرحلة (كلمات - جمل - قصص)
// ==========================================
class StageSelectionScreen extends StatelessWidget {
  final String childId;
  final String language;
  final String levelId;
  final String levelTitle;

  const StageSelectionScreen({
    Key? key, required this.childId, required this.language, required this.levelId, required this.levelTitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(levelTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStageButton(context, 'المرحلة 1: الكلمات', Colors.blue, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LearningScreen(
                childId: childId, language: language, levelId: levelId, type: 'words'
              )));
            }),
            const SizedBox(height: 20),
            _buildStageButton(context, 'المرحلة 2: الجمل', Colors.green, () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => SentenceLearningScreen(
                childId: childId, language: language, levelId: levelId
              )));
            }),
            const SizedBox(height: 20),
            _buildStageButton(context, 'المرحلة 3: القصص', Colors.orange, () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => StoryLearningScreen(
                childId: childId, language: language, levelId: levelId
              )));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStageButton(BuildContext context, String title, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onTap,
      child: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

// ==========================================
// 5. شاشة التدريب - الكلمات (مع Gemini AI)
// ==========================================
class LearningScreen extends StatefulWidget {
  final String childId;
  final String language;
  final String levelId;
  final String type;

  const LearningScreen({
    Key? key, required this.childId, required this.language, required this.levelId, required this.type
  }) : super(key: key);

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> items = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      // إحضار الكلمات
      final response = await supabase.from('words').select().eq('level_id', widget.levelId);
      List<dynamic> allWords = response;

      if (allWords.isNotEmpty) {
        // فحص الإنجاز
        final progressRes = await supabase.from('child_progress').select('word_id').eq('child_id', widget.childId).eq('is_mastered', true);
        List masteredIds = progressRes.map((p) => p['word_id']).toList();

        // تصفية الكلمات المتبقية
        List<dynamic> remaining = allWords.where((w) => !masteredIds.contains(w['id'])).toList();

        setState(() {
          items = remaining.isNotEmpty ? remaining : allWords; // إعادة تدوير إذا أتقن الكل
          currentIndex = 0;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _markAsMastered() async {
    if (items.isEmpty) return;
    final currentItem = items[currentIndex];
    
    await supabase.from('child_progress').insert({
      'child_id': widget.childId,
      'word_id': currentItem['id'],
      'is_mastered': true,
      'times_practiced': 1
    });

    if (currentIndex < items.length - 1) {
      setState(() => currentIndex++);
    } else {
      _fetchItems(); // تحديث القائمة
    }
  }

  void _speak(String text) async {
    await flutterTts.setLanguage(widget.language == 'ar' ? "ar-SA" : "en-US");
    await flutterTts.setSpeechRate(0.4); // نطق بطيء ليناسب الأطفال
    await flutterTts.speak(text);
  }

  // مولد الذكاء الاصطناعي للكلمات
  Future<void> _generateAIWords() async {
    setState(() => isLoading = true);
    const apiKey = ""; // ضع مفتاح Gemini 1.5 Flash الخاص بك هنا
    if (apiKey.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء وضع مفتاح API')));
      return;
    }

    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    final prompt = "Generate 20 unique simple words for kids learning to read in ${widget.language}. Return ONLY a raw JSON list of strings like [\"word1\", \"word2\"]. No formatting or backticks.";

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}]
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final generatedText = jsonData['candidates'][0]['content']['parts'][0]['text'];
        List<dynamic> newWords = jsonDecode(generatedText.trim());

        for (String word in newWords) {
          await supabase.from('words').insert({
            'level_id': widget.levelId,
            'word_text': word,
            'target_letter': word.isNotEmpty ? word[0] : ''
          });
        }
        await _fetchItems();
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تدريب الكلمات'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.psychology, color: Colors.amber, size: 30), onPressed: _generateAIWords, tooltip: 'توليد بالذكاء الاصطناعي'),
        ],
      ),
      body: items.isEmpty 
        ? const Center(child: Text('لا توجد كلمات حالياً، اضغط على 🧠 لتوليد كلمات.', style: TextStyle(fontSize: 20)))
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('الكلمة ${currentIndex + 1} من ${items.length}', style: const TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 50),
                Text(
                  items[currentIndex]['word_text'],
                  style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _speak(items[currentIndex]['word_text']),
                      icon: const Icon(Icons.volume_up, size: 40),
                      label: const Text('استمع', style: TextStyle(fontSize: 24)),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: _markAsMastered,
                      icon: const Icon(Icons.check_circle, size: 40),
                      label: const Text('أتقنها', style: TextStyle(fontSize: 24)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}

// ==========================================
// 6. شاشة الجمل والقصص المشابهة ستكتب بنفس النمط 
// (تم اختصارها هنا للحفاظ على المساحة، يمكنك نسخ هيكل LearningScreen مع تغيير اسم الجدول لـ 'sentences' أو 'stories')
// ==========================================
class SentenceLearningScreen extends StatefulWidget {
  final String childId;
  final String language;
  final String levelId;

  const SentenceLearningScreen({Key? key, required this.childId, required this.language, required this.levelId}) : super(key: key);

  @override
  _SentenceLearningScreenState createState() => _SentenceLearningScreenState();
}

class _SentenceLearningScreenState extends State<SentenceLearningScreen> {
  // نفس المنطق المستخدم في شاشة الكلمات تماماً ولكن مع جدول sentences
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تدريب الجمل')),
      body: const Center(child: Text('شاشة الجمل قيد الإنشاء... يمكنك تطبيق نفس كود الكلمات هنا بجدول sentences')),
    );
  }
}

class StoryLearningScreen extends StatefulWidget {
  final String childId;
  final String language;
  final String levelId;

  const StoryLearningScreen({Key? key, required this.childId, required this.language, required this.levelId}) : super(key: key);

  @override
  _StoryLearningScreenState createState() => _StoryLearningScreenState();
}

class _StoryLearningScreenState extends State<StoryLearningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تدريب القصص')),
      body: const Center(child: Text('شاشة القصص قيد الإنشاء... يمكنك تطبيق نفس كود الكلمات هنا بجدول stories')),
    );
  }
}