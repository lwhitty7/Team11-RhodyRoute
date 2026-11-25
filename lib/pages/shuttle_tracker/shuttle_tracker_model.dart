import '/components/app_navigation_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'shuttle_tracker_widget.dart' show ShuttleTrackerWidget;
import 'package:flutter/material.dart';

class ShuttleTrackerModel extends FlutterFlowModel<ShuttleTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AppNavigation.
  late AppNavigationModel appNavigationModel;

  @override
  void initState(BuildContext context) {
    appNavigationModel = createModel(context, () => AppNavigationModel());
  }

  @override
  void dispose() {
    appNavigationModel.dispose();
  }
}
