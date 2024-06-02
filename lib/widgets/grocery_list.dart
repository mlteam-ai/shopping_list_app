import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final _url = Uri.https(
      'mlteam-dummy-backend-default-rtdb.firebaseio.com', 'shopping-list.json');
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<GroceryItem> loadedItems = [];
      final response = await http.get(_url);
      if (response.statusCode != 200) {
        setState(() {
          _error = 'Failed to load items';
          _isLoading = false;
        });
        return;
      }
      if (response.body != 'null') {
        final data = json.decode(response.body) as Map<String, dynamic>;
        data.forEach((key, value) {
          final category = dummyCategories.values.firstWhere(
            (cat) => cat.name == value['category'],
          );
          loadedItems.add(GroceryItem(
            id: key,
            name: value['name'],
            quantity: value['quantity'],
            category: category,
          ));
        });
      }

      setState(() {
        groceryItems = loadedItems;
        _isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = 'Failed to load items. $e';
        _isLoading = false;
      });
    }
  }

  void _showNewItemScreen() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    _addItem(newItem, groceryItems.length);
  }

  void _addItem(newItem, index) async {
    if (newItem == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': newItem.name,
            'quantity': newItem.quantity,
            'category': newItem.category.name,
          },
        ),
      );

      if (response.statusCode != 200) {
        setState(() {
          _error = 'Failed to add item.';
          _isLoading = false;
        });
        return;
      }
      newItem.id = json.decode(response.body)['name'];
      setState(() {
        groceryItems.insert(index, newItem);
        _isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = 'Failed to add item. $e';
        _isLoading = false;
      });
    }
  }

  void _removeItem(index) async {
    final deletedItem = groceryItems[index];
    setState(() {
      groceryItems.removeAt(index);
    });
    try {
      final response = await http.delete(Uri.https(
          'mlteam-dummy-backend-default-rtdb.firebaseio.com',
          'shopping-list/${deletedItem.id}.json'));
      if (response.statusCode != 200) {
        setState(() {
          groceryItems.insert(index, deletedItem);
        });
        return;
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Item removed!'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                _addItem(deletedItem, index);
              },
            )),
      );
    } on Exception catch (e) {
      print(e);
      setState(() {
        groceryItems.insert(index, deletedItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Center(
        child: Text(_error!),
      );
    } else if (_isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (groceryItems.isNotEmpty) {
      body = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(groceryItems[index].id),
            onDismissed: (direction) {
              _removeItem(index);
            },
            child: ListTile(
              title: Text(groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: groceryItems[index].category.color,
              ),
              trailing: Text('${groceryItems[index].quantity}'),
            ),
          );
        },
      );
    } else {
      body = const Center(
        child: Text('No items yet! Add some!'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewItemScreen,
          ),
        ],
      ),
      body: body,
    );
  }
}
