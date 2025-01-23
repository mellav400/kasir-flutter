import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_mella/pelanggan.dart';
import 'package:kasir_mella/tambahProdukk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'editproduk.dart';
import 'penjualan.dart';

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

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cart = [];
  String selectedCategory = "All";

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == "All") {
      return products;
    }
    return products
        .where((product) => product['category'] == selectedCategory)
        .toList();
  }

  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    final response = await Supabase.instance.client.from('produk').select();
    setState(() {
      products = List<Map<String, dynamic>>.from(response);
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produk ${product['nama_produk']} ditambahkan ke keranjang')),
    );
  }

  void _deleteProduct(int index) async {
    final product = products[index];

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Produk'),
          content: Text('Apakah Anda yakin ingin menghapus produk "${product['nama_produk']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await Supabase.instance.client
            .from('produk')
            .delete()
            .eq('id', product['id']);
        setState(() {
          products.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil dihapus')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: $error')),
        );
      }
    }
  }

  void _editProduct(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => tambahProduk(),
      ),
    ).then((updatedProduct) {
      if (updatedProduct != null) {
        setState(() {
          products[index] = updatedProduct;
        });
      }
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(cart: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 245, 115, 158),
        title: Text(
          'Llav Florist',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _goToCart,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 144, 179)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30),
                  SizedBox(height: 10),
                  Text('Admin',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.filter_vintage),
              title: Text('Produk', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
        ListTile(
  leading: Icon(Icons.person),
  title: Text('Pelanggan', style: GoogleFonts.poppins()),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pelanggan()),
    );
  },
        ),

            
          
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan', style: GoogleFonts.poppins()),
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
          Container(
            height: 60,
            color: Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Color.fromARGB(255, 254, 231, 255),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['nama_produk'],
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        'Rp ${product['harga']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.green,
                            ),
                            onPressed: () => _addToCart(product),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              var hasil = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduk(data: product)));
                              if (hasil == 'success'){
                                fetchProduk();
                              };
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteProduct(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var hasil = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => tambahProduk()));
          if (hasil == 'success') {
            fetchProduk();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 248, 174, 199),
      ),
    );
  }
}

