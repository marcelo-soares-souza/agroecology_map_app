import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  final imagePicker = ImagePicker();

  Future _getImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        widget.onPickImage(_selectedImage!);
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 1980);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        widget.onPickImage(_selectedImage!);
      }
    });
  }

  Future showOptions() async {
    final l10n = AppLocalizations.of(context)!;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(l10n.photoGallery),
            onPressed: () {
              Navigator.of(context).pop();
              _getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(l10n.camera),
            onPressed: () {
              Navigator.of(context).pop();
              _getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: Text(l10n.pickAPhoto),
      onPressed: showOptions,
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: showOptions,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      height: 200,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
