import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_input_widget.dart' show OnboardingInputWidget;
import 'package:flutter/material.dart';

class OnboardingInputModel extends FlutterFlowModel<OnboardingInputWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for TextField.
  late TextFieldModel textFieldModel;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextFieldModel());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
  }
}
