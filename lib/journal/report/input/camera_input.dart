import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as IMG;
import 'dart:math';

class CameraInput extends StatefulWidget {
  const CameraInput(this.onPressed, {Key key}) : super(key: key);

  final Function onPressed;

  @override
  _CameraInputState createState() => _CameraInputState();
}

class _CameraInputState extends State<CameraInput> {
  List<CameraDescription> _cameras = [];
  int _selectedCamera = 0;
  CameraController _controller;
  bool _takingPhoto = false;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void _onPressed() async {
    setState(() {
      _takingPhoto = true;
    });
    final Uint8List photoBytes = await _cropPicture(await takePhoto());
    widget.onPressed(photoBytes);
    setState(() {
      _takingPhoto = false;
    });
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    initController();
  }

  void initController() {
    _controller = CameraController(
      _cameras[_selectedCamera],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void switchCamera() {
    _selectedCamera++;
    if (_selectedCamera >= _cameras.length) _selectedCamera = 0;
    initController();
  }

  Future<XFile> takePhoto() async => await _controller.takePicture();

  Future<Uint8List> _cropPicture(XFile picture) async {
    var bytes = await File(picture.path).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes);

    var cropSize = min(src.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    IMG.Image destImage =
        IMG.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    Uint8List jpg = Uint8List.fromList(IMG.encodeJpg(destImage));
    return jpg;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRect(
                            child: OverflowBox(
                              maxWidth: constraints.maxWidth,
                              maxHeight: double.infinity,
                              child: CameraPreview(_controller),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: FlatButton(
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.camera_front,
                            color: Colors.white,
                          ),
                          color: Colors.black38,
                          onPressed: switchCamera,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _takingPhoto,
                child: FlatButton(
                  minWidth: double.infinity,
                  height: 64,
                  color: _takingPhoto
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                  child: _takingPhoto
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                  onPressed: _onPressed,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
