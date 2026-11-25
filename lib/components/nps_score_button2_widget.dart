import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nps_score_button2_model.dart';
export 'nps_score_button2_model.dart';

class NpsScoreButton2Widget extends StatefulWidget {
  const NpsScoreButton2Widget({
    super.key,
    String? score,
    bool? selected,
    this.onTapTap,
  })  : this.score = score ?? '0',
        this.selected = selected ?? false;

  final String score;
  final bool selected;
  final Future Function()? onTapTap;

  @override
  State<NpsScoreButton2Widget> createState() => _NpsScoreButton2WidgetState();
}

class _NpsScoreButton2WidgetState extends State<NpsScoreButton2Widget> {
  late NpsScoreButton2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NpsScoreButton2Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FFButtonWidget(
          onPressed: () async {
            logFirebaseEvent('NPS_SCORE_BUTTON2_COMP_BUTTON_BTN_ON_TAP');
            logFirebaseEvent('Button_execute_callback');
            await widget.onTapTap?.call();
          },
          text: valueOrDefault<String>(
            '${widget.score}',
            '0',
          ),
          options: FFButtonOptions(
            height: 40.0,
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: valueOrDefault<Color>(
              widget.onTapTap != null
                  ? Color(0xFF4485EA)
                  : FlutterFlowTheme.of(context).secondary,
              Color(0xFFE1DBD1),
            ),
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.sourceSans3(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  color: valueOrDefault<Color>(
                    valueOrDefault<bool>(
                      widget.selected,
                      false,
                    )
                        ? Colors.white
                        : FlutterFlowTheme.of(context).accent1,
                    FlutterFlowTheme.of(context).primaryText,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    );
  }
}
