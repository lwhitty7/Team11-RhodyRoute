import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'app_navigation_model.dart';
export 'app_navigation_model.dart';

class AppNavigationWidget extends StatefulWidget {
  const AppNavigationWidget({
    super.key,
    String? activeTab,
  }) : this.activeTab = activeTab ?? 'map';

  final String activeTab;

  @override
  State<AppNavigationWidget> createState() => _AppNavigationWidgetState();
}

class _AppNavigationWidgetState extends State<AppNavigationWidget> {
  late AppNavigationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppNavigationModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
