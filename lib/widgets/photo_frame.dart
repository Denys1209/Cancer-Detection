import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_cnn/utils/utils.dart';

class PhotoFrame extends StatefulWidget {
  final Function(Uint8List?) setPhoto;
  final Function() getPhoto;
  PhotoFrame({
    super.key,
    required this.setPhoto,
    required this.getPhoto,
  });

  @override
  State<PhotoFrame> createState() => _PhotoFrameState();
}

class _PhotoFrameState extends State<PhotoFrame> {
  _getFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() async {
        Uint8List file = await File(pickedFile.path).readAsBytes();
        widget.setPhoto(file);
      });
    }
  }

  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Which source to select'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                final picker = ImagePicker();
                final image =
                    await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  Uint8List file = await File(image.path).readAsBytes();

                  setState(() {
                    widget.setPhoto(file);
                  });
                  widget.setPhoto(file);
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("select from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                _getFromGallery();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: widget.getPhoto() == null
              ? BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.grey,
                  ),
                )
              : BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(widget.getPhoto()),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
         Align(
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 27,
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    _selectImage(context);
                  },
                ),
              )
      ],
    );
  }
}
