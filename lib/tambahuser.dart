import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_mella/kasir.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tambahuser extends StatefulWidget {
  @override
  _User createState() => _User();
}

class _User extends State<Tambahuser> {
  List<Map<String, dynamic>> users = [];
  String selectedCategory = 'User'; // Kategori default

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('user').select();
    setState(() {
      users = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addUser(String username, String password) async {
    try {
      final response = await Supabase.instance.client.from('user').insert({
        'username': username,
        'password': password,
      });
      fetchUsers();

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menambahkan user: ${response.error!.message}')),
        );
      } else {
        fetchUsers(); // Update the list of users
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User berhasil ditambahkan')),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _deleteUser(int index) async {
    final user = users[index];
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus User'),
          content: Text(
              'Apakah Anda yakin ingin menghapus user "${user['username']}"?'),
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
        final response = await Supabase.instance.client
            .from('User')
            .delete()
            .eq('Id', user['id']);
        setState(() {});
        ();
        if (response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menghapus user: ${response.error!.message}')),
          );
        } else {
          setState(() {
            users.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User berhasil dihapus')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
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
                    selectedCategory = 'User';
                  });
                  fetchUsers();
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
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
          ElevatedButton(
            onPressed: () {
              // Add User logic can be placed here, or navigate to another screen for adding users
            },
            child: Text('Tambah User'),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      user['username'],
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user['password'],
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteUser(index),
                    ),
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
