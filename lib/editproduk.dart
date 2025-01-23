import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduk extends StatefulWidget {
  final Map data;
  const EditProduk({super.key, required this.data});

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaProdukController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late SingleValueDropDownController _kategoriController;

  @override
  void initState() {
    super.initState();
    _namaProdukController = TextEditingController(text: widget.data['nama_produk']);
    _hargaController = TextEditingController(text: widget.data['harga'].toString());
    _stokController = TextEditingController(text: widget.data['stok'].toString());
    _kategoriController = SingleValueDropDownController(
      data: DropDownValueModel(
        name: widget.data['kategori'],
        value: widget.data['kategori'],
      ),
    );
  }

  Future<void> _editProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = _namaProdukController.text;
    final harga = _hargaController.text;
    final stok = _stokController.text;
    final kategori = _kategoriController.dropDownValue!.value;

    final response = await Supabase.instance.client
        .from('produk')
        .update({
          'nama_produk': nama,
          'harga': harga,
          'stok': stok,
          'kategori': kategori
        })
        .eq('id', widget.data['id']);

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui!')),
      );
      Navigator.pop(context, 'success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 170, 199),
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk
                Text(
                  'Nama Produk',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaProdukController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.local_florist, color: Color.fromARGB(255, 255, 82, 82)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Harga Produk
                Text(
                  'Harga Produk',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _hargaController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Harga Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.money, color: Color.fromARGB(255, 52, 93, 40)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Stok Produk
                Text(
                  'Stok Produk',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stokController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Stok Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.storage, color: Color.fromARGB(255, 54, 53, 53)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok produk tidak boleh kosong';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Kategori Produk
                Text(
                  'Kategori Produk',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 31, 39),
                  ),
                ),
                const SizedBox(height: 8),
                DropDownTextField(
                  controller: _kategoriController,
                  textFieldDecoration: InputDecoration(
                    labelText: 'Kategori Produk',
                    labelStyle: GoogleFonts.poppins(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.category, color: Color.fromARGB(255, 163, 142, 255)),
                  ),
                  dropDownList: const [
                    DropDownValueModel(name: 'Spring', value: 'Spring'),
                    DropDownValueModel(name: 'Sweet', value: 'Sweet'),
                    DropDownValueModel(name: 'Cold', value: 'Cold'),
                    DropDownValueModel(name: 'Wedding', value: 'Wedding'),
                    DropDownValueModel(name: 'Custom', value: 'Custom'),
                    DropDownValueModel(name: 'Others', value: 'Others'),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kategori produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Tombol Simpan
                Center(
                  child: ElevatedButton(
                    onPressed: _editProduct,
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 156, 186),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
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
