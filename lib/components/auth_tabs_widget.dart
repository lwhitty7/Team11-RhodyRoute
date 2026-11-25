import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_tabs_model.dart';
export 'auth_tabs_model.dart';

class AuthTabsWidget extends StatefulWidget {
  const AuthTabsWidget({
    super.key,
    String? label,
    String? label2,
    String? label3,
    String? activeTab,
  })  : this.label = label ?? 'Login',
        this.label2 = label2 ?? 'Sign Up',
        this.label3 = label3 ?? 'Guest',
        this.activeTab = activeTab ?? 'signup';

  final String label;
  final String label2;
  final String label3;
  final String activeTab;

  @override
  State<AuthTabsWidget> createState() => _AuthTabsWidgetState();
}

class _AuthTabsWidgetState extends State<AuthTabsWidget> {
  late AuthTabsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthTabsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            valueOrDefault<String>(
                                      widget.activeTab,
                                      'signup',
                                    ) ==
                                    'login'
                                ? FlutterFlowTheme.of(context).primary
                                : Colors.transparent,
                            Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 8.0, 24.0, 8.0),
                          child: Container(
                            child: Text(
                              valueOrDefault<String>(
                                widget.label,
                                'Login',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.sourceSans3(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: valueOrDefault<Color>(
                                      valueOrDefault<String>(
                                                widget.activeTab,
                                                'signup',
                                              ) ==
                                              'login'
                                          ? FlutterFlowTheme.of(context)
                                              .onPrimary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
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
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (valueOrDefault<String>(
                                    widget.activeTab,
                                    'signup',
                                  ) ==
                                  'login') {
                                return Colors.transparent;
                              } else if (valueOrDefault<String>(
                                    widget.activeTab,
                                    'signup',
                                  ) ==
                                  'guest') {
                                return Colors.transparent;
                              } else {
                                return FlutterFlowTheme.of(context).primary;
                              }
                            }(),
                            FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 8.0, 24.0, 8.0),
                          child: Container(
                            child: Text(
                              valueOrDefault<String>(
                                widget.label2,
                                'Sign Up',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.sourceSans3(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: valueOrDefault<Color>(
                                      () {
                                        if (valueOrDefault<String>(
                                              widget.activeTab,
                                              'signup',
                                            ) ==
                                            'login') {
                                          return FlutterFlowTheme.of(context)
                                              .secondaryText;
                                        } else if (valueOrDefault<String>(
                                              widget.activeTab,
                                              'signup',
                                            ) ==
                                            'guest') {
                                          return FlutterFlowTheme.of(context)
                                              .secondaryText;
                                        } else {
                                          return FlutterFlowTheme.of(context)
                                              .onPrimary;
                                        }
                                      }(),
                                      FlutterFlowTheme.of(context).onPrimary,
                                    ),
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
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            valueOrDefault<String>(
                                      widget.activeTab,
                                      'signup',
                                    ) ==
                                    'guest'
                                ? FlutterFlowTheme.of(context).primary
                                : Colors.transparent,
                            Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 8.0, 24.0, 8.0),
                          child: Container(
                            child: Text(
                              valueOrDefault<String>(
                                widget.label3,
                                'Guest',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.sourceSans3(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: valueOrDefault<Color>(
                                      valueOrDefault<String>(
                                                widget.activeTab,
                                                'signup',
                                              ) ==
                                              'guest'
                                          ? FlutterFlowTheme.of(context)
                                              .onPrimary
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
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
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.0,
                      height: 3.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(9999.0),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
