import '/components/app_navigation_widget.dart';
import '/components/button_widget.dart';
import '/components/class_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'class_schedule_list_widget.dart' show ClassScheduleListWidget;
import 'package:flutter/material.dart';

class ClassScheduleListModel extends FlutterFlowModel<ClassScheduleListWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ClassItem.
  late ClassItemModel classItemModel1;
  // Model for ClassItem.
  late ClassItemModel classItemModel2;
  // Model for ClassItem.
  late ClassItemModel classItemModel3;
  // Model for ClassItem.
  late ClassItemModel classItemModel4;
  // Model for ClassItem.
  late ClassItemModel classItemModel5;
  // Model for Button.
  late ButtonModel buttonModel;
  // Model for AppNavigation.
  late AppNavigationModel appNavigationModel;

  @override
  void initState(BuildContext context) {
    classItemModel1 = createModel(context, () => ClassItemModel());
    classItemModel2 = createModel(context, () => ClassItemModel());
    classItemModel3 = createModel(context, () => ClassItemModel());
    classItemModel4 = createModel(context, () => ClassItemModel());
    classItemModel5 = createModel(context, () => ClassItemModel());
    buttonModel = createModel(context, () => ButtonModel());
    appNavigationModel = createModel(context, () => AppNavigationModel());
  }

  @override
  void dispose() {
    classItemModel1.dispose();
    classItemModel2.dispose();
    classItemModel3.dispose();
    classItemModel4.dispose();
    classItemModel5.dispose();
    buttonModel.dispose();
    appNavigationModel.dispose();
  }
}
