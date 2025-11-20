import 'package:flutter/material.dart';

//enum categories
enum Categories{
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


//class categories
class Category{
  const Category(this.title, this.color);
  final String title;
  final Color color;
}