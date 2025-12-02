import 'package:flutter/material.dart';
import 'package:shopping_list_fa2025/data/dummy_items.dart';
import 'package:shopping_list_fa2025/models/grocery_item.dart';
import 'package:shopping_list_fa2025/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()));
      if(newItem == null){
        return;
      }
      else{
        setState(() {
          _groceryItems.add(newItem);
        });
      }

    void _removeItem(){
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
          actions: [
          IconButton(
            onPressed: _addItem, 
            icon: Icon(Icons.add_box)
            )
        ],
      ),
      body:ListView.builder(
        itemCount:_groceryItems.length,
        itemBuilder: (ctx, index)=>ListTile(
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[index].category.color,
          ),
          title: Text(_groceryItems[index].name),
          trailing: Text(_groceryItems[index].quantity.toString()),
        ),
        )
    );
  }
}