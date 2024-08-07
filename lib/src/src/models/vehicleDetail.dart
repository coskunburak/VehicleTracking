class VehicleDetail {
  final double fuelTankLevel;
  final double longitude;
  final double latitude;
  final double speed;
  final int deviceId;
  final int km;
  final bool isActive;
  final int sensors;
  final String plate;

  VehicleDetail({
    required this.fuelTankLevel,
    required this.longitude,
    required this.latitude,
    required this.speed,
    required this.deviceId,
    required this.km,
    required this.isActive,
    required this.sensors,
    required this.plate,
  });

  factory VehicleDetail.fromFirestore(Map<String, dynamic> data) {
    return VehicleDetail(
      fuelTankLevel: data['fuelTankLevel']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      latitude: data['latitude']?.toDouble() ?? 0.0,
      speed: data['speed']?.toDouble() ?? 0.0,
      deviceId: data['deviceId']?.toInt() ?? 0,
      km: data['km']?.toInt() ?? 0,
      isActive: data['isActive'] ?? false,
      sensors: data['sensors']?.toInt() ?? 0,
      plate: data['plate'] ?? '',
    );
  }
}
