import 'dart:math';
import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

double clamp(double x, double low, double high) {
  return x < low ? low : (x > high ? high : x);
}

double mod(double x, double m) {
  return ((x % m) + m) % m;
}

double wrap(double n, double min, double max) {
  return (n >= min && n < max) ? n : (mod(n - min, max - min) + min);
}

double mercator(double lat) {
  return log(tan(lat * 0.5 + PI / 4));
}

double inverseMercator(double y) {
  return 2 * atan(exp(y)) - PI / 2;
}

double hav(double x) {
  double sinHalf = sin(x * 0.5);
  return sinHalf * sinHalf;
}

double havDistance(double lat1, double lat2, double dLng) {
  return hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
}

double sinFromHav(double h) {
  return 2 * sqrt(h * (1 - h));
}

double havFromSin(double x) {
  double x2 = x * x;
  return x2 / (1 + sqrt(1 - x2)) * .5;
}

double sinDeltaBearing(double lat1, double lng1, double lat2, double lng2,
    double lat3, double lng3) {
  double sinLat1 = sin(lat1);
  double cosLat2 = cos(lat2);
  double cosLat3 = cos(lat3);
  double lat31 = lat3 - lat1;
  double lng31 = lng3 - lng1;
  double lat21 = lat2 - lat1;
  double lng21 = lng2 - lng1;
  double a = sin(lng31) * cosLat3;
  double c = sin(lng21) * cosLat2;
  double b = sin(lat31) + 2 * sinLat1 * cosLat3 * hav(lng31);
  double d = sin(lat21) + 2 * sinLat1 * cosLat2 * hav(lng21);
  double denom = (a * a + b * b) * (c * c + d * d);
  return denom <= 0 ? 1 : (a * d - b * c) / sqrt(denom);
}

double sinSumFromHav(double x, double y) {
  double a = sqrt(x * (1 - x));
  double b = sqrt(y * (1 - y));
  return 2 * (a + b - 2 * (a * y + b * x));
}

bool isOnSegmentGC(double lat1, double lng1, double lat2, double lng2,
    double lat3, double lng3, double havTolerance) {
  double havDist13 = havDistance(lat1, lat3, lng1 - lng3);
  if (havDist13 <= havTolerance) {
    return true;
  }
  double havDist23 = havDistance(lat2, lat3, lng2 - lng3);
  if (havDist23 <= havTolerance) {
    return true;
  }
  double sinBearing = sinDeltaBearing(lat1, lng1, lat2, lng2, lat3, lng3);
  double sinDist13 = sinFromHav(havDist13);
  double havCrossTrack = havFromSin(sinDist13 * sinBearing);
  if (havCrossTrack > havTolerance) {
    return false;
  }
  double havDist12 = havDistance(lat1, lat2, lng1 - lng2);
  double term = havDist12 + havCrossTrack * (1 - 2 * havDist12);
  if (havDist13 > term || havDist23 > term) {
    return false;
  }
  if (havDist12 < 0.74) {
    return true;
  }
  double cosCrossTrack = 1 - 2 * havCrossTrack;
  double havAlongTrack13 = (havDist13 - havCrossTrack) / cosCrossTrack;
  double havAlongTrack23 = (havDist23 - havCrossTrack) / cosCrossTrack;
  double sinSumAlongTrack = sinSumFromHav(havAlongTrack13, havAlongTrack23);
  return sinSumAlongTrack >
      0; // Compare with half-circle == PI using sign of sin().
}

