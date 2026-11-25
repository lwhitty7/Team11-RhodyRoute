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

import '/app_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class UriCampusMap extends StatefulWidget {
  const UriCampusMap({
    super.key,
    this.width,
    this.height,
    required this.center,
    required this.zoom,
    required this.mapStyle,
    this.routeCoordinates,
    this.currentLocation,
    this.hasCurrentLocation,
    this.followUser,
  });

  final double? width;
  final double? height;

  final LatLng center;
  final int zoom;
  final String mapStyle;

  final List<LatLng>? routeCoordinates;

  final LatLng? currentLocation;
  final bool? hasCurrentLocation;
  final bool? followUser;

  @override
  State<UriCampusMap> createState() => _UriCampusMapState();
}

class _UriCampusMapState extends State<UriCampusMap> {
  gmaps.GoogleMapController? _controller;

  // Prevent our own camera animations from being
  // mistaken for manual map movements.
  bool _programmaticCameraMove = false;

  // Determine which map style to display.
  gmaps.MapType _resolveMapType(String style) {
    switch (style) {
      case 'Terrain':
        return gmaps.MapType.terrain;
      case 'Satellite':
        return gmaps.MapType.satellite;
      case 'Hybrid':
        return gmaps.MapType.hybrid;
      default:
        return gmaps.MapType.normal;
    }
  }

  // Check whether a valid GPS location is available.
  bool get _hasUserLocation =>
      widget.currentLocation != null && widget.hasCurrentLocation == true;

  // Safely animate the camera without disabling follow mode.
  Future<void> _moveCamera(
    gmaps.CameraUpdate update,
  ) async {
    final controller = _controller;

    if (controller == null) return;

    _programmaticCameraMove = true;

    try {
      await controller.animateCamera(update);
    } catch (e) {
      debugPrint('Campus map camera error: $e');
    } finally {
      _programmaticCameraMove = false;
    }
  }

  // Follow the latest GPS position.
  // newLatLng preserves the current zoom level.
  void _followCurrentLocation() {
    if (_controller == null || widget.followUser != true || !_hasUserLocation) {
      return;
    }

    final location = widget.currentLocation!;

    _moveCamera(
      gmaps.CameraUpdate.newLatLng(
        gmaps.LatLng(
          location.latitude,
          location.longitude,
        ),
      ),
    );
  }

  // Detect when the user manually moves the map.
  void _handleCameraMoveStarted() {
    if (_programmaticCameraMove) return;

    if (widget.followUser == true) {
      FFAppState().update(() {
        FFAppState().isFollowingUser = false;
      });
    }
  }

  // React to FlutterFlow parameter updates.
  @override
  void didUpdateWidget(
    covariant UriCampusMap oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (_controller == null) return;

    final oldLocation = oldWidget.currentLocation;
    final newLocation = widget.currentLocation;

    final locationChanged = oldLocation?.latitude != newLocation?.latitude ||
        oldLocation?.longitude != newLocation?.longitude;

    // Resume following when enabled or when GPS changes.
    final shouldFollow = widget.followUser == true &&
        _hasUserLocation &&
        (locationChanged ||
            oldWidget.followUser != widget.followUser ||
            oldWidget.hasCurrentLocation != widget.hasCurrentLocation);

    if (shouldFollow) {
      _followCurrentLocation();

      if (oldWidget.zoom != widget.zoom) {
        _moveCamera(
          gmaps.CameraUpdate.zoomTo(
            widget.zoom.toDouble(),
          ),
        );
      }

      return;
    }

    // Update zoom when changed.
    if (oldWidget.zoom != widget.zoom) {
      _moveCamera(
        gmaps.CameraUpdate.zoomTo(
          widget.zoom.toDouble(),
        ),
      );
    }

    // Update map center only when not following the user.
    if (oldWidget.center != widget.center && widget.followUser != true) {
      _moveCamera(
        gmaps.CameraUpdate.newLatLng(
          gmaps.LatLng(
            widget.center.latitude,
            widget.center.longitude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert FlutterFlow route coordinates into Google Maps coordinates.
    final routePts = (widget.routeCoordinates ?? [])
        .map(
          (p) => gmaps.LatLng(
            p.latitude,
            p.longitude,
          ),
        )
        .toList();

    // Draw the remaining walking route.
    final polylines = <gmaps.Polyline>{
      if (routePts.length >= 2)
        gmaps.Polyline(
          polylineId: const gmaps.PolylineId('campus_walkway'),
          points: routePts,
          color: const Color(0xFF3B82F6),
          width: 6,
          jointType: gmaps.JointType.round,
          startCap: gmaps.Cap.roundCap,
          endCap: gmaps.Cap.roundCap,
        ),
    };

    // Display destination marker only while a route exists.
    final markers = <gmaps.Marker>{
      if (routePts.isNotEmpty)
        gmaps.Marker(
          markerId: const gmaps.MarkerId('destination'),
          position: routePts.last,
          infoWindow: const gmaps.InfoWindow(
            title: 'Destination',
          ),
        ),
    };

    // Custom user-location indicator.
    final circles = <gmaps.Circle>{};

    if (_hasUserLocation) {
      final userPosition = gmaps.LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );

      // Outer blue location halo.
      circles.add(
        gmaps.Circle(
          circleId: const gmaps.CircleId('user_location_halo'),
          center: userPosition,
          radius: 15,
          fillColor: const Color(0x332196F3),
          strokeColor: const Color(0x662196F3),
          strokeWidth: 1,
          zIndex: 1,
        ),
      );

      // Inner blue GPS dot.
      circles.add(
        gmaps.Circle(
          circleId: const gmaps.CircleId('user_location_dot'),
          center: userPosition,
          radius: 4.5,
          fillColor: const Color(0xFF1A73E8),
          strokeColor: Colors.white,
          strokeWidth: 2,
          zIndex: 2,
        ),
      );
    }

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(
            widget.center.latitude,
            widget.center.longitude,
          ),
          zoom: widget.zoom.toDouble(),
        ),

        mapType: _resolveMapType(widget.mapStyle),

        // Walking route.
        polylines: polylines,

        // Destination marker.
        markers: markers,

        // Current location dot and halo.
        circles: circles,

        // Use our custom location indicator when available.
        myLocationEnabled: !_hasUserLocation,

        myLocationButtonEnabled: false,

        zoomControlsEnabled: false,

        // Detect manual panning and zooming.
        onCameraMoveStarted: _handleCameraMoveStarted,

        onMapCreated: (controller) {
          _controller = controller;

          // Start following if navigation is already active.
          _followCurrentLocation();
        },
      ),
    );
  }
}
