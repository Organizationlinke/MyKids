// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:http/http.dart' as http;

// // // // --- CONFIGURATION ---
// // // // const String supabaseUrl = 'https://qsvhdpitcljewzqjqhbe.supabase.co';
// // // // const String supabaseAnnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzdmhkcGl0Y2xqZXd6cWpxaGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDYwMTksImV4cCI6MjA2OTUyMjAxOX0.YH-RR0w03qgYcpHQM-eygczVuheNljrbvXm6i-9uSwM';
// // // const String geminiApiKey = 'AIzaSyDQ9_0_qyzzqDO1Sq5ngL0VGxTfAUjTOVI'; // سيتم تزويده برمجياً


// // // // class MyApp extends StatelessWidget {
// // // //   const MyApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       title: 'تعلم الإنجليزية بالقصص',
// // // //       debugShowCheckedModeBanner: false,
// // // //       theme: ThemeData(
// // // //         primarySwatch: Colors.blue,
// // // //         useMaterial3: true,
// // // //         fontFamily: 'Roboto', // تأكد من دعم الخطوط العربية في مشروعك
// // // //       ),
// // // //       home: const LevelsScreen(),
// // // //     );
// // // //   }
// // // // }

// // // // --- شاشة المستويات الرئيسية ---
// // // class LevelsScreen extends StatefulWidget {
// // //   const LevelsScreen({super.key});

// // //   @override
// // //   State<LevelsScreen> createState() => _LevelsScreenState();
// // // }

// // // class _LevelsScreenState extends State<LevelsScreen> {
// // //   final supabase = Supabase.instance.client;
// // //   List<dynamic> levelsData = [];
// // //   bool isLoading = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchLevels();
// // //   }

