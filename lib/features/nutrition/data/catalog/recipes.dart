import '../../domain/recipe.dart';

/// Bundled affordable Indian vegetarian recipes (no eggs).
///
/// Ingredient amounts refer to the bundled food ids and to the recipe's stated
/// servings. Nutrition is computed from those ingredients at display time, so a
/// recipe can never quote a number that disagrees with its ingredient list.
const List<Recipe> kBundledRecipes = <Recipe>[
  Recipe(
    id: 'moong-dal-khichdi',
    title: 'Moong dal khichdi',
    description:
        'One-pot rice and moong dal with vegetables. Cheap, easy to digest and '
        'a reliable lunch or dinner.',
    servings: 2,
    prepMinutes: 25,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'rice-white-cooked', amount: 300),
      RecipeIngredient(foodId: 'dal-moong-cooked', amount: 200),
      RecipeIngredient(foodId: 'mixed-veg-sabzi', amount: 150),
      RecipeIngredient(foodId: 'ghee', amount: 8),
    ],
    steps: <String>[
      'Wash the rice and dal, then pressure-cook with about three cups of '
          'water until soft.',
      'Add chopped vegetables and salt, and simmer for five minutes.',
      'Finish with ghee and serve hot with curd if you have it.',
    ],
    tags: <RecipeTag>{RecipeTag.glutenFree, RecipeTag.nutFree},
    note: 'Use less water for a drier khichdi that travels well in a tiffin.',
  ),
  Recipe(
    id: 'paneer-bhurji',
    title: 'Paneer bhurji',
    description:
        'Crumbled paneer with tomato and onion. High protein and ready in about '
        'twenty minutes.',
    servings: 2,
    prepMinutes: 20,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'paneer', amount: 150),
      RecipeIngredient(foodId: 'tomato-raw', amount: 100),
      RecipeIngredient(foodId: 'onion-raw', amount: 80),
      RecipeIngredient(foodId: 'ghee', amount: 6),
    ],
    steps: <String>[
      'Heat ghee and soften the onion, then add tomato and cook until it '
          'breaks down.',
      'Crumble the paneer in and stir for two to three minutes only, so it '
          'stays soft.',
      'Season with salt, turmeric and a little chilli; serve with roti.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.glutenFree,
    },
  ),
  Recipe(
    id: 'soya-chunk-curry',
    title: 'Soya chunk curry',
    description:
        'Soy chunks simmered in an onion-tomato gravy. One of the cheapest '
        'high-protein vegetarian mains.',
    servings: 2,
    prepMinutes: 30,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'soy-chunks-dry', amount: 50),
      RecipeIngredient(foodId: 'tomato-raw', amount: 100),
      RecipeIngredient(foodId: 'onion-raw', amount: 80),
      RecipeIngredient(foodId: 'mixed-veg-sabzi', amount: 100),
      RecipeIngredient(foodId: 'mustard-oil', amount: 8),
    ],
    steps: <String>[
      'Boil the soy chunks in salted water for five minutes, then squeeze them '
          'dry — this removes the raw taste.',
      'Cook onion and tomato into a thick masala, then add the chunks and '
          'vegetables.',
      'Add a cup of water and simmer for ten minutes; serve with rice or roti.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.glutenFree,
      RecipeTag.nutFree,
      RecipeTag.lactoseFree,
    },
  ),
  Recipe(
    id: 'chole-masala',
    title: 'Chole masala',
    description:
        'Chickpea curry with a simple home masala. Soak the chickpeas the night '
        'before to keep it cheap and quick.',
    servings: 2,
    prepMinutes: 25,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'chole-cooked', amount: 300),
      RecipeIngredient(foodId: 'onion-raw', amount: 60),
      RecipeIngredient(foodId: 'tomato-raw', amount: 100),
      RecipeIngredient(foodId: 'mustard-oil', amount: 8),
    ],
    steps: <String>[
      'Fry onion until golden, add tomato and the spices, and cook until the '
          'oil separates.',
      'Add the cooked chole with a little water and simmer for ten minutes.',
      'Mash a few chickpeas to thicken the gravy; serve with rice or roti.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.glutenFree,
      RecipeTag.nutFree,
      RecipeTag.lactoseFree,
    },
  ),
  Recipe(
    id: 'rajma-rice',
    title: 'Rajma rice',
    description:
        'Kidney beans and rice — a complete, filling meal from two inexpensive '
        'staples.',
    servings: 2,
    prepMinutes: 30,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'rajma-cooked', amount: 250),
      RecipeIngredient(foodId: 'rice-white-cooked', amount: 300),
      RecipeIngredient(foodId: 'ghee', amount: 6),
    ],
    steps: <String>[
      'Simmer cooked rajma with onion, tomato, ginger and the usual masala for '
          'fifteen minutes.',
      'Cook the rice separately and fluff it with a little ghee.',
      'Serve the rajma over the rice with a spoon of curd if available.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.glutenFree,
      RecipeTag.nutFree,
    },
  ),
  Recipe(
    id: 'vegetable-poha',
    title: 'Vegetable poha',
    description:
        'Flattened rice with vegetables and peanuts. A ten-minute breakfast or '
        'evening snack.',
    servings: 2,
    prepMinutes: 20,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'poha-raw', amount: 80),
      RecipeIngredient(foodId: 'mixed-veg-sabzi', amount: 150),
      RecipeIngredient(foodId: 'peanuts-roasted', amount: 15),
      RecipeIngredient(foodId: 'mustard-oil', amount: 6),
    ],
    steps: <String>[
      'Rinse the poha in a sieve until soft, then drain well.',
      'Temper mustard seeds and peanuts in oil, add vegetables and turmeric.',
      'Fold in the poha, warm through for two minutes and finish with lemon.',
    ],
    tags: <RecipeTag>{
      RecipeTag.quick,
      RecipeTag.glutenFree,
      RecipeTag.lactoseFree,
    },
    note: 'Contains peanuts; skip them if nuts are restricted.',
  ),
  Recipe(
    id: 'oats-porridge',
    title: 'Oats with milk and banana',
    description:
        'A five-minute breakfast that covers protein and carbs without any '
        'supplement.',
    servings: 1,
    prepMinutes: 10,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'oats-raw', amount: 60),
      RecipeIngredient(foodId: 'milk-toned', amount: 300),
      RecipeIngredient(foodId: 'banana', amount: 118),
      RecipeIngredient(foodId: 'peanuts-roasted', amount: 10),
    ],
    steps: <String>[
      'Simmer the oats in milk for four to five minutes, stirring so it does '
          'not catch.',
      'Slice the banana over the top and add crushed peanuts.',
      'Add cinnamon or a date if you want sweetness instead of sugar.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.breakfast,
    },
    note: 'Contains milk and peanuts.',
  ),
  Recipe(
    id: 'besan-chilla',
    title: 'Besan chilla with curd',
    description:
        'Savoury gram-flour pancakes with curd on the side. Cheap protein for '
        'breakfast or a light dinner.',
    servings: 2,
    prepMinutes: 20,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'besan-raw', amount: 60),
      RecipeIngredient(foodId: 'onion-raw', amount: 50),
      RecipeIngredient(foodId: 'tomato-raw', amount: 50),
      RecipeIngredient(foodId: 'mustard-oil', amount: 6),
      RecipeIngredient(foodId: 'curd-plain', amount: 100),
    ],
    steps: <String>[
      'Mix besan with water, salt and chopped onion/tomato into a pourable '
          'batter.',
      'Spread a ladle on a hot pan with a little oil and cook both sides.',
      'Serve hot with curd and a squeeze of lemon.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.glutenFree,
      RecipeTag.nutFree,
    },
  ),
  Recipe(
    id: 'curd-rice',
    title: 'Curd rice',
    description:
        'Cooling rice with curd and cucumber. Good on hot days or when appetite '
        'is low.',
    servings: 1,
    prepMinutes: 10,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'curd-plain', amount: 200),
      RecipeIngredient(foodId: 'rice-white-cooked', amount: 250),
      RecipeIngredient(foodId: 'cucumber-raw', amount: 100),
      RecipeIngredient(foodId: 'mustard-oil', amount: 5),
    ],
    steps: <String>[
      'Mix cooled rice with curd and salt; add grated cucumber.',
      'Temper mustard seeds in a teaspoon of oil and pour over the top.',
      'Serve fresh; it keeps for a few hours in a cool box, not overnight.',
    ],
    tags: <RecipeTag>{
      RecipeTag.quick,
      RecipeTag.glutenFree,
      RecipeTag.highProtein,
    },
  ),
  Recipe(
    id: 'sprout-chaat',
    title: 'Moong sprout chaat',
    description:
        'Raw sprouts with onion, tomato and lemon. A high-protein snack that '
        'needs no cooking.',
    servings: 1,
    prepMinutes: 10,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'moong-sprouts-raw', amount: 150),
      RecipeIngredient(foodId: 'onion-raw', amount: 40),
      RecipeIngredient(foodId: 'tomato-raw', amount: 50),
      RecipeIngredient(foodId: 'lemon-juice', amount: 10),
    ],
    steps: <String>[
      'Rinse the sprouts well; steam them for two minutes if raw sprouts upset '
          'your stomach.',
      'Chop onion and tomato and mix with the sprouts.',
      'Season with lemon, salt and a little chilli powder.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.snack,
      RecipeTag.glutenFree,
      RecipeTag.nutFree,
      RecipeTag.lactoseFree,
    },
  ),
  Recipe(
    id: 'banana-peanut-shake',
    title: 'Banana peanut shake',
    description:
        'Milk, banana and peanuts blended together. A cheap way to add energy '
        'when appetite is low.',
    servings: 1,
    prepMinutes: 5,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'milk-toned', amount: 250),
      RecipeIngredient(foodId: 'banana', amount: 118),
      RecipeIngredient(foodId: 'peanuts-roasted', amount: 15),
    ],
    steps: <String>[
      'Blend milk, banana and peanuts until smooth.',
      'Add a date or a pinch of cinnamon if you want it sweeter.',
      'Drink it with a meal rather than replacing one.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.breakfast,
      RecipeTag.glutenFree,
    },
    note: 'Contains milk and peanuts.',
  ),
  Recipe(
    id: 'paneer-sandwich',
    title: 'Paneer vegetable sandwich',
    description:
        'Whole-wheat bread with paneer, cucumber and tomato. A quick packed '
        'lunch or snack.',
    servings: 1,
    prepMinutes: 10,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'bread-whole-wheat', amount: 60),
      RecipeIngredient(foodId: 'paneer', amount: 60),
      RecipeIngredient(foodId: 'cucumber-raw', amount: 50),
      RecipeIngredient(foodId: 'tomato-raw', amount: 50),
    ],
    steps: <String>[
      'Slice paneer and vegetables thinly.',
      'Layer them between the bread with salt, pepper and a little curd or '
          'chutney.',
      'Toast the sandwich if you prefer it warm.',
    ],
    tags: <RecipeTag>{RecipeTag.highProtein, RecipeTag.quick, RecipeTag.snack},
    note: 'Contains wheat and milk.',
  ),
  Recipe(
    id: 'sattu-shake',
    title: 'Sattu shake',
    description:
        'Roasted gram flour blended with milk and banana. A traditional, cheap '
        'and filling drink.',
    servings: 1,
    prepMinutes: 5,
    ingredients: <RecipeIngredient>[
      RecipeIngredient(foodId: 'sattu-raw', amount: 30),
      RecipeIngredient(foodId: 'milk-toned', amount: 200),
      RecipeIngredient(foodId: 'banana', amount: 100),
    ],
    steps: <String>[
      'Whisk the sattu into the milk so there are no lumps.',
      'Blend with banana, or mash the banana and stir well.',
      'Drink fresh; this is a meal addition, not a meal replacement.',
    ],
    tags: <RecipeTag>{
      RecipeTag.highProtein,
      RecipeTag.quick,
      RecipeTag.breakfast,
      RecipeTag.glutenFree,
    },
    note: 'Contains milk.',
  ),
];
