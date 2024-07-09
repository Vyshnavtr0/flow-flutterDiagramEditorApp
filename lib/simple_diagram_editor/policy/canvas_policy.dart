import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect) {
      isReadyToConnect = false;
      canvasWriter.model.updateComponent(selectedComponentId!);
    } else {
      selectedComponentId = null;
      hideAllHighlights();
    }
  }

  void onCanvasPanUpdate(DragUpdateDetails details) {
    // Default implementation or leave empty if not needed
  }

  void onCanvasPanEnd(DragEndDetails details) {
    // Default implementation or leave empty if not needed
  }
}
