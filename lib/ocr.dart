// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // --- ملاحظة هامة ---
// // هذا التطبيق يتطلب إعداد Firebase لمشروع Flutter
// // يرجى اتباع التعليمات في ملف README.md لإضافة ملف
// // google-services.json (للأندرويد) و GoogleService-Info.plist (للآيفون)

// Future<void> main() async {
//   // التأكد من تهيئة Flutter قبل تشغيل الكود
//   WidgetsFlutterBinding.ensureInitialized();
//   // تهيئة Firebase
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ماسح الأرقام',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const AuthWrapper(), // يبدأ بالتحقق من التوثيق
//     );
//   }
// }

// // هذا الكلاس يتحقق إذا كان المستخدم مسجل دخوله
// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});

//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     // تسجيل دخول المستخدم كمجهول عند فتح التطبيق
//     _signInAnonymously();
//   }

//   Future<void> _signInAnonymously() async {
//     try {
//       await FirebaseAuth.instance.signInAnonymously();
//     } catch (e) {
//       print("Error signing in anonymously: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // مراقبة حالة التوثيق
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//         if (snapshot.hasData) {
//           // إذا تم تسجيل الدخول (كمجهول)، اذهب لشاشة الكاميرا
//           return OCRScannerScreen(userId: snapshot.data!.uid);
//         }
//         // إذا لم يتم تسجيل الدخول، أظهر شاشة تحميل
//         return const Scaffold(body: Center(child: Text("جارٍ تسجيل الدخول...")));
//       },
//     );
//   }
// }


// // الشاشة الرئيسية للتطبيق (شاشة الكاميرا)
// class OCRScannerScreen extends StatefulWidget {
//   final String userId;
//   const OCRScannerScreen({super.key, required this.userId});

//   @override
//   State<OCRScannerScreen> createState() => _OCRScannerScreenState();
// }

// class _OCRScannerScreenState extends State<OCRScannerScreen> {
//   CameraController? _cameraController;
//   TextRecognizer? _textRecognizer;
//   bool _isCameraInitialized = false;
//   bool _isProcessing = false;

//   // هذه المتغيرات ستحمل الرقم الذي يتم التعرف عليه ومكانه
//   String _recognizedNumber = "";
//   Rect? _numberBoundingBox;

//   @override
//   void initState() {
//     super.initState();
//     // تهيئة محرك التعرف على النص
//     _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     // طلب إذن الكاميرا وتشغيلها
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     // إغلاق الموارد عند إغلاق الشاشة
//     _cameraController?.dispose();
//     _textRecognizer?.close();
//     super.dispose();
//   }

//   Future<void> _initializeCamera() async {
//     // 1. طلب الإذن
//     var status = await Permission.camera.request();
//     if (!status.isGranted) {
//       print("تم رفض إذن الكاميرا");
//       return;
//     }

//     // 2. الحصول على الكاميرات المتاحة
//     final cameras = await availableCameras();
//     if (cameras.isEmpty) {
//       print("لم يتم العثور على كاميرات");
//       return;
//     }

//     // 3. تهيئة الكنترولر (استخدام الكاميرا الخلفية)
//     _cameraController = CameraController(
//       cameras.first, // استخدام أول كاميرا (عادة الخلفية)
//       ResolutionPreset.high,
//       enableAudio: false,
//     );

//     // 4. تشغيل الكاميرا
//     await _cameraController!.initialize();
//     setState(() {
//       _isCameraInitialized = true;
//     });

//     // 5. تشغيل بث الفيديو للمعالجة اللحظية
//     _cameraController!.startImageStream(_processImageStream);
//   }

//   // هذه الدالة هي قلب التطبيق
//   // تعمل على كل إطار (frame) من بث الفيديو
//   Future<void> _processImageStream(CameraImage image) async {
//     if (_isProcessing) return; // منع المعالجة المتداخلة

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       // 1. تحويل صورة الكاميرا إلى تنسيق يفهمه ML Kit
//       final inputImage = _createInputImageFromCameraImage(image);
//       if (inputImage == null) return;

//       // 2. معالجة الصورة للتعرف على النص
//       final RecognizedText recognizedText =
//           await _textRecognizer!.processImage(inputImage);

//       String? foundNumber;
//       Rect? foundBox;

//       // فلترة النتائج للبحث عن أرقام فقط
//       final RegExp numberRegExp = RegExp(r'^[0-9]{3,}$'); // البحث عن 3 أرقام أو أكثر

//       for (TextBlock block in recognizedText.blocks) {
//         // تنظيف النص من المسافات
//         String cleanText = block.text.replaceAll(RegExp(r'\s+'), '');
        
//         if (numberRegExp.hasMatch(cleanText)) {
//           foundNumber = cleanText;
//           foundBox = block.boundingBox;
//           break; // التوقف عند أول رقم مطابق
//         }
//       }

//       // 3. تحديث الواجهة بالنتائج
//       setState(() {
//         if (foundNumber != null) {
//           _recognizedNumber = foundNumber;
//           _numberBoundingBox = foundBox;
//         } else {
//           // إذا لم يتم العثور على رقم، قم بإخفاء المربع
//           _numberBoundingBox = null;
//         }
//       });
//     } catch (e) {
//       print("Error processing image: $e");
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   // دالة مساعدة لتحويل تنسيق الصورة
//   InputImage? _createInputImageFromCameraImage(CameraImage image) {
//     final camera = _cameraController!.description;
//     final sensorOrientation = camera.sensorOrientation;
    
//     // حساب التدوير (Rotation) الصحيح للصورة
//     // (هذا الكود ضروري ليعمل ML Kit بشكل صحيح)
//     InputImageRotation rotation;
//     switch (sensorOrientation) {
//       case 90:
//         rotation = InputImageRotation.rotation90deg;
//         break;
//       case 180:
//         rotation = InputImageRotation.rotation180deg;
//         break;
//       case 270:
//         rotation = InputImageRotation.rotation270deg;
//         break;
//       default:
//         rotation = InputImageRotation.rotation0deg;
//     }

//     final format = InputImageFormatValue.fromRawValue(image.format.raw as int) ?? InputImageFormat.nv21;

//     return InputImage.fromBytes(
//       bytes: image.planes.first.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: image.planes.first.bytesPerRow,
//       ),
//     );
//   }

//   // دالة لحفظ الرقم في Firestore
//   Future<void> _saveNumberToFirestore() async {
//     if (_recognizedNumber.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("لم يتم تحديد أي رقم للحفظ!")),
//       );
//       return;
//     }

//     try {
//       // استخدام معرف المستخدم (userId) الممرر من شاشة التوثيق
//       final collectionPath =
//           'flutter_scans/${widget.userId}/scans'; // مسار تخزين بسيط

//       await FirebaseFirestore.instance.collection(collectionPath).add({
//         'number': _recognizedNumber,
//         'scan_date': FieldValue.serverTimestamp(),
//         'user_id': widget.userId,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("تم حفظ الرقم: $_recognizedNumber"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("Error saving to Firestore: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("فشل الحفظ: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     if (!_isCameraInitialized) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("التقاط الأرقام"),
//         backgroundColor: Colors.indigo,
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // 1. عرض الكاميرا
//           CameraPreview(_cameraController!),

//           // 2. رسم المربع حول الرقم (إذا وجد)
//           if (_numberBoundingBox != null)
//             CustomPaint(
//               painter: BoxPainter(
//                 box: _numberBoundingBox!,
//                 imageSize: Size(
//                   _cameraController!.value.previewSize!.height,
//                   _cameraController!.value.previewSize!.width,
//                 ),
//                 screenSize: MediaQuery.of(context).size,
//               ),
//             ),

//           // 3. زر الالتقاط والرقم المعترف به
//           Positioned(
//             bottom: 30,
//             left: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 // عرض الرقم المعترف به
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     _recognizedNumber.isEmpty ? "وجّه الكاميرا نحو رقم..." : _recognizedNumber,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // زر الالتقاط
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.camera),
//                   label: const Text("حفظ الرقم المحدد"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     textStyle: const TextStyle(fontSize: 18),
//                   ),
//                   onPressed: _saveNumberToFirestore,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // كلاس مساعد لرسم المربع (Painter)
// // هذا الكود مسؤول عن تحويل إحداثيات الصورة إلى إحداثيات الشاشة
// class BoxPainter extends CustomPainter {
//   final Rect box;
//   final Size imageSize;
//   final Size screenSize;

//   BoxPainter({required this.box, required this.imageSize, required this.screenSize});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.green
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0;

//     // دالة لتحويل الإحداثيات
//     Rect scaleRect(Rect rect, Size imageSize, Size widgetSize) {
//       final  scaleX = widgetSize.width / imageSize.width;
//       final  scaleY = widgetSize.height / imageSize.height;

//       // الاختيار بين scaleX و scaleY يعتمد على aspect ratio
//       // هنا نفترض أن الكاميرا تملأ الشاشة (BoxFit.cover)
//       final  scale = scaleX > scaleY ? scaleX : scaleY;

//       final  scaledLeft = rect.left * scale;
//       final scaledTop = rect.top * scale;
//       final scaledRight = rect.right * scale;
//       final  scaledBottom = rect.bottom * scale;
      
//       // (قد تحتاج لتعديل هذه الحسابات بناءً على تدوير الجهاز)
//       // هذا هو الإعداد الافتراضي للوضع الرأسي (Portrait)
//       return Rect.fromLTRB(scaledLeft, scaledTop, scaledRight, scaledBottom);
//     }

