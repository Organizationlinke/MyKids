import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mykids/SpeakFast.dart';
import 'package:mykids/english.dart';
import 'package:mykids/ocr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

// --- (A) معلومات Supabase الخاصة بك ---
// قم بلصق نفس المعلومات الموجودة في ملف HTML
const String supabaseUrl = 'https://qsvhdpitcljewzqjqhbe.supabase.co';
const String supabaseAnnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzdmhkcGl0Y2xqZXd6cWpxaGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDYwMTksImV4cCI6MjA2OTUyMjAxOX0.YH-RR0w03qgYcpHQM-eygczVuheNljrbvXm6i-9uSwM';

// --- (B) الروابط الصوتية الثابتة ---
const String correctAudioUrl =
    'https://qsvhdpitcljewzqjqhbe.supabase.co/storage/v1/object/public/sounds/feedback_sounds/bravo_correct.wav';
const String incorrectAudioUrl =
    'https://qsvhdpitcljewzqjqhbe.supabase.co/storage/v1/object/public/sounds/feedback_sounds/error_try_again.wav';

// --- الدالة الرئيسية لتشغيل التطبيق ---
Future<void> main() async {
  // تأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
  );

  // تشغيل التطبيق مع مدير الحالة (Provider)
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const AlphabetApp(),
    ),
  );
}

// ===============================================
// (1) نماذج البيانات (Data Models)
// ===============================================

// نموذج لجدول المستخدمين A_Alphabet_users
class AppUser {
  final int id;
  final String userName;
  final String? url;
  final String depart1; // سيتم تخزينها كـ JSON String
  final String depart2;
  final String depart3;

  AppUser({
    required this.id,
    required this.userName,
    this.url,
    required this.depart1,
    required this.depart2,
    required this.depart3,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      userName: json['user_name'] ?? 'مستخدم',
      url: json['url'],
      depart1: json['depart1'] ?? '[]',
      depart2: json['depart2'] ?? '[]',
      depart3: json['depart3'] ?? '[]',
    );
  }

  // دالة لنسخ الكائن مع تعديلات (مفيدة عند حفظ الإعدادات)
  AppUser copyWith({
    String? depart1,
    String? depart2,
    String? depart3,
  }) {
    return AppUser(
      id: id,
      userName: userName,
      url: url,
      depart1: depart1 ?? this.depart1,
      depart2: depart2 ?? this.depart2,
      depart3: depart3 ?? this.depart3,
    );
  }
}

// نموذج لجدول الحروف A_Alphabet
class AlphabetLetter {
  final int id;
  final String letter;
  // يمكنك إضافة باقي الحقول إذا احتجت إليها

  AlphabetLetter({required this.id, required this.letter});

  factory AlphabetLetter.fromJson(Map<String, dynamic> json) {
    return AlphabetLetter(
      id: json['id'],
      letter: json['letter'] ?? '؟',
    );
  }
}

// نموذج لجدول الأسئلة A_Alphabet_questions
class Question {
  final int id;
  final int alphabetId;
  final String questionText;
  final String chose01;
  final String chose02;
  final String chose03;
  final String chose04;
  final String choseCorrect;
  final String? mp3Url;
  final String depart;

  Question({
    required this.id,
    required this.alphabetId,
    required this.questionText,
    required this.chose01,
    required this.chose02,
    required this.chose03,
    required this.chose04,
    required this.choseCorrect,
    this.mp3Url,
    required this.depart,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      alphabetId: json['A_Alphabet_id'],
      questionText: json['question'] ?? 'اختر الإجابة',
      chose01: json['chose01'] ?? '1',
      chose02: json['chose02'] ?? '2',
      chose03: json['chose03'] ?? '3',
      chose04: json['chose04'] ?? '4',
      choseCorrect: json['chose_correct'] ?? '1',
      mp3Url: json['mp3_url'],
      depart: json['depart'] ?? '1',
    );
  }

  // دالة لجلب الاختيارات مبعثرة
  List<String> getShuffledChoices() {
    final choices = [chose01, chose02, chose03, chose04];
    choices.shuffle();
    return choices;
  }
}

// ===============================================
// (2) مدير الحالة (AppState)
// ===============================================

