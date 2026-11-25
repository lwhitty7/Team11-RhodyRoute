import '/components/button4_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'new_screen2_widget.dart' show NewScreen2Widget;
import 'package:flutter/material.dart';

class NewScreen2Model extends FlutterFlowModel<NewScreen2Widget> {
  ///  State fields for stateful widgets in this page.

  // Model for Button.
  late Button4Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button4Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
