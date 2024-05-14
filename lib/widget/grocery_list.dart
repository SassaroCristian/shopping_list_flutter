import 'package:flutter/material.dart';
import 'package:shopping_list_flutter/models/grocery_item.dart';
import 'package:shopping_list_flutter/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(
      () {
        _groceryItems.add(newItem);
      },
    );
  }

  void _removeItem(GroceryItem item) {
    final indexGrocery = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Grocery deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _groceryItems.insert(indexGrocery, item);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries:'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'No groceries yet! Try adding some.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (_groceryItems.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries:'),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            background: Container(
              height: 30,
              color: Colors.red,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 25,
              ),
            ),
            key: ValueKey(_groceryItems[index]),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
              ),
            ),
          ),
        ),
      );
    } else {
      return content;
    }
  }
}