class AppState extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- (1) الحالة العامة للتطبيق ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _loadingMessage = 'جاري تحميل التطبيق...';
  String get loadingMessage => _loadingMessage;

  List<AppUser> _allUsers = [];
  List<AppUser> get allUsers => _allUsers;

  List<AlphabetLetter> _allAlphabet = [];
  List<AlphabetLetter> get allAlphabet => _allAlphabet;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // --- (2) حالة الاختبار ---
  List<Question> _currentQuestionQueue = [];
  Question? _currentQuestion;
  Question? get currentQuestion => _currentQuestion;

  List<String> _shuffledChoices = [];
  List<String> get shuffledChoices => _shuffledChoices;

  bool _isCheckingAnswer = false;
  bool get isCheckingAnswer => _isCheckingAnswer;

  bool? _lastAnswerWasCorrect;
  bool? get lastAnswerWasCorrect => _lastAnswerWasCorrect;

  // --- (3) مشغلات الصوت ---
  final AudioPlayer _questionAudioPlayer = AudioPlayer();
  final AudioPlayer _correctAudioPlayer = AudioPlayer();
  final AudioPlayer _incorrectAudioPlayer = AudioPlayer();

  AppState() {
    _initAudioPlayers();
  }

  void _initAudioPlayers() {
    // إعداد المصادر الثابتة
    _correctAudioPlayer.setSource(UrlSource(correctAudioUrl));
    _incorrectAudioPlayer.setSource(UrlSource(incorrectAudioUrl));
    _correctAudioPlayer.setReleaseMode(ReleaseMode.stop);
    _incorrectAudioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  // --- (A) دوال تهيئة التطبيق ---

  Future<void> initApp() async {
    try {
      _setLoading(true, 'جاري تحميل المستخدمين والحروف...');
      final usersResponse =
          await _supabase.from('A_Alphabet_users').select();
      final alphabetResponse =
          await _supabase.from('A_Alphabet').select('id, letter').order('id');

      _allUsers = (usersResponse as List)
          .map((json) => AppUser.fromJson(json))
          .toList();
      _allAlphabet = (alphabetResponse as List)
          .map((json) => AlphabetLetter.fromJson(json))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setLoading(true, 'خطأ في التحميل: ${e.toString()}');
    }
  }

  void selectUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // --- (B) دوال شاشة الإعدادات ---

  Future<bool> saveSettings(
      List<int> dept1Ids, List<int> dept2Ids, List<int> dept3Ids) async {
    if (_currentUser == null) return false;

    final String dept1Json = jsonEncode(dept1Ids);
    final String dept2Json = jsonEncode(dept2Ids);
    final String dept3Json = jsonEncode(dept3Ids);

    try {
      final response = await _supabase
          .from('A_Alphabet_users')
          .update({
            'depart1': dept1Json,
            'depart2': dept2Json,
            'depart3': dept3Json,
          })
          .eq('id', _currentUser!.id)
          .select() // .select() لإرجاع البيانات المحدثة
          .single();

      // تحديث المستخدم الحالي في الحالة
      _currentUser = AppUser.fromJson(response);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error saving settings: $e");
      return false;
    }
  }

  // --- (C) دوال منطق الاختبار (الأساسية) ---

  Future<void> loadQuestionsForUser(int department) async {
    if (_currentUser == null) return;

    _setLoading(true, 'جاري تحميل الأسئلة...');
    _currentQuestionQueue = [];

    // 1. تحديد الحروف المسموحة للمستخدم
    String jsonString = '[]';
    if (department == 1) jsonString = _currentUser!.depart1;
    if (department == 2) jsonString = _currentUser!.depart2;
    if (department == 3) jsonString = _currentUser!.depart3;

    List<int> allowedLetterIds = [];
    try {
      allowedLetterIds = (jsonDecode(jsonString) as List)
          .map((id) => id as int)
          .toList();
    } catch (e) {
      debugPrint("Error parsing depart JSON: $e");
    }

    if (allowedLetterIds.isEmpty) {
      _setLoading(false); // لا توجد حروف، سيعرض شاشة الإكمال
      return;
    }

    try {
      // 2. جلب جميع الأسئلة المطابقة لهذه الحروف
      final questionsResponse = await _supabase
          .from('A_Alphabet_questions')
          .select()
          .eq('depart', department.toString())
          .inFilter('A_Alphabet_id', allowedLetterIds);

      final allQuestions = (questionsResponse as List)
          .map((q) => Question.fromJson(q))
          .toList();

      // 3. جلب سجل إجابات المستخدم
      final progressResponse = await _supabase
          .from('A_Alphabet_questions_users')
          .select('A_Alphabet_questions_id, is_true')
          .eq('user_id', _currentUser!.id);

      final progressData = progressResponse as List;

      // 4. تصفية الأسئلة التي أجاب عليها "صحيح"
      final answeredCorrectlyIds = progressData
          .where((p) => p['is_true'] == true)
          .map((p) => p['A_Alphabet_questions_id'] as int)
          .toSet();

      _currentQuestionQueue = allQuestions
          .where((q) => !answeredCorrectlyIds.contains(q.id))
          .toList();
      _currentQuestionQueue.shuffle();

      debugPrint(
          "Loaded ${_currentQuestionQueue.length} unanswered questions.");
    } catch (e) {
      _setLoading(true, 'خطأ في تحميل الأسئلة: ${e.toString()}');
    }

    _setLoading(false);
  }

  // دالة لبدء الاختبار وعرض السؤال الأول
  void showNextQuestion() {
    if (_currentQuestionQueue.isEmpty) {
      _currentQuestion = null; // لا توجد أسئلة متبقية
    } else {
      _currentQuestion = _currentQuestionQueue.removeAt(0);
      _shuffledChoices = _currentQuestion!.getShuffledChoices();
      playQuestionAudio(); // تشغيل صوت السؤال تلقائياً
    }
    _isCheckingAnswer = false;
    _lastAnswerWasCorrect = null;
    notifyListeners();
  }

  // دالة فحص الإجابة (النقطة الأهم)
  Future<void> checkAnswer(String selectedChoice) async {
    if (_isCheckingAnswer || _currentQuestion == null) return;

    _isCheckingAnswer = true;
    final bool isCorrect = selectedChoice == _currentQuestion!.choseCorrect;
    _lastAnswerWasCorrect = isCorrect;
    notifyListeners();

    // 1. تحديث قاعدة البيانات بالنتيجة
    await _updateQuestionStatus(_currentQuestion!.id, isCorrect);

    // 2. تشغيل الصوت (صحيح أو خطأ)
    final audioPlayerToUse =
        isCorrect ? _correctAudioPlayer : _incorrectAudioPlayer;

    // استخدام Completer لمحاكاة حدث 'onEnded'
    final audioCompleter = Completer<void>();
    StreamSubscription? sub;
    sub = audioPlayerToUse.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        if (!audioCompleter.isCompleted) {
          audioCompleter.complete();
          sub?.cancel();
        }
      }
    });

    // تشغيل الصوت (إعادة التعيين للبداية أولاً)
    await audioPlayerToUse.seek(Duration.zero);
    await audioPlayerToUse.resume();

    // 3. مؤقت احتياطي (كما في ملف JS)
    final failsafeTimer = Timer(const Duration(seconds: 5), () {
      if (!audioCompleter.isCompleted) {
        audioCompleter.complete();
        sub?.cancel();
      }
    });

    // 4. انتظار انتهاء الصوت (أو 5 ثوانٍ)
    await audioCompleter.future;
    failsafeTimer.cancel(); // إلغاء المؤقت الاحتياطي
    sub?.cancel(); // إلغاء المستمع

    // 5. إذا كانت الإجابة خاطئة، أعد السؤال لآخر القائمة
    if (!isCorrect) {
      _currentQuestionQueue.add(_currentQuestion!);
      _currentQuestionQueue.shuffle(); // (اختياري)
    }

    // 6. عرض السؤال التالي
    showNextQuestion();
  }

  // دالة تشغيل صوت السؤال
  void playQuestionAudio() async{
    if (_currentQuestion?.mp3Url != null &&
        _currentQuestion!.mp3Url!.isNotEmpty) {
      await _questionAudioPlayer.play(UrlSource(_currentQuestion!.mp3Url!));
    }
  }

  // دالة تحديث سجل المستخدم (UPSERT)
  Future<void> _updateQuestionStatus(int questionId, bool status) async {
    if (_currentUser == null) return;
    final userId = _currentUser!.id;

    try {
      // 1. التحقق من وجود سجل
      final existing = await _supabase
          .from('A_Alphabet_questions_users')
          .select('id')
          .eq('user_id', userId)
          .eq('A_Alphabet_questions_id', questionId)
          .limit(1);

      if ((existing as List).isNotEmpty) {
        // 2. تحديث السجل
        await _supabase
            .from('A_Alphabet_questions_users')
            .update({
              'is_true': status,
              'created_at': DateTime.now().toIso8601String()
            })
            .eq('id', existing[0]['id']);
      } else {
        // 3. إدراج سجل جديد
        await _supabase.from('A_Alphabet_questions_users').insert({
          'user_id': userId,
          'A_Alphabet_questions_id': questionId,
          'is_true': status
        });
      }
    } catch (e) {
      debugPrint("Error updating progress: $e");
    }
  }

  // --- (D) دوال مساعدة ---
  void _setLoading(bool loading, [String message = '']) {
    _isLoading = loading;
    if (loading) _loadingMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _questionAudioPlayer.dispose();
    _correctAudioPlayer.dispose();
    _incorrectAudioPlayer.dispose();
    super.dispose();
  }
}

