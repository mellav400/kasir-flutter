import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final List<String> categories = [
    "Our Bouquet's",
    "Tulips",
    "Rose",
    "Lily",
    "Sunflower",
    "Wedding Flower",
    "More"
  ];

  final List<Map<String, dynamic>> products = [
    {"name": "OOK", "price": 50000, "image": "assets/kmbg.png"},
     {"name": "OOK", "price": 50000, "image": "assets/kmbg.png"},
      {"name": "OOK", "price": 50000, "image": "assets/kmbg.png"},
       {"name": "OOK", "price": 50000, "image": "assets/kmbg.png"},
        {"name": "OOK", "price": 50000, "image": "assets/kmbg.png"},
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 142, 151),
        title: Text(
          'Welcome to Florist by OOK',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Kategori
          Container(
            height: 60,
            color: Color.fromARGB(255, 255, 223, 233),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: Chip(
                    label: Text(
                      categories[index],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          // Daftar Produk
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        product['image'],
                        height: 50,
                        width: 51,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product['name'],
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp ${product['price']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 27, 26, 26),
                      ),
                    ),
                    trailing: Icon(
                      Icons.add_circle,
                      color: const Color.fromARGB(255, 255, 123, 113),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
