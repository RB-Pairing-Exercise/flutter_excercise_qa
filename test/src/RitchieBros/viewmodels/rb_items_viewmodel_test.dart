import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_excercise/src/RitchieBros/repository/search_repository.dart';
import 'package:flutter_excercise/src/RitchieBros/viewmodels/rb_items_viewmodel.dart';

@GenerateMocks([SearchtRepository])
import 'rb_items_viewmodel_test.mocks.dart';

void main() {
  late MockSearchtRepository mockRepository;
  late RbItemsViewModel viewModel;
  final mockItems = List.generate(
      20,
      (i) => RBItem(
            '$i',
            'Item $i',
            'https://example.com/image$i.jpg',
            'Location $i',
            'ST',
            'Country',
            'Auction',
            'ID$i',
            DateTime.now().millisecondsSinceEpoch,
            1000 + i,
            'Features',
          ));

  setUp(() {
    mockRepository = MockSearchtRepository();
    viewModel = RbItemsViewModel.withRepository(mockRepository);
  });

  group('Initial state', () {
    test('should have empty items, not loading, no error', () {
      expect(viewModel.items, isEmpty);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.hasMore, true);
    });
  });

  group('fetchAssets', () {
    test('should load initial items successfully', () async {
      when(mockRepository.getSearchResult(from: 0, size: 20))
          .thenAnswer((_) async => mockItems);

      await viewModel.fetchAssets();

      verify(mockRepository.getSearchResult(from: 0, size: 20)).called(1);
      expect(viewModel.items, mockItems);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.hasMore, true);
    });

    test('should handle load more correctly', () async {
      // First page
      when(mockRepository.getSearchResult(from: 0, size: 20))
          .thenAnswer((_) async => mockItems);
      await viewModel.fetchAssets();

      // Second page
      when(mockRepository.getSearchResult(from: 20, size: 20))
          .thenAnswer((_) async => mockItems);
      await viewModel.fetchAssets(loadMore: true);

      verify(mockRepository.getSearchResult(from: 20, size: 20)).called(1);
      expect(viewModel.items.length, 40); // 20 + 20
      expect(viewModel.isLoading, false);
    });

    test(
        'should set hasMore to false when response has fewer items than page size',
        () async {
      final partialItems = mockItems.sublist(0, 10);
      when(mockRepository.getSearchResult(from: 0, size: 20))
          .thenAnswer((_) async => partialItems);

      await viewModel.fetchAssets();

      expect(viewModel.hasMore, false);
      expect(viewModel.items.length, 10);
    });

    test('should handle errors properly', () async {
      when(mockRepository.getSearchResult(from: 0, size: 20))
          .thenThrow(Exception('Network error'));

      await viewModel.fetchAssets();

      expect(viewModel.error, contains('Network error'));
      expect(viewModel.items, isEmpty);
      expect(viewModel.isLoading, false);
    });
  });
}
