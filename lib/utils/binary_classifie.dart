import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart'
    as tflp;

class BinaryClassifier {
  late tfl.Interpreter _interpreter;
  late String _path;
  late bool _load;

  BinaryClassifier(String path) {
    _path = path;
    _load = false;
  }

  Future<void> loadModel() async {
    _interpreter = await tfl.Interpreter.fromAsset(_path);
    _load = true;
  }

  Future<int> runModelOnImage(Uint8List image) async {
    await loadModel();

    try {
      var _inputShape = _interpreter!.getInputTensor(0).shape;
      var _inputeType = _interpreter!.getInputTensor(0).type;
      var _outputShape = _interpreter!.getOutputTensor(0).shape;
      var _outputType = _interpreter!.getOutputTensor(0).type;

      tflp.ImageProcessor imageProcessor = tflp.ImageProcessorBuilder()
          .add(tflp.ResizeOp(
              _inputShape[1], _inputShape[2], tflp.ResizeMethod.bilinear))
          .add(tflp.NormalizeOp(128, 128))
          .build();
      tflp.TensorImage tensorImage;

      tensorImage = tflp.TensorImage(tflp.TensorBufferFloat.datatype);
      tensorImage.loadImage(decodeImage(image)!);
      tensorImage = imageProcessor.process(tensorImage);
      tflp.TensorBuffer _outputBuffer = tflp.TensorBuffer.createFixedSize(
          _outputShape, tflp.TensorBufferFloat.datatype);
      _interpreter!.run(tensorImage.buffer, _outputBuffer.buffer);
      print(_path);
      print(_outputBuffer.getDoubleList());
      return (_outputBuffer.getDoubleList()[0] * 100).toInt();
    } catch (e) {
      print('Exception details:\n $e');
    }
    return 0;
  }
}

/*  Future<TensorImage> preprocessImage(List<int> inputShape, TensorImage tensorImage) async {
  ImageProcessor imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(inputShape[0], inputShape[1], ResizeMethod.bilinear))
          .build();

      tensorImage = imageProcessor.process(tensorImage);

  return tensorImage;
}

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/AKmodel.tflite');
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  Future<int> predict(File fileImage) async {
    try {
      Interpreter interpreter =
          await Interpreter.fromAsset("models/face_detection_front.tflite");

      var _inputShape = interpreter.getInputTensor(0).shape;
      var _outputShape = interpreter.getOutputTensor(0).shape;
      var _outputType = interpreter.getOutputTensor(0).type;

      TensorImage tensorImage = TensorImage.fromFile(fileImage);
      tensorImage = await preprocessImage([128, 128], tensorImage);

      var _outputBuffer =
          TensorBuffer.createFixedSize(_outputShape, TfLiteType.kTfLiteUInt32);
      print(_outputShape.toString());
      interpreter.run(tensorImage.buffer, _outputBuffer.getBuffer());
      print(_outputBuffer);
      return (_outputBuffer.getIntList()[0] * 100).toInt();
    } catch (e) {
      print(e);
    }
    return 0;
    // Load the model
    /*try {
      _interpreter = await Interpreter.fromAsset('assets/AKmodel.tflite');
    } catch (e) {
      print("Error while creating interpreter: $e");
      return -1;
    }

    // Load and decode the image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      print('Failed to decode image');
      return 0;
    }

    // Preprocess the image
    img.Image resized = img.copyResize(image, width: 128, height: 128);

    // Convert the image to a tensor
    List<double> input = resized.getBytes().map((b) => b / 255.0).toList();

    // Check for zero division
    if (input.length % (128 * 128 * 3) != 0) {
      print('Error: Invalid input length');
      return 0;
    }

    var reshapedInput = reshape4D(input, 128, 128, 3);

    // Run inference
    var output = Float32List(1).reshape([1]);
    if (_interpreter == null) {
      print("NULLLLLLLLLLLLLLLLLLLLLLLLLLLL");
    }
    try {
      _interpreter!.run(reshapedInput, output);
    } catch (e) {
      print("Failed to run model: $e");
      return 0;
    }

    // Process the output
    bool prediction = output[0] > 0.5;

    return (output[0] * 100).toInt();*/
  }

  List<double> convertImageFromRgbaToRgb(List<double> rgbaImage) {
    List<double> rgbImage = [];
    for (var i = 0; i < rgbaImage.length; i += 4) {
      rgbImage.addAll(rgbaImage.sublist(i, i + 3));
    }
    return rgbImage;
  }

  List reshape4D(List list, int height, int width, int depth) {
    var reshaped = reshape(list, height);
    for (var i = 0; i < reshaped.length; i++) {
      reshaped[i] = reshape(reshaped[i], width);
      for (var j = 0; j < reshaped[i].length; j++) {
        reshaped[i][j] = reshape(reshaped[i][j], depth);
      }
    }
    return reshaped;
  }*/

