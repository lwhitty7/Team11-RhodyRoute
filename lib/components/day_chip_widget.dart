import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'day_chip_model.dart';
export 'day_chip_model.dart';

class DayChipWidget extends StatefulWidget {
  const DayChipWidget({
    super.key,
    String? label,
    bool? active,
  })  : this.label = label ?? 'M',
        this.active = active ?? true;

  final String label;
  final bool active;

  @override
  State<DayChipWidget> createState() => _DayChipWidgetState();
}

class _DayChipWidgetState extends State<DayChipWidget> {
  late DayChipModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DayChipModel());

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
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          valueOrDefault<bool>(
            widget.active,
            true,
          )
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          FlutterFlowTheme.of(context).primary,
        ),
        borderRadius: BorderRadius.circular(6.0),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: valueOrDefault<Color>(
            valueOrDefault<bool>(
              widget.active,
              true,
            )
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            FlutterFlowTheme.of(context).primary,
          ),
          width: valueOrDefault<double>(
            valueOrDefault<bool>(
              widget.active,
              true,
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
          widget.label,
          'M',
        ),
        style: FlutterFlowTheme.of(context).labelLarge.override(
              font: GoogleFonts.sourceSans3(
                fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
              ),
              color: valueOrDefault<Color>(
                valueOrDefault<bool>(
                  widget.active,
                  true,
                )
                    ? FlutterFlowTheme.of(context).onPrimary
                    : FlutterFlowTheme.of(context).primaryText,
                FlutterFlowTheme.of(context).onPrimary,
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
