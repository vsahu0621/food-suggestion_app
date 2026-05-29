class RecipeModel {
  final String id;
  final String title;
  final String category;
  final String area;
  final String image;
  final String instructions;
  final String youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.image,
    required this.instructions,
    required this.youtubeUrl,
    required this.ingredients,
    required this.measures,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] ?? '').toString().trim();
      final measure = (json['strMeasure$i'] ?? '').toString().trim();
      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return RecipeModel(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      image: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}