// ===============================================
// (3) التطبيق والشاشات (Widgets)
// ===============================================

class AlphabetApp extends StatelessWidget {
  const AlphabetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تعليم حروف الهجاء',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFFFBEB), // bg-yellow-50
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.blue[900]),
        // إعدادات الخط الافتراضي
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // تحديد الاتجاه من اليمين لليسار
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('ar', ''), // العربية
      // ],
      home: const InitialLoadingScreen(),
    );
  }
}

// --- الشاشة 1: شاشة التحميل الأولية ---
class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // بدء تحميل البيانات عند فتح التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().initApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة حالة التحميل
    final isLoading = context.watch<AppState>().isLoading;
    final loadingMessage = context.watch<AppState>().loadingMessage;

    // إذا انتهى التحميل، اذهب لشاشة اختيار المستخدم
    if (!isLoading) {
      // استخدام Future.microtask لتجنب استدعاء setState أثناء build
      Future.microtask(() => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UserSelectionScreen()),
          ));
    }

    // عرض شاشة التحميل
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              loadingMessage,
              style:
                  const TextStyle(fontSize: 18, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// --- الشاشة 2: شاشة اختيار المستخدم ---
class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      floatingActionButton: IconButton(onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OCRScannerScreen(userId: '10',)),
            );
      }, icon: Icon(Icons.abc)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                   Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                     const LevelsScreen()
                                 
                          ));
                  // LevelsScreen();
                }, icon: Icon(Icons.abc_outlined)),
                 IconButton(onPressed: (){
                   Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                     const SpeakFastApp()
                                 
                          ));
                  // LevelsScreen();
                }, icon: Icon(Icons.abc_outlined)),
                Text(
                  'من سيتعلم اليوم؟',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 40),
                if (state.isLoading)
                  const CircularProgressIndicator()
                else
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: state.allUsers
                        .map((user) =>
                            UserSelectionCard(user: user))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// بطاقة اختيار المستخدم
