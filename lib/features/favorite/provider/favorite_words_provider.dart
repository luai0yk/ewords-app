import 'package:flutter/cupertino.dart';

import '../../../core/database/favorite_word_helper.dart';
import '../model/favorite_word_model.dart';

class FavoriteWordsProvider extends ChangeNotifier {
  final Set<int> _favoriteIds = <int>{};
  bool _isLoaded = false;
  Future<void>? _loading;

  Future<void> _ensureLoaded() {
    if (_isLoaded) {
      return Future<void>.value();
    }
    _loading ??= _loadFavorites();
    return _loading!;
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoriteWordHelper.instance.getFavorites();
    _favoriteIds
      ..clear()
      ..addAll(favorites.map((favorite) => favorite.id));
    _isLoaded = true;
    _loading = null;
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  Future<void> checkFavorites(int id) async {
    final bool isInFavorite = await FavoriteWordHelper.instance.isFavorite(id);
    if (isInFavorite) {
      _favoriteIds.add(id);
    } else {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }

  Future<void> deleteFavorite({required int id}) async {
    await FavoriteWordHelper.instance.deleteFavorite(id);
    _favoriteIds.remove(id);
    notifyListeners();
  }

  Future<bool> isFav(String id) async {
    await _ensureLoaded();
    final int? parsedId = int.tryParse(id);
    if (parsedId == null) return false;
    return _favoriteIds.contains(parsedId);
  }

  Future<List<FavoriteWordModel>> getFavorites() async {
    await _ensureLoaded();
    return FavoriteWordHelper.instance.getFavorites();
  }

  Future<void> refreshFavorites() async {
    _isLoaded = false;
    await _ensureLoaded();
  }
}
