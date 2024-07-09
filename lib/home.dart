import 'dart:math';

import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_picker_wheel/flutter_color_picker_wheel.dart';
import 'package:flutter_color_picker_wheel/models/button_behaviour.dart';
import 'package:whiteboard/whiteboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color color = Colors.black;
  double opacity = 1;
  bool isOpacitySliderVisible = false;
  final board = WhiteBoardController();
  final GlobalKey<FabCircularMenuPlusState> fabKey = GlobalKey();
  bool pen = true;
  ColorPickerController controller = ColorPickerController(
    color: Colors.black, // Initial color
    opacity: 1.0, // Initial opacity
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 6), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26)),
                child: WheelColorPicker(
                  onSelect: (Color newColor) {
                    setState(() {
                      color = newColor.withOpacity(opacity);
                    });
                  },
                  controller: controller,
                  opacity: opacity,
                  stickToButton: true,
                  debugMode: true,
                  behaviour: ButtonBehaviour.clickToOpen,
                  defaultColor: color,
                  animationConfig: fanLikeAnimationConfig,
                  colorList: defaultAvailableColors,
                  buttonSize: 30,
                  onOpacityChanged: (d) {
                    d = opacity;
                  },
                  pieceHeight: 25,
                  innerRadius: 70,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOpacitySliderVisible =
                        !isOpacitySliderVisible; // Toggle visibility of opacity slider
                  });
                },
                child: Container(
                  width: 33,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 6), // changes position of shadow
                      ),
                    ],
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.opacity_outlined),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 40,
                child: AnimatedOpacity(
                  opacity: isOpacitySliderVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Visibility(
                    visible: isOpacitySliderVisible,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Slider(
                        value: color.opacity,
                        activeColor: Colors.black,
                        onChanged: (double value) {
                          setState(() {
                            color = color.withOpacity(value);
                            opacity = value;
                          });
                          controller.opacity = opacity;
                          controller.color = color.withOpacity(opacity);
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            isOpacitySliderVisible = false;
                          });
                        },
                        min: 0.0,
                        max: 1.0,
                        divisions: 100,
                        label: "${(color.opacity * 100).toInt()}%",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Center(
          child: WhiteBoard(
            backgroundColor: Colors.transparent,
            controller: board,
            strokeWidth: 5,
            strokeColor: color,
            isErasing: !pen,
            onConvertImage: (list) {},
            onRedoUndo: (t, m) {},
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FabCircularMenuPlus(
                key: fabKey,
                fabSize: 40,
                ringDiameter: 300,
                ringColor: Colors.grey.shade100,
                fabOpenIcon: pen
                    ? Icon(Icons.brush)
                    : Icon(CupertinoIcons.cube_box_fill),
                fabColor: Colors.white,
                children: <Widget>[
                  IconButton(
                      icon: Icon(CupertinoIcons.cube_box_fill),
                      onPressed: () {
                        setState(() {
                          pen = false;
                        });
                        fabKey.currentState?.close();
                      }),
                  IconButton(
                      icon: Icon(Icons.brush),
                      onPressed: () {
                        setState(() {
                          pen = true;
                        });
                        fabKey.currentState?.close();
                      }),
                  IconButton(
                      icon: Icon(Icons.undo),
                      onPressed: () {
                        board.undo();
                      }),
                  IconButton(
                      icon: Icon(Icons.redo),
                      onPressed: () {
                        board.redo();
                      }),
                  IconButton(
                      icon: Icon(CupertinoIcons.trash_fill),
                      onPressed: () {
                        board.clear();
                        fabKey.currentState?.close();
                      })
                ]),
          ),
        )
      ]),
    );
  }
}
