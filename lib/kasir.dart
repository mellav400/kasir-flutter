import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> categories = [
    "All",
    "Spring",
    "Sweet",
    "Cold",
    "Wedding",
    "Custom",
    "Others"
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "Bouquet's Korean",
      "price": 50000,
      "category": "Sweet",
      "image": "assets/buketkorea.jpeg"
    },
    {
      "name": "Bouquet's Spring",
      "price": 70000,
      "category": "Spring",
      "image": "assets/buketspring.jpeg"
    },
    {
      "name": "Bouquet's Tulips",
      "price": 150000,
      "category": "Wedding",
      "image": "assets/bukettulip.jpeg"
    },
    {
      "name": "Bouquet's Sweet Tulips",
      "price": 50000,
      "category": "Sweet",
      "image": "assets/bukettulips.jpg"
    },
    {
      "name": "Bouquet's Old",
      "price": 50000,
      "category": "Cold",
      "image": "assets/springold.jpg"
    },
    {
      "name": "Bouquet's Sunflower",
      "price": 50000,
      "category": "Custom",
      "image": "assets/buketsunfl.jpg"
    },
  ];

  String selectedCategory = "All";
  List<Map<String, dynamic>> cart = []; // Keranjang belanja

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == "All") {
      return products;
    }
    return products
        .where((product) => product['category'] == selectedCategory)
        .toList();
  }

  // Fungsi untuk menambahkan produk ke keranjang
  void _addToCart(Map<String, dynamic> product, int quantity) {
    setState(() {
      cart.add({
        "product": product,
        "quantity": quantity,
        "totalPrice": product['price'] * quantity
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart!')),
    );
  }

  // Fungsi untuk menampilkan dialog pembelian
  void _showPurchaseDialog(BuildContext context, Map<String, dynamic> product) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buy ${product['name']}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(product['image'], height: 100),
              SizedBox(height: 10),
              Text(
                'Price: Rp ${product['price']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Quantity: ', style: GoogleFonts.poppins()),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text('$quantity', style: GoogleFonts.poppins()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _addToCart(product, quantity); // Menambahkan ke keranjang
                  Navigator.pop(context); // Menutup dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 248, 137, 174),
                ),
                child: Text('Add to Cart'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan keranjang
  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shopping Cart',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart[index];
                    final product = cartItem['product'];
                    final quantity = cartItem['quantity'];
                    final totalPrice = cartItem['totalPrice'];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('Qty: $quantity - Total: Rp $totalPrice'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            cart.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Proses checkout
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Checkout successful!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 230, 182, 198),
                ),
                child: Text('Checkout'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          'Bouquet by Efelav',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/admin.jpg'),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Colors.pinkAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/admin_profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin',
                    style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 219, 130, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'adminook@google.com',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Kategori
          Container(
            height: 60,
            color: Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Produk
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    _showPurchaseDialog(context, product); // Menampilkan dialog pembelian
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              product['image'],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name'],
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Rp ${product['price']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCart, // Menampilkan keranjang
        child: Icon(Icons.shopping_cart),
        backgroundColor: const Color.fromARGB(255, 248, 174, 199),
      ),
    );
  }
}
