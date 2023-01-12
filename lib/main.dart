import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ImagePicker picker;
  File? _image;
  String result = "Result will be shown here !";

  //TODO: declare ImageLabeler
  dynamic imageLabeler;

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
    //TODO: Initialize labeler
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //TODO: declare Image labeler
  doImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result = '';
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final String confidence = (label.confidence).toStringAsFixed(2);
      result += '$text   $confidence \n';
    }
    setState(() {
      result;
    });
  }

  imageFromGallery() async {
    final XFile? pickFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickFile != null) {
      setState(() {
        _image = File(pickFile.path);
        doImageLabeling();
      });
    }
  }

  imageFromCamera() async {
    final XFile? pickFile = await picker.pickImage(source: ImageSource.camera);
    _image = File(pickFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'images/frame.png',
                              height: 510,
                              width: 500,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: imageFromGallery,
                          onLongPress: imageFromCamera,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    height: 335,
                                    width: 495,
                                    fit: BoxFit.fill,
                                  )
                                : const SizedBox(
                                    height: 330,
                                    width: 340,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                      size: 100.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
