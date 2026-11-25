import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nps_score_button_model.dart';
export 'nps_score_button_model.dart';

class NpsScoreButtonWidget extends StatefulWidget {
  const NpsScoreButtonWidget({
    super.key,
    String? score,
    bool? selected,
  })  : this.score = score ?? '0',
        this.selected = selected ?? false;

  final String score;
  final bool selected;

  @override
  State<NpsScoreButtonWidget> createState() => _NpsScoreButtonWidgetState();
}

class _NpsScoreButtonWidgetState extends State<NpsScoreButtonWidget> {
  late NpsScoreButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NpsScoreButtonModel());

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
      width: 36.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget.selected,
            false,
          )
              ? FlutterFlowTheme.of(context).primary
              : Color(0xFFE1DBD1),
          Color(0xFFE1DBD1),
        ),
        borderRadius: BorderRadius.circular(6.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget.selected,
              false,
            )
                ? FlutterFlowTheme.of(context).primary
                : Color(0x3374777F),
            Color(0x3374777F),
          ),
          width: valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.selected,
              false,
            )
                ? 1.0
                : 1.0,
            1.0,
          ),
        ),
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Text(
        valueOrDefault<String>(
          '${widget.score}',
          '0',
        ),
        style: FlutterFlowTheme.of(context).labelLarge.override(
              font: GoogleFonts.sourceSans3(
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
              color: valueOrDefault<Color>(
                valueOrDefault<bool>(
                  widget.selected,
                  false,
                )
                    ? Colors.white
                    : FlutterFlowTheme.of(context).primaryText,
                FlutterFlowTheme.of(context).primaryText,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              lineHeight: 1.4,
            ),
      ),
    );
  }
}
