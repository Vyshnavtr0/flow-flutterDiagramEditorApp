import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/data/custom_component_data.dart';
import 'package:flow/simple_diagram_editor/policy/component_widgets_policy.dart';
import 'package:flutter/material.dart';

class BaseComponentBody extends StatefulWidget {
  final ComponentData componentData;
  final CustomPainter componentPainter;

  const BaseComponentBody({
    Key? key,
    required this.componentData,
    required this.componentPainter,
  }) : super(key: key);

  @override
  _BaseComponentBodyState createState() => _BaseComponentBodyState();
}

class _BaseComponentBodyState extends State<BaseComponentBody> {
  late MyComponentData customData;
  bool edit = false;
  final controller = TextEditingController(text: '');
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    customData = widget.componentData.data as MyComponentData;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          edit = true;
          _focusNode.requestFocus();
        });
      },
      child: CustomPaint(
        painter: widget.componentPainter,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Align(
            alignment: customData.textAlignment,
            child: edit == false
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        customData.text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 50),
                      ),
                    ),
                  )
                : TextField(
                    focusNode: _focusNode,
                    textAlign: TextAlign.center, // Set text alignment to right
                    readOnly: !edit,
                    controller: controller,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    onChanged: (newValue) {
                      setState(() {
                        customData.text = newValue;
                      });
                      // Handle onChanged event if needed
                    },
                    onTapOutside: (event) {
                      setState(() {
                        edit = false;
                      });
                    },
                    onEditingComplete: () {},
                    maxLines: null, // Set maxLines to 1
                    textInputAction:
                        TextInputAction.none, // Disable text input action
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
