class VehicleDetail {
  final String plate;
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final double km;
  final bool isActive;
  final int sensors;

  VehicleDetail({
    required this.plate,
    required this.fuelTankLevel,
    required this.longitude,
    required this.latitude,
    required this.speed,
    required this.deviceId,
    required this.km,
    required this.isActive,
    required this.sensors,
  });

  factory VehicleDetail.fromFirestore(Map<String, dynamic> data) {
    return VehicleDetail(
      plate: data['plate'],
      fuelTankLevel: data['fuelTankLevel'],
      longitude: data['longitude'],
      latitude: data['latitude'],
      speed: data['speed'],
      deviceId: data['deviceId'],
      km: data['km'],
      isActive: data['isActive'],
      sensors: data['sensors'],
    );
  }
}
