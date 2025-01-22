import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_mella/tambahProdukk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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


  Future<void> addProduk(String nama_produk, String harga, String stok) async {
    try {
      await Supabase.instance.client.from('books').insert({
        'nama_produk': nama_produk,
        'harga': harga,
        'stok': stok,
      });
      fetchProduk();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan buku: $error')),
      );
    }
  }

  // Fungsi untuk menghapus produk
  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product deleted')),
    );
  }

  // Fungsi untuk mengedit produk
  void _editProduct(int index) {
    // Arahkan ke halaman edit (mungkin menggunakan form untuk mengedit)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          'Bouquet by Efelav',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tidak ada gambar, hanya nama dan harga
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['nama_produk'],
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Rp ${product['harga']}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Tombol Edit dan Hapus
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editProduct(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => tambahProduk()));
        }, // Menampilkan halaman tambah produk
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 248, 174, 199),
      ),
    );
  }
}
