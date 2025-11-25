import 'package:flutter/material.dart';
import 'package:shopping_list_fa2025/data/dummy_items.dart';
import 'package:shopping_list_fa2025/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const NewItem())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
          actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.add_box)
            )
        ],
      ),
      body:ListView.builder(
        itemCount:groceryItems.length,
        itemBuilder: (ctx, index)=>ListTile(
          leading: Container(
            width: 24,
            height:24,
            color: groceryItems[index].category.color,
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(groceryItems[index].quantity.toString()),
        ),
        )
    );
  }
}