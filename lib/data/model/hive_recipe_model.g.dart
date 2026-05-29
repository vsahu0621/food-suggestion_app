// GENERATED CODE - written manually to avoid needing build_runner
// If you add build_runner to dev_dependencies, delete this file and run:
//   flutter pub run build_runner build --delete-conflicting-outputs

part of 'hive_recipe_model.dart';

class HiveRecipeModelAdapter extends TypeAdapter<HiveRecipeModel> {
  @override
  final int typeId = 0;

  @override
  HiveRecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRecipeModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      area: fields[3] as String,
      image: fields[4] as String,
      instructions: fields[5] as String,
      youtubeUrl: fields[6] as String,
      ingredients: (fields[7] as List).cast<String>(),
      measures: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveRecipeModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.area)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.instructions)
      ..writeByte(6)
      ..write(obj.youtubeUrl)
      ..writeByte(7)
      ..write(obj.ingredients)
      ..writeByte(8)
      ..write(obj.measures);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
