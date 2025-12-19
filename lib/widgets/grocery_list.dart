import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_fa2025/data/categories.dart';
import 'package:shopping_list_fa2025/data/dummy_items.dart';
import 'package:shopping_list_fa2025/models/grocery_item.dart';
import 'package:shopping_list_fa2025/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      "shopping-list-c75cf-default-rtdb.firebaseio.com",
      'shopping-list.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Try again later";
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic>? listData = json.decode(response.body);
      if (listData == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        try {
          final currentCat = categories.entries
              .firstWhere(
                (catItem) => catItem.value.title == item.value['category'],
                orElse: () => categories.entries.first,
              )
              .value;
          loadedItems.add(
            GroceryItem(
              id: item.key,
              name: item.value['name'] ?? '',
              quantity: item.value['quantity'] ?? 1,
              category: currentCat,
            ),
          );
        } catch (e) {
          // Skip invalid items
          continue;
        }
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch data. Try again later";
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() => _groceryItems.remove(item));
    final url = Uri.https(
      "shopping-list-c75cf-default-rtdb.firebaseio.com",
      'shopping-list/${item.id}.json',
    );
    try {
      var response = await http.delete(url);
      if (response.statusCode >= 400) {
        if (mounted) {
          setState(() {
            _groceryItems.insert(index, item);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete item. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _groceryItems.insert(index, item);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete item. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("Please Click the + Button to add an Item"),
    );
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null && _error!.isNotEmpty) {
      content = Center(child: Text(_error!));
    } else if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            title: Text(_groceryItems[index].name),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addItem, icon: const Icon(Icons.add_box)),
        ],
      ),
      body: content,
    );
  }
}
