import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'report_option_model.dart';
export 'report_option_model.dart';

class ReportOptionWidget extends StatefulWidget {
  const ReportOptionWidget({
    super.key,
    this.icon,
    String? subtitle,
    String? title,
    bool? selected,
    required this.onTapCallback,
  })  : this.subtitle = subtitle ?? 'Sidewalk or road blocked by equipment',
        this.title = title ?? 'Construction',
        this.selected = selected ?? true;

  final Widget? icon;
  final String subtitle;
  final String title;
  final bool selected;
  final Future Function()? onTapCallback;

  @override
  State<ReportOptionWidget> createState() => _ReportOptionWidgetState();
}

class _ReportOptionWidgetState extends State<ReportOptionWidget> {
  late ReportOptionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportOptionModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        logFirebaseEvent('REPORT_OPTION_COMP_Container_ON_TAP');
        logFirebaseEvent('Container_execute_callback');
        await widget.onTapCallback?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget.selected,
              true,
            )
                ? FlutterFlowTheme.of(context).primary10
                : FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context).primary10,
          ),
          borderRadius: BorderRadius.circular(6.0),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: valueOrDefault<Color>(
              valueOrDefault<bool>(
                widget.selected,
                true,
              )
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              FlutterFlowTheme.of(context).primary,
            ),
            width: valueOrDefault<double>(
              valueOrDefault<bool>(
                widget.selected,
                true,
              )
                  ? 1.0
                  : 1.0,
              1.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: valueOrDefault<Color>(
                      valueOrDefault<bool>(
                        widget.selected,
                        true,
                      )
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      FlutterFlowTheme.of(context).primary,
                    ),
                    borderRadius: BorderRadius.circular(9999.0),
                    shape: BoxShape.rectangle,
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: widget.icon!,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          widget.title,
                          'Construction',
                        ),
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                              lineHeight: 1.7,
                            ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          widget.subtitle,
                          'Sidewalk or road blocked by equipment',
                        ),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.sourceSans3(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                              lineHeight: 1.6,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
                Container(
                  width: 20.0,
                  height: 20.0,
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    children: [
                      if (valueOrDefault<bool>(
                        valueOrDefault<bool>(
                          widget.selected,
                          true,
                        )
                            ? true
                            : false,
                        true,
                      ))
                        Icon(
                          Icons.check_circle_rounded,
                          color: valueOrDefault<Color>(
                            valueOrDefault<bool>(
                              widget.selected,
                              true,
                            )
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).alternate,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          size: 20.0,
                        ),
                      if (valueOrDefault<bool>(
                        valueOrDefault<bool>(
                          widget.selected,
                          true,
                        )
                            ? false
                            : true,
                        false,
                      ))
                        Icon(
                          Icons.radio_button_unchecked_rounded,
                          color: valueOrDefault<Color>(
                            valueOrDefault<bool>(
                              widget.selected,
                              true,
                            )
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).alternate,
                            FlutterFlowTheme.of(context).primary,
                          ),
                          size: 20.0,
                        ),
                    ],
                  ),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
