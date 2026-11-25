import '/components/auth_header_widget.dart';
import '/components/button_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_up_and_login_real_widget.dart' show SignUpAndLoginRealWidget;
import 'package:flutter/material.dart';

class SignUpAndLoginRealModel
    extends FlutterFlowModel<SignUpAndLoginRealWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AuthHeader.
  late AuthHeaderModel authHeaderModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for EmailLogIn.
  late TextFieldModel emailLogInModel;
  // Model for PasswordLogIn.
  late TextFieldModel passwordLogInModel;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for Button.
  late ButtonModel buttonModel3;
  // Model for signupFullNameField.
  late TextFieldModel signupFullNameFieldModel;
  // Model for signupEmailField.
  late TextFieldModel signupEmailFieldModel;
  // Model for signupPasswordField.
  late TextFieldModel signupPasswordFieldModel;
  // Model for signupConfirmPasswordField.
  late TextFieldModel signupConfirmPasswordFieldModel;
  // Model for Button.
  late ButtonModel buttonModel4;
  // Model for Button.
  late ButtonModel buttonModel5;

  @override
  void initState(BuildContext context) {
    authHeaderModel = createModel(context, () => AuthHeaderModel());
    emailLogInModel = createModel(context, () => TextFieldModel());
    passwordLogInModel = createModel(context, () => TextFieldModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    buttonModel3 = createModel(context, () => ButtonModel());
    signupFullNameFieldModel = createModel(context, () => TextFieldModel());
    signupEmailFieldModel = createModel(context, () => TextFieldModel());
    signupPasswordFieldModel = createModel(context, () => TextFieldModel());
    signupConfirmPasswordFieldModel =
        createModel(context, () => TextFieldModel());
    buttonModel4 = createModel(context, () => ButtonModel());
    buttonModel5 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    authHeaderModel.dispose();
    tabBarController?.dispose();
    emailLogInModel.dispose();
    passwordLogInModel.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    buttonModel3.dispose();
    signupFullNameFieldModel.dispose();
    signupEmailFieldModel.dispose();
    signupPasswordFieldModel.dispose();
    signupConfirmPasswordFieldModel.dispose();
    buttonModel4.dispose();
    buttonModel5.dispose();
  }
}
