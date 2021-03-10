import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput(this.onPressed, {Key key}) : super(key: key);

  final Function onPressed;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;
  @override
  void initState() {
    super.initState();
  }

  void _onPressed() async {
    if (_image != null) {
      widget.onPressed(_image.readAsBytesSync());
      setState(() {
        _image = null;
      });
    } else {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _image = File(result.files.single.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _image != null
              ? Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.file(_image),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        color: Colors.black38,
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                      ),
                    )
                  ],
                )
              : Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
        ),
        FlatButton(
          minWidth: double.infinity,
          height: 64,
          color: Theme.of(context).primaryColor,
          child: Icon(
            _image != null ? Icons.add : Icons.image_search,
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }
}
