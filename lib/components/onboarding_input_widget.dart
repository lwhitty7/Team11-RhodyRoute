import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_input_model.dart';
export 'onboarding_input_model.dart';

class OnboardingInputWidget extends StatefulWidget {
  const OnboardingInputWidget({
    super.key,
    String? hint,
    String? icon,
    String? label,
  })  : this.hint = hint ?? 'Enter your name',
        this.icon = icon ?? 'person_outline_rounded',
        this.label = label ?? 'Full Name';

  final String hint;
  final String icon;
  final String label;

  @override
  State<OnboardingInputWidget> createState() => _OnboardingInputWidgetState();
}

class _OnboardingInputWidgetState extends State<OnboardingInputWidget> {
  late OnboardingInputModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingInputModel());

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          valueOrDefault<String>(
            widget.label,
            'Full Name',
          ),
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.sourceSans3(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                lineHeight: 1.4,
              ),
        ),
        wrapWithModel(
          model: _model.textFieldModel,
          updateCallback: () => safeSetState(() {}),
          updateOnChange: true,
          child: TextFieldWidget(
            label: '',
            labelPresent: false,
            helper: '',
            helperPresent: false,
            leadingIcon: Icon(
              Icons.person_outline_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            leadingIconPresent: false,
            trailingIconPresent: false,
            hint: valueOrDefault<String>(
              widget.hint,
              'Enter your name',
            ),
            value: '',
            onChange: '',
            onSubmit: '',
            variant: 'outlined',
            error: false,
          ),
        ),
      ].divide(SizedBox(height: 4.0)),
    );
  }
}
