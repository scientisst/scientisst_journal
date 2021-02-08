import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';

class FancyFab extends StatefulWidget {
  final List<FloatingActionButton> options;
  final Widget icon;

  FancyFab({@required this.icon, @required this.options});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  AnimateIconController controller;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });
    controller = AnimateIconController();
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        child: AnimateIcons(
          startIcon: Icons.add,
          endIcon: Icons.close,
          controller: controller,
          size: 32,
          endTooltip: "Close",
          startTooltip: "Options",
          onStartIconPress: () {
            animate();
            return true;
          },
          onEndIconPress: () {
            animate();
            return true;
          },
          duration: Duration(milliseconds: 250),
          color: Theme.of(context).primaryIconTheme.color,
          clockwise: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Theme(
          data: ThemeData(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: _animationController.value < 0.5 ? 0 : 5,
            ),
          ),
          child: Column(
            children: List<Widget>.generate(
              widget.options.length,
              (int index) => Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * (widget.options.length - index),
                  0.0,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    print(2);
                  },
                  child: Container(
                    child: widget.options[index],
                  ),
                ),
              ),
            ),
          ),
        ),
        toggle(),
      ],
    );
  }
}
