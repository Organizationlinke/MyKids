import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // قم بوضع مفاتيح Supabase الخاصة بك هنا
  await Supabase.initialize(
    url: 'https://kwzpmzvhndyalkrsahys.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3enBtenZobmR5YWxrcnNhaHlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE2MTc0NjQsImV4cCI6MjEwNzE5MzQ2NH0.h98FVvA920uCqpWidfQhMrrL39AQvqoFc5WOHhQpHhk', // ضع مفتاحك
  );

  runApp(const SmartReadingApp());
}

class SmartReadingApp extends StatelessWidget {
  const SmartReadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منصة القراءة الذكية 🌟',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: Colors.indigo.shade600,
        scaffoldBackgroundColor: const Color(
          0xFFF0F9FF,
        ), // خلفية مطابقة لـ Tailwind (blue-50)
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade600,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      home: const ChildSelectionScreen(),
    );
  }
}

// ------------------------------------------------------------------------
// مساعدات التصميم (Helpers) - رسائل ونوافذ وتصاميم مشتركة
// ------------------------------------------------------------------------
void showCustomModal(
  BuildContext context,
  String title,
  String message,
  String icon,
) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.indigo.shade500, width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.indigo.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'حسناً 👍',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

PreferredSizeWidget buildCustomAppBar(
  BuildContext context,
  String title, {
  String? childId,
  String? childName,
}) {
  return AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [const Text('🌟 '), Text(title)],
    ),
    actions: childId != null
        ? [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade400,
                  foregroundColor: Colors.indigo.shade900,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.emoji_events, size: 20),
                label: const Text(
                  'إنجازات البطل',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgressDashboardScreen(
                        childId: childId,
                        childName: childName!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
        : [],
  );
}

