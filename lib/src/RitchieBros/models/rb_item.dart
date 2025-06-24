import 'package:intl/intl.dart';

class RBItem {
  const RBItem(
    this.itemNumber,
    this.assetDescription,
    this.imageUrl,
    this.locationCity,
    this.locationState,
    this.locationCountry,
    this.eventAdvertisedName,
    this.serialNumber,
    this.eventStartDate,
    this.usageHours,
    this.features,
  );
  final String itemNumber;
  final String assetDescription;
  final String imageUrl;
  final String locationCity;
  final String locationState;
  final String locationCountry;
  final String eventAdvertisedName;
  final String serialNumber;
  final int eventStartDate;
  final num? usageHours;
  final String features;
  factory RBItem.fromJson(Map<String, dynamic> json) {
    return RBItem(
      json['itemNumber'] as String? ?? '',
      json['assetDescription'] as String? ?? '',
      json['imageUrl'] as String? ?? '',
      json['locationCity'] as String? ?? '',
      json['locationState'] as String? ?? '',
      json['locationCountry'] as String? ?? '',
      json['eventAdvertisedName'] as String? ?? '',
      json['serialNumber'] as String? ?? '',
      json['eventStartDate'] as int? ?? 0,
      json['usageHours'] != null ? json['usageHours'] as num : 0,
      json['features'] as String? ?? '',
    );
  }

  String get formattedLocation {
    if (locationCountry == 'USA') {
      return '$locationCity, $locationState, $locationCountry';
    } else {
      return '$locationCity, $locationCountry';
    }
  }

  String get formattedDate => DateFormat('MMM dd, yyyy')
      .format(DateTime.fromMillisecondsSinceEpoch(eventStartDate).toLocal());
}
