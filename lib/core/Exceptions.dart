class NoConnectionException implements Exception {}

abstract class LocationException implements Exception {}

class LocationPermissionException extends LocationException {}

class LocationOutOfBoundsException extends LocationException {}

abstract class BluetoothException implements Exception {}

class BluetoothOffException extends BluetoothException {}
