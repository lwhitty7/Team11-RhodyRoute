import '/components/button3_widget.dart';
import '/components/text_field3_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'user_satisfaction_survery_widget.dart'
    show UserSatisfactionSurveryWidget;
import 'package:flutter/material.dart';

class UserSatisfactionSurveryModel
    extends FlutterFlowModel<UserSatisfactionSurveryWidget> {
  ///  Local state fields for this page.
  /// NPS User score
  int? selectScore = -1;

  /// User Feedback
  String feedbackText = 'empty';

  /// Is the user submitting or not submitting
  bool isSubmitting = false;

  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextField3Model textFieldModel;
  // Model for Button.
  late Button3Model buttonModel1;
  // Model for Button.
  late Button3Model buttonModel2;

  @override
  void initState(BuildContext context) {
    textFieldModel = createModel(context, () => TextField3Model());
    buttonModel1 = createModel(context, () => Button3Model());
    buttonModel2 = createModel(context, () => Button3Model());
  }

  @override
  void dispose() {
    textFieldModel.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
