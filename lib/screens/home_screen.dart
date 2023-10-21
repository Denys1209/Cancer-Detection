import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:test_cnn/utils/binary_classifie.dart';
import 'package:test_cnn/widgets/list_of_values.dart';
import 'package:test_cnn/widgets/my_check_button.dart';
import 'package:test_cnn/widgets/photo_frame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _photo = null;
  bool _checking = false;

  Map<String, BinaryClassifier> _classifiers = {
    'Melanoma': new BinaryClassifier("assets/MELmodel.tflite"),
    'Melanocytic nevus': new BinaryClassifier("assets/NVmodel.tflite"),
    'Basal cell carcinoma': new BinaryClassifier("assets/NVmodel.tflite"),
    'Actinic keratosis': new BinaryClassifier("assets/AKmodel.tflite"),
    'Benign keratosis': new BinaryClassifier("assets/BKLmodel.tflite"),
    'Dermatofibroma': new BinaryClassifier("assets/DFmodel.tflite"),
    'Vascular lesion': new BinaryClassifier("assets/VASCmodel.tflite"),
    'Squamous cell carcinoma': new BinaryClassifier("assets/SCCmodel.tflite")
  };

  BinaryClassifier classifier = new BinaryClassifier("assets/AKmodel.tflite");
  Map<String, int> _cancers = {
    'Melanoma': 0,
    'Melanocytic nevus': 0,
    'Basal cell carcinoma': 0,
    'Actinic keratosis': 0,
    'Dermatofibroma': 0,
    'Vascular lesion': 0,
    'Squamous cell carcinoma': 0,
    'Benign keratosis': 0,
  };

  void _changePhoto(Uint8List? photo) {
    setState(() {
      _photo = photo;
    });
  }

  Uint8List? _getPhoto() {
    return _photo;
  }

  Future<void> _checkPhoto(Uint8List? photo) async {
    List<Future<int>> futures = [];

    for (var key in _classifiers.keys) {
      int check = await _classifiers[key]!.runModelOnImage(_photo!);
      setState(() {
        _cancers[key] = check;
      });
    }
    setState(() {
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_checking
        ? Scaffold(
            appBar: null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  PhotoFrame(
                    getPhoto: _getPhoto,
                    setPhoto: _changePhoto,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  _photo != null
                      ? MyCheckButton(
                          text: "check",
                          function: () {
                            setState(() {
                              _checking = true;
                            });
                            _checkPhoto(_photo);
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ListOfValues(listOfValues: _cancers),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
