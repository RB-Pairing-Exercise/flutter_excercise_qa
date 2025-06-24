import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('RBItem', () {
    final json = {
      'itemNumber': '1234',
      'assetDescription': 'Excavator',
      'imageUrl': 'https://example.com/image.jpg',
      'locationCity': 'Houston',
      'locationState': 'TX',
      'locationCountry': 'USA',
      'eventAdvertisedName': 'Big Auction',
      'serialNumber': 'ABC123456',
      'eventStartDate': DateTime(2024, 6, 15).millisecondsSinceEpoch,
      'usageHours': 1200,
      'features': 'AC, Radio',
    };

    test('fromJson should create correct RBItem', () {
      final item = RBItem.fromJson(json);

      expect(item.itemNumber, '1234');
      expect(item.assetDescription, 'Excavator');
      expect(item.imageUrl, 'https://example.com/image.jpg');
      expect(item.locationCity, 'Houston');
      expect(item.locationState, 'TX');
      expect(item.locationCountry, 'USA');
      expect(item.eventAdvertisedName, 'Big Auction');
      expect(item.serialNumber, 'ABC123456');
      expect(item.eventStartDate, DateTime(2024, 6, 15).millisecondsSinceEpoch);
      expect(item.usageHours, 1200);
      expect(item.features, 'AC, Radio');
    });

    test('formattedLocation returns correct US format', () {
      final item = RBItem.fromJson(json);
      expect(item.formattedLocation, 'Houston, TX, USA');
    });

    test('formattedLocation returns correct international format', () {
      final nonUSJson = Map<String, dynamic>.from(json)
        ..['locationCountry'] = 'Canada'
        ..['locationState'] = 'BC'
        ..['locationCity'] = 'Vancouver';
      final item = RBItem.fromJson(nonUSJson);
      expect(item.formattedLocation, 'Vancouver, Canada');
    });

    test('formattedDate returns correct formatted string', () {
      final item = RBItem.fromJson(json);
      final expectedDate =
          DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(json['eventStartDate'] as int).toLocal());
      expect(item.formattedDate, expectedDate);
    });
  });
}
