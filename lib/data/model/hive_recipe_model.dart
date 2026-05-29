import 'package:hive/hive.dart';

part 'hive_recipe_model.g.dart';

@HiveType(typeId: 0)
class HiveRecipeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String area;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String instructions;

  @HiveField(6)
  final String youtubeUrl;

  @HiveField(7)
  final List<String> ingredients;

  @HiveField(8)
  final List<String> measures;

  HiveRecipeModel({
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
}
