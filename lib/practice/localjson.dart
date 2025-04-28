import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const RecipeListScreen(),
    );
  }
}

// Model classes
class Recipe {
  final int id;
  final String name;
  final String category;
  final String difficulty;
  final int prepTime;
  final int cookTime;
  final int servings;
  final bool isFavorite;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.isFavorite,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      difficulty: json['difficulty'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      servings: json['servings'],
      isFavorite: json['isFavorite'],
      imageUrl: json['imageUrl'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      instructions: List<String>.from(json['instructions']),
    );
  }
}

class Ingredient {
  final String name;
  final String amount;

  Ingredient({required this.name, required this.amount});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      amount: json['amount'],
    );
  }
}

// Main screen to display recipes
class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> _recipesFuture;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _recipesFuture = _loadRecipes();
  }

  Future<List<Recipe>> _loadRecipes() async {
    try {
      // In a real app, you would add the JSON file to your assets in pubspec.yaml
      // For this example, we'll simulate loading from assets
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      // This is where you would normally load from assets:
      // final String jsonString = await rootBundle.loadString('assets/data/recipes.json');

      // For this example, we'll use the JSON string directly
      final String jsonString = '''
[
  {
    "id": 1,
    "name": "Pasta Carbonara",
    "category": "Italian",
    "difficulty": "Medium",
    "prepTime": 15,
    "cookTime": 20,
    "servings": 4,
    "isFavorite": true,
    "imageUrl": "pasta_carbonara.jpg",
    "ingredients": [
      {"name": "Spaghetti", "amount": "400g"},
      {"name": "Pancetta", "amount": "150g"},
      {"name": "Egg Yolks", "amount": "4"},
      {"name": "Parmesan", "amount": "50g"},
      {"name": "Black Pepper", "amount": "to taste"},
      {"name": "Salt", "amount": "to taste"}
    ],
    "instructions": [
      "Boil the pasta in salted water until al dente",
      "Fry the pancetta until crispy",
      "Mix egg yolks with grated parmesan",
      "Drain pasta and mix with pancetta",
      "Add egg mixture and stir quickly",
      "Season with black pepper and serve immediately"
    ]
  },
  {
    "id": 2,
    "name": "Chicken Tikka Masala",
    "category": "Indian",
    "difficulty": "Hard",
    "prepTime": 30,
    "cookTime": 40,
    "servings": 6,
    "isFavorite": false,
    "imageUrl": "chicken_tikka.jpg",
    "ingredients": [
      {"name": "Chicken Breast", "amount": "800g"},
      {"name": "Yogurt", "amount": "200g"},
      {"name": "Tomato Sauce", "amount": "400g"},
      {"name": "Heavy Cream", "amount": "200ml"},
      {"name": "Garam Masala", "amount": "2 tbsp"},
      {"name": "Turmeric", "amount": "1 tsp"},
      {"name": "Cumin", "amount": "1 tsp"},
      {"name": "Ginger", "amount": "2 tbsp"},
      {"name": "Garlic", "amount": "4 cloves"},
      {"name": "Coriander", "amount": "for garnish"}
    ],
    "instructions": [
      "Marinate chicken in yogurt and spices for at least 2 hours",
      "Grill or broil chicken until charred",
      "Sauté onions, garlic, and ginger",
      "Add tomato sauce and spices",
      "Simmer for 15 minutes",
      "Add cream and simmer for 10 more minutes",
      "Add grilled chicken and simmer for 5 minutes",
      "Garnish with fresh coriander and serve with rice"
    ]
  },
  {
    "id": 3,
    "name": "Avocado Toast",
    "category": "Breakfast",
    "difficulty": "Easy",
    "prepTime": 5,
    "cookTime": 5,
    "servings": 2,
    "isFavorite": true,
    "imageUrl": "avocado_toast.jpg",
    "ingredients": [
      {"name": "Bread", "amount": "2 slices"},
      {"name": "Avocado", "amount": "1"},
      {"name": "Lemon Juice", "amount": "1 tsp"},
      {"name": "Red Pepper Flakes", "amount": "pinch"},
      {"name": "Salt", "amount": "to taste"},
      {"name": "Olive Oil", "amount": "drizzle"}
    ],
    "instructions": [
      "Toast the bread until golden",
      "Mash the avocado with lemon juice, salt, and pepper",
      "Spread avocado on toast",
      "Sprinkle with red pepper flakes",
      "Drizzle with olive oil and serve"
    ]
  },
  {
    "id": 4,
    "name": "Chocolate Chip Cookies",
    "category": "Dessert",
    "difficulty": "Medium",
    "prepTime": 15,
    "cookTime": 12,
    "servings": 24,
    "isFavorite": false,
    "imageUrl": "chocolate_cookies.jpg",
    "ingredients": [
      {"name": "Butter", "amount": "225g"},
      {"name": "White Sugar", "amount": "150g"},
      {"name": "Brown Sugar", "amount": "150g"},
      {"name": "Eggs", "amount": "2"},
      {"name": "Vanilla Extract", "amount": "2 tsp"},
      {"name": "All-Purpose Flour", "amount": "375g"},
      {"name": "Baking Soda", "amount": "1 tsp"},
      {"name": "Salt", "amount": "1/2 tsp"},
      {"name": "Chocolate Chips", "amount": "350g"}
    ],
    "instructions": [
      "Cream together butter and sugars",
      "Beat in eggs and vanilla",
      "Mix in flour, baking soda, and salt",
      "Stir in chocolate chips",
      "Drop by rounded tablespoons onto baking sheets",
      "Bake at 350°F (175°C) for 10-12 minutes",
      "Cool on wire racks"
    ]
  }
]
      ''';

      final List<dynamic> jsonData = json.decode(jsonString);
      final recipes = jsonData.map((json) => Recipe.fromJson(json)).toList();

      // Extract unique categories
      final Set<String> categorySet = {'All'};
      for (var recipe in recipes) {
        categorySet.add(recipe.category);
      }
      _categories = categorySet.toList();

      return recipes;
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No recipes found'));
                } else {
                  final recipes = snapshot.data!;
                  final filteredRecipes = _selectedCategory == 'All'
                      ? recipes
                      : recipes.where((r) => r.category == _selectedCategory).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return _buildRecipeCard(recipe);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.orange[100],
              checkmarkColor: Colors.orange,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Recipe Image (placeholder)
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // Category and Favorite badges
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      recipe.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (recipe.isFavorite)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.timer, '${recipe.prepTime + recipe.cookTime} min'),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.restaurant_menu, '${recipe.servings} servings'),
                      const SizedBox(width: 12),
                      _buildDifficultyChip(recipe.difficulty),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${recipe.ingredients.length} ingredients',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Detail screen to show recipe details
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              // In a real app, you would toggle favorite status here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    recipe.isFavorite
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image (placeholder)
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Info
                  Row(
                    children: [
                      _buildInfoCard(Icons.timer, 'Prep Time', '${recipe.prepTime} min'),
                      const SizedBox(width: 16),
                      _buildInfoCard(Icons.whatshot, 'Cook Time', '${recipe.cookTime} min'),
                      const SizedBox(width: 16),
                      _buildInfoCard(Icons.restaurant, 'Servings', '${recipe.servings}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) => _buildIngredientItem(ingredient)),
                  const SizedBox(height: 24),

                  // Instructions Section
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    recipe.instructions.length,
                        (index) => _buildInstructionItem(index + 1, recipe.instructions[index]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(ingredient.name),
          ),
          Text(
            ingredient.amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}