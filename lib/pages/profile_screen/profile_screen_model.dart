import '/components/button5_widget.dart';
import '/components/top_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_screen_widget.dart' show ProfileScreenWidget;
import 'package:flutter/material.dart';

class ProfileScreenModel extends FlutterFlowModel<ProfileScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TopBar.
  late TopBarModel topBarModel;
  // Model for Button.
  late Button5Model buttonModel;

  @override
  void initState(BuildContext context) {
    topBarModel = createModel(context, () => TopBarModel());
    buttonModel = createModel(context, () => Button5Model());
  }

  @override
  void dispose() {
    topBarModel.dispose();
    buttonModel.dispose();
  }
}
