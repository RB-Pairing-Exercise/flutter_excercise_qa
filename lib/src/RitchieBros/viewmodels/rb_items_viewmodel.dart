import 'package:flutter/material.dart';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_excercise/src/RitchieBros/repository/search_repository.dart';
import 'package:flutter_excercise/src/RitchieBros/services/rb_api_service.dart';

class RbItemsViewModel extends ChangeNotifier {
  final SearchtRepository _searchtRepository;

  RbItemsViewModel() : _searchtRepository = SearchtRepository(RbApiService());

  RbItemsViewModel.withRepository(this._searchtRepository);

  final List<RBItem> _items = [];
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  List<RBItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchAssets({bool loadMore = false}) async {
    if (_isLoading || (!loadMore && !_hasMore)) return;
    try {
      _isLoading = true;
      if (!loadMore) _currentPage = 0; // Reset for new searches
      notifyListeners();

      final newItems = await _searchtRepository.getSearchResult(
        from: _currentPage * _pageSize,
        size: _pageSize,
      );

      _hasMore = newItems.length == _pageSize;
      _items.addAll(loadMore ? newItems : newItems);
      _currentPage++;
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (loadMore) _currentPage--; // Revert page increment on failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
