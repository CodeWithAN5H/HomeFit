import '../../domain/food_item.dart';
import 'foods.dart';

/// Read-only lookup over the bundled food data.
///
/// The catalogue is const Dart, so search is instant, works offline and can be
/// asserted in plain unit tests. It never talks to a database or a network.
class FoodCatalogue {
  FoodCatalogue._(this._foods)
    : _byId = <String, FoodItem>{
        for (final FoodItem food in _foods) food.id: food,
      };

  factory FoodCatalogue.bundled() => FoodCatalogue._(kBundledFoods);

  final List<FoodItem> _foods;
  final Map<String, FoodItem> _byId;

  List<FoodItem> get all => _foods;

  Map<String, FoodItem> get byIdMap =>
      Map<String, FoodItem>.unmodifiable(_byId);

  FoodItem? byId(String id) => _byId[id];

  /// Search by name/category/note, optionally narrowed to one category.
  /// Results are alphabetical so the list is predictable.
  List<FoodItem> search(String query, {FoodCategory? category}) {
    final List<FoodItem> matches = <FoodItem>[
      for (final FoodItem food in _foods)
        if ((category == null || food.category == category) &&
            food.matches(query))
          food,
    ]..sort((FoodItem a, FoodItem b) => a.name.compareTo(b.name));
    return matches;
  }

  List<FoodCategory> get categoriesWithFood => <FoodCategory>[
    for (final FoodCategory category in FoodCategory.values)
      if (_foods.any((FoodItem food) => food.category == category)) category,
  ];
}
