
class VehicleDetail {
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final double km;

  VehicleDetail(
      {required this.fuelTankLevel,
        required this.longitude,
        required this.latitude,
        required this.deviceId,
        required this.speed,
        required this.km});
}
