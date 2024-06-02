import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_category.dart';

const dummyCategories = {
  GroceryCategories.vegetables: GroceryCategory(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  GroceryCategories.fruit: GroceryCategory(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  GroceryCategories.meat: GroceryCategory(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  GroceryCategories.dairy: GroceryCategory(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  GroceryCategories.carbs: GroceryCategory(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  GroceryCategories.sweets: GroceryCategory(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  GroceryCategories.spices: GroceryCategory(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  GroceryCategories.convenience: GroceryCategory(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  GroceryCategories.hygiene: GroceryCategory(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  GroceryCategories.other: GroceryCategory(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};
