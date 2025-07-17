// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteRecipeAdapter extends TypeAdapter<FavoriteRecipe> {
  @override
  final int typeId = 0;

  @override
  FavoriteRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteRecipe(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      addedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteRecipe obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
