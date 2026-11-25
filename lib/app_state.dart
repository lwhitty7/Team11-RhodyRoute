import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import '/backend/backend.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  LatLng? _mapCenter = LatLng(41.485578, -71.533818);
  LatLng? get mapCenter => _mapCenter;
  set mapCenter(LatLng? value) {
    _mapCenter = value;
  }

  String _layerStyle = 'Roadmap';
  String get layerStyle => _layerStyle;
  set layerStyle(String value) {
    _layerStyle = value;
  }

  int _CurrentZome = 17;
  int get CurrentZome => _CurrentZome;
  set CurrentZome(int value) {
    _CurrentZome = value;
  }

  List<LatLng> _routePoints = [];
  List<LatLng> get routePoints => _routePoints;
  set routePoints(List<LatLng> value) {
    _routePoints = value;
  }

  void addToRoutePoints(LatLng value) {
    routePoints.add(value);
  }

  void removeFromRoutePoints(LatLng value) {
    routePoints.remove(value);
  }

  void removeAtIndexFromRoutePoints(int index) {
    routePoints.removeAt(index);
  }

  void updateRoutePointsAtIndex(
    int index,
    LatLng Function(LatLng) updateFn,
  ) {
    routePoints[index] = updateFn(_routePoints[index]);
  }

  void insertAtIndexInRoutePoints(int index, LatLng value) {
    routePoints.insert(index, value);
  }

  List<LatLng> _activeHazards = [];
  List<LatLng> get activeHazards => _activeHazards;
  set activeHazards(List<LatLng> value) {
    _activeHazards = value;
  }

  void addToActiveHazards(LatLng value) {
    activeHazards.add(value);
  }

  void removeFromActiveHazards(LatLng value) {
    activeHazards.remove(value);
  }

  void removeAtIndexFromActiveHazards(int index) {
    activeHazards.removeAt(index);
  }

  void updateActiveHazardsAtIndex(
    int index,
    LatLng Function(LatLng) updateFn,
  ) {
    activeHazards[index] = updateFn(_activeHazards[index]);
  }

  void insertAtIndexInActiveHazards(int index, LatLng value) {
    activeHazards.insert(index, value);
  }

  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;
  set isNavigating(bool value) {
    _isNavigating = value;
  }

  bool _hasNavigationLocation = false;
  bool get hasNavigationLocation => _hasNavigationLocation;
  set hasNavigationLocation(bool value) {
    _hasNavigationLocation = value;
  }

  LatLng? _navigationLocation = LatLng(0, 0);
  LatLng? get navigationLocation => _navigationLocation;
  set navigationLocation(LatLng? value) {
    _navigationLocation = value;
  }

  double _remainingDistanceMeters = 0.0;
  double get remainingDistanceMeters => _remainingDistanceMeters;
  set remainingDistanceMeters(double value) {
    _remainingDistanceMeters = value;
  }

  int _remainingEtaMinutes = 0;
  int get remainingEtaMinutes => _remainingEtaMinutes;
  set remainingEtaMinutes(int value) {
    _remainingEtaMinutes = value;
  }

  LatLng? _lockedDestination = LatLng(0, 0);
  LatLng? get lockedDestination => _lockedDestination;
  set lockedDestination(LatLng? value) {
    _lockedDestination = value;
  }

  bool _isFollowingUser = false;
  bool get isFollowingUser => _isFollowingUser;
  set isFollowingUser(bool value) {
    _isFollowingUser = value;
  }

  bool _isRerouting = false;
  bool get isRerouting => _isRerouting;
  set isRerouting(bool value) {
    _isRerouting = value;
  }

  String _lockedDestinationQuery = '';
  String get lockedDestinationQuery => _lockedDestinationQuery;
  set lockedDestinationQuery(String value) {
    _lockedDestinationQuery = value;
  }
}
