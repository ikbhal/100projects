import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(DictationApp(camera: firstCamera));
}

class DictationApp extends StatelessWidget {
  final CameraDescription camera;

  DictationApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hindi Dictation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DictationScreen(camera: camera),
    );
  }
}

class DictationScreen extends StatefulWidget {
  final CameraDescription camera;

  DictationScreen({required this.camera});

  @override
  _DictationScreenState createState() => _DictationScreenState();
}

class _DictationScreenState extends State<DictationScreen> {
  late AudioPlayer audioPlayer;
  String dictationText = "The quick brown fox jumps over the lazy dog.";

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playAudio() {
    Source source = AssetSource('story.mp3');
    audioPlayer.play(source);
  }

  Future<void> submitPhoto(XFile imageFile) async {
    final url = Uri.parse('http://localhost:3006/dictation/photo');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('photo', imageFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      _notifyMadam();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submission Successful'),
            content: Text('Your dictation has been submitted.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submission Failed'),
            content: Text('There was an error while submitting your dictation.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _notifyMadam() {
    final madamNumber = '9901014560';
    // Code to send SMS or notification to madam with the completion status
    // using the provided madamNumber.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hindi Dictation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Listen to the dictation and write it down in Hindi:',
              style: TextStyle(fontSize: 18),
            ),
            // SizedBox(height: 20),
            // Text(
            //   dictationText,
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: playAudio,
              child: Text('Play Dictation'),
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     final XFile? imageFile = await widget.camera.takePicture();
            //     if (imageFile != null) {
            //       await submitPhoto(imageFile);
            //     }
            //   },
            //   child: Text('Submit via Photo'),
            // ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () {
            //     // TODO: Implement text input logic.
            //   },
            //   child: Text('Submit via Text'),
            // ),
          ],
        ),
      ),
    );
  }
}
