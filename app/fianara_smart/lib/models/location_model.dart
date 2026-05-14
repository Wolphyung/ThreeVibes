class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? district;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.district,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      city: json['city'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'district': district,
    };
  }

  @override
  String toString() => address ?? '($latitude, $longitude)';
}
