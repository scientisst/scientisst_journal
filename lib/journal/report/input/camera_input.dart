import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void _onPressed() async {
    setState(() {
      _takingPhoto = true;
    });
    widget.onPressed(await takePhoto());
    setState(() {
      _takingPhoto = false;
    });
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    initController();
  }

  void initController() async {
    _controller = CameraController(
      _cameras[_selectedCamera],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller.initialize();
    setState(() {});
  }

  void switchCamera() {
    _selectedCamera++;
    if (_selectedCamera >= _cameras.length) _selectedCamera = 0;
    initController();
  }

  Future<XFile> takePhoto() async => await _controller.takePicture();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: (_controller != null &&
                  (_controller?.value?.isInitialized ?? false))
              ? LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children: [
                      OverflowBox(
                        maxWidth: constraints.maxWidth,
                        maxHeight: double.infinity,
                        child: CameraPreview(_controller),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.camera_front),
                          color: Colors.white,
                          onPressed: switchCamera,
                        ),
                      )
                    ],
                  ),
                )
              : Container(color: Colors.grey),
        ),
        IgnorePointer(
          ignoring: _takingPhoto,
          child: FlatButton(
            minWidth: double.infinity,
            height: 64,
            color: _takingPhoto ? Colors.grey : Theme.of(context).primaryColor,
            child: Icon(
              Icons.camera,
              color: Colors.white,
            ),
            onPressed: _onPressed,
          ),
        ),
      ],
    );
  }
}