int locationIndexOnEdgeOrPath(LatLng point, List<LatLng> poly, bool closed,
    bool geodesic, double toleranceEarth) {
  int size = poly.length;
  if (size == 0) {
    return -1;
  }
  double tolerance = toleranceEarth / EARTH_RADIUS;
  double havTolerance = hav(tolerance);
  double lat3 = point.latitudeInRad;
  double lng3 = point.longitudeInRad;
  LatLng prev = poly.elementAt(closed ? size - 1 : 0);
  double lat1 = prev.latitudeInRad;
  double lng1 = prev.longitudeInRad;
  int idx = 0;
  if (geodesic) {
    for (LatLng point2 in poly) {
      double lat2 = point2.latitudeInRad;
      double lng2 = point2.longitudeInRad;
      if (isOnSegmentGC(lat1, lng1, lat2, lng2, lat3, lng3, havTolerance)) {
        return max(0, idx - 1);
      }
      lat1 = lat2;
      lng1 = lng2;
      idx++;
    }
  } else {
    // We project the points to mercator space, where the Rhumb segment is a straight line,
    // and compute the geodesic distance between point3 and the closest point on the
    // segment. This method is an approximation, because it uses "closest" in mercator
    // space which is not "closest" on the sphere -- but the error is small because
    // "tolerance" is small.
    double minAcceptable = lat3 - tolerance;
    double maxAcceptable = lat3 + tolerance;
    double y1 = mercator(lat1);
    double y3 = mercator(lat3);
    List<double> xTry = List<double>(3);
    for (LatLng point2 in poly) {
      double lat2 = point2.latitudeInRad;
      double y2 = mercator(lat2);
      double lng2 = point2.longitudeInRad;
      if (max(lat1, lat2) >= minAcceptable &&
          min(lat1, lat2) <= maxAcceptable) {
        // We offset longitudes by -lng1; the implicit x1 is 0.
        double x2 = wrap(lng2 - lng1, -PI, PI);
        double x3Base = wrap(lng3 - lng1, -PI, PI);
        xTry[0] = x3Base;
        // Also explore wrapping of x3Base around the world in both directions.
        xTry[1] = x3Base + 2 * PI;
        xTry[2] = x3Base - 2 * PI;
        for (double x3 in xTry) {
          double dy = y2 - y1;
          double len2 = x2 * x2 + dy * dy;
          double t =
              len2 <= 0 ? 0 : clamp((x3 * x2 + (y3 - y1) * dy) / len2, 0, 1);
          double xClosest = t * x2;
          double yClosest = y1 + t * dy;
          double latClosest = inverseMercator(yClosest);
          double havDist = havDistance(lat3, latClosest, x3 - xClosest);
          if (havDist < havTolerance) {
            return max(0, idx - 1);
          }
        }
      }
      lat1 = lat2;
      lng1 = lng2;
      y1 = y2;
      idx++;
    }
  }
  return -1;
}

LatLng nearestPointIfClose(
    LatLng location, List<LatLng> pois, double distanceTreshold) {
  double nearestDistance;
  LatLng nearestPoi;
  for (LatLng poi in pois) {
    final distance =
        Distance(roundResult: true).as(LengthUnit.Meter, location, poi);
    if (distance <= distanceTreshold) {
      if (nearestDistance == null || distance < nearestDistance) {
        nearestDistance = distance;
        nearestPoi = poi;
      }
    }
  }
  return nearestPoi;
}

LatLng nearestCoordinateToPoint(List<LatLng> line, LatLng poi) {
  double nearestDistance;
  LatLng nearestCoordinates;
  for (LatLng coordinate in line) {
    final distance =
        Distance(roundResult: true).as(LengthUnit.Meter, coordinate, poi);
    if (nearestDistance == null || distance < nearestDistance) {
      nearestDistance = distance;
      nearestCoordinates = coordinate;
    }
  }
  return nearestCoordinates;
}

double distanceTo(List<LatLng> line1, List<LatLng> line2) {
  int n = line1.length;
  int m = line2.length;

  var dtw = List.generate(n + 1, (i) => List(m + 1), growable: false);

  for (int i = 1; i <= n; i++) dtw[i][0] = double.maxFinite;

  for (int j = 1; j <= m; j++) dtw[0][j] = double.maxFinite;

  dtw[0][0] = 0;

  for (int i = 1; i <= n; i++)
    for (int j = 1; j <= m; j++) {
      double cost =
          distanceToPoint(line1.elementAt(i - 1), line2.elementAt(j - 1));
      dtw[i][j] = cost +
          min(
              min(
                  dtw[i - 1][j], // insertion
                  dtw[i][j - 1]), // deletion
              dtw[i - 1][j - 1]); // match
    }
  return dtw[n][m];
}

double distanceToPoint(LatLng point1, LatLng point2) {
  double deltaX = point1.latitude - point2.latitude;
  double deltaY = point1.longitude - point2.longitude;
  return sqrt(deltaX * deltaX + deltaY * deltaY);
}
