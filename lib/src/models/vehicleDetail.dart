class VehicleDetail {
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final double km;
  final bool isActive;
  final int sensors;
  final String plate;

  VehicleDetail(
      {required this.fuelTankLevel,
      required this.longitude,
      required this.latitude,
      required this.speed,
      required this.deviceId,
      required this.km,
      required this.isActive,
      required this.sensors,
      required this.plate});
}
