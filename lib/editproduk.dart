import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editproduk extends StatefulWidget {
  final Map<String, dynamic>? existingProduct;

  Editproduk({this.existingProduct});

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<Editproduk> {
  final List<String> categories = [
    "All",
    "Spring",
    "Sweet",
    "Cold",
    "Wedding",
    "Custom",
    "Others"
  ];

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late String category;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.existingProduct != null ? widget.existingProduct!['name'] : '');
    priceController = TextEditingController(
        text: widget.existingProduct != null
            ? widget.existingProduct!['price'].toString()
            : '');
    stockController = TextEditingController(
        text: widget.existingProduct != null
            ? widget.existingProduct!['stock'].toString()
            : '');
    category = widget.existingProduct != null ? widget.existingProduct!['category'] : categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingProduct == null ? 
          'Tambah Barang' : 'Edit Barang',
          style: GoogleFonts.poppins(),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Barang',),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: category,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newProduct = {
                  "name": nameController.text,
                  "price": int.parse(priceController.text),
                  "stock": int.parse(stockController.text),
                  "category": category,
                };
                Navigator.pop(context, newProduct);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
