import '/components/action_pill_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'campus_interactive_map_widget.dart' show CampusInteractiveMapWidget;
import 'package:flutter/material.dart';

class CampusInteractiveMapModel
    extends FlutterFlowModel<CampusInteractiveMapWidget> {
  ///  Local state fields for this page.

  bool isProcessingSnackBar = false;

  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel;
  // Model for ActionPill.
  late ActionPillModel actionPillModel;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextFieldModel());
    actionPillModel = createModel(context, () => ActionPillModel());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
    actionPillModel.dispose();
  }
}
