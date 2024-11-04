import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text(
          "Welcome to DF's Bakery",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _selectedIndex == 0 ? _buildMenuList() : ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/banner.jpg',
          height: 200,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Menu Daily Fresh Bakery',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const MenuItem(
          imagePath: 'assets/croissant.jpg',
          title: 'Croissant',
          price: 20000.0,
        ),
        const MenuItem(
          imagePath: 'assets/donut.jpg',
          title: 'Donut',
          price: 10000.0,
        ),
        const MenuItem(
          imagePath: 'assets/cupcake.jpg',
          title: 'Cupcake',
          price: 15000.0,
        ),
        const MenuItem(
          imagePath: 'assets/chocolate_eclair.jpg',
          title: 'Chocolate Eclair',
          price: 18000.0,
        ),
        const MenuItem(
          imagePath: 'assets/chocolate_muffin.jpg',
          title: 'Chocolate Muffin',
          price: 15000.0,
        ),
        const MenuItem(
          imagePath: 'assets/scone.jpg',
          title: 'Scone',
          price: 18000.0,
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final double price;

  const MenuItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        height: 70,
        width: 70,
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
      subtitle: Text(
        'Rp ${price.toStringAsFixed(0)}',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.brown,
        ),
      ),
      trailing: const Icon(Icons.favorite_border, color: Colors.red),
    );
  }
}