// // //   Future<void> fetchLevels() async {
// // //     try {
// // //       final data = await supabase.from('w_words_levels').select();
// // //       setState(() {
// // //         levelsData = data;
// // //         isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       debugPrint("Error: $e");
// // //       setState(() => isLoading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final uniqueLevels = levelsData.map((item) => item['level_name']).toSet().toList();

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('مستويات الكلمات'),
// // //         centerTitle: true,
// // //         backgroundColor: Colors.blue[700],
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: isLoading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : Padding(
// // //               padding: const EdgeInsets.all(12.0),
// // //               child: GridView.builder(
// // //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //                   crossAxisCount: 2,
// // //                   childAspectRatio: 1.2,
// // //                   crossAxisSpacing: 10,
// // //                   mainAxisSpacing: 10,
// // //                 ),
// // //                 itemCount: uniqueLevels.length,
// // //                 itemBuilder: (context, index) {
// // //                   return Card(
// // //                     elevation: 4,
// // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// // //                     child: InkWell(
// // //                       onTap: () {
// // //                         Navigator.push(
// // //                           context,
// // //                           MaterialPageRoute(
// // //                             builder: (context) => GroupsScreen(
// // //                               levelName: uniqueLevels[index],
// // //                               allData: levelsData,
// // //                             ),
// // //                           ),
// // //                         );
// // //                       },
// // //                       child: Column(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           const Icon(Icons.menu_book, size: 40, color: Colors.blue),
// // //                           const SizedBox(height: 10),
// // //                           Text(
// // //                             uniqueLevels[index],
// // //                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //     );
// // //   }
// // // }

// // // // --- شاشة عرض المجموعات داخل المستوى ---
// // // class GroupsScreen extends StatelessWidget {
// // //   final String levelName;
// // //   final List<dynamic> allData;

// // //   const GroupsScreen({super.key, required this.levelName, required this.allData});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final groups = allData.where((item) => item['level_name'] == levelName).toList();

// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('مجموعات $levelName')),
// // //       body: ListView.builder(
// // //         padding: const EdgeInsets.all(10),
// // //         itemCount: groups.length,
// // //         itemBuilder: (context, index) {
// // //           return Card(
// // //             margin: const EdgeInsets.only(bottom: 10),
// // //             child: ListTile(
// // //               title: Text(groups[index]['group_name']),
// // //               trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // //               onTap: () {
// // //                 Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => WordDetailScreen(
// // //                       groupName: groups[index]['group_name'],
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // // // --- الشاشة الرئيسية للتفاصيل والتابات ---
// // // class WordDetailScreen extends StatefulWidget {
// // //   final String groupName;
// // //   const WordDetailScreen({super.key, required this.groupName});

// // //   @override
// // //   State<WordDetailScreen> createState() => _WordDetailScreenState();
// // // }

// // // class _WordDetailScreenState extends State<WordDetailScreen> with SingleTickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   final supabase = Supabase.instance.client;
// // //   List<dynamic> words = [];
// // //   List<dynamic> stories = [];
// // //   List<dynamic> storyLevels = [];
// // //   bool isLoading = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 6, vsync: this);
// // //     fetchGroupData();
// // //   }

// // //   Future<void> fetchGroupData() async {
// // //     setState(() => isLoading = true);
// // //     try {
// // //       final wordsData = await supabase.from('w_words').select().eq('group_name', widget.groupName);
// // //       final storiesData = await supabase.from('w_story').select().eq('group_name', widget.groupName);
      
// // //       List<dynamic> levelsData = [];
// // //       if (storiesData.isNotEmpty) {
// // //         final storyIds = storiesData.map((s) => s['id']).toList();
// // //         levelsData = await supabase.from('w_story_level').select().inFilter('w_story_id', storyIds);
// // //       }

// // //       setState(() {
// // //         words = wordsData;
// // //         stories = storiesData;
// // //         storyLevels = levelsData;
// // //         isLoading = false;
// // //       });
// // //     } catch (e) {
// // //       debugPrint("Error fetching group data: $e");
// // //       setState(() => isLoading = false);
// // //     }
// // //   }

// // //   Future<void> generateStory() async {
// // //     if (words.isEmpty) return;
// // //     setState(() => isLoading = true);
// // //     print('A1');

// // //     final wordListEn = words.map((w) => w['word_en']).join(', ');
// // //     final prompt = """
// // //       Create a short creative story in English using these specific words: $wordListEn. 
// // //       Return a JSON object with: 
// // //       "title": "A catchy title", 
// // //       "story_en": "The full English story", 
// // //       "story_ar": "The full Arabic translation",
// // //       "story_hybrid_1": "The Arabic version of the story where exactly 5 words from the group [$wordListEn] are kept in English while the rest is Arabic."
// // //     """;
// // // print('A2');

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode({
// // //           "contents": [{"parts": [{"text": prompt}]}],
// // //           "generationConfig": {"responseMimeType": "application/json"}
// // //         }),
// // //       );
// // // print('A3');
// // // print(response);

// // //       final result = jsonDecode(response.body);
// // //       final content = jsonDecode(result['candidates'][0]['content']['parts'][0]['text']);

// // //       // حفظ القصة الرئيسية
// // //       final newStory = await supabase.from('w_story').insert({
// // //         'story_en': content['story_en'],
// // //         'story_ar': content['story_ar'],
// // //         'group_name': widget.groupName,
// // //         'story_title': content['title']
// // //       }).select().single();
// // // print('A4');

// // //       // حفظ المستوى الأول
// // //       await supabase.from('w_story_level').insert({
// // //         'w_story_id': newStory['id'],
// // //         'story': content['story_hybrid_1'],
// // //         'level': 1,
// // //         'story_title': content['title']
// // //       });
// // // print('A5');

// // //       fetchGroupData();
// // //       print('A6');

// // //     } catch (e) {
// // //       print(e);
// // //       debugPrint("AI Generation Error: $e");
// // //     } finally {
// // //       setState(() => isLoading = false);
// // //     }
// // //   }

// // //   Future<void> upgradeLevel(dynamic currentLevelData) async {
// // //     setState(() => isLoading = true);
// // //     final nextLevel = currentLevelData['level'] + 1;
// // //     final masterStory = stories.firstWhere((s) => s['id'] == currentLevelData['w_story_id']);
// // //     final wordListEn = words.map((w) => w['word_en']).join(', ');

// // //     int wordCount = (nextLevel == 2) ? 10 : (nextLevel == 3) ? 15 : 25;
// // //     String prompt = "Take this Arabic story: \"${masterStory['story_ar']}\". Create a version where exactly $wordCount words from this list [$wordListEn] are used in English. Return ONLY the story text.";
    
// // //     if (nextLevel == 5) {
// // //       prompt = "Return ONLY the full English version of this story: \"${masterStory['story_en']}\"";
// // //     }

// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode({
// // //           "contents": [{"parts": [{"text": prompt}]}]
// // //         }),
// // //       );

// // //       final result = jsonDecode(response.body);
// // //       final nextStoryText = result['candidates'][0]['content']['parts'][0]['text'];

// // //       await supabase.from('w_story_level').insert({
// // //         'w_story_id': currentLevelData['w_story_id'],
// // //         'story': nextStoryText,
// // //         'level': nextLevel,
// // //         'story_title': currentLevelData['story_title']
// // //       });

// // //       fetchGroupData();
// // //       _tabController.animateTo(nextLevel);
// // //     } catch (e) {
// // //       debugPrint("Upgrade error: $e");
// // //     } finally {
// // //       setState(() => isLoading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(widget.groupName),
// // //         bottom: TabBar(
// // //           controller: _tabController,
// // //           isScrollable: true,
// // //           tabs: const [
// // //             Tab(text: 'الكلمات'),
// // //             Tab(text: 'مستوى 1'),
// // //             Tab(text: 'مستوى 2'),
// // //             Tab(text: 'مستوى 3'),
// // //             Tab(text: 'مستوى 4'),
// // //             Tab(text: 'مستوى 5'),
// // //           ],
// // //         ),
// // //       ),
// // //       body: Stack(
// // //         children: [
// // //           TabBarView(
// // //             controller: _tabController,
// // //             children: [
// // //               _buildWordsTab(),
// // //               _buildStoryLevelTab(1),
// // //               _buildStoryLevelTab(2),
// // //               _buildStoryLevelTab(3),
// // //               _buildStoryLevelTab(4),
// // //               _buildStoryLevelTab(5),
// // //             ],
// // //           ),
// // //           if (isLoading)
// // //             Container(
// // //               color: Colors.black26,
// // //               child: const Center(child: CircularProgressIndicator()),
// // //             ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildWordsTab() {
// // //     return Column(
// // //       children: [
// // //         Expanded(
// // //           child: ListView.builder(
// // //             padding: const EdgeInsets.all(16),
// // //             itemCount: words.length,
// // //             itemBuilder: (context, index) {
// // //               return Card(
// // //                 child: ListTile(
// // //                   title: Text(words[index]['word_en'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
// // //                   trailing: Text(words[index]['word_ar'] ?? ""),
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         ),
// // //         Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: ElevatedButton.icon(
// // //             onPressed: generateStory,
// // //             icon: const Icon(Icons.auto_awesome),
// // //             label: const Text('إنشاء قصة ذكية بالذكاء الاصطناعي'),
// // //             style: ElevatedButton.styleFrom(
// // //               minimumSize: const Size.fromHeight(50),
// // //               backgroundColor: Colors.blue[800],
// // //               foregroundColor: Colors.white,
// // //             ),
// // //           ),
// // //         )
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildStoryLevelTab(int level) {
// // //     final storiesAtLevel = storyLevels.where((s) => s['level'] == level).toList();

// // //     if (storiesAtLevel.isEmpty) {
// // //       return const Center(child: Text('لا توجد قصص في هذا المستوى بعد.'));
// // //     }

// // //     return ListView.builder(
// // //       padding: const EdgeInsets.all(16),
// // //       itemCount: storiesAtLevel.length,
// // //       itemBuilder: (context, index) {
// // //         final item = storiesAtLevel[index];
// // //         return Card(
// // //           margin: const EdgeInsets.all(20),
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(item['story_title'] ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                 const Divider(),
// // //                 const SizedBox(height: 10),
// // //                 Text(
// // //                   item['story'] ?? "",
// // //                   style: const TextStyle(fontSize: 16, height: 1.5),
// // //                   textAlign: TextAlign.justify,
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //                 if (level < 5)
// // //                   Align(
// // //                     alignment: Alignment.centerLeft,
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: () => upgradeLevel(item),
// // //                       icon: const Icon(Icons.upgrade),
// // //                       label: Text('ترقية للمستوى ${level + 1}'),
// // //                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
// // //                     ),
// // //                   )
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:http/http.dart' as http;

// // // --- CONFIGURATION ---
// // const String geminiApiKey = 'AIzaSyC_Z7iS-6QBiDVzLsOq20ma3DKiDOP-kQA'; 

// // class LevelsScreen extends StatefulWidget {
// //   const LevelsScreen({super.key});

// //   @override
// //   State<LevelsScreen> createState() => _LevelsScreenState();
// // }

// // class _LevelsScreenState extends State<LevelsScreen> {
// //   final supabase = Supabase.instance.client;
// //   List<dynamic> levelsData = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchLevels();
// //   }

// //   Future<void> fetchLevels() async {
// //     try {
// //       final data = await supabase.from('w_words_levels').select();
// //       setState(() {
// //         levelsData = data;
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       debugPrint("Error: $e");
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final uniqueLevels = levelsData.map((item) => item['level_name']).toSet().toList();

// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
        
// //         appBar: AppBar(
// //           title: const Text('مستويات الكلمات'),
// //           centerTitle: true,
// //           backgroundColor: Colors.blue[700],
// //           foregroundColor: Colors.white,
// //         ),
// //         body: isLoading
// //             ? const Center(child: CircularProgressIndicator())
// //             : Padding(
// //                 padding: const EdgeInsets.all(12.0),
// //                 child: GridView.builder(
// //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     childAspectRatio: 1.2,
// //                     crossAxisSpacing: 10,
// //                     mainAxisSpacing: 10,
// //                   ),
// //                   itemCount: uniqueLevels.length,
// //                   itemBuilder: (context, index) {
// //                     return Card(
// //                       elevation: 4,
// //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //                       child: InkWell(
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => GroupsScreen(
// //                                 levelName: uniqueLevels[index],
// //                                 allData: levelsData,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             const Icon(Icons.menu_book, size: 40, color: Colors.blue),
// //                             const SizedBox(height: 10),
// //                             Text(
// //                               uniqueLevels[index],
// //                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// // }

// // class GroupsScreen extends StatelessWidget {
// //   final String levelName;
// //   final List<dynamic> allData;

// //   const GroupsScreen({super.key, required this.levelName, required this.allData});

// //   @override
// //   Widget build(BuildContext context) {
// //     final groups = allData.where((item) => item['level_name'] == levelName).toList();

// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
// //         appBar: AppBar(title: Text('مجموعات $levelName')),
// //         body: ListView.builder(
// //           padding: const EdgeInsets.all(10),
// //           itemCount: groups.length,
// //           itemBuilder: (context, index) {
// //             return Card(
// //               margin: const EdgeInsets.only(bottom: 10),
// //               child: ListTile(
// //                 title: Text(groups[index]['group_name']),
// //                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => WordDetailScreen(
// //                         groupName: groups[index]['group_name'],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class WordDetailScreen extends StatefulWidget {
// //   final String groupName;
// //   const WordDetailScreen({super.key, required this.groupName});

// //   @override
// //   State<WordDetailScreen> createState() => _WordDetailScreenState();
// // }

// // class _WordDetailScreenState extends State<WordDetailScreen> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   final supabase = Supabase.instance.client;
// //   List<dynamic> words = [];
// //   List<dynamic> stories = [];
// //   List<dynamic> storyLevels = [];
// //   bool isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 6, vsync: this);
// //     fetchGroupData();
// //   }

// //   Future<void> fetchGroupData() async {
// //     setState(() => isLoading = true);
// //     try {
// //       final wordsData = await supabase.from('w_words').select().eq('group_name', widget.groupName);
// //       final storiesData = await supabase.from('w_story').select().eq('group_name', widget.groupName);
      
// //       List<dynamic> levelsData = [];
// //       if (storiesData.isNotEmpty) {
// //         final storyIds = storiesData.map((s) => s['id']).toList();
// //         levelsData = await supabase.from('w_story_level').select().inFilter('w_story_id', storyIds);
// //       }

// //       setState(() {
// //         words = wordsData;
// //         stories = storiesData;
// //         storyLevels = levelsData;
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       debugPrint("Error fetching group data: $e");
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   Future<void> generateStory() async {
// //     if (words.isEmpty) return;
// //     setState(() => isLoading = true);

// //     final wordListEn = words.map((w) => w['word_en']).join(', ');
// //     final prompt = """
// //       Create a short creative story in English using these specific words: $wordListEn. 
// //       Return a JSON object with: 
// //       "title": "A catchy title", 
// //       "story_en": "The full English story", 
// //       "story_ar": "The full Arabic translation",
// //       "story_hybrid_1": "The Arabic version of the story where exactly 5 words from the group [$wordListEn] are kept in English while the rest is Arabic."
// //       Ensure the response is valid JSON only.
// //     """;

// //     try {
// //       final response = await http.post(
// //          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           "contents": [{"parts": [{"text": prompt}]}],
// //           "generationConfig": {
// //             "responseMimeType": "application/json"
// //           }
// //         }),
// //       );

// //       if (response.statusCode != 200) {
// //         throw Exception("API returned status ${response.statusCode}: ${response.body}");
// //       }

// //       final result = jsonDecode(response.body);
      
// //       // تأكد من وجود الـ candidates والـ content بشكل آمن
// //       if (result['candidates'] == null || result['candidates'].isEmpty) {
// //         throw Exception("No candidates found in Gemini response");
// //       }

// //       final contentText = result['candidates'][0]['content']['parts'][0]['text'];
// //       final content = jsonDecode(contentText);

// //       final newStory = await supabase.from('w_story').insert({
// //         'story_en': content['story_en'],
// //         'story_ar': content['story_ar'],
// //         'group_name': widget.groupName,
// //         'story_title': content['title']
// //       }).select().single();

// //       await supabase.from('w_story_level').insert({
// //         'w_story_id': newStory['id'],
// //         'story': content['story_hybrid_1'],
// //         'level': 1,
// //         'story_title': content['title']
// //       });

// //       await fetchGroupData();
// //       _tabController.animateTo(1);

// //     } catch (e) {
// //       debugPrint("AI Generation Error Detail: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ في توليد القصة: $e'))
// //       );
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   Future<void> upgradeLevel(dynamic currentLevelData) async {
// //     setState(() => isLoading = true);
// //     final nextLevel = currentLevelData['level'] + 1;
// //     final masterStory = stories.firstWhere((s) => s['id'] == currentLevelData['w_story_id']);
// //     final wordListEn = words.map((w) => w['word_en']).join(', ');

// //     int wordCount = (nextLevel == 2) ? 10 : (nextLevel == 3) ? 15 : 25;
// //     String prompt = "Take this Arabic story: \"${masterStory['story_ar']}\". Create a version where exactly $wordCount words from this list [$wordListEn] are used in English. Return ONLY the story text string.";
    
// //     if (nextLevel == 5) {
// //       prompt = "Return ONLY the full English version of this story: \"${masterStory['story_en']}\"";
// //     }

// //     try {
// //       final response = await http.post(
// //  Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           "contents": [{"parts": [{"text": prompt}]}]
// //         }),
// //       );

// //       final result = jsonDecode(response.body);
// //       final nextStoryText = result['candidates'][0]['content']['parts'][0]['text'];

// //       await supabase.from('w_story_level').insert({
// //         'w_story_id': currentLevelData['w_story_id'],
// //         'story': nextStoryText,
// //         'level': nextLevel,
// //         'story_title': currentLevelData['story_title']
// //       });

// //       await fetchGroupData();
// //       _tabController.animateTo(nextLevel);
// //     } catch (e) {
// //       debugPrint("Upgrade error: $e");
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: TextDirection.rtl,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(widget.groupName),
// //           bottom: TabBar(
// //             controller: _tabController,
// //             isScrollable: true,
// //             tabs: const [
// //               Tab(text: 'الكلمات'),
// //               Tab(text: 'مستوى 1'),
// //               Tab(text: 'مستوى 2'),
// //               Tab(text: 'مستوى 3'),
// //               Tab(text: 'مستوى 4'),
// //               Tab(text: 'مستوى 5'),
// //             ],
// //           ),
// //         ),
// //         body: Stack(
// //           children: [
// //             TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 _buildWordsTab(),
// //                 _buildStoryLevelTab(1),
// //                 _buildStoryLevelTab(2),
// //                 _buildStoryLevelTab(3),
// //                 _buildStoryLevelTab(4),
// //                 _buildStoryLevelTab(5),
// //               ],
// //             ),
// //             if (isLoading)
// //               Container(
// //                 color: Colors.black26,
// //                 child: const Center(child: CircularProgressIndicator()),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildWordsTab() {
// //     return Column(
// //       children: [
// //         Expanded(
// //           child: ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: words.length,
// //             itemBuilder: (context, index) {
// //               return Card(
// //                 child: ListTile(
// //                   title: Text(words[index]['word_en'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
// //                   trailing: Text(words[index]['word_ar'] ?? ""),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: ElevatedButton.icon(
// //             onPressed: isLoading ? null : generateStory,
// //             icon: const Icon(Icons.auto_awesome),
// //             label: const Text('إنشاء قصة ذكية بالذكاء الاصطناعي'),
// //             style: ElevatedButton.styleFrom(
// //               minimumSize: const Size.fromHeight(50),
// //               backgroundColor: Colors.blue[800],
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         )
// //       ],
// //     );
// //   }

// //   Widget _buildStoryLevelTab(int level) {
// //     final storiesAtLevel = storyLevels.where((s) => s['level'] == level).toList();

// //     if (storiesAtLevel.isEmpty) {
// //       return const Center(child: Text('لا توجد قصص في هذا المستوى بعد.'));
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: storiesAtLevel.length,
// //       itemBuilder: (context, index) {
// //         final item = storiesAtLevel[index];
// //         return Card(
// //           margin: const EdgeInsets.all(10),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(item['story_title'] ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //                 const Divider(),
// //                 const SizedBox(height: 10),
// //                 Text(
// //                   item['story'] ?? "",
// //                   style: const TextStyle(fontSize: 16, height: 1.5),
// //                   textAlign: TextAlign.justify,
// //                 ),
// //                 const SizedBox(height: 20),
// //                 if (level < 5)
// //                   Align(
// //                     alignment: Alignment.centerLeft,
// //                     child: ElevatedButton.icon(
// //                       onPressed: isLoading ? null : () => upgradeLevel(item),
// //                       icon: const Icon(Icons.upgrade),
// //                       label: Text('ترقية للمستوى ${level + 1}'),
// //                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
// //                     ),
// //                   )
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:http/http.dart' as http;

// // --- CONFIGURATION ---
// const String geminiApiKey = 'AIzaSyC_Z7iS-6QBiDVzLsOq20ma3DKiDOP-kQA'; 

// class LevelsScreen extends StatefulWidget {
//   const LevelsScreen({super.key});

//   @override
//   State<LevelsScreen> createState() => _LevelsScreenState();
// }

// class _LevelsScreenState extends State<LevelsScreen> {
//   final supabase = Supabase.instance.client;
//   List<dynamic> levelsData = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchLevels();
//   }

//   Future<void> fetchLevels() async {
//     try {
//       final data = await supabase.from('w_words_levels').select();
//       setState(() {
//         levelsData = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final uniqueLevels = levelsData.map((item) => item['level_name']).toSet().toList();

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('مستويات الكلمات'),
//           centerTitle: true,
//           backgroundColor: Colors.blue[700],
//           foregroundColor: Colors.white,
//         ),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: uniqueLevels.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => GroupsScreen(
//                                 levelName: uniqueLevels[index],
//                                 allData: levelsData,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.menu_book, size: 40, color: Colors.blue),
//                             const SizedBox(height: 10),
//                             Text(
//                               uniqueLevels[index],
//                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class GroupsScreen extends StatelessWidget {
//   final String levelName;
//   final List<dynamic> allData;

//   const GroupsScreen({super.key, required this.levelName, required this.allData});

//   @override
//   Widget build(BuildContext context) {
//     final groups = allData.where((item) => item['level_name'] == levelName).toList();

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(title: Text('مجموعات $levelName')),
//         body: ListView.builder(
//           padding: const EdgeInsets.all(10),
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             return Card(
//               margin: const EdgeInsets.only(bottom: 10),
//               child: ListTile(
//                 title: Text(groups[index]['group_name']),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WordDetailScreen(
//                         groupName: groups[index]['group_name'],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class WordDetailScreen extends StatefulWidget {
//   final String groupName;
//   const WordDetailScreen({super.key, required this.groupName});

//   @override
//   State<WordDetailScreen> createState() => _WordDetailScreenState();
// }

// class _WordDetailScreenState extends State<WordDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final supabase = Supabase.instance.client;
//   List<dynamic> words = [];
//   List<dynamic> stories = [];
//   List<dynamic> storyLevels = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     fetchGroupData();
//   }

//   Future<void> fetchGroupData() async {
//     setState(() => isLoading = true);
//     try {
//       final wordsData = await supabase.from('w_words').select().eq('group_name', widget.groupName);
//       final storiesData = await supabase.from('w_story').select().eq('group_name', widget.groupName);
      
//       List<dynamic> levelsData = [];
//       if (storiesData.isNotEmpty) {
//         final storyIds = storiesData.map((s) => s['id']).toList();
//         levelsData = await supabase.from('w_story_level').select().inFilter('w_story_id', storyIds);
//       }

//       setState(() {
//         words = wordsData;
//         stories = storiesData;
//         storyLevels = levelsData;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching group data: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> generateStory() async {
//     if (words.isEmpty) return;
//     setState(() => isLoading = true);

//     final wordListEn = words.map((w) => w['word_en']).join(', ');
    
//     // المستوى الأول الآن يطلب استخدام كل الكلمات الإنجليزية داخل نص عربي
//     final prompt = """
//       Create a creative story.
//       First, write the full story in English using all these words: [$wordListEn].
//       Second, translate it to full Arabic.
//       Third, create "story_level_1": This is the Arabic version of the story where ALL the English words from the list [$wordListEn] are used in their English form within the Arabic sentences.

//       Return a JSON object with: 
//       "title": "A catchy title", 
//       "story_en": "The full English version", 
//       "story_ar": "The full Arabic version",
//       "story_level_1": "The Arabic version with ALL words [$wordListEn] kept in English."
//       Ensure the response is valid JSON only.
//     """;

//     try {
//       final response = await http.post(
//         Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
//         //  Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "contents": [{"parts": [{"text": prompt}]}],
//           "generationConfig": { "responseMimeType": "application/json" }
//         }),
//       );

//       if (response.statusCode != 200) throw Exception("API Error: ${response.statusCode}");

//       final result = jsonDecode(response.body);
//       final contentText = result['candidates'][0]['content']['parts'][0]['text'];
//       final content = jsonDecode(contentText);

//       final newStory = await supabase.from('w_story').insert({
//         'story_en': content['story_en'],
//         'story_ar': content['story_ar'],
//         'group_name': widget.groupName,
//         'story_title': content['title']
//       }).select().single();

//       await supabase.from('w_story_level').insert({
//         'w_story_id': newStory['id'],
//         'story': content['story_level_1'],
//         'level': 1,
//         'story_title': content['title']
//       });

//       await fetchGroupData();
//       _tabController.animateTo(1);

//     } catch (e) {
//       debugPrint("Generation Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> upgradeLevel(dynamic currentLevelData) async {
//     setState(() => isLoading = true);
//     final nextLevel = currentLevelData['level'] + 1;
//     final masterStory = stories.firstWhere((s) => s['id'] == currentLevelData['w_story_id']);
    
//     // حساب عدد الكلمات بناءً على النسب المئوية المطلوبة
//     int totalWords = words.length;
//     int targetCount = 0;
    
//     if (nextLevel == 2) targetCount = (totalWords * 0.25).ceil();
//     if (nextLevel == 3) targetCount = (totalWords * 0.50).ceil();
//     if (nextLevel == 4) targetCount = (totalWords * 0.75).ceil();

//     final wordListEn = words.map((w) => w['word_en']).toList()..shuffle();
//     final selectedWords = wordListEn.take(targetCount).join(', ');

//     String prompt = "";
//     if (nextLevel <= 4) {
//       prompt = """
//         Take this Arabic story: "${masterStory['story_ar']}".
//         Rewrite it in Arabic but replace the Arabic meanings of these specific English words with the English words themselves: [$selectedWords].
//         The rest of the story must remain in Arabic. 
//         Return ONLY the rewritten story text.
//       """;
//     } else {
//       // المستوى الخامس: الإنجليزية كاملة
//       prompt = "Return ONLY the full English version of this story: \"${masterStory['story_en']}\"";
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
// //         headers: {'Content-Type': 'application/json'},
//         // Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "contents": [{"parts": [{"text": prompt}]}]
//         }),
//       );

//       final result = jsonDecode(response.body);
//       final nextStoryText = result['candidates'][0]['content']['parts'][0]['text'];

//       await supabase.from('w_story_level').insert({
//         'w_story_id': currentLevelData['w_story_id'],
//         'story': nextStoryText,
//         'level': nextLevel,
//         'story_title': currentLevelData['story_title']
//       });

//       await fetchGroupData();
//       _tabController.animateTo(nextLevel);
//     } catch (e) {
//       debugPrint("Upgrade error: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.groupName),
//           bottom: TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             tabs: const [
//               Tab(text: 'الكلمات'),
//               Tab(text: 'مستوى 1'),
//               Tab(text: 'مستوى 2'),
//               Tab(text: 'مستوى 3'),
//               Tab(text: 'مستوى 4'),
//               Tab(text: 'مستوى 5'),
//             ],
//           ),
//         ),
//         body: Stack(
//           children: [
//             TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildWordsTab(),
//                 _buildStoryLevelTab(1),
//                 _buildStoryLevelTab(2),
//                 _buildStoryLevelTab(3),
//                 _buildStoryLevelTab(4),
//                 _buildStoryLevelTab(5),
//               ],
//             ),
//             if (isLoading)
//               Container(
//                 color: Colors.black26,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWordsTab() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: words.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 child: ListTile(
//                   title: Text(words[index]['word_en'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                   trailing: Text(words[index]['word_ar'] ?? ""),
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ElevatedButton.icon(
//             onPressed: isLoading ? null : generateStory,
//             icon: const Icon(Icons.auto_awesome),
//             label: const Text('إنشاء قصة ذكية بالذكاء الاصطناعي'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size.fromHeight(50),
//               backgroundColor: Colors.blue[800],
//               foregroundColor: Colors.white,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildStoryLevelTab(int level) {
//     final storiesAtLevel = storyLevels.where((s) => s['level'] == level).toList();

//     if (storiesAtLevel.isEmpty) {
//       String msg = (level == 1) 
//         ? 'اضغط على "إنشاء قصة" في تبويب الكلمات أولاً.'
//         : 'يجب ترقية القصة من المستوى السابق.';
//       return Center(child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(msg, textAlign: TextAlign.center),
//       ));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: storiesAtLevel.length,
//       itemBuilder: (context, index) {
//         final item = storiesAtLevel[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 20),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item['story_title'] ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 const Divider(),
//                 const SizedBox(height: 10),
//                 Text(
//                   item['story'] ?? "",
//                   style: const TextStyle(fontSize: 16, height: 1.6),
//                   textAlign: TextAlign.justify,
//                 ),
//                 const SizedBox(height: 20),
//                 if (level < 5)
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: ElevatedButton.icon(
//                       onPressed: isLoading ? null : () => upgradeLevel(item),
//                       icon: const Icon(Icons.upgrade),
//                       label: Text('ترقية للمستوى ${level + 1}'),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

// --- CONFIGURATION ---
const String geminiApiKey = 'AIzaSyC_Z7iS-6QBiDVzLsOq20ma3DKiDOP-kQA'; 

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
                                levelName: uniqueLevels[index],
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
                              uniqueLevels[index],
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
                title: Text(groups[index]['group_name']),
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
    _tabController = TabController(length: 6, vsync: this);
    fetchGroupData();
  }

  Future<void> fetchGroupData() async {
    setState(() => isLoading = true);
    try {
      final wordsData = await supabase.from('w_words').select().eq('group_name', widget.groupName);
      final storiesData = await supabase.from('w_story').select().eq('group_name', widget.groupName);
      
      List<dynamic> levelsData = [];
      if (storiesData.isNotEmpty) {
        final storyIds = storiesData.map((s) => s['id']).toList();
        levelsData = await supabase.from('w_story_level').select().inFilter('w_story_id', storyIds);
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
    
    final prompt = """
      Create a creative story.
      First, write the full story in English using all these words: [$wordListEn].
      Second, translate it to full Arabic.
      Third, create "story_level_1": This is the Arabic version of the story where ALL the English words from the list [$wordListEn] are used in their English form within the Arabic sentences.

      Return a JSON object with: 
      "title": "A catchy title", 
      "story_en": "The full English version", 
      "story_ar": "The full Arabic version",
      "story_level_1": "The Arabic version with ALL words [$wordListEn] kept in English."
      Ensure the response is valid JSON only.
    """;

    try {
      final response = await http.post(
         Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}],
          "generationConfig": { "responseMimeType": "application/json" }
        }),
      );

      if (response.statusCode != 200) throw Exception("API Error: ${response.statusCode}");

      final result = jsonDecode(response.body);
      final contentText = result['candidates'][0]['content']['parts'][0]['text'];
      final content = jsonDecode(contentText);

      final newStory = await supabase.from('w_story').insert({
        'story_en': content['story_en'],
        'story_ar': content['story_ar'],
        'group_name': widget.groupName,
        'story_title': content['title']
      }).select().single();

      await supabase.from('w_story_level').insert({
        'w_story_id': newStory['id'],
        'story': content['story_level_1'],
        'level': 1,
        'story_title': content['title']
      });

      await fetchGroupData();
      _tabController.animateTo(1);

    } catch (e) {
      debugPrint("Generation Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> upgradeLevel(dynamic currentLevelData) async {
    setState(() => isLoading = true);
    final nextLevel = currentLevelData['level'] + 1;
    final masterStory = stories.firstWhere((s) => s['id'] == currentLevelData['w_story_id']);
    
    // قائمة الكلمات الأساسية للمجموعة
    final groupWordListEn = words.map((w) => w['word_en']).join(', ');
    
    String prompt = "";
    
    if (nextLevel >= 2 && nextLevel <= 4) {
      String percentage = "";
      if (nextLevel == 2) percentage = "25%";
      if (nextLevel == 3) percentage = "50%";
      if (nextLevel == 4) percentage = "75%";

      prompt = """
        Take this Arabic story: "${masterStory['story_ar']}".
        I want you to rewrite it in Arabic but with a hybrid language approach:
        1. Keep ALL these primary group words in English: [$groupWordListEn].
        2. In addition to those words, change $percentage of the REST of the Arabic words in the story to their English equivalents.
        
        Ensure the story remains readable and the flow is natural for a learner.
        Return ONLY the rewritten story text.
      """;
    } else if (nextLevel == 5) {
      // المستوى الخامس: الإنجليزية كاملة
      prompt = "Return ONLY the full English version of this story: \"${masterStory['story_en']}\"";
    } else {
      // للمستوى 1 أو أي حالة غير متوقعة، ننهي التحميل ونعود
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}]
        }),
      );

      final result = jsonDecode(response.body);
      final nextStoryText = result['candidates'][0]['content']['parts'][0]['text'];

      await supabase.from('w_story_level').insert({
        'w_story_id': currentLevelData['w_story_id'],
        'story': nextStoryText,
        'level': nextLevel,
        'story_title': currentLevelData['story_title']
      });

      await fetchGroupData();
      _tabController.animateTo(nextLevel);
    } catch (e) {
      debugPrint("Upgrade error: $e");
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
              Tab(text: 'مستوى 1'),
              Tab(text: 'مستوى 2'),
              Tab(text: 'مستوى 3'),
              Tab(text: 'مستوى 4'),
              Tab(text: 'مستوى 5'),
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(words[index]['word_en'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  trailing: Text(words[index]['word_ar'] ?? ""),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : generateStory,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('إنشاء قصة ذكية بالذكاء الاصطناعي'),
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

  Widget _buildStoryLevelTab(int level) {
    final storiesAtLevel = storyLevels.where((s) => s['level'] == level).toList();

    if (storiesAtLevel.isEmpty) {
      String msg = (level == 1) 
        ? 'اضغط على "إنشاء قصة" في تبويب الكلمات أولاً.'
        : 'يجب ترقية القصة من المستوى السابق.';
      return Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(msg, textAlign: TextAlign.center),
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: storiesAtLevel.length,
      itemBuilder: (context, index) {
        final item = storiesAtLevel[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['story_title'] ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  item['story'] ?? "",
                  style: const TextStyle(fontSize: 16, height: 1.6),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                if (level < 5)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : () => upgradeLevel(item),
                      icon: const Icon(Icons.upgrade),
                      label: Text('ترقية للمستوى ${level + 1}'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}