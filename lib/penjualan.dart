import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  CheckoutPage({required this.cart});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTelpController = TextEditingController();

  Future<void> saveToDatabase() async {
    final supabase = Supabase.instance.client;

    // Simpan data pelanggan ke tabel pelanggan
    final pelangganResponse = await supabase.from('pelanggan').insert({
      'NamaPelanggan': _namaController.text,
      'Alamat': _alamatController.text,
      'NoTelp': _noTelpController.text,
    }).select();

    if (pelangganResponse.isNotEmpty) {
      final pelangganID = pelangganResponse[0]['PelangganID'];

      // Simpan data detail penjualan untuk setiap item di keranjang
      for (var item in widget.cart) {
        await supabase.from('detailpenjualan').insert({
          'PenjualanID': 1, // Ganti dengan ID Penjualan yang sesuai
          'ProdukID': item['id'], // Pastikan ID produk tersedia di data
          'JumlahProduk': item['jumlah'], // Ganti sesuai dengan jumlah produk
          'Subtotal': item['harga'] * item['jumlah'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalHarga = widget.cart.fold(
        0, (sum, item) => sum + double.parse(item['harga'].toString()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 115, 158),
        title: Text(
          'Checkout',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pelanggan harus diisi';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No Telepon harus diisi';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final product = widget.cart[index];
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
                      backgroundColor:
                          const Color.fromARGB(255, 248, 174, 199),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await saveToDatabase();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Checkout berhasil!')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Checkout',
                      style:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
