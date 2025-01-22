import 'package:flutter/material.dart';

void hapusproduk(BuildContext context, List<Map<String, dynamic>> products, Map<String, dynamic> product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Hapus produk dari daftar
              products.remove(product);
              Navigator.pop(context); // Menutup dialog
            },
            child: Text('Hapus'),
          ),
        ],
      );
    },
  );
}
