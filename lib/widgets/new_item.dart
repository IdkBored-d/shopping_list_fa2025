import 'package:flutter/material.dart';
import 'package:shopping_list_fa2025/data/categories.dart';
import 'package:shopping_list_fa2025/models/category.dart';

class NewItem extends StatefulWidget{
  const NewItem({super.key});
  @override
  State<NewItem> createState(){
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem>{
  final _formKey = GlobalKey<FormState>();
  var _eneteredName = "";
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem(){
    if(_formKey.currentState!.validate())
    {
          _formKey.currentState!.save();
          print(_eneteredName);
          print(_enteredQuantity);
          print(_selectedCategory.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new item..."),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column( children: [
          TextFormField(
            maxLength: 50,
            decoration: InputDecoration(
              label: Text('Name')),
              validator: (value){
                if(value==null ||
                 value.isEmpty ||
                  value.length <= 1 ||
                   value.length > 50){
                  return "Must have a name between 2 and 50 characters long!";
                }
                  return null;
              },
                onSaved: (value){
                  _eneteredName = value!;
                }
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("Quanitity"),
                    ),
                    initialValue: '1',
                    validator: (value){
                      if(value==null ||
                   value.isEmpty ||
                   int.tryParse(value) == null ||
                   int.tryParse(value)!<= 0){
                  return "Must have a name between 2 and 50 characters long!";
                }
                  return null;
                },
               onSaved: (value){
                  _enteredQuantity = int.parse(value!);
                }
                ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    initialValue: _selectedCategory,
                    items: [
                    for(final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value,
                      child: Row(children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: category.value.color,
                      ),
                      const SizedBox(width: 6),
                      Text(category.value.title)
                    ],))
                  ],
                   onChanged: (value){
                    setState(() {
                      _selectedCategory = value!;
                    });
                   }),
                )
              ],),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                TextButton(onPressed: (){
                  _formKey.currentState!.reset();
                }, child: const Text("Reset")),
                ElevatedButton(onPressed: _saveItem, child: Text("Add Item"))
              ],)
        ],
        ),
        )
      ),
    );
  }
}