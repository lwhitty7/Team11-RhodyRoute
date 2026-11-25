import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/auth_header_widget.dart';
import '/components/button_widget.dart';
import '/components/text_field_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_and_login_real_model.dart';
export 'sign_up_and_login_real_model.dart';

class SignUpAndLoginRealWidget extends StatefulWidget {
  const SignUpAndLoginRealWidget({super.key});

  static String routeName = 'SignUpAndLoginReal';
  static String routePath = '/signUpAndLoginReal';

  @override
  State<SignUpAndLoginRealWidget> createState() =>
      _SignUpAndLoginRealWidgetState();
}

class _SignUpAndLoginRealWidgetState extends State<SignUpAndLoginRealWidget>
    with TickerProviderStateMixin {
  late SignUpAndLoginRealModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpAndLoginRealModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'SignUpAndLoginReal'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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
        body: SafeArea(
          left: false,
          top: false,
          right: false,
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 40.0,
                            ),
                            wrapWithModel(
                              model: _model.authHeaderModel,
                              updateCallback: () => safeSetState(() {}),
                              child: AuthHeaderWidget(
                                subtitle: 'Campus navigation made simple',
                                title: 'Rhody Maps',
                              ),
                            ),
                            Container(
                              height: 48.0,
                            ),
                            Container(
                              width: 100.0,
                              height: 489.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment(0.0, 0),
                                    child: TabBar(
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.sourceSans3(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                      unselectedLabelStyle: FlutterFlowTheme.of(
                                              context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.sourceSans3(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                      indicatorColor: Color(0xFF959FAE),
                                      tabs: [
                                        Tab(
                                          text: 'Log In',
                                        ),
                                        Tab(
                                          text: 'Sign Up',
                                        ),
                                        Tab(
                                          text: getRemoteConfigBool(
                                                  'show_guest_login')
                                              ? 'Guest'
                                              : '',
                                        ),
                                      ],
                                      controller: _model.tabBarController,
                                      onTap: (i) async {
                                        [
                                          () async {},
                                          () async {},
                                          () async {}
                                        ][i]();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _model.tabBarController,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 30.0, 0.0, 0.0),
                                                  child: wrapWithModel(
                                                    model:
                                                        _model.emailLogInModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TextFieldWidget(
                                                      label: 'University Email',
                                                      labelPresent: true,
                                                      helper: '',
                                                      helperPresent: false,
                                                      leadingIcon: Icon(
                                                        Icons.email_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      leadingIconPresent: true,
                                                      trailingIconPresent:
                                                          false,
                                                      hint: ' student@uri.edu',
                                                      value: '',
                                                      onChange: '',
                                                      onSubmit: '',
                                                      variant: 'outlined',
                                                      error: false,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    wrapWithModel(
                                                      model: _model
                                                          .passwordLogInModel,
                                                      updateCallback: () =>
                                                          safeSetState(() {}),
                                                      child: TextFieldWidget(
                                                        label: 'Password',
                                                        labelPresent: true,
                                                        helper: '',
                                                        helperPresent: false,
                                                        leadingIcon: Icon(
                                                          Icons.lock_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 24.0,
                                                        ),
                                                        leadingIconPresent:
                                                            true,
                                                        trailingIconPresent:
                                                            false,
                                                        hint: '••••••••',
                                                        value: '',
                                                        onChange: '',
                                                        onSubmit: '',
                                                        variant: 'outlined',
                                                        error: false,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        wrapWithModel(
                                                          model: _model
                                                              .buttonModel1,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child: ButtonWidget(
                                                            iconPresent: false,
                                                            iconEndPresent:
                                                                false,
                                                            content:
                                                                'Forgot Password?',
                                                            variant: 'ghost',
                                                            size: 'small',
                                                            fullWidth: false,
                                                            loading: false,
                                                            disabled: false,
                                                            onTapAction:
                                                                () async {},
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 4.0)),
                                                ),
                                              ].divide(SizedBox(height: 24.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'SIGN_UP_AND_LOGIN_REAL_Button_ON_TAP');
                                                    logFirebaseEvent(
                                                        'Button_google_analytics_event');
                                                    logFirebaseEvent(
                                                      'login',
                                                      parameters: {
                                                        'Param 1':
                                                            'loginButton',
                                                      },
                                                    );
                                                  },
                                                  child: wrapWithModel(
                                                    model: _model.buttonModel2,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: ButtonWidget(
                                                      iconPresent: false,
                                                      iconEndPresent: false,
                                                      content: 'Sign In',
                                                      variant: 'primary',
                                                      size: 'medium',
                                                      fullWidth: true,
                                                      loading: false,
                                                      disabled: false,
                                                      onTapAction: () async {
                                                        logFirebaseEvent(
                                                            'SIGN_UP_AND_LOGIN_REAL_Button_CALLBACK');
                                                        if (functions
                                                            .checkDomain(_model
                                                                .emailLogInModel
                                                                .inputTextController
                                                                .text)) {
                                                          logFirebaseEvent(
                                                              'Button_auth');
                                                          GoRouter.of(context)
                                                              .prepareAuthEvent();

                                                          final user =
                                                              await authManager
                                                                  .signInWithEmail(
                                                            context,
                                                            _model
                                                                .emailLogInModel
                                                                .inputTextController
                                                                .text,
                                                            _model
                                                                .passwordLogInModel
                                                                .inputTextController
                                                                .text,
                                                          );
                                                          if (user == null) {
                                                            return;
                                                          }

                                                          logFirebaseEvent(
                                                              'Button_backend_call');

                                                          await currentUserReference!
                                                              .update({
                                                            ...mapToFirestore(
                                                              {
                                                                'login_Counter':
                                                                    FieldValue
                                                                        .increment(
                                                                            1),
                                                              },
                                                            ),
                                                          });
                                                          if ((valueOrDefault(
                                                                      currentUserDocument
                                                                          ?.loginCounter,
                                                                      0) >=
                                                                  1) &&
                                                              !valueOrDefault<
                                                                  bool>(
                                                                valueOrDefault<
                                                                        bool>(
                                                                    currentUserDocument
                                                                        ?.nPSSurveyCompletion,
                                                                    false),
                                                                false,
                                                              )) {
                                                            logFirebaseEvent(
                                                                'Button_navigate_to');

                                                            context.pushNamedAuth(
                                                                UserSatisfactionSurveryWidget
                                                                    .routeName,
                                                                context
                                                                    .mounted);
                                                          } else {
                                                            logFirebaseEvent(
                                                                'Button_navigate_to');

                                                            context.pushNamedAuth(
                                                                CampusInteractiveMapWidget
                                                                    .routeName,
                                                                context
                                                                    .mounted);
                                                          }
                                                        } else {
                                                          logFirebaseEvent(
                                                              'Button_show_snack_bar');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Invalid Login',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                            ),
                                                          );
                                                          return;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Divider(
                                                        height: 16.0,
                                                        thickness: 1.0,
                                                        indent: 0.0,
                                                        endIndent: 0.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                    Text(
                                                      'or',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .sourceSans3(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .fontStyle,
                                                                lineHeight: 1.4,
                                                              ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Divider(
                                                        height: 16.0,
                                                        thickness: 1.0,
                                                        indent: 0.0,
                                                        endIndent: 0.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 16.0)),
                                                ),
                                                wrapWithModel(
                                                  model: _model.buttonModel3,
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child: ButtonWidget(
                                                    icon: Icon(
                                                      Icons.school_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 24.0,
                                                    ),
                                                    iconPresent: true,
                                                    iconEndPresent: false,
                                                    content:
                                                        'Continue with SSO',
                                                    variant: 'outline',
                                                    size: 'medium',
                                                    fullWidth: true,
                                                    loading: false,
                                                    disabled: false,
                                                    onTapAction: () async {},
                                                  ),
                                                ),
                                                Container(
                                                  height: 40.0,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ].divide(SizedBox(height: 16.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'By continuing, you agree to our',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .sourceSans3(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                        lineHeight: 1.4,
                                                      ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        (FFMainAxisAlignment
                                                                .start)
                                                            .flutterValue,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Terms of Service',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .sourceSans3(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  lineHeight:
                                                                      1.4,
                                                                ),
                                                      ),
                                                      Text(
                                                        '&',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .sourceSans3(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                  lineHeight:
                                                                      1.4,
                                                                ),
                                                      ),
                                                      Text(
                                                        'Privacy Policy',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .sourceSans3(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  lineHeight:
                                                                      1.4,
                                                                ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 4.0)),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 8.0)),
                                            ),
                                          ],
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  wrapWithModel(
                                                    model: _model
                                                        .signupFullNameFieldModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TextFieldWidget(
                                                      label: 'Full Name',
                                                      labelPresent: true,
                                                      helper: '',
                                                      helperPresent: false,
                                                      leadingIcon: Icon(
                                                        Icons
                                                            .person_outline_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      leadingIconPresent: true,
                                                      trailingIconPresent:
                                                          false,
                                                      hint: 'Alex Rivera',
                                                      value: '',
                                                      onChange: '',
                                                      onSubmit: '',
                                                      variant: 'outlined',
                                                      error: false,
                                                    ),
                                                  ),
                                                  wrapWithModel(
                                                    model: _model
                                                        .signupEmailFieldModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TextFieldWidget(
                                                      label: 'University Email',
                                                      labelPresent: true,
                                                      helper: '',
                                                      helperPresent: false,
                                                      leadingIcon: Icon(
                                                        Icons.help,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      leadingIconPresent: true,
                                                      trailingIconPresent:
                                                          false,
                                                      hint: 'student@uri.edu',
                                                      value: '',
                                                      onChange: '',
                                                      onSubmit: '',
                                                      variant: 'outlined',
                                                      error: false,
                                                    ),
                                                  ),
                                                  wrapWithModel(
                                                    model: _model
                                                        .signupPasswordFieldModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TextFieldWidget(
                                                      label: 'Password',
                                                      labelPresent: true,
                                                      helper: '',
                                                      helperPresent: false,
                                                      leadingIcon: Icon(
                                                        Icons
                                                            .lock_outline_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      leadingIconPresent: true,
                                                      trailingIconPresent:
                                                          false,
                                                      hint: '••••••••',
                                                      value: '',
                                                      onChange: '',
                                                      onSubmit: '',
                                                      variant: 'outlined',
                                                      error: false,
                                                    ),
                                                  ),
                                                  wrapWithModel(
                                                    model: _model
                                                        .signupConfirmPasswordFieldModel,
                                                    updateCallback: () =>
                                                        safeSetState(() {}),
                                                    child: TextFieldWidget(
                                                      label: 'Confirm Password',
                                                      labelPresent: true,
                                                      helper: '',
                                                      helperPresent: false,
                                                      leadingIcon: Icon(
                                                        Icons
                                                            .lock_reset_rounded,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 24.0,
                                                      ),
                                                      leadingIconPresent: true,
                                                      trailingIconPresent:
                                                          false,
                                                      hint: '••••••••',
                                                      value: '',
                                                      onChange: '',
                                                      onSubmit: '',
                                                      variant: 'outlined',
                                                      error: false,
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 19.0)),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 32.0, 0.0, 0.0),
                                                child: SingleChildScrollView(
                                                  primary: false,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          logFirebaseEvent(
                                                              'SIGN_UP_AND_LOGIN_REAL_Button_ON_TAP');
                                                          logFirebaseEvent(
                                                              'Button_google_analytics_event');
                                                          logFirebaseEvent(
                                                            'signup',
                                                            parameters: {
                                                              'Param 1':
                                                                  'signupButton',
                                                            },
                                                          );
                                                        },
                                                        child: wrapWithModel(
                                                          model: _model
                                                              .buttonModel4,
                                                          updateCallback: () =>
                                                              safeSetState(
                                                                  () {}),
                                                          child: ButtonWidget(
                                                            iconPresent: false,
                                                            iconEndPresent:
                                                                false,
                                                            content:
                                                                'Create Account',
                                                            variant: 'primary',
                                                            size: 'medium',
                                                            fullWidth: true,
                                                            loading: false,
                                                            disabled: false,
                                                            onTapAction:
                                                                () async {
                                                              logFirebaseEvent(
                                                                  'SIGN_UP_AND_LOGIN_REAL_Button_CALLBACK');
                                                              if (functions
                                                                  .checkDomain(
                                                                      valueOrDefault<
                                                                          String>(
                                                                _model
                                                                    .signupEmailFieldModel
                                                                    .inputTextController
                                                                    .text,
                                                                'none',
                                                              ))) {
                                                                logFirebaseEvent(
                                                                    'Button_auth');
                                                                GoRouter.of(
                                                                        context)
                                                                    .prepareAuthEvent();
                                                                if (_model
                                                                        .signupPasswordFieldModel
                                                                        .inputTextController
                                                                        .text !=
                                                                    _model
                                                                        .signupConfirmPasswordFieldModel
                                                                        .inputTextController
                                                                        .text) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        'Passwords don\'t match!',
                                                                      ),
                                                                    ),
                                                                  );
                                                                  return;
                                                                }

                                                                final user =
                                                                    await authManager
                                                                        .createAccountWithEmail(
                                                                  context,
                                                                  _model
                                                                      .signupEmailFieldModel
                                                                      .inputTextController
                                                                      .text,
                                                                  _model
                                                                      .signupPasswordFieldModel
                                                                      .inputTextController
                                                                      .text,
                                                                );
                                                                if (user ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                logFirebaseEvent(
                                                                    'Button_navigate_to');

                                                                context.pushNamedAuth(
                                                                    ProfileCreationWidget
                                                                        .routeName,
                                                                    context
                                                                        .mounted);
                                                              } else {
                                                                logFirebaseEvent(
                                                                    'Button_show_snack_bar');
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Invalid Email',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                  ),
                                                                );
                                                                return;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 16.0)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              (FFMainAxisAlignment.start)
                                                  .flutterValue,
                                          children: [
                                            if (getRemoteConfigBool(
                                                'show_guest_login'))
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 30.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'SIGN_UP_AND_LOGIN_REAL_Button_ON_TAP');
                                                        logFirebaseEvent(
                                                            'Button_google_analytics_event');
                                                        logFirebaseEvent(
                                                          'guest',
                                                          parameters: {
                                                            'Param 1':
                                                                'guestButton',
                                                          },
                                                        );
                                                      },
                                                      child: wrapWithModel(
                                                        model:
                                                            _model.buttonModel5,
                                                        updateCallback: () =>
                                                            safeSetState(() {}),
                                                        child: ButtonWidget(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_forward_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 24.0,
                                                          ),
                                                          iconPresent: true,
                                                          iconEndPresent: false,
                                                          content:
                                                              'Continue as Guest',
                                                          variant: 'primary',
                                                          size: 'large',
                                                          fullWidth: true,
                                                          loading: false,
                                                          disabled: false,
                                                          onTapAction:
                                                              () async {
                                                            logFirebaseEvent(
                                                                'SIGN_UP_AND_LOGIN_REAL_Button_CALLBACK');
                                                            logFirebaseEvent(
                                                                'Button_auth');
                                                            GoRouter.of(context)
                                                                .prepareAuthEvent();
                                                            final user =
                                                                await authManager
                                                                    .signInAnonymously(
                                                                        context);
                                                            if (user == null) {
                                                              return;
                                                            }

                                                            context.goNamedAuth(
                                                                CampusInteractiveMapWidget
                                                                    .routeName,
                                                                context
                                                                    .mounted);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  24.0),
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .info_outline_rounded,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: 20.0,
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'Guest Access',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              font: GoogleFonts.sourceSans3(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                              lineHeight: 1.3,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        'View the campus map and real-time shuttle routes instantly. Sign in to save your class schedule or report campus hazards.',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .override(
                                                                              font: GoogleFonts.sourceSans3(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                              lineHeight: 1.6,
                                                                            ),
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        height:
                                                                            4.0)),
                                                                  ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 16.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 16.0)),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
