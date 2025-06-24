import 'package:flutter_excercise/src/RitchieBros/services/rb_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';


@GenerateMocks([http.Client])
import 'rb_api_service_test.mocks.dart';

void main() {
  group('ApiService', () {
   late MockClient mockClient;
    late RbApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = RbApiService(); // Need to modify RbApiService to accept client
    });

    test('returns data if the http call completes successfully', () async {
      when(mockClient.post(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
          .thenAnswer((_) async => http.Response('{"totalAmount": 880, "returnedAmount": 20, "records": {}}', 200));

      expect(await apiService.fetchAssets(), isA<List<RBItem>>());
    });

    test('throws an exception if the http call completes with an error', () async {
     final url = Uri.parse('https://api.marketplace.ritchiebros.com/marketplace-listings-service/v1/api/search');

      when(mockClient.post(
        url,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));
      expect(await apiService.fetchAssets(), throwsException);
    });
  });
}

// void main() {
//   late MockClient mockClient;
//   late RbApiService apiService;

//   final mockItemJson = {
//     'itemNumber': '1234',
//     'assetDescription': 'Excavator',
//     'imageUrl': 'https://example.com/image.jpg',
//     'locationCity': 'Houston',
//     'locationState': 'TX',
//     'locationCountry': 'USA',
//     'eventAdvertisedName': 'Big Auction',
//     'serialNumber': 'ABC123456',
//     'eventStartDate': DateTime(2024, 6, 15).millisecondsSinceEpoch,
//     'usageHours': 1200,
//     'features': 'AC, Radio',
//   };

//   setUp(() {
//     mockClient = MockClient();
//     apiService = RbApiService(client: mockClient);
//   });

//   test('fetchAssets returns list of RBItem on 200 response', () async {
//     final responseJson = json.encode({
//       'records': [mockItemJson]
//     });

//     // Mock the http post call
//     when(mockClient.post(
//       Uri.parse('https://api.marketplace.ritchiebros.com/marketplace-listings-service/v1/api/search'),
//       headers: anyNamed('headers'),
//       body: anyNamed('body'),
//     )).thenAnswer((_) async => http.Response(responseJson, 200));

//     final items = await apiService.fetchAssets();

//     expect(items, isA<List<RBItem>>());
//     expect(items.length, 1);
//     expect(items.first.itemNumber, '1234');
//   });

//   test('fetchAssets throws exception on non-200 response', () async {
//     when(mockClient.post(
//       Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
//       headers: anyNamed('headers'),
//       body: anyNamed('body'),
//     )).thenAnswer((_) async => http.Response('Error', 404));
//     expect(() async => apiService.fetchAssets(), throwsException);
//   });
// }
