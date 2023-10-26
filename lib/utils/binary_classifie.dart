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


