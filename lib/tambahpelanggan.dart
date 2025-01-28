import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_mella/pelanggan.dart';
import 'kasir.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pelanggan extends StatefulWidget {
  @override
  _Pelanggan createState() => _Pelanggan();
}

class _Pelanggan extends State<Pelanggan> {
  List<Map<String, dynamic>> customers = [];
  String selectedCategory = 'Pelanggan'; // Kategori default

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    final response = await Supabase.instance.client.from('pelanggan').select();
    setState(() {
      customers = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addPelanggan(String nama, String noTelp, String alamat) async {
    try {
      await Supabase.instance.client.from('pelanggan').insert({
        'NamaPelanggan': nama,
        'NoTelp': noTelp,
        'Alamat': alamat,
      });
      fetchPelanggan();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan pelanggan: $error')),
      );
    }
  }

  void _deleteCustomer(int index) async {
    final customer = customers[index];
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Pelanggan'),
          content: Text('Apakah Anda yakin ingin menghapus pelanggan "${customer['NamaPelanggan']}"?'),
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
            .from('pelanggan')
            .delete()
            .eq('pelangganID', customer['pelangganID']);
        setState(() {
          customers.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pelanggan berhasil dihapus')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus pelanggan: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 115, 158),
        title: Text(
          'Llav Florist - ${selectedCategory}',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'Pelanggan';
                  });
                  fetchPelanggan();
                },
                child: Text('Pelanggan'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'User';
                  });
                  // Load user data if required
                },
                child: Text('User'),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 249, 144, 179)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30),
                  SizedBox(height: 10),
                  Text('Admin', style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_vintage),
              title: Text('Produk', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.card_travel),
              title: Text('Detail Penjualan', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pelanggan', style: GoogleFonts.poppins()),
              onTap: () {},
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
      body: selectedCategory == 'Pelanggan'
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['NamaPelanggan'],
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'No Telp: ${customer['NoTelp']}',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Alamat: ${customer['Alamat']}',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'Tampilkan data User di sini',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
    );
  }
}
