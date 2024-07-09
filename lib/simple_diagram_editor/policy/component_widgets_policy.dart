import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/dialog/edit_component_dialog.dart';
import 'package:flow/simple_diagram_editor/policy/custom_policy.dart';
import 'package:flow/simple_diagram_editor/widget/option_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(
      BuildContext context, ComponentData componentData) {
    bool isJunction = componentData.type == 'junction';
    bool showOptions =
        (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          if (showOptions) componentTopOptions(componentData, context),
          if (showOptions) componentBottomOptions(componentData),
          highlight(componentData,
              isMultipleSelectionOn ? Colors.cyan : Colors.blueAccent),
          if (showOptions) resizeCorner(componentData),
          if (isJunction && !isReadyToConnect) junctionOptions(componentData),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentData componentData, context) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 10,
      top: componentPosition.dy - 70,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.black38)),
        child: Row(
          children: [
            OptionIcon(
              color: Colors.white,
              iconData: CupertinoIcons.arrow_branch,
              tooltip: 'bring to front',
              size: 40,
              shape: BoxShape.rectangle,
              onPressed: () {
                isReadyToConnect = true;
                componentData.updateComponent();
              },
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade300,
            ),
            OptionIcon(
              color: Colors.white,
              iconData: Icons.arrow_upward,
              tooltip: 'bring to front',
              size: 40,
              shape: BoxShape.rectangle,
              onPressed: () =>
                  canvasWriter.model.moveComponentToTheFront(componentData.id),
            ),
            const SizedBox(width: 12),
            OptionIcon(
              color: Colors.white,
              iconData: Icons.arrow_downward,
              tooltip: 'move to back',
              size: 40,
              shape: BoxShape.rectangle,
              onPressed: () =>
                  canvasWriter.model.moveComponentToTheBack(componentData.id),
            ),
            const SizedBox(width: 12),
            OptionIcon(
              color: Colors.white,
              iconData: CupertinoIcons.delete,
              tooltip: 'delete',
              size: 40,
              onPressed: () {
                canvasWriter.model.removeComponent(componentData.id);
                selectedComponentId = null;
              },
            ),
            const SizedBox(width: 12),
            OptionIcon(
              color: Colors.white,
              iconData: Icons.copy,
              tooltip: 'duplicate',
              size: 40,
              onPressed: () {
                String newId = duplicate(componentData);
                canvasWriter.model.moveComponentToTheFront(newId);
                selectedComponentId = newId;
                hideComponentHighlight(componentData.id);
                highlightComponent(newId);
              },
            ),
            const SizedBox(width: 12),
            OptionIcon(
              color: Colors.white,
              iconData: Icons.edit,
              tooltip: 'edit',
              size: 40,
              onPressed: () => showEditComponentDialog(context, componentData),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget componentBottomOptions(ComponentData componentData) {
    Offset componentBottomLeftCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomLeft(Offset.zero));
    return Positioned(
      left: componentBottomLeftCorner.dx - 8,
      top: componentBottomLeftCorner.dy + 20,
      child: Row(
        children: [],
      ),
    );
  }

  Widget highlight(ComponentData componentData, Color color) {
    return Positioned(
      left: canvasReader.state
          .toCanvasCoordinates(componentData.position - const Offset(5, 5))
          .dx,
      top: canvasReader.state
          .toCanvasCoordinates(componentData.position - const Offset(5, 5))
          .dy,
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (componentData.size.width + 10) * canvasReader.state.scale,
          height: (componentData.size.height + 10) * canvasReader.state.scale,
          color: color,
        ),
      ),
    );
  }

  resizeCorner(ComponentData componentData) {
    Offset componentBottomRightCorner = canvasReader.state.toCanvasCoordinates(
        componentData.position + componentData.size.bottomRight(Offset.zero));
    return Positioned(
      left: componentBottomRightCorner.dx + 7,
      top: componentBottomRightCorner.dy + 7,
      child: GestureDetector(
        onPanUpdate: (details) {
          canvasWriter.model.resizeComponent(
              componentData.id, details.delta / canvasReader.state.scale);
          canvasWriter.model.updateComponentLinks(componentData.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 23,
            height: 23,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(400),
                    border: Border.all(color: Colors.blueGrey, width: 2)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget junctionOptions(ComponentData componentData) {
    Offset componentPosition =
        canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }
}