// ------------------------------------------------------------------------
// 1. شاشة اختيار الطفل
// ------------------------------------------------------------------------
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
      final response = await supabase
          .from('children')
          .select()
          .order('created_at');
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
    await supabase.from('children').insert({
      'name': name.trim(),
      'avatar': '👦🏽',
    });
    _fetchChildren();
    if (mounted)
      showCustomModal(
        context,
        'تمت الإضافة بنجاح! 🎉',
        'تمت إضافة البطل $name بنجاح.',
        '🎉',
      );
  }

  void _showAddChildDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'إضافة بطل جديد ➕',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        content: TextField(
          controller: nameController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'اسم البطل (مثال: حمزة)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.indigo.shade50,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _addChild(nameController.text);
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'إضافة',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'منصة القراءة الذكية'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'من يدرس اليوم؟ 🌟',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'اختر اسم البطل لبدء رحلة القراءة الممتعة',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 40),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                      itemCount: childrenList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == childrenList.length) {
                          return _buildChildCard(
                            context,
                            '➕',
                            'إضافة بطل',
                            Colors.white,
                            Colors.indigo.shade200,
                            Colors.indigo,
                            onTap: _showAddChildDialog,
                          );
                        }
                        final child = childrenList[index];
                        return _buildChildCard(
                          context,
                          child['avatar'] ?? '👦🏽',
                          child['name'],
                          Colors.amber.shade100,
                          Colors.amber.shade400,
                          Colors.amber.shade900,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LanguageSelectionScreen(
                                childId: child['id'],
                                childName: child['name'],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    String emoji,
    String title,
    Color bg,
    Color border,
    Color text, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 2. شاشة اختيار اللغة
// ------------------------------------------------------------------------
class LanguageSelectionScreen extends StatelessWidget {
  final String childId;
  final String childName;

  const LanguageSelectionScreen({
    Key? key,
    required this.childId,
    required this.childName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'منصة القراءة الذكية',
        childId: childId,
        childName: childName,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أهلاً بك يا $childName! 🌟',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'اختر لغة التعلم المفضلة لديك:',
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              _buildLangCard(
                context,
                'اللغة العربية 📚',
                'حروف المد، الفتح، الضم، الجمل والقصص',
                '🇸🇦',
                Colors.teal.shade500,
                'ar',
              ),
              const SizedBox(height: 20),
              _buildLangCard(
                context,
                'English Language 🌍',
                'Phonics, CVC Words, Sentences & Stories',
                '🇬🇧',
                Colors.orange.shade500,
                'en',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangCard(
    BuildContext context,
    String title,
    String subtitle,
    String iconText,
    Color color,
    String langCode,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategorySelectionScreen(
            childId: childId,
            childName: childName,
            language: langCode,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Text(iconText, style: const TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 3. شاشة اختيار القسم (كلمات - جمل - قصص)
// ------------------------------------------------------------------------
class CategorySelectionScreen extends StatelessWidget {
  final String childId;
  final String childName;
  final String language;

  const CategorySelectionScreen({
    Key? key,
    required this.childId,
    required this.childName,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String langName = language == 'ar' ? 'اللغة العربية' : 'English Language';
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'منصة القراءة الذكية',
        childId: childId,
        childName: childName,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                '$langName 🎯',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'اختر القسم التعليمي الأساسي:',
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              _buildCatCard(
                context,
                'المرحلة 1: الكلمات 🔤',
                'التدرب حسب المستويات مع 20+ كلمة',
                '🗣️',
                Colors.blue.shade500,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelsScreen(
                        childId: childId,
                        childName: childName,
                        language: language,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildCatCard(
                context,
                'المرحلة 2: الجمل 📝',
                'جمل بسيطة ومباشرة للتدريب',
                '📖',
                Colors.purple.shade500,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SentencesScreen(
                        childId: childId,
                        childName: childName,
                        language: language,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildCatCard(
                context,
                'المرحلة 3: القصص 📚',
                'قصص الروتين اليومي الممتعة',
                '🌟',
                Colors.teal.shade500,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoriesScreen(
                        childId: childId,
                        childName: childName,
                        language: language,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatCard(
    BuildContext context,
    String title,
    String subtitle,
    String icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Text(icon, style: const TextStyle(fontSize: 50)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 4. شاشة مستويات الكلمات (للكلمات فقط)
// ------------------------------------------------------------------------
class LevelsScreen extends StatefulWidget {
  final String childId;
  final String childName;
  final String language;

  const LevelsScreen({
    Key? key,
    required this.childId,
    required this.childName,
    required this.language,
  }) : super(key: key);

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
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
    if (mounted) setState(() => levels = response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'مستويات الكلمات 🔤',
        childId: widget.childId,
        childName: widget.childName,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: levels.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.blue.shade200, width: 2),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        level['title'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        level['description'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Text(
                        '➡️',
                        style: TextStyle(fontSize: 24),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WordsScreen(
                              childId: widget.childId,
                              childName: widget.childName,
                              language: widget.language,
                              levelId: level['id'],
                              levelTitle: level['title'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 5. شاشة التدريب للكلمات (مع الذكاء الاصطناعي)
// ------------------------------------------------------------------------
class WordsScreen extends StatefulWidget {
  final String childId, childName, language, levelId, levelTitle;
  const WordsScreen({
    Key? key,
    required this.childId,
    required this.childName,
    required this.language,
    required this.levelId,
    required this.levelTitle,
  }) : super(key: key);

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> items = [];
  int currentIndex = 0;
  bool isLoading = true, isGenerating = false;
  final String apiKey = ""; // ضع المفتاح هنا

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final response = await supabase
          .from('words')
          .select()
          .eq('level_id', widget.levelId);
      List<dynamic> allWords = response;
      if (allWords.isNotEmpty) {
        final progressRes = await supabase
            .from('child_progress')
            .select('word_id')
            .eq('child_id', widget.childId)
            .eq('is_mastered', true);
        List masteredIds = progressRes.map((p) => p['word_id']).toList();
        int startIndex = 0;
        for (int i = 0; i < allWords.length; i++) {
          if (!masteredIds.contains(allWords[i]['id'])) {
            startIndex = i;
            break;
          }
        }
        setState(() {
          items = allWords;
          currentIndex = startIndex;
          isLoading = false;
        });
        _speakWord();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _speakWord() async {
    if (items.isEmpty) return;
    await flutterTts.setLanguage(widget.language == 'ar' ? "ar-SA" : "en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(items[currentIndex]['word_text']);
  }

  Future<void> _markAsMastered() async {
    if (items.isEmpty) return;
    await supabase.from('child_progress').insert({
      'child_id': widget.childId,
      'word_id': items[currentIndex]['id'],
      'is_mastered': true,
      'times_practiced': 1,
    });
    if (currentIndex < items.length - 1) {
      setState(() => currentIndex++);
      _speakWord();
    } else {
      if (mounted)
        showCustomModal(
          context,
          'أحسنت يا بطل! 🎉',
          'أنهيت جميع كلمات هذا المستوى بنجاح! تم العودة لبداية القائمة للمراجعة.',
          '🏆',
        );
      setState(() => currentIndex = 0);
      _speakWord();
    }
  }

  Future<void> _generateAIWords() async {
    if (apiKey.isEmpty) {
      if (mounted)
        showCustomModal(
          context,
          'تنبيه',
          'الرجاء وضع مفتاح API في الكود',
          '⚠️',
        );
      return;
    }
    setState(() => isGenerating = true);
    if (mounted)
      showCustomModal(
        context,
        'جاري التوليد...',
        'الذكاء الاصطناعي يبتكر أكثر من 20 كلمة جديدة 🤖✨',
        '⏳',
      );

    final existingList = items.map((w) => w['word_text']).join(', ');
    final prompt = widget.language == 'ar'
        ? 'أنت خبير تربوي لتطوير قراءة الأطفال. المستوى: "${widget.levelTitle}". الكلمات الموجودة: [$existingList]. أنشئ 20 كلمة عربية جديدة وغير مكررة. أرجع الناتج بصيغة JSON فقط: [{"word_text": "كلمة"}].'
        : 'Reading expert. Level: "${widget.levelTitle}". Existing: [$existingList]. Generate 20 new unique words. Return JSON only: [{"word_text": "word"}].';

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final textResult = jsonDecode(
          response.body,
        )['candidates'][0]['content']['parts'][0]['text'];
        String cleanedJson = textResult
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        List<dynamic> newWords = jsonDecode(cleanedJson);

        for (var item in newWords) {
          if (item['word_text'] != null) {
            await supabase.from('words').insert({
              'level_id': widget.levelId,
              'word_text': item['word_text'],
              'target_letter': item['word_text'].toString().isNotEmpty
                  ? item['word_text'][0]
                  : '',
            });
          }
        }
        Navigator.pop(context); // إغلاق رسالة التوليد
        if (mounted)
          showCustomModal(
            context,
            'تم بنجاح! 🚀',
            'تم توليد 20 كلمة جديدة وإضافتها للنظام.',
            '🎉',
          );
        await _fetchItems();
      }
    } catch (e) {
      Navigator.pop(context);
      if (mounted)
        showCustomModal(context, 'خطأ', 'حدث خطأ أثناء التوليد.', '❌');
    }
    setState(() => isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'تدريب الكلمات',
        childId: widget.childId,
        childName: widget.childName,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: items.isEmpty
              ? _buildEmptyState(
                  'لا توجد كلمات في هذا المستوى بعد',
                  'اضغط على زر التوليد لجلب 20+ كلمة فريدة',
                  Colors.blue,
                  _generateAIWords,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            'الكلمة ${currentIndex + 1} من ${items.length}',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.blue.shade100,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.psychology),
                          label: Text(
                            isGenerating ? 'جاري...' : 'توليد 20 كلمة 🤖',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: isGenerating ? null : _generateAIWords,
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _speakWord,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          border: Border.all(
                            color: Colors.amber.shade300,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'اضغط للاستماع 🔊',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              items[currentIndex]['word_text'],
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w900,
                                color: Colors.indigo.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'استمع',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _speakWord,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'أتقنها ⬅️',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _markAsMastered,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    Color color,
    VoidCallback onGenerate,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withAlpha(50), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.indigo.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onGenerate,
              child: const Text(
                'توليد بالذكاء الاصطناعي ✨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 6. شاشة الجمل (SentencesScreen - اللون الأرجواني)
// ------------------------------------------------------------------------
class SentencesScreen extends StatefulWidget {
  final String childId, childName, language;
  const SentencesScreen({
    Key? key,
    required this.childId,
    required this.childName,
    required this.language,
  }) : super(key: key);

  @override
  _SentencesScreenState createState() => _SentencesScreenState();
}

class _SentencesScreenState extends State<SentencesScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> items = [];
  int currentIndex = 0;
  bool isLoading = true, isGenerating = false;

  // ⚠️ ضع مفتاح Gemini API الخاص بك هنا
  final String apiKey = "";

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final response = await supabase.from('sentences').select();
      List<dynamic> allItems = response;
      if (allItems.isNotEmpty) {
        final progressRes = await supabase
            .from('child_progress')
            .select('word_id')
            .eq('child_id', widget.childId)
            .eq('is_mastered', true);
        List masteredIds = progressRes.map((p) => p['word_id']).toList();

        int startIndex = 0;
        for (int i = 0; i < allItems.length; i++) {
          if (!masteredIds.contains(allItems[i]['id'])) {
            startIndex = i;
            break;
          }
        }
        setState(() {
          items = allItems;
          currentIndex = startIndex;
          isLoading = false;
        });
        _speakSentence();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _speakSentence() async {
    if (items.isEmpty) return;
    await flutterTts.setLanguage(widget.language == 'ar' ? "ar-SA" : "en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(items[currentIndex]['sentence_text']);
  }

  Future<void> _markAsMastered() async {
    if (items.isEmpty) return;
    try {
      await supabase.from('child_progress').insert({
        'child_id': widget.childId,
        'word_id': items[currentIndex]['id'],
        'is_mastered': true,
        'times_practiced': 1,
      });
    } catch (e) {} // تجاوز أخطاء الربط إن وجدت

    if (currentIndex < items.length - 1) {
      setState(() => currentIndex++);
      _speakSentence();
    } else {
      if (mounted)
        showCustomModal(
          context,
          'أحسنت يا بطل! 🎉',
          'أنهيت جميع الجمل بنجاح! تم العودة للبداية.',
          '🏆',
        );
      setState(() => currentIndex = 0);
      _speakSentence();
    }
  }

  Future<void> _generateAISentences() async {
    if (apiKey.isEmpty) {
      if (mounted)
        showCustomModal(context, 'تنبيه', 'الرجاء وضع مفتاح API', '⚠️');
      return;
    }
    setState(() => isGenerating = true);
    if (mounted)
      showCustomModal(
        context,
        'جاري التوليد...',
        'الذكاء الاصطناعي يبتكر جملاً جديدة ومتنوعة 🤖✨',
        '⏳',
      );

    // 1. جلب الجمل الموجودة لمنع التكرار
    final existingList = items.map((w) => w['sentence_text']).join('، ');

    // 2. قائمة مواضيع عشوائية لضمان التنوع
    List<String> themesAr = [
      'الحيوانات الأليفة',
      'الأسرة',
      'في الحديقة',
      'المدرسة',
      'الطعام',
      'الألعاب',
      'الطبيعة',
    ];
    List<String> themesEn = [
      'Pets',
      'Family',
      'At the park',
      'School',
      'Food',
      'Toys',
      'Nature',
    ];
    String randomThemeAr = (themesAr..shuffle()).first;
    String randomThemeEn = (themesEn..shuffle()).first;

    // 3. المطالبة المحدثة بذكاء
    final prompt = widget.language == 'ar'
        ? 'أنت خبير تربوي لتطوير قراءة الأطفال. استبعد هذه الجمل لتجنب التكرار: [$existingList]. أنشئ 10 جمل عربية جديدة وبسيطة جداً (تتكون من كلمتين أو 3 كلمات كحد أقصى) للأطفال المبتدئين في القراءة. اجعل الجمل متنوعة وتدور حول موضوع "$randomThemeAr". استخدم مفردات شائعة وسهلة. أرجع الناتج بصيغة JSON فقط كقائمة: [{"sentence_text": "الجملة هنا"}] بدون أي نص إضافي.'
        : 'Reading expert. Exclude these: [$existingList]. Generate 10 new, very simple sentences (2-3 words max) for beginning readers about "$randomThemeEn". Use basic vocabulary. Return JSON only: [{"sentence_text": "sentence"}].';

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final textResult = jsonDecode(
          response.body,
        )['candidates'][0]['content']['parts'][0]['text'];
        String cleanedJson = textResult
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        List<dynamic> newItems = jsonDecode(cleanedJson);

        final lvlRes = await supabase
            .from('levels')
            .select('id')
            .eq('language', widget.language)
            .limit(1);
        String? levelId = lvlRes.isNotEmpty ? lvlRes[0]['id'] : null;

        for (var item in newItems) {
          if (item['sentence_text'] != null &&
              !existingList.contains(item['sentence_text'])) {
            await supabase.from('sentences').insert({
              'level_id': levelId,
              'sentence_text': item['sentence_text'],
            });
          }
        }
        Navigator.pop(context); // إغلاق رسالة التوليد
        if (mounted)
          showCustomModal(
            context,
            'تم بنجاح! 🚀',
            'تم توليد جمل جديدة عن ($randomThemeAr) 🌟',
            '🎉',
          );
        await _fetchItems();
      }
    } catch (e) {
      Navigator.pop(context);
      if (mounted)
        showCustomModal(context, 'خطأ', 'حدث خطأ أثناء التوليد.', '❌');
    }
    setState(() => isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'المرحلة 2: الجمل 📝',
        childId: widget.childId,
        childName: widget.childName,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: items.isEmpty
              ? _buildEmptyState(
                  'لا توجد جمل مضافة بعد',
                  'اضغط على زر التوليد لجلب جمل بسيطة للتدريب',
                  Colors.purple,
                  _generateAISentences,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            'الجملة ${currentIndex + 1} من ${items.length}',
                            style: TextStyle(
                              color: Colors.purple.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.purple.shade100,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.psychology),
                          label: Text(
                            isGenerating ? 'جاري...' : 'توليد جمل 🤖',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: isGenerating ? null : _generateAISentences,
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _speakSentence,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          border: Border.all(
                            color: Colors.purple.shade300,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'اضغط للاستماع 🔊',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              items[currentIndex]['sentence_text'],
                              style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.w900,
                                color: Colors.indigo.shade900,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'استمع',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _speakSentence,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'أتقنها ⬅️',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _markAsMastered,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    Color color,
    VoidCallback onGenerate,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withAlpha(50), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.indigo.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onGenerate,
              child: const Text(
                'توليد بالذكاء الاصطناعي ✨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 7. شاشة القصص (StoriesScreen - اللون الزمردي/Teal)
// ------------------------------------------------------------------------
class StoriesScreen extends StatefulWidget {
  final String childId, childName, language;
  const StoriesScreen({
    Key? key,
    required this.childId,
    required this.childName,
    required this.language,
  }) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final FlutterTts flutterTts = FlutterTts();
  List<dynamic> items = [];
  int currentIndex = 0;
  bool isLoading = true, isGenerating = false;

  // ⚠️ ضع مفتاح Gemini API الخاص بك هنا
  final String apiKey = "";

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final response = await supabase.from('stories').select();
      List<dynamic> allItems = response;
      if (allItems.isNotEmpty) {
        final progressRes = await supabase
            .from('child_progress')
            .select('word_id')
            .eq('child_id', widget.childId)
            .eq('is_mastered', true);
        List masteredIds = progressRes.map((p) => p['word_id']).toList();

        int startIndex = 0;
        for (int i = 0; i < allItems.length; i++) {
          if (!masteredIds.contains(allItems[i]['id'])) {
            startIndex = i;
            break;
          }
        }
        setState(() {
          items = allItems;
          currentIndex = startIndex;
          isLoading = false;
        });
        _speakStory();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _speakStory() async {
    if (items.isEmpty) return;
    await flutterTts.setLanguage(widget.language == 'ar' ? "ar-SA" : "en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(items[currentIndex]['content']);
  }

  Future<void> _markAsMastered() async {
    if (items.isEmpty) return;
    try {
      await supabase.from('child_progress').insert({
        'child_id': widget.childId,
        'word_id': items[currentIndex]['id'],
        'is_mastered': true,
        'times_practiced': 1,
      });
    } catch (e) {}

    if (currentIndex < items.length - 1) {
      setState(() => currentIndex++);
      _speakStory();
    } else {
      if (mounted)
        showCustomModal(
          context,
          'أحسنت يا بطل! 🎉',
          'أنهيت جميع قصص الروتين اليومي!',
          '🏆',
        );
      setState(() => currentIndex = 0);
      _speakStory();
    }
  }

Future<void> _generateAIStory() async {
    if (apiKey.isEmpty) {
      if(mounted) showCustomModal(context, 'تنبيه', 'الرجاء وضع مفتاح API', '⚠️');
      return;
    }
    setState(() => isGenerating = true);
    if(mounted) showCustomModal(context, 'جاري التوليد...', 'الذكاء الاصطناعي يبتكر قصة جديدة وممتعة 🤖✨', '⏳');

    // 1. جلب عناوين القصص السابقة لمنع التكرار
    final existingTitles = items.map((w) => w['title']).join('، ');

    // 2. مواضيع قصص عشوائية مبسطة
    List<String> topicsAr = ['رحلة إلى المزرعة', 'لعبتي المفضلة', 'مساعدة أمي', 'قطتي الصغيرة', 'يوم الإجازة', 'صديقي الجديد', 'في حديقة الحيوان'];
    List<String> topicsEn = ['Trip to the farm', 'My favorite toy', 'Helping mom', 'My little cat', 'Holiday', 'My new friend', 'At the zoo'];
    String randomTopicAr = (topicsAr..shuffle()).first;
    String randomTopicEn = (topicsEn..shuffle()).first;

    // 3. المطالبة المحدثة للقصص لضمان القِصَر والسهولة
    final prompt = widget.language == 'ar'
        ? 'أنت خبير تربوي لتطوير قراءة الأطفال. استبعد هذه القصص السابقة: [$existingTitles]. أنشئ قصة قصيرة جداً وبسيطة جداً للأطفال المبتدئين حول موضوع "$randomTopicAr". شروط القصة: تتكون من 4 إلى 5 أسطر فقط، وكل سطر لا يتجاوز 3 إلى 4 كلمات سهلة جداً (مثال للسطر: القطة تلعب بالكرة). أرجع الناتج بصيغة JSON فقط ككائن واحد: {"title": "عنوان القصة", "content": "السطر الأول\\nالسطر الثاني\\nالسطر الثالث"} بدون أي نص إضافي.'
        : 'Reading expert. Exclude titles: [$existingTitles]. Create a very simple short story for beginners about "$randomTopicEn". Constraints: 4-5 short lines total, max 4 simple words per line. Return JSON only: {"title": "Story Title", "content": "Line 1\\nLine 2\\nLine 3"}.';

    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
    try {
      final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode({"contents": [{"parts": [{"text": prompt}]}]}));
      if (response.statusCode == 200) {
        final textResult = jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text'];
        String cleanedJson = textResult.replaceAll('```json', '').replaceAll('```', '').trim();
        Map<String, dynamic> newStory = jsonDecode(cleanedJson);

        final lvlRes = await supabase.from('levels').select('id').eq('language', widget.language).limit(1);
        String? levelId = lvlRes.isNotEmpty ? lvlRes[0]['id'] : null;

        if (newStory['title'] != null && newStory['content'] != null) {
          await supabase.from('stories').insert({'level_id': levelId, 'title': newStory['title'], 'content': newStory['content']});
        }
        Navigator.pop(context); 
        if(mounted) showCustomModal(context, 'تم بنجاح! 🚀', 'تم توليد قصة ممتعة عن ($randomTopicAr) 🌟', '🎉');
        await _fetchItems();
      }
    } catch (e) {
      Navigator.pop(context);
      if(mounted) showCustomModal(context, 'خطأ', 'حدث خطأ أثناء التوليد.', '❌');
    }
    setState(() => isGenerating = false);
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'المرحلة 3: القصص 📚',
        childId: widget.childId,
        childName: widget.childName,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: items.isEmpty
              ? _buildEmptyState(
                  'لا توجد قصص مضافة',
                  'اضغط على زر التوليد لجلب قصة روتين يومي',
                  Colors.teal,
                  _generateAIStory,
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            'القصة ${currentIndex + 1} من ${items.length}',
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.teal.shade100,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.psychology),
                          label: Text(
                            isGenerating ? 'جاري...' : 'توليد قصة 🤖',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: isGenerating ? null : _generateAIStory,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          border: Border.all(
                            color: Colors.teal.shade300,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  items[currentIndex]['title'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal.shade900,
                                  ),
                                ),
                              ),
                              const Divider(thickness: 2, height: 30),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.teal.shade100,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  items[currentIndex]['content'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'استمع',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _speakStory,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: const Text(
                              'أنهى القصة ⬅️',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _markAsMastered,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    Color color,
    VoidCallback onGenerate,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withAlpha(50), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.indigo.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onGenerate,
              child: const Text(
                'توليد بالذكاء الاصطناعي ✨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// 8. لوحة الإنجازات (Progress Dashboard)
// ------------------------------------------------------------------------
class ProgressDashboardScreen extends StatefulWidget {
  final String childId;
  final String childName;
  const ProgressDashboardScreen({
    Key? key,
    required this.childId,
    required this.childName,
  }) : super(key: key);

  @override
  _ProgressDashboardScreenState createState() =>
      _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  int masteredCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      final res = await supabase
          .from('child_progress')
          .select('id')
          .eq('child_id', widget.childId)
          .eq('is_mastered', true);
      setState(() {
        masteredCount = res.length;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _resetProgress() async {
    await supabase
        .from('child_progress')
        .delete()
        .eq('child_id', widget.childId);
    if (mounted)
      showCustomModal(
        context,
        'تم إعادة الضبط 🔄',
        'تم مسح إنجازات البطل ${widget.childName} للبدء من جديد بنجاح.',
        '🔄',
      );
    _fetchProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏆 إنجازات البطل')),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.amber.shade300, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 80)),
                      const SizedBox(height: 10),
                      Text(
                        'لوحة إنجازات البطل ${widget.childName}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.indigo.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$masteredCount',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                color: Colors.amber.shade700,
                              ),
                            ),
                            const Text(
                              'عنصر تم إتقانه وقراءته بنجاح! 🌟',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade500,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text(
                          'إعادة ضبط التقدم 🔄',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _resetProgress,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