class UserSelectionCard extends StatelessWidget {
  final AppUser user;
  const UserSelectionCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // صورة افتراضية
    final imageUrl = user.url ??
        'https://placehold.co/150x150/7dd3fc/075985?text=${user.userName[0]}';

    return GestureDetector(
      onTap: () {
        context.read<AppState>().selectUser(user);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
        ));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(imageUrl),
            onBackgroundImageError: (e, s) =>
                debugPrint('Failed to load image $e'),
          ),
          const SizedBox(height: 10),
          Text(
            user.userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}

// --- الشاشة 3: القائمة الرئيسية ---
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;

    if (user == null) {
      // إذا فقدنا المستخدم (مستحيل نظرياً)، عد للبداية
      Future.microtask(() => Navigator.of(context).popUntil((route) => route.isFirst));
      return const Scaffold(body: Center(child: Text('خطأ. جاري العودة...')));
    }

    final imageUrl = user.url ??
        'https://placehold.co/150x150/7dd3fc/075985?text=${user.userName[0]}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'أهلاً، ${user.userName}!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'اختر قسم',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // أزرار الأقسام
                  MainMenuButton(
                    text: 'القسم الأول: الحروف (أ)',
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const QuizScreen(department: 1),
                      ));
                    },
                  ),
                  const SizedBox(height: 20),
                  MainMenuButton(
                    text: 'القسم الثاني: الحركات (أَ)',
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const QuizScreen(department: 2),
                      ));
                    },
                  ),
                  const SizedBox(height: 20),
                  MainMenuButton(
                    text: 'القسم الثالث: أشكال الحروف (ـأ)',
                    color: Colors.purple,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const QuizScreen(department: 3),
                      ));
                    },
                  ),
                  const SizedBox(height: 40),
                  // أزرار الإعدادات وتغيير المستخدم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: const Text('الإعدادات',
                            style:
                                TextStyle(fontSize: 20, color: Colors.blue)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ));
                        },
                      ),
                      TextButton(
                        child: const Text('تغيير المستخدم',
                            style:
                                TextStyle(fontSize: 20, color: Colors.grey)),
                        onPressed: () {
                          context.read<AppState>().logout();
                          Navigator.of(context).pop(); // العودة لشاشة الاختيار
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// زر مخصص للقائمة الرئيسية
class MainMenuButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const MainMenuButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// --- الشاشة 4: شاشة الإعدادات ---
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Set<int> _dept1Selected;
  late Set<int> _dept2Selected;
  late Set<int> _dept3Selected;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser!;
    _dept1Selected = _parseIds(user.depart1);
    _dept2Selected = _parseIds(user.depart2);
    _dept3Selected = _parseIds(user.depart3);
  }

  // دالة مساعدة لتحويل JSON String إلى Set<int>
  Set<int> _parseIds(String jsonString) {
    try {
      final list = jsonDecode(jsonString) as List;
      return list.map((id) => id as int).toSet();
    } catch (e) {
      return {};
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);

    final bool success = await context.read<AppState>().saveSettings(
          _dept1Selected.toList(),
          _dept2Selected.toList(),
          _dept3Selected.toList(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'تم حفظ الإعدادات!' : 'خطأ في الحفظ'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        Navigator.of(context).pop(); // العودة للقائمة الرئيسية
      } else {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAlphabet = context.read<AppState>().allAlphabet;
    final userName = context.read<AppState>().currentUser?.userName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('إعدادات: $userName'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      // استخدام FloatingActionButton لحفظ التغييرات
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isSaving
          ? const CircularProgressIndicator()
          : FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text('حفظ الإعدادات',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              onPressed: _saveSettings,
            ),
      body: ListView(
        padding:
            const EdgeInsets.all(16.0).copyWith(bottom: 100), // لإظهار الزر
        children: [
          _buildSection(
            title: 'القسم الأول: الحروف (أ)',
            color: Colors.green,
            alphabet: allAlphabet,
            selectedSet: _dept1Selected,
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'القسم الثاني: الحركات (أَ)',
            color: Colors.orange,
            alphabet: allAlphabet,
            selectedSet: _dept2Selected,
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'القسم الثالث: أشكال الحروف (ـأ)',
            color: Colors.purple,
            alphabet: allAlphabet,
            selectedSet: _dept3Selected,
          ),
        ],
      ),
    );
  }

  // ويدجت لعرض قسم الإعدادات
  Widget _buildSection({
    required String title,
    required Color color,
    required List<AlphabetLetter> alphabet,
    required Set<int> selectedSet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: alphabet.map((letter) {
                final bool isSelected = selectedSet.contains(letter.id);
                return FilterChip(
                  label: Text(
                    letter.letter,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.blue[400],
                  backgroundColor: Colors.grey[200],
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedSet.add(letter.id);
                      } else {
                        selectedSet.remove(letter.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- الشاشة 5: شاشة الاختبار ---
class QuizScreen extends StatefulWidget {
  final int department;
  const QuizScreen({super.key, required this.department});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    // بدء تحميل الأسئلة وعرض السؤال الأول
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = context.read<AppState>();
      await state.loadQuestionsForUser(widget.department);
      // بعد التحميل، اعرض السؤال الأول (إذا كان موجوداً)
      state.showNextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة الحالة
    final state = context.watch<AppState>();

    // تحديد ما سيتم عرضه
    Widget body;
    if (state.isLoading) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(state.loadingMessage, style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
    } else if (state.currentQuestion == null && !state.isCheckingAnswer) {
      // لا توجد أسئلة (إما لم يتم إعدادها أو اكتملت)
      body = const CompletionScreenContent();
    } else {
      // عرض شاشة الاختبار الفعلية
      body = const QuizContent();
    }

    return Scaffold(
      body: SafeArea(
        // استخدام Stack لعرض الطبقات فوق بعضها (التغذية الراجعة)
        child: Stack(
          children: [
            body,
            // طبقة الإجابة الصحيحة
            if (state.isCheckingAnswer && state.lastAnswerWasCorrect == true)
              const FeedbackOverlay(isCorrect: true),
            // طبقة الإجابة الخاطئة
            if (state.isCheckingAnswer && state.lastAnswerWasCorrect == false)
              const FeedbackOverlay(isCorrect: false),
          ],
        ),
      ),
    );
  }
}

// محتوى شاشة الاختبار (لفصله عن منطق التحميل)
class QuizContent extends StatelessWidget {
  const QuizContent({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final choices = state.shuffledChoices;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // زر السماعة وزر العودة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward,
                    color: Colors.grey, size: 40),
                onPressed: () => Navigator.of(context).pop(),
              ),
              GestureDetector(
                onTap: state.playQuestionAudio,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5)
                    ],
                  ),
                  child:
                      const Icon(Icons.volume_up, color: Colors.blue, size: 50),
                ),
              ),
              // عنصر وهمي للمحاذاة
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 20),
          // شبكة الاختيارات (تملأ باقي الشاشة)
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // ضمان أن الأزرار تملأ المساحة
              childAspectRatio: 0.9,
              physics:
                  const NeverScrollableScrollPhysics(), // منع التمرير
              children: [
                QuizChoiceButton(
                  text: choices.isNotEmpty ? choices[0] : '',
                  color: const Color.fromARGB(255, 21, 3, 183),
                  onPressed: () =>
                      state.checkAnswer(choices[0]),
                ),
                QuizChoiceButton(
                  text: choices.isNotEmpty ? choices[1] : '',
                  color: const Color.fromARGB(255, 2, 98, 24),
                  onPressed: () =>
                      state.checkAnswer(choices[1]),
                ),
                QuizChoiceButton(
                  text: choices.isNotEmpty ? choices[2] : '',
                  color: const Color.fromARGB(255, 112, 102, 6),
                  onPressed: () =>
                      state.checkAnswer(choices[2]),
                ),
                QuizChoiceButton(
                  text: choices.isNotEmpty ? choices[3] : '',
                  color: const Color.fromARGB(255, 154, 2, 52),
                  onPressed: () =>
                      state.checkAnswer(choices[3]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// زر الاختيار (مع خط ضخم)
class QuizChoiceButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const QuizChoiceButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = context.watch<AppState>().isCheckingAnswer;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(isDisabled ? 0.7 : 1.0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: color.withOpacity(0.5),
        elevation: 8,
      ),
      // تعطيل الزر أثناء فحص الإجابة
      onPressed: isDisabled ? null : onPressed,
      child: Center(
        // استخدام FittedBox لجعل الخط يملأ المساحة
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: const TextStyle(fontSize: 70,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              // الخط الضخم جداً سيتم التحكم به بواسطة FittedBox
            ),
          ),
        ),
      ),
    );
  }
}

// --- الشاشة 6: شاشة الإكمال ---
class CompletionScreenContent extends StatelessWidget {
  const CompletionScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 20),
          Text(
            'ممتاز!',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'لقد أكملت جميع الأسئلة المخصصة لك!',
            style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo'),
            ),
            child: const Text('العودة للقائمة'),
            onPressed: () {
              // العودة للقائمة الرئيسية
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

// --- ويدجت إضافي: طبقة التغذية الراجعة ---
class FeedbackOverlay extends StatelessWidget {
  final bool isCorrect;
  const FeedbackOverlay({super.key, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.9),
      child: Center(
        child: Text(
          isCorrect ? '👍' : '🔄',
          style: const TextStyle(
            fontSize: 150,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
