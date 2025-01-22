import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class tambahProduk extends StatefulWidget {
  const tambahProduk({super.key});

  @override
  _tambahProdukState createState() => _tambahProdukState();
}

class _tambahProdukState extends State<tambahProduk> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _NamaProdukController = TextEditingController();
  final TextEditingController _HargaController = TextEditingController();
  final TextEditingController _StokController = TextEditingController();
  final TextEditingController _KategoriController = TextEditingController();

  Future<void> _tambahProduk() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final produk = _NamaProdukController.text;
    final harga = _HargaController.text;
    final stok = _StokController.text;
    final kategori = _KategoriController.text;

    final response = await Supabase.instance.client.from('produk').insert([
      {
        'nama_produk': produk,
        'harga': harga,
        'stok': stok,
        'kategori': kategori
      }
    ]);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk Berhasil Ditambahkan')),
      );

      _NamaProdukController.clear();
      _HargaController.clear();
      _StokController.clear();
      _KategoriController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 170, 199),
        title: Text('Tambah Produk', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Text(
                  'Nama Produk',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _NamaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.local_florist, color: Color.fromARGB(255, 255, 82, 82)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Harga Produk
                Text(
                  'Harga Produk',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _HargaController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Harga Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.money, color: Color.fromARGB(255, 52, 93, 40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Stok Produk
                Text(
                  'Stok Produk',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _StokController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Stok Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.storage, color: const Color.fromARGB(255, 54, 53, 53)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                // Kategori Produk
                Text(
                  'Kategori Produk',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 53, 31, 39)),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _KategoriController,
                  decoration: InputDecoration(
                    labelText: 'Kategori Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(Icons.category, color: Color.fromARGB(255, 163, 142, 255)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kategori produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Tombol Simpan
                Center(
                  child: ElevatedButton(
                    onPressed: _tambahProduk,
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 156, 186),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
