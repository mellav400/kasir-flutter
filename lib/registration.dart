// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kasir_mella/tambahProdukk.dart';

// class Registration extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               const Color.fromARGB(255, 255, 230, 246),
//               const Color.fromARGB(255, 252, 162, 216),
//             ],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/kmbg.png', height: 200),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Create Your Account',
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: const Color.fromARGB(255, 51, 2, 44),
//                     ),
//                   ),
//                   const Text(
//                     'Join us and start your journey',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color.fromARGB(255, 63, 55, 60),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildTextField(Icons.person, 'Full Name'),
//                   const SizedBox(height: 20),
//                   _buildTextField(Icons.email, 'Email Address'),
//                   const SizedBox(height: 20),
//                   _buildTextField(Icons.lock, 'Password', obscureText: true),
//                   const SizedBox(height: 20),
//                   _buildTextField(Icons.lock, 'Confirm Password', obscureText: true),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => DashboardPage()));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 100, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 5,
//                       backgroundColor: const Color.fromARGB(255, 51, 2, 44),
//                     ),
//                     child: const Text(
//                       'Register',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildDivider(),
//                   const SizedBox(height: 20),
//                   _buildSocialIcons(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(IconData icon, String labelText,
//       {bool obscureText = false}) {
//     return TextField(
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: const Color.fromARGB(255, 51, 2, 44)),
//         labelText: labelText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Row(
//       children: [
//         const Expanded(
//           child: Divider(
//             color: Color.fromARGB(255, 51, 2, 44),
//             thickness: 1,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Text(
//             "Or continue with",
//             style: GoogleFonts.poppins(
//                 color: const Color.fromARGB(255, 51, 2, 44)),
//           ),
//         ),
//         const Expanded(
//           child: Divider(
//             color: Color.fromARGB(255, 51, 2, 44),
//             thickness: 1,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSocialIcons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildSocialIcon(Icons.g_translate, Colors.red),
//         const SizedBox(width: 20),
//         _buildSocialIcon(Icons.facebook, Colors.blue),
//         _buildSocialIcon(Icons.account_box, Colors.grey)
//       ],
//     );
//   }

//   Widget _buildSocialIcon(IconData icon, Color color) {
//     return CircleAvatar(
//       backgroundColor: color.withOpacity(0.1),
//       child: Icon(icon, color: color),
//       radius: 30,
//     );
//   }
// }
