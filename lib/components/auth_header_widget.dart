import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_header_model.dart';
export 'auth_header_model.dart';

class AuthHeaderWidget extends StatefulWidget {
  const AuthHeaderWidget({
    super.key,
    String? subtitle,
    String? title,
  })  : this.subtitle = subtitle ?? 'Campus navigation made simple',
        this.title = title ?? 'Rhody Maps';

  final String subtitle;
  final String title;

  @override
  State<AuthHeaderWidget> createState() => _AuthHeaderWidgetState();
}

class _AuthHeaderWidgetState extends State<AuthHeaderWidget> {
  late AuthHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthHeaderModel());

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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary10,
            borderRadius: BorderRadius.circular(16.0),
            shape: BoxShape.rectangle,
          ),
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Icon(
            Icons.map_outlined,
            color: FlutterFlowTheme.of(context).primary,
            size: 48.0,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valueOrDefault<String>(
                widget.title,
                'Rhody Maps',
              ),
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).headlineLarge.override(
                    font: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                    lineHeight: 1.2,
                  ),
            ),
            Text(
              valueOrDefault<String>(
                widget.subtitle,
                'Campus navigation made simple',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.sourceSans3(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    lineHeight: 1.7,
                  ),
            ),
          ].divide(SizedBox(height: 4.0)),
        ),
      ].divide(SizedBox(height: 16.0)),
    );
  }
}
