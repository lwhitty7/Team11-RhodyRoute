import '/components/button_widget.dart';
import '/components/day_chip_widget.dart';
import '/components/switch_component_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'add_class_schedule_widget.dart' show AddClassScheduleWidget;
import 'package:flutter/material.dart';

class AddClassScheduleModel extends FlutterFlowModel<AddClassScheduleWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextField.
  late TextFieldModel textFieldModel1;
  // Model for TextField.
  late TextFieldModel textFieldModel2;
  // Model for TextField.
  late TextFieldModel textFieldModel3;
  // Model for TextField.
  late TextFieldModel textFieldModel4;
  // Model for DayChip.
  late DayChipModel dayChipModel1;
  // Model for DayChip.
  late DayChipModel dayChipModel2;
  // Model for DayChip.
  late DayChipModel dayChipModel3;
  // Model for DayChip.
  late DayChipModel dayChipModel4;
  // Model for DayChip.
  late DayChipModel dayChipModel5;
  // Model for DayChip.
  late DayChipModel dayChipModel6;
  // Model for DayChip.
  late DayChipModel dayChipModel7;
  // Model for Switch.
  late SwitchComponentModel switchModel;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;

  @override
  void initState(BuildContext context) {
    textFieldModel1 = createModel(context, () => TextFieldModel());
    textFieldModel2 = createModel(context, () => TextFieldModel());
    textFieldModel3 = createModel(context, () => TextFieldModel());
    textFieldModel4 = createModel(context, () => TextFieldModel());
    dayChipModel1 = createModel(context, () => DayChipModel());
    dayChipModel2 = createModel(context, () => DayChipModel());
    dayChipModel3 = createModel(context, () => DayChipModel());
    dayChipModel4 = createModel(context, () => DayChipModel());
    dayChipModel5 = createModel(context, () => DayChipModel());
    dayChipModel6 = createModel(context, () => DayChipModel());
    dayChipModel7 = createModel(context, () => DayChipModel());
    switchModel = createModel(context, () => SwitchComponentModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    textFieldModel1.dispose();
    textFieldModel2.dispose();
    textFieldModel3.dispose();
    textFieldModel4.dispose();
    dayChipModel1.dispose();
    dayChipModel2.dispose();
    dayChipModel3.dispose();
    dayChipModel4.dispose();
    dayChipModel5.dispose();
    dayChipModel6.dispose();
    dayChipModel7.dispose();
    switchModel.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
