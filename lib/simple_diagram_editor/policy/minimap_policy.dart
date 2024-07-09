import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/policy/component_design_policy.dart';
import 'package:flutter/material.dart';

class MiniMapPolicySet extends PolicySet
    with MiniMapInitPolicy, CanvasControlPolicy, MyComponentDesignPolicy {}

mixin MiniMapInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setMinScale(0.025);
    canvasWriter.state.setMaxScale(0.25);
    canvasWriter.state.setScale(0.1);
    canvasWriter.state.setCanvasColor(const Color(0xFFE0E0E0).withOpacity(0.9));
    canvasWriter.state.setPosition(const Offset(80, 60));
  }
}
