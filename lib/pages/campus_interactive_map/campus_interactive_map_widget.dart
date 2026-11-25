import '/auth/firebase_auth/auth_util.dart';
import '/components/action_pill_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'campus_interactive_map_model.dart';
export 'campus_interactive_map_model.dart';

class CampusInteractiveMapWidget extends StatefulWidget {
  const CampusInteractiveMapWidget({super.key});

  static String routeName = 'CampusInteractiveMap';
  static String routePath = '/campusInteractiveMap';

  @override
  State<CampusInteractiveMapWidget> createState() =>
      _CampusInteractiveMapWidgetState();
}

class _CampusInteractiveMapWidgetState
    extends State<CampusInteractiveMapWidget> {
  late CampusInteractiveMapModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CampusInteractiveMapModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CampusInteractiveMap'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CAMPUS_INTERACTIVE_MAP_CampusInteractive');
      logFirebaseEvent('CampusInteractiveMap_request_permissions');
      await requestPermission(locationPermission);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Stack(
              alignment: AlignmentDirectional(-1.0, -1.0),
              children: [
                Container(
                  width: 415.6,
                  height: 795.6,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: custom_widgets.UriCampusMap(
                          width: double.infinity,
                          height: double.infinity,
                          zoom: FFAppState().CurrentZome,
                          mapStyle: FFAppState().layerStyle,
                          center: FFAppState().mapCenter!,
                          routeCoordinates: FFAppState().routePoints,
                          hasCurrentLocation:
                              FFAppState().hasNavigationLocation,
                          followUser: FFAppState().isFollowingUser,
                          currentLocation: FFAppState().navigationLocation,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 24.0, 24.0, 24.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (FFAppState().routePoints.isNotEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 75.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 12.0),
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    functions
                                                        .getCampusRouteEtaMinutes(
                                                            FFAppState()
                                                                .routePoints
                                                                .toList()),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .sourceSans3(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Estimated Walking Time',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .sourceSans3(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    functions
                                                        .getCampusRouteDistanceMeters(
                                                            FFAppState()
                                                                .routePoints
                                                                .toList()),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .sourceSans3(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Distance',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .sourceSans3(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(6.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: wrapWithModel(
                                          model: _model.textFieldModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: TextFieldWidget(
                                            label: '',
                                            labelPresent: false,
                                            helper: '',
                                            helperPresent: false,
                                            leadingIconPresent: false,
                                            trailingIconPresent: false,
                                            hint:
                                                'Search buildings, labs, or dining...',
                                            value: '',
                                            onChange: '',
                                            onSubmit: '',
                                            variant: 'ghost',
                                            error: false,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.mic_none_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        (FFMainAxisAlignment.start)
                                            .flutterValue,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'CAMPUS_INTERACTIVE_MAP_ActionPill_ON_TAP');
                                            if (currentUserEmail != '') {
                                              logFirebaseEvent(
                                                  'ActionPill_navigate_to');

                                              context.pushNamed(
                                                  HazardReportWidget.routeName);
                                            } else {
                                              if (_model.isProcessingSnackBar ==
                                                  false) {
                                                logFirebaseEvent(
                                                    'ActionPill_update_page_state');
                                                _model.isProcessingSnackBar =
                                                    true;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'ActionPill_show_snack_bar');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Guests can\'t report hazards',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 2050),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryBackground,
                                                    action: SnackBarAction(
                                                      label: 'Sign In',
                                                      onPressed: () async {
                                                        context.pushNamed(
                                                            SignUpAndLoginRealWidget
                                                                .routeName);
                                                      },
                                                    ),
                                                  ),
                                                );
                                                logFirebaseEvent(
                                                    'ActionPill_wait__delay');
                                                await Future.delayed(
                                                  Duration(
                                                    milliseconds: 4000,
                                                  ),
                                                );
                                                logFirebaseEvent(
                                                    'ActionPill_hide_snack_bar');
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                logFirebaseEvent(
                                                    'ActionPill_update_page_state');
                                                _model.isProcessingSnackBar =
                                                    false;
                                                safeSetState(() {});
                                              }
                                            }
                                          },
                                          child: wrapWithModel(
                                            model: _model.actionPillModel,
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ActionPillWidget(
                                              icon: Icon(
                                                Icons.warning_amber_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                size: 18.0,
                                              ),
                                              label: 'Report Hazard',
                                              tone: FlutterFlowTheme.of(context)
                                                  .error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 0.0),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderRadius: 6.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              icon: Icon(
                                Icons.my_location_rounded,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent(
                                    'CAMPUS_INTERACTIVE_MAP_IconButton_ON_TAP');
                                currentUserLocationValue =
                                    await getCurrentUserLocation(
                                        defaultLocation: LatLng(0.0, 0.0));
                                logFirebaseEvent('IconButton_update_app_state');
                                FFAppState().mapCenter =
                                    currentUserLocationValue;
                                FFAppState().isFollowingUser = true;
                                FFAppState().update(() {});
                              },
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderRadius: 6.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              icon: Icon(
                                Icons.layers_outlined,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent(
                                    'CAMPUS_INTERACTIVE_MAP_IconButton_ON_TAP');
                                logFirebaseEvent('IconButton_update_app_state');
                                FFAppState().layerStyle = functions
                                    .layerStyleFunc(FFAppState().layerStyle)!;
                                safeSetState(() {});
                                logFirebaseEvent(
                                    'IconButton_google_analytics_event');
                                logFirebaseEvent(
                                  'centerAn',
                                  parameters: {
                                    'Param 1': 'centerBut',
                                  },
                                );
                              },
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderRadius: 6.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              icon: Icon(
                                Icons.add_rounded,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent(
                                    'CAMPUS_INTERACTIVE_MAP_IconButton_ON_TAP');
                                logFirebaseEvent('IconButton_update_app_state');
                                FFAppState().CurrentZome =
                                    FFAppState().CurrentZome + 1;
                                safeSetState(() {});
                              },
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderRadius: 6.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              icon: Icon(
                                Icons.remove_rounded,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                logFirebaseEvent(
                                    'CAMPUS_INTERACTIVE_MAP_IconButton_ON_TAP');
                                logFirebaseEvent('IconButton_update_app_state');
                                FFAppState().CurrentZome =
                                    FFAppState().CurrentZome + -1;
                                safeSetState(() {});
                              },
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.0,
                  height: 0.0,
                ),
                Container(
                  width: 1.0,
                  height: 1.0,
                  child: custom_widgets.CampusLocationTracker(
                    width: 1.0,
                    height: 1.0,
                    enabled: true,
                  ),
                ),
              ],
            ),
            Container(
              height: 190.1,
              decoration: BoxDecoration(),
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Visibility(
                visible: FFAppState().routePoints.isNotEmpty,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent(
                          'CAMPUS_INTERACTIVE_MAP_Button_wbwhdc90_O');
                      if (FFAppState().isNavigating) {
                        logFirebaseEvent('Button_update_app_state');
                        FFAppState().isNavigating = false;
                        FFAppState().isFollowingUser = false;
                        FFAppState().remainingDistanceMeters = 0.0;
                        FFAppState().remainingEtaMinutes = 0;
                        FFAppState().routePoints = [];
                        FFAppState().lockedDestination = LatLng(0, 0);
                        FFAppState().isRerouting = false;
                        FFAppState().lockedDestinationQuery = '';
                        safeSetState(() {});
                      } else {
                        if (FFAppState().routePoints.isNotEmpty) {
                          logFirebaseEvent('Button_update_app_state');
                          FFAppState().isNavigating = true;
                          FFAppState().isFollowingUser = true;
                          FFAppState().isRerouting = false;
                          safeSetState(() {});
                        } else {
                          logFirebaseEvent('Button_show_snack_bar');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                        }
                      }
                    },
                    text: () {
                      if (FFAppState().isNavigating) {
                        return 'End Navigation';
                      } else if (FFAppState().isNavigating) {
                        return 'Begin Navigation';
                      } else {
                        return 'Begin Navigation';
                      }
                    }(),
                    icon: Icon(
                      Icons.fmd_good,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      width: 329.1,
                      height: 61.3,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.sourceSans3(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).error,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
