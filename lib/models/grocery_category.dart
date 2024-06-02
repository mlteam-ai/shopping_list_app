import 'package:flutter/material.dart';

enum GroceryCategories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class GroceryCategory {
  final String name;
  final Color color;

  const GroceryCategory(this.name, this.color);
}
