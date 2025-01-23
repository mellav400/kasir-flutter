import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  CheckoutPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    double totalHarga = cart.fold(
        0, (sum, item) => sum + double.parse(item['harga'].toString()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 115, 158),
        title: Text(
          'Checkout',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final product = cart[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      product['nama_produk'][0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    product['nama_produk'],
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'Rp ${product['harga']}',
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Hapus item dari keranjang
                      cart.removeAt(index);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(cart: cart),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp $totalHarga',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 248, 174, 199),
                  ),
                  onPressed: () {
                    if (cart.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Keranjang kosong!')),
                      );
                    } else {
                      // Lakukan tindakan checkout di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Checkout berhasil!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Checkout',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}