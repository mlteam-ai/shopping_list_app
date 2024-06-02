import 'package:shopping_list_app/models/grocery_category.dart';

class GroceryItem {
  String? id;
  final String name;
  final int quantity;
  final GroceryCategory category;

  GroceryItem(
      {this.id,
      required this.name,
      required this.quantity,
      required this.category});
}
