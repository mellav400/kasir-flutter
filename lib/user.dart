import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_mella/pelanggan.dart';
import 'kasir.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'editPelanggan.dart';

class User extends StatefulWidget {
  @override
  _User createState() => _User();
}

class _User extends State<User> {
  List<Map<String, dynamic>> customers = [];

  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final response = await Supabase.instance.client.from('User').select();
    setState(() {
      customers = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addPelanggan(String nama, String noTelp, String alamat) async {
    try {
      await Supabase.instance.client.from('User').insert({
        // 'Username': username,
        // 'Password': password,
        
      });
      fetchUser();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan user: $error')),
      );
    }
  }

  void _deleteCustomer(int index) async {
    final customer = customers[index];

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus '),
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
            .from('User')
            .delete()
            .eq('Id', customer['Id']);
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
          'Llav Florist - User',
          style: GoogleFonts.domine(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
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
              title: Text('User', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.card_travel),
              title: Text('Member', style: GoogleFonts.poppins()),
              onTap: () {},

            ),
           
          ],
        ),
      ),
      body: Column(
        children: [
          // Pelanggan
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
      ),
    
    );
  }
}
