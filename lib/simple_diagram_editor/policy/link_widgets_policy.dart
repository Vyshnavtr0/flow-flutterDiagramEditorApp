import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/dialog/edit_link_dialog.dart';
import 'package:flow/simple_diagram_editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyLinkWidgetsPolicy implements LinkWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showWidgetsWithLinkData(
      BuildContext context, LinkData linkData) {
    double linkLabelSize = 32;

    var linkStartLabelPosition = labelPosition(
      linkData.linkPoints.first,
      linkData.linkPoints[1],
      linkLabelSize / 2,
      false,
    );
    var linkEndLabelPosition = labelPosition(
      linkData.linkPoints.last,
      linkData.linkPoints[linkData.linkPoints.length - 2],
      linkLabelSize / 2,
      true,
    );

    return [
      label(linkStartLabelPosition, linkData.data.startLabel, linkLabelSize),
      label(linkEndLabelPosition, linkData.data.endLabel, linkLabelSize),
      if (selectedLinkId == linkData.id) showLinkOptions(context, linkData),
    ];
  }

  Widget showLinkOptions(BuildContext context, LinkData linkData) {
    var nPos = canvasReader.state.toCanvasCoordinates(tapLinkPosition);
    return Positioned(
      left: nPos.dx,
      top: nPos.dy,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              canvasWriter.model.removeLink(linkData.id);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: const Center(child: Icon(Icons.close, size: 20))),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showEditLinkDialog(context, linkData);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: const Center(child: Icon(Icons.edit, size: 20))),
          ),
        ],
      ),
    );
  }

  Widget label(Offset position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * canvasReader.state.scale,
      height: size * canvasReader.state.scale,
      child: GestureDetector(
        onTap: () {},
        onLongPress: () {},
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10 * canvasReader.state.scale,
            ),
          ),
        ),
      ),
    );
  }

  Offset labelPosition(
      Offset point1, Offset point2, double labelSize, bool left) {
    var normalized = VectorUtils.normalizeVector(point2 - point1);

    return canvasReader.state.toCanvasCoordinates(point1 -
        Offset(labelSize, labelSize) +
        normalized * labelSize +
        VectorUtils.getPerpendicularVectorToVector(normalized, left) *
            labelSize);
  }

  @override
  void drawLink(Canvas canvas, LinkData linkData) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 60
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(linkData.linkPoints.first.dx, linkData.linkPoints.first.dy);

    for (int i = 1; i < linkData.linkPoints.length - 1; i += 2) {
      var cp1 = linkData.linkPoints[i];
      var cp2 = linkData.linkPoints[i + 1];
      var endPoint = (i + 2 < linkData.linkPoints.length)
          ? linkData.linkPoints[i + 2]
          : linkData.linkPoints.last;
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, endPoint.dx, endPoint.dy);
    }

    canvas.drawPath(path, paint);
  }
}
