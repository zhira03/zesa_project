class WeatherInfo {
  final String city;
  final String country;
  final double temperature; // in Celsius
  final int cloudCover; // in percentage
  final double rainProbability; // in percentage
  final double windSpeed; // in m/s
  final int humidity; // in percentage

  WeatherInfo({
    required this.city,
    required this.country,
    required this.temperature,
    required this.cloudCover,
    required this.rainProbability,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      cloudCover: json['cloudCover'] ?? 0,
      rainProbability: (json['rainProbability'] ?? 0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      humidity: json['humidity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'temperature': temperature,
      'cloudCover': cloudCover,
      'rainProbability': rainProbability,
      'windSpeed': windSpeed,
      'humidity': humidity,
    };
  }
}