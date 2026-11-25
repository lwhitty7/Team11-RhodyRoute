import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/report_option_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hazard_report_model.dart';
export 'hazard_report_model.dart';

class HazardReportWidget extends StatefulWidget {
  const HazardReportWidget({super.key});

  static String routeName = 'HazardReport';
  static String routePath = '/hazardReport';

  @override
  State<HazardReportWidget> createState() => _HazardReportWidgetState();
}

class _HazardReportWidgetState extends State<HazardReportWidget> {
  late HazardReportModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HazardReportModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'HazardReport'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            fillColor: Colors.transparent,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              logFirebaseEvent(
                                  'HAZARD_REPORT_PAGE_IconButton_ON_TAP');
                              logFirebaseEvent('IconButton_navigate_back');
                              context.safePop();
                            },
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report Hazard',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.sourceSans3(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                      lineHeight: 1.3,
                                    ),
                              ),
                              Text(
                                'Help fellow Rhody students navigate safely',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.sourceSans3(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                      lineHeight: 1.6,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        ].divide(SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'HAZARD_REPORT_PAGE_Container_ON_TAP');
                                logFirebaseEvent(
                                    'Container_store_media_for_upload');
                                final selectedMedia = await selectMedia(
                                  maxWidth: 195.00,
                                  imageQuality: 100,
                                  multiImage: false,
                                );
                                if (selectedMedia != null &&
                                    selectedMedia.every((m) =>
                                        validateFileFormat(
                                            m.storagePath, context))) {
                                  safeSetState(() => _model
                                      .isDataUploading_uploadData9va = true);
                                  var selectedUploadedFiles =
                                      <FFUploadedFile>[];

                                  try {
                                    selectedUploadedFiles = selectedMedia
                                        .map((m) => FFUploadedFile(
                                              name:
                                                  m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                              originalFilename:
                                                  m.originalFilename,
                                            ))
                                        .toList();
                                  } finally {
                                    _model.isDataUploading_uploadData9va =
                                        false;
                                  }
                                  if (selectedUploadedFiles.length ==
                                      selectedMedia.length) {
                                    safeSetState(() {
                                      _model.uploadedLocalFile_uploadData9va =
                                          selectedUploadedFiles.first;
                                    });
                                  } else {
                                    safeSetState(() {});
                                    return;
                                  }
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Container(
                                  height: 194.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 50.0,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            if ((_model.uploadedLocalFile_uploadData9va
                                                        .bytes?.isNotEmpty ??
                                                    false))
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.memory(
                                                  _model.uploadedLocalFile_uploadData9va
                                                          .bytes ??
                                                      Uint8List.fromList([]),
                                                  width: double.infinity,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'What\'s the issue?',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        font: GoogleFonts.sourceSans3(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontStyle,
                                        lineHeight: 1.4,
                                      ),
                                ),
                                wrapWithModel(
                                  model: _model.reportOption1Model,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ReportOptionWidget(
                                    icon: Icon(
                                      Icons.block_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onPrimaryContainer,
                                      size: 20.0,
                                    ),
                                    subtitle: 'Construction, snow, or debris',
                                    title: 'Path Blocked',
                                    selected:
                                        _model.selectedComponentIndex == 1,
                                    onTapCallback: () async {
                                      logFirebaseEvent(
                                          'HAZARD_REPORT_ReportOption1_CALLBACK');
                                      logFirebaseEvent(
                                          'ReportOption1_update_page_state');
                                      _model.selectedComponentIndex = 1;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.reportOption2Model,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ReportOptionWidget(
                                    icon: Icon(
                                      Icons.event_busy_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onPrimaryContainer,
                                      size: 20.0,
                                    ),
                                    subtitle:
                                        'Temporary tents or restricted access',
                                    title: 'Event Closure',
                                    selected:
                                        _model.selectedComponentIndex == 2,
                                    onTapCallback: () async {
                                      logFirebaseEvent(
                                          'HAZARD_REPORT_ReportOption2_CALLBACK');
                                      logFirebaseEvent(
                                          'ReportOption2_update_page_state');
                                      _model.selectedComponentIndex = 2;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                                wrapWithModel(
                                  model: _model.reportOption3Model,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ReportOptionWidget(
                                    icon: Icon(
                                      Icons.warning_amber_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .onPrimaryContainer,
                                      size: 20.0,
                                    ),
                                    subtitle:
                                        'Poor lighting or slippery surface',
                                    title: 'Safety Concern',
                                    selected:
                                        _model.selectedComponentIndex == 3,
                                    onTapCallback: () async {
                                      logFirebaseEvent(
                                          'HAZARD_REPORT_ReportOption3_CALLBACK');
                                      logFirebaseEvent(
                                          'ReportOption3_update_page_state');
                                      _model.selectedComponentIndex = 3;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Additional Details',
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        font: GoogleFonts.sourceSans3(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .fontStyle,
                                        lineHeight: 1.4,
                                      ),
                                ),
                                wrapWithModel(
                                  model: _model.descriptionHazardModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TextFieldWidget(
                                    label: 'Description (Optional)',
                                    labelPresent: true,
                                    helper: '',
                                    helperPresent: false,
                                    leadingIconPresent: false,
                                    trailingIconPresent: false,
                                    hint:
                                        'e.g. Fence blocking the library entrance',
                                    value: '',
                                    onChange: '',
                                    onSubmit: '',
                                    variant: 'outlined',
                                    error: false,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Expires in',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.sourceSans3(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.7,
                                          ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: FlutterFlowDropDown<String>(
                                        controller: _model
                                                .dropdownExpireHazardValueController ??=
                                            FormFieldController<String>(
                                          _model.dropdownExpireHazardValue ??=
                                              '4 Hours',
                                        ),
                                        options: [
                                          '1 Hour',
                                          '4 Hours',
                                          '12 Hours',
                                          '24 Hours'
                                        ],
                                        onChanged: (val) => safeSetState(() =>
                                            _model.dropdownExpireHazardValue =
                                                val),
                                        width: 200.0,
                                        height: 40.0,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.sourceSans3(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                              lineHeight: 1.7,
                                            ),
                                        hintText: '1 Hour',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 1.0,
                                        borderRadius: 6.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 16.0)),
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.rectangle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Container(
                      child: FFButtonWidget(
                        onPressed: () async {
                          logFirebaseEvent(
                              'HAZARD_REPORT_PAGE_SUBMIT_BTN_ON_TAP');
                          currentUserLocationValue =
                              await getCurrentUserLocation(
                                  defaultLocation: LatLng(0.0, 0.0));
                          if (_model.selectedComponentIndex == 4) {
                            logFirebaseEvent('Button_show_snack_bar');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please pick a hazard type',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            );
                          } else {
                            logFirebaseEvent('Button_backend_call');

                            await HazardCollectionsRecord.collection
                                .doc()
                                .set(createHazardCollectionsRecordData(
                                  title: valueOrDefault<String>(
                                    () {
                                      if (_model.selectedComponentIndex == 1) {
                                        return 'Path Blocked';
                                      } else if (_model
                                              .selectedComponentIndex ==
                                          2) {
                                        return 'Event Closure';
                                      } else {
                                        return 'Safety Concern';
                                      }
                                    }(),
                                    'None',
                                  ),
                                  description: valueOrDefault<String>(
                                    _model.descriptionHazardModel
                                        .inputTextController.text,
                                    'None',
                                  ),
                                  timeToExpire: valueOrDefault<int>(
                                    () {
                                      if (_model.dropdownExpireHazardValue !=
                                          '1 Hour') {
                                        return 1;
                                      } else if (_model
                                              .dropdownExpireHazardValue ==
                                          '4 Hours') {
                                        return 4;
                                      } else if (_model
                                              .dropdownExpireHazardValue ==
                                          '12 Hours') {
                                        return 12;
                                      } else {
                                        return 24;
                                      }
                                    }(),
                                    -1,
                                  ),
                                  createdTime: getCurrentTimestamp,
                                  location: currentUserLocationValue,
                                  user: currentUserReference,
                                  expired: false,
                                  photoUrl: valueOrDefault<String>(
                                    _model.uploadedLocalFile_uploadData9va
                                        .originalFilename,
                                    'no picture',
                                  ),
                                ));
                            logFirebaseEvent('Button_navigate_to');

                            context.pushNamed(
                                CampusInteractiveMapWidget.routeName);
                          }
                        },
                        text: 'Submit',
                        options: FFButtonOptions(
                          height: 48.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.sourceSans3(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
