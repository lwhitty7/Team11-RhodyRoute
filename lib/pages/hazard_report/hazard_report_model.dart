import '/components/report_option_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'hazard_report_widget.dart' show HazardReportWidget;
import 'package:flutter/material.dart';

class HazardReportModel extends FlutterFlowModel<HazardReportWidget> {
  ///  Local state fields for this page.

  int? selectedComponentIndex = 4;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadData9va = false;
  FFUploadedFile uploadedLocalFile_uploadData9va =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Model for ReportOption1.
  late ReportOptionModel reportOption1Model;
  // Model for ReportOption2.
  late ReportOptionModel reportOption2Model;
  // Model for ReportOption3.
  late ReportOptionModel reportOption3Model;
  // Model for DescriptionHazard.
  late TextFieldModel descriptionHazardModel;
  // State field(s) for DropdownExpireHazard widget.
  String? dropdownExpireHazardValue;
  FormFieldController<String>? dropdownExpireHazardValueController;

  @override
  void initState(BuildContext context) {
    reportOption1Model = createModel(context, () => ReportOptionModel());
    reportOption2Model = createModel(context, () => ReportOptionModel());
    reportOption3Model = createModel(context, () => ReportOptionModel());
    descriptionHazardModel = createModel(context, () => TextFieldModel());
  }

  @override
  void dispose() {
    reportOption1Model.dispose();
    reportOption2Model.dispose();
    reportOption3Model.dispose();
    descriptionHazardModel.dispose();
  }
}
