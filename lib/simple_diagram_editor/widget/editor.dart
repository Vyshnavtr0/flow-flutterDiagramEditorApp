import 'package:diagram_editor/diagram_editor.dart';
import 'package:flow/simple_diagram_editor/policy/minimap_policy.dart';
import 'package:flow/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:flow/simple_diagram_editor/widget/menu.dart';
import 'package:flow/simple_diagram_editor/widget/option_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleDemoEditor extends StatefulWidget {
  const SimpleDemoEditor({super.key});

  @override
  SimpleDemoEditorState createState() => SimpleDemoEditorState();
}

class SimpleDemoEditorState extends State<SimpleDemoEditor> {
  late DiagramEditorContext diagramEditorContext;
  late DiagramEditorContext diagramEditorContextMiniMap;

  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  bool isMiniMapVisible = true;
  bool isMenuVisible = true;
  bool isOptionsVisible = true;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(
        diagramEditorContext,
        policySet: miniMapPolicySet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: DiagramEditor(
                    diagramEditorContext: diagramEditorContext,
                  ),
                ),
              ),
              // Positioned(
              //   right: 16,
              //   top: 16,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Visibility(
              //         visible: isMiniMapVisible,
              //         child: SizedBox(
              //           width: 320,
              //           height: 240,
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 border: Border.all(
              //               color: Colors.black,
              //               width: 2,
              //             )),
              //             child: DiagramEditor(
              //               diagramEditorContext: diagramEditorContextMiniMap,
              //             ),
              //           ),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             isMiniMapVisible = !isMiniMapVisible;
              //           });
              //         },
              //         child: Container(
              //           color: Colors.grey[300],
              //           child: Padding(
              //             padding: const EdgeInsets.all(4),
              //             child: Text(isMiniMapVisible
              //                 ? 'hide minimap'
              //                 : 'show minimap'),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildIconButton(
                        tooltip: myPolicySet.isGridVisible
                            ? 'hide grid'
                            : 'show grid',
                        icon: isOptionsVisible ? Icons.menu_open : Icons.menu,
                        onPressed: () {
                          setState(() {
                            isOptionsVisible = !isOptionsVisible;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: isOptionsVisible,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Add more IconButton widgets with the same style
                            _buildIconButton(
                              tooltip: 'reset view',
                              icon: Icons.replay,
                              onPressed: () => myPolicySet.resetView(),
                            ),
                            const SizedBox(width: 8),
                            _buildIconButton(
                              tooltip: 'delete all',
                              icon: CupertinoIcons.delete,
                              onPressed: () {
                                setState(() {
                                  myPolicySet.removeAll();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildIconButton(
                              tooltip: myPolicySet.isGridVisible
                                  ? 'hide grid'
                                  : 'show grid',
                              icon: myPolicySet.isGridVisible
                                  ? Icons.grid_off
                                  : Icons.grid_on,
                              onPressed: () {
                                setState(() {
                                  myPolicySet.isGridVisible =
                                      !myPolicySet.isGridVisible;
                                });
                              },
                            ),
                            const SizedBox(width: 8),

                            // Add more IconButton widgets with the same style
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMenuVisible = !isMenuVisible;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child:
                                Text(isMenuVisible ? 'Hide Menu' : 'Show Menu'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: isMenuVisible,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: DraggableMenu(myPolicySet: myPolicySet),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconButton({
  required String tooltip,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.black),
    ),
    child: IconButton(
      tooltip: tooltip,
      color: Colors.black,
      splashRadius: 20,
      iconSize: 20,
      constraints: const BoxConstraints(maxHeight: 60, maxWidth: 60),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      icon: Icon(icon),
      onPressed: onPressed,
    ),
  );
}
