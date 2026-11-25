// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!

import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import '/app_state.dart';
import '/flutter_flow/lat_lng.dart';

class _RouteProjection {
  final LatLng point;
  final int segmentIndex;
  final double distanceMeters;

  const _RouteProjection({
    required this.point,
    required this.segmentIndex,
    required this.distanceMeters,
  });
}

class CampusLocationTracker extends StatefulWidget {
  const CampusLocationTracker({
    super.key,
    this.width,
    this.height,
    required this.enabled,
  });

  final double? width;
  final double? height;
  final bool enabled;

  @override
  State<CampusLocationTracker> createState() => _CampusLocationTrackerState();
}

class _CampusLocationTrackerState extends State<CampusLocationTracker>
    with WidgetsBindingObserver {
  StreamSubscription<Position>? _positionSubscription;

  bool _starting = false;
  bool _rerouting = false;
  bool _arrivalHandled = false;
  bool _navigationInitialized = false;

  int _offRouteFixCount = 0;
  DateTime? _lastRerouteAt;

  static const double walkingSpeedMps = 1.34112;
  static const double arrivalRadiusMeters = 18.0;
  static const double maximumGpsAccuracyMeters = 35.0;
  static const double offRouteMinimumAccuracyMeters = 20.0;

  static const int offRouteFixesBeforeReroute = 3;
  static const Duration rerouteCooldown = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (widget.enabled) {
      _startTracking();
    }
  }

  @override
  void didUpdateWidget(covariant CampusLocationTracker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled && !oldWidget.enabled) {
      _startTracking();
    } else if (!widget.enabled && oldWidget.enabled) {
      _stopTracking();
      _navigationInitialized = false;

      FFAppState().update(() {
        FFAppState().isFollowingUser = false;
        FFAppState().isRerouting = false;
      });
    }
  }

  double _distanceMeters(LatLng a, LatLng b) {
    const earthRadius = 6371008.8;

    double radians(double degrees) => degrees * math.pi / 180.0;

    final lat1 = radians(a.latitude);
    final lat2 = radians(b.latitude);
    final dLat = lat2 - lat1;
    final dLng = radians(b.longitude - a.longitude);

    final sinLat = math.sin(dLat / 2);
    final sinLng = math.sin(dLng / 2);

    final h =
        (sinLat * sinLat + math.cos(lat1) * math.cos(lat2) * sinLng * sinLng)
            .clamp(0.0, 1.0)
            .toDouble();

    return 2 * earthRadius * math.atan2(math.sqrt(h), math.sqrt(1.0 - h));
  }

  double _routeLengthMeters(List<LatLng> route) {
    double total = 0.0;

    for (int i = 1; i < route.length; i++) {
      total += _distanceMeters(route[i - 1], route[i]);
    }

    return total;
  }

  _RouteProjection? _nearestProjection(
    LatLng location,
    List<LatLng> route,
  ) {
    if (route.length < 2) return null;

    const metersPerDegreeLat = 111320.0;

    final metersPerDegreeLng =
        111320.0 * math.cos(location.latitude * math.pi / 180.0);

    _RouteProjection? best;

    for (int i = 0; i < route.length - 1; i++) {
      final a = route[i];
      final b = route[i + 1];

      final dx = (b.longitude - a.longitude) * metersPerDegreeLng;

      final dy = (b.latitude - a.latitude) * metersPerDegreeLat;

      final px = (location.longitude - a.longitude) * metersPerDegreeLng;

      final py = (location.latitude - a.latitude) * metersPerDegreeLat;

      final lengthSquared = dx * dx + dy * dy;

      if (lengthSquared < 0.0001) continue;

      final t =
          ((px * dx + py * dy) / lengthSquared).clamp(0.0, 1.0).toDouble();

      final projected = LatLng(
        a.latitude + t * (b.latitude - a.latitude),
        a.longitude + t * (b.longitude - a.longitude),
      );

      final errorX =
          (location.longitude - projected.longitude) * metersPerDegreeLng;

      final errorY =
          (location.latitude - projected.latitude) * metersPerDegreeLat;

      final distance = math.sqrt(
        errorX * errorX + errorY * errorY,
      );

      if (best == null || distance < best.distanceMeters) {
        best = _RouteProjection(
          point: projected,
          segmentIndex: i,
          distanceMeters: distance,
        );
      }
    }

    return best;
  }

  List<LatLng> _getRemainingRoute(
    List<LatLng> route,
    _RouteProjection projection,
  ) {
    final remaining = <LatLng>[projection.point];

    for (int i = projection.segmentIndex + 1; i < route.length; i++) {
      final point = route[i];

      if (_distanceMeters(remaining.last, point) > 0.5) {
        remaining.add(point);
      }
    }

    return remaining;
  }

  Future<void> _startTracking() async {
    if (_positionSubscription != null || _starting) return;

    _starting = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage('Please enable location services.');
        _handleTrackingFailure();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Location permission is required to show your location.');
        _handleTrackingFailure();
        return;
      }

      if (!mounted || !widget.enabled) return;

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        _handlePosition,
        onError: (error) {
          debugPrint('Campus GPS error: $error');
        },
      );
    } catch (e) {
      debugPrint('GPS startup error: $e');
      _handleTrackingFailure();
      _showMessage('Unable to start GPS tracking.');
    } finally {
      _starting = false;
    }
  }

  void _handlePosition(Position position) {
    if (!mounted || !widget.enabled) return;

    if (!position.latitude.isFinite || !position.longitude.isFinite) {
      return;
    }

    final location = LatLng(
      position.latitude,
      position.longitude,
    );

    // GPS and the map location marker remain active outside navigation.
    FFAppState().update(() {
      FFAppState().navigationLocation = location;
      FFAppState().hasNavigationLocation = true;
    });

    // Reset navigation-only state when the user ends navigation.
    if (!FFAppState().isNavigating) {
      _navigationInitialized = false;
      _arrivalHandled = false;
      _offRouteFixCount = 0;
      return;
    }

    if (_arrivalHandled) return;

    final route = List<LatLng>.from(FFAppState().routePoints);
    if (route.length < 2) return;

    // Initialize each new navigation session without restarting GPS.
    if (!_navigationInitialized) {
      final destination = FFAppState().lockedDestination ?? route.last;
      final initialDistance = _routeLengthMeters(route);

      _arrivalHandled = false;
      _offRouteFixCount = 0;
      _lastRerouteAt = null;
      _navigationInitialized = true;

      FFAppState().update(() {
        FFAppState().lockedDestination = destination;
        FFAppState().remainingDistanceMeters = initialDistance;
        FFAppState().remainingEtaMinutes =
            (initialDistance / walkingSpeedMps / 60).ceil();
        FFAppState().isFollowingUser = true;
      });
    }

    if (!position.accuracy.isFinite ||
        position.accuracy > maximumGpsAccuracyMeters) {
      return;
    }

    final destination = FFAppState().lockedDestination ?? route.last;
    final destinationDistance = _distanceMeters(location, destination);

    if (destinationDistance <= arrivalRadiusMeters) {
      _finishNavigation();
      return;
    }

    final projection = _nearestProjection(location, route);
    if (projection == null) return;

    final snapTolerance =
        (position.accuracy * 1.5).clamp(15.0, 30.0).toDouble();

    if (projection.distanceMeters > snapTolerance) {
      if (position.accuracy <= offRouteMinimumAccuracyMeters) {
        _offRouteFixCount++;
        if (_offRouteFixCount >= offRouteFixesBeforeReroute) {
          unawaited(_rerouteFrom(location, destination));
        }
      }
      return;
    }

    _offRouteFixCount = 0;
    final remainingRoute = _getRemainingRoute(route, projection);
    if (remainingRoute.length < 2) return;

    final remainingDistance = _routeLengthMeters(remainingRoute);
    final remainingEta = (remainingDistance / walkingSpeedMps / 60).ceil();

    FFAppState().update(() {
      FFAppState().routePoints = remainingRoute;
      FFAppState().remainingDistanceMeters = remainingDistance;
      FFAppState().remainingEtaMinutes = remainingEta;
    });
  }

  Future<void> _rerouteFrom(
    LatLng currentLocation,
    LatLng lockedEntrance,
  ) async {
    if (_rerouting || !mounted || !widget.enabled || !FFAppState().isNavigating)
      return;

    final now = DateTime.now();

    if (_lastRerouteAt != null &&
        now.difference(_lastRerouteAt!) < rerouteCooldown) {
      return;
    }

    final query = FFAppState().lockedDestinationQuery.trim();

    if (query.length < 2) {
      _showMessage(
        'Cannot reroute: original destination was not saved.',
      );

      _offRouteFixCount = 0;
      return;
    }

    _rerouting = true;
    _lastRerouteAt = now;

    FFAppState().update(() {
      FFAppState().isRerouting = true;
    });

    try {
      final hazards = List<LatLng>.from(
        FFAppState().activeHazards,
      );

      // V8 routing function:
      // current location + original query + hazards + locked entrance.
      final newRoute = getCampusRoute(
        currentLocation,
        query,
        hazards,
        lockedEntrance,
      );

      if (newRoute.length < 2) {
        _showMessage('No safe replacement route was found.');

        _offRouteFixCount = 0;
        return;
      }

      final newDistance = _routeLengthMeters(newRoute);

      final newEta = (newDistance / walkingSpeedMps / 60).ceil();

      FFAppState().update(() {
        FFAppState().routePoints = newRoute;

        FFAppState().lockedDestination = lockedEntrance;

        FFAppState().remainingDistanceMeters = newDistance;

        FFAppState().remainingEtaMinutes = newEta;
      });

      _offRouteFixCount = 0;

      _showMessage('Route updated.');
    } catch (e) {
      debugPrint('Campus reroute error: $e');

      _showMessage('Unable to calculate a new route.');

      _offRouteFixCount = 0;
    } finally {
      _rerouting = false;

      if (mounted) {
        FFAppState().update(() {
          FFAppState().isRerouting = false;
        });
      }
    }
  }

  void _finishNavigation() {
    if (_arrivalHandled) return;

    _arrivalHandled = true;

    _navigationInitialized = false;

    FFAppState().update(() {
      FFAppState().routePoints = <LatLng>[];

      FFAppState().isNavigating = false;
      FFAppState().isFollowingUser = false;
      FFAppState().isRerouting = false;

      FFAppState().remainingDistanceMeters = 0.0;
      FFAppState().remainingEtaMinutes = 0;

      FFAppState().lockedDestination = null;
      FFAppState().lockedDestinationQuery = '';

      // Keep the current location marker visible.
    });

    _showMessage('You have arrived at your destination!');
  }

  void _handleTrackingFailure() {
    if (!mounted) return;

    FFAppState().update(() {
      FFAppState().hasNavigationLocation = false;

      FFAppState().isNavigating = false;
      FFAppState().isFollowingUser = false;
      FFAppState().isRerouting = false;

      FFAppState().remainingDistanceMeters = 0.0;
      FFAppState().remainingEtaMinutes = 0;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.enabled) {
        _startTracking();
      }
    } else {
      _stopTracking();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
