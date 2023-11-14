import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dine Inn'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image2.jpeg'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
              child: Text('View Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  // Replace this list with your actual menu items
  final List<MenuItem> menuItems = [
    // MenuItem(name: 'Item 1', description: 'Description 1', price: 10.99),
    // MenuItem(name: 'Item 2', description: 'Description 2', price: 12.99),
    MenuItem(
        name: 'Chicken Stack',
        description:
            'A savory sensation that takes your taste buds to new heights.',
        price: 10.99),
    MenuItem(
        name: 'Burger Platter',
        description: 'Satisfy your cravings with our Burger and Fries',
        price: 12.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(menuItems[index].name),
              onTap: () {
                ShoppingCart.addToCart(menuItems[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemPage(item: menuItems[index]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  ShoppingCart.addToCart(menuItems[index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to Cart: ${menuItems[index].name}'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  final MenuItem item;

  ItemPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image.jpeg', height: 150, width: 150),
            Text('Name: ${item.name}'),
            Text('Description: ${item.description}'),
            Text('Price: \$${item.price}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ShoppingCart.addToCart(item);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Added to Cart: ${item.name}'),
                //     duration: Duration(seconds: 2),
                //   ),
                // );
                // Navigate to the OrderPage after adding an item to the cart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: Column(
        children: [
          // Display the selected items and their total cost
          Expanded(
            child: ListView.builder(
              itemCount: ShoppingCart.cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ShoppingCart.cartItems[index].name),
                  subtitle: Text(
                      '\$${ShoppingCart.cartItems[index].price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        ShoppingCart.removeFromCart(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Display the total cost
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${calculateTotal()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Add a button to proceed to checkout
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(),
                ),
              );
            },
            child: Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }

  // Helper method to calculate the total cost
  double calculateTotal() {
    double total = 0;
    for (var item in ShoppingCart.cartItems) {
      total += item.price;
    }
    return total;
  }
}

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          // Display the order summary with the list of items and total cost
          Expanded(
            child: ListView.builder(
              itemCount: ShoppingCart.cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ShoppingCart.cartItems[index].name),
                  subtitle: Text(
                      '\$${ShoppingCart.cartItems[index].price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          // Display the total cost
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${calculateTotal()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Make the order summary immutable once it's finalized
          Text('Order Finalized',
              style: TextStyle(fontSize: 16, color: Colors.green)),
          // Include a "Place Order" button to complete the order
          ElevatedButton(
            onPressed: () {
              // Add logic to place the order
              // This is where you might send the order to a backend server, for example
              ShoppingCart.clearCart();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text('Place Order™'),
          ),
        ],
      ),
    );
  }

  // Helper method to calculate the total cost
  double calculateTotal() {
    double total = 0;
    for (var item in ShoppingCart.cartItems) {
      total += item.price;
    }
    return total;
  }
}

class ShoppingCart {
  static List<MenuItem> cartItems = [];

  static void addToCart(MenuItem item) {
    cartItems.add(item);
  }

  static void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  static void clearCart() {
    cartItems.clear();
  }
}

class MenuItem {
  final String name;
  final String description;
  final double price;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
  });
}