//     // ارسم المربع المحوّل
//     canvas.drawRect(scaleRect(box, imageSize, screenSize), paint);
//   }

//   @override
//   bool shouldRepaint(covariant BoxPainter oldDelegate) {
//     return oldDelegate.box != box ||
//            oldDelegate.imageSize != imageSize ||
//            oldDelegate.screenSize != screenSize;
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماسح الأرقام',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _signInAnonymously();
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print("Error signing in anonymously: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return OCRScannerScreen(userId: snapshot.data!.uid);
        }
        return const Scaffold(body: Center(child: Text("جارٍ تسجيل الدخول...")));
      },
    );
  }
}

class OCRScannerScreen extends StatefulWidget {
  final String userId;
  const OCRScannerScreen({super.key, required this.userId});

  @override
  State<OCRScannerScreen> createState() => _OCRScannerScreenState();
}

class _OCRScannerScreenState extends State<OCRScannerScreen> {
  CameraController? _cameraController;
  TextRecognizer? _textRecognizer;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  String _recognizedNumber = "";
  Rect? _numberBoundingBox;
  Timer? _throttleTimer;

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _initializeCamera();
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
      _cameraController!.dispose();
    }
    _textRecognizer?.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      print("تم رفض إذن الكاميرا");
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print("لم يتم العثور على كاميرات");
      return;
    }

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    setState(() => _isCameraInitialized = true);

    _cameraController!.startImageStream(_processImageStream);
  }

  Future<void> _processImageStream(CameraImage image) async {
    if (_isProcessing) return;

    // تقليل عدد مرات المعالجة (مرّة كل 0.5 ثانية)
    if (_throttleTimer?.isActive ?? false) return;
    _throttleTimer = Timer(const Duration(milliseconds: 500), () {});

    setState(() => _isProcessing = true);

    try {
      final inputImage = _createInputImageFromCameraImage(image);
      if (inputImage == null) return;

      final RecognizedText recognizedText =
          await _textRecognizer!.processImage(inputImage);

      String? foundNumber;
      Rect? foundBox;

      final RegExp numberRegExp = RegExp(r'\b\d{3,}\b');

      for (TextBlock block in recognizedText.blocks) {
        String cleanText = block.text.replaceAll(RegExp(r'\s+'), '');
        if (numberRegExp.hasMatch(cleanText)) {
          foundNumber = cleanText;
          foundBox = block.boundingBox;
          break;
        }
      }

      setState(() {
        _recognizedNumber = foundNumber ?? "";
        _numberBoundingBox = foundBox;
      });
    } catch (e) {
      print("Error processing image: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  InputImage? _createInputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController!.description;

    final rotation = InputImageRotationValue.fromRawValue(
            camera.sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw as int) ??
        InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _saveNumberToFirestore() async {
    if (_recognizedNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لم يتم تحديد أي رقم للحفظ!")),
      );
      return;
    }

    try {
      final collectionPath = 'flutter_scans/${widget.userId}/scans';
      await FirebaseFirestore.instance.collection(collectionPath).add({
        'number': _recognizedNumber,
        'scan_date': FieldValue.serverTimestamp(),
        'user_id': widget.userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم حفظ الرقم: $_recognizedNumber"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error saving to Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("فشل الحفظ: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("التقاط الأرقام"),
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          if (_numberBoundingBox != null)
            CustomPaint(
              painter: BoxPainter(
                box: _numberBoundingBox!,
                imageSize: Size(
                  _cameraController!.value.previewSize!.height,
                  _cameraController!.value.previewSize!.width,
                ),
                screenSize: MediaQuery.of(context).size,
              ),
            ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _recognizedNumber.isEmpty
                        ? "وجّه الكاميرا نحو رقم..."
                        : _recognizedNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("حفظ الرقم المحدد"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _saveNumberToFirestore,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxPainter extends CustomPainter {
  final Rect box;
  final Size imageSize;
  final Size screenSize;

  BoxPainter({
    required this.box,
    required this.imageSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Rect scaleRect(Rect rect, Size imageSize, Size widgetSize) {
      final double scaleX = widgetSize.width / imageSize.width;
      final double scaleY = widgetSize.height / imageSize.height;
      final double scale = scaleX > scaleY ? scaleX : scaleY;

      final double scaledLeft = rect.left * scale;
      final double scaledTop = rect.top * scale;
      final double scaledRight = rect.right * scale;
      final double scaledBottom = rect.bottom * scale;

      return Rect.fromLTRB(
          scaledLeft, scaledTop, scaledRight, scaledBottom);
    }

    canvas.drawRect(scaleRect(box, imageSize, screenSize), paint);
  }

  @override
  bool shouldRepaint(covariant BoxPainter oldDelegate) {
    return oldDelegate.box != box ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.screenSize != screenSize;
  }
}
