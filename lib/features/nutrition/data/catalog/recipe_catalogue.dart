import '../../domain/recipe.dart';
import 'recipes.dart';

/// Read-only lookup over the bundled recipes.
class RecipeCatalogue {
  RecipeCatalogue._(this._recipes)
    : _byId = <String, Recipe>{
        for (final Recipe recipe in _recipes) recipe.id: recipe,
      };

  factory RecipeCatalogue.bundled() => RecipeCatalogue._(kBundledRecipes);

  final List<Recipe> _recipes;
  final Map<String, Recipe> _byId;

  List<Recipe> get all => _recipes;

  Map<String, Recipe> get byIdMap => Map<String, Recipe>.unmodifiable(_byId);

  Recipe? byId(String id) => _byId[id];

  /// Search title/description/tag, optionally narrowed to one tag.
  List<Recipe> search(String query, {RecipeTag? tag}) {
    final List<Recipe> matches = <Recipe>[
      for (final Recipe recipe in _recipes)
        if ((tag == null || recipe.tags.contains(tag)) && recipe.matches(query))
          recipe,
    ]..sort((Recipe a, Recipe b) => a.title.compareTo(b.title));
    return matches;
  }
}
