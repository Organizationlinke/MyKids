

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

// --- CONFIGURATION ---
const String geminiModel = 'gemini-2.5-flash'; 
const String aaa1='AIzaSyCzfQLh';
const String aaa2='hE3HsAFlRtCFVny';
const String aaa3='3JPaVNAS-c5E';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> levelsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLevels();
  }

  Future<void> fetchLevels() async {
    try {
      final data = await supabase.from('w_words_levels').select();
      setState(() {
        levelsData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uniqueLevels = levelsData.map((item) => item['level_name']).toSet().toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مستويات الكلمات'),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: uniqueLevels.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupsScreen(
                                levelName: uniqueLevels[index].toString(),
                                allData: levelsData,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book, size: 40, color: Colors.blue),
                            const SizedBox(height: 10),
                            Text(
                              uniqueLevels[index].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class GroupsScreen extends StatelessWidget {
  final String levelName;
  final List<dynamic> allData;

  const GroupsScreen({super.key, required this.levelName, required this.allData});

  @override
  Widget build(BuildContext context) {
    final groups = allData.where((item) => item['level_name'] == levelName).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('مجموعات $levelName')),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(groups[index]['group_name'] ?? "بدون اسم"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordDetailScreen(
                        groupName: groups[index]['group_name'],
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

class WordDetailScreen extends StatefulWidget {
  final String groupName;
  const WordDetailScreen({super.key, required this.groupName});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final supabase = Supabase.instance.client;
  List<dynamic> words = [];
  List<dynamic> stories = [];
  List<dynamic> storyLevels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this); 
    fetchGroupData();
  }

  Future<void> fetchGroupData() async {
    setState(() => isLoading = true);
    try {
      final wordsData = await supabase.from('w_words_2').select().eq('group_name', widget.groupName);
      final storiesData = await supabase.from('w_story').select().eq('group_name', widget.groupName);
      
      List<dynamic> levelsData = [];
      if (storiesData.isNotEmpty) {
        final storyIds = storiesData.map((s) => s['id']).toList();
        levelsData = await supabase.from('w_story_level').select().inFilter('w_story_id', storyIds);
        levelsData.sort((a, b) => (a['level'] as int).compareTo(b['level'] as int));
      }

      setState(() {
        words = wordsData;
        stories = storiesData;
        storyLevels = levelsData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching group data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> generateStory() async {
    if (words.isEmpty) return;
    setState(() => isLoading = true);

    final wordListEn = words.map((w) => w['word_en']).join(', ');
    
    // تم تعديل البرومبت هنا ليطلب مستوى A2 تحديداً
    final prompt = """
      Create a creative and educational story suitable for English learners at level A2 (Elementary).
      The story must be simple, using clear grammar and common vocabulary, based on these words: [$wordListEn].
      
      Return ONLY a JSON object with this exact structure:
      {
        "title": "A catchy simple title",
        "story_en": "The full story in simple English (Level A2)",
        "story_ar": "The full story translated into natural Arabic",
        "levels": {
          "1": "The Arabic story but with ONLY the specific words [$wordListEn] kept in English.",
          "2": "The Arabic story where the specific words and 25% of other simple sentences are translated to English.",
          "3": "The Arabic story where the specific words and 50% of the story are in English.",
          "4": "The Arabic story where 75% of the content is in English.",
          "5": "The full English story at Level A2 (same as story_en)."
        }
      }
      Ensure the story is engaging and appropriate for a beginner-level student.
    """;

    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$geminiModel:generateContent?key=$aaa1$aaa2$aaa3'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}],
          "generationConfig": { "responseMimeType": "application/json" }
        }),
      );

      if (response.statusCode != 200) throw Exception("API Error: ${response.body}");

      final result = jsonDecode(response.body);
      String contentText = result['candidates'][0]['content']['parts'][0]['text'];
      final content = jsonDecode(contentText);

      final newStory = await supabase.from('w_story').insert({
        'story_en': content['story_en'],
        'story_ar': content['story_ar'],
        'group_name': widget.groupName,
        'story_title': content['title']
      }).select().single();

      List<Map<String, dynamic>> levelsToInsert = [];
      Map<String, dynamic> levelsMap = content['levels'];
      
      levelsMap.forEach((levelKey, storyText) {
        levelsToInsert.add({
          'w_story_id': newStory['id'],
          'story': storyText,
          'level': int.parse(levelKey),
          'story_title': content['title']
        });
      });

      await supabase.from('w_story_level').insert(levelsToInsert);

      await fetchGroupData();
      _tabController.animateTo(2); 

    } catch (e) {
      debugPrint("Generation Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الإنشاء: $e')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'الكلمات'),
              
              Tab(text: 'L1'),     
              Tab(text: 'L2'),     
              Tab(text: 'L3'),     
              Tab(text: 'L4'),     
              Tab(text: 'L5'),   
               Tab(text: 'العربية'),   
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildWordsTab(),
                
                _buildStoryLevelTab(1),
                _buildStoryLevelTab(2),
                _buildStoryLevelTab(3),
                _buildStoryLevelTab(4),
                _buildStoryLevelTab(5),
                _buildBaseArabicTab(),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordsTab() {
    return Column(
      children: [
        Expanded(
          child: words.isEmpty 
            ? const Center(child: Text("لا توجد كلمات في هذه المجموعة"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(words[index]['word_en'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      trailing: Text(words[index]['word_ar'] ?? ""),
                    ),
                  );
                },
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: (isLoading || words.isEmpty) ? null : generateStory,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('إنشاء قصة بمستوى A2'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBaseArabicTab() {
    if (stories.isEmpty) return const Center(child: Text("يرجى إنشاء قصة أولاً"));
    final story = stories.first;
    return _buildStoryCard(story['story_title'], story['story_ar']);
  }

  Widget _buildStoryLevelTab(int level) {
    final levelData = storyLevels.where((s) => s['level'] == level).toList();

    if (levelData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('هذا المستوى سيكون متاحاً فور إنشاء القصة الذكية', textAlign: TextAlign.center),
        ),
      );
    }

    final item = levelData.first;
    return _buildStoryCard(item['story_title'], item['story']);
  }

  Widget _buildStoryCard(String? title, String? content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? "بدون عنوان", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              const Divider(height: 30),
              Text(
                content ?? "", 
                style: const TextStyle(fontSize: 18, height: 1.8, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}