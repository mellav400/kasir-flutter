// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding telah diinisialisasi
//   await Supabase.initialize(
//     url: 'https://fskjujschwinwwfptgoh.supabase.co', // Ganti dengan URL Supabase Anda
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZza2p1anNjaHdpbnd3ZnB0Z29oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyOTM3MzIsImV4cCI6MjA1MTg2OTczMn0.YgPBDyHWuUD1aAj3b17KF6-KHxfHsMmfA5IItqsBZoY',
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pelanggan App',
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       home: PelangganPage(),
//     );
//   }
// }

// class PelangganPage extends StatefulWidget {
//   @override
//   _PelangganPageState createState() => _PelangganPageState();
// }

// class _PelangganPageState extends State<PelangganPage> {
//   final TextEditingController _namaController = TextEditingController();
//   final TextEditingController _alamatController = TextEditingController();
//   final TextEditingController _noTelpController = TextEditingController();
//   List<Map<String, dynamic>> _pelangganList = [];
//   bool _isLoading = false; // Tambahkan status loading untuk menampilkan progress

//   @override
//   void initState() {
//     super.initState();
//     _fetchPelanggan();
//   }

//   // Fetch data pelanggan dari Supabase
//   Future<void> _fetchPelanggan() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Supabase.instance.client.from('pelanggan').select().execute();
//       if (response.error == null) {
//         setState(() {
//           _pelangganList = List<Map<String, dynamic>>.from(response.data);
//         });
//       } else {
//         print('Error fetching data: ${response.error!.message}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Tambah data pelanggan ke Supabase
//   Future<void> _addPelanggan() async {
//     if (_namaController.text.isEmpty ||
//         _alamatController.text.isEmpty ||
//         _noTelpController.text.isEmpty) {
//       // Menampilkan pesan error jika ada field yang kosong
//       print('Silakan isi semua field.');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Supabase.instance.client.from('pelanggan').insert([
//         {
//           'nama': _namaController.text,
//           'alamat': _alamatController.text,
//           'no_telp': _noTelpController.text,
//         }
//       ]).execute();

//       if (response.error == null) {
//         // Reset input fields and fetch updated list
//         _namaController.clear();
//         _alamatController.clear();
//         _noTelpController.clear();
//         _fetchPelanggan();
//       } else {
//         print('Error adding pelanggan: ${response.error!.message}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Hapus pelanggan berdasarkan ID
//   Future<void> _deletePelanggan(int pelangganId) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Supabase.instance.client
//           .from('pelanggan')
//           .delete()
//           .eq('pelanggan_id', pelangganId)
//           .execute();

//       if (response.error == null) {
//         _fetchPelanggan();
//       } else {
//         print('Error deleting pelanggan: ${response.error!.message}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pelanggan', style: GoogleFonts.poppins()),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Form untuk menambah pelanggan
//             TextField(
//               controller: _namaController,
//               decoration: InputDecoration(
//                 labelText: 'Nama Pelanggan',
//                 labelStyle: GoogleFonts.poppins(),
//                 border: OutlineInputBorder(),
//               ),
//               style: GoogleFonts.poppins(),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _alamatController,
//               decoration: InputDecoration(
//                 labelText: 'Alamat',
//                 labelStyle: GoogleFonts.poppins(),
//                 border: OutlineInputBorder(),
//               ),
//               style: GoogleFonts.poppins(),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _noTelpController,
//               decoration: InputDecoration(
//                 labelText: 'Nomor Telepon',
//                 labelStyle: GoogleFonts.poppins(),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//               style: GoogleFonts.poppins(),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _addPelanggan,
//                     child: Text('Tambah Pelanggan', style: GoogleFonts.poppins()),
//                   ),
//             SizedBox(height: 20),

//             // List pelanggan
//             Expanded(
//               child: _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: _pelangganList.length,
//                       itemBuilder: (context, index) {
//                         final pelanggan = _pelangganList[index];
//                         return Card(
//                           margin: EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text(pelanggan['nama'], style: GoogleFonts.poppins()),
//                             subtitle: Text(
//                               'Alamat: ${pelanggan['alamat']} \nNo Telp: ${pelanggan['no_telp']}',
//                               style: GoogleFonts.poppins(),
//                             ),
//                             trailing: IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _deletePelanggan(pelanggan['pelanggan_id']),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
