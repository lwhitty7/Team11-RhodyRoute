import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import '/flutter_flow/ff_builtin_enums.dart';
import '/auth/firebase_auth/auth_util.dart';

String getCampusRouteEtaMinutes(List<LatLng>? route) {
  if (route == null || route.length < 2) return '0 min';

  const earthRadius = 6371008.8;
  const walkingSpeedMps = 1.34112;

  double radians(double degrees) => degrees * math.pi / 180.0;

  double distance = 0.0;

  for (int i = 1; i < route.length; i++) {
    final a = route[i - 1];
    final b = route[i];

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

    distance += 2 * earthRadius * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  if (distance <= 0) return '0 min';

  final minutes = (distance / walkingSpeedMps / 60).ceil();

  return '$minutes min';
}
