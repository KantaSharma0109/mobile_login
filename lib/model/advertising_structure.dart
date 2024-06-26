class AdvertisingStructure {
  final String title;
  final String subtitle;
  final String imagePath;
  final int categoryId;
  final int locationId;
  final bool? flexSelected;
  final String? flexType;

  AdvertisingStructure({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.categoryId,
    required this.locationId,
    this.flexSelected,
    this.flexType,
  });
  factory AdvertisingStructure.fromJson(Map<String, dynamic> json) {
    return AdvertisingStructure(
        title: json['title'],
        subtitle: json['subtitle'],
        imagePath: json['imagePath'],
        categoryId: json['id'],
        locationId: json['id'],
        flexSelected: json['flexSelected'],
        flexType: json['flexType']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'categoryId': categoryId,
      'locationId': locationId,
      'flexSelected': flexSelected,
      'flexType': flexType,
    };
  }
}
