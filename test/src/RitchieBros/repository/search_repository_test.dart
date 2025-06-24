// dart
import 'package:flutter_excercise/src/RitchieBros/services/rb_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_excercise/src/RitchieBros/repository/search_repository.dart';

@GenerateMocks([RbApiService])
import 'search_repository_test.mocks.dart';

void main() {
  late MockRbApiService mockApiService;
  late SearchtRepository repository;

  final mockItem = RBItem(
    '1234',
    'Excavator',
    'https://example.com/image.jpg',
    'Houston',
    'TX',
    'USA',
    'Big Auction',
    'ABC123456',
    DateTime(2024, 6, 15).millisecondsSinceEpoch,
    1200,
    'AC, Radio',
  );

  setUp(() {
    mockApiService = MockRbApiService();
    repository = SearchtRepository(mockApiService);
  });

  test('getSearchResult returns list from api service', () async {
    when(mockApiService.fetchAssets(from: 0, size: 20))
        .thenAnswer((_) async => [mockItem]);

    final result = await repository.getSearchResult();

    expect(result, isA<List<RBItem>>());
    expect(result.length, 1);
    expect(result.first.itemNumber, '1234');
    verify(mockApiService.fetchAssets(from: 0, size: 20)).called(1);
  });

  test('getSearchResult passes correct parameters', () async {
    when(mockApiService.fetchAssets(from: 5, size: 10))
        .thenAnswer((_) async => [mockItem]);

    final result = await repository.getSearchResult(from: 5, size: 10);

    expect(result.length, 1);
    verify(mockApiService.fetchAssets(from: 5, size: 10)).called(1);
  });

  test('getSearchResult throws if api service throws', () async {
    when(mockApiService.fetchAssets(from: 0, size: 20))
        .thenThrow(Exception('API error'));

    expect(() => repository.getSearchResult(), throwsException);
    verify(mockApiService.fetchAssets(from: 0, size: 20)).called(1);
  });
}