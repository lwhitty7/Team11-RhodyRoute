import '/components/app_navigation_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'shuttle_tracker_model.dart';
export 'shuttle_tracker_model.dart';

class ShuttleTrackerWidget extends StatefulWidget {
  const ShuttleTrackerWidget({super.key});

  static String routeName = 'ShuttleTracker';
  static String routePath = '/shuttleTracker';

  @override
  State<ShuttleTrackerWidget> createState() => _ShuttleTrackerWidgetState();
}

class _ShuttleTrackerWidgetState extends State<ShuttleTrackerWidget> {
  late ShuttleTrackerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShuttleTrackerModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ShuttleTracker'});
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
        body: Stack(
          alignment: AlignmentDirectional(-1.0, -1.0),
          children: [
            FlutterFlowWebView(
              content: 'https://uri.transloc.com/routes',
              bypass: false,
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: 800.0,
              verticalScroll: false,
              horizontalScroll: false,
            ),
            if (false == true)
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: PointerInterceptor(
                  intercepting: isWeb,
                  child: Container(
                    child: wrapWithModel(
                      model: _model.appNavigationModel,
                      updateCallback: () => safeSetState(() {}),
                      child: AppNavigationWidget(
                        activeTab: 'shuttles',
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
