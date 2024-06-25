// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:hookup4u_admin/dash_board_screen.dart';

// class EmailVerificationScreen extends StatefulWidget {
//   const EmailVerificationScreen({Key? key}) : super(key: key);

//   @override
//   State<EmailVerificationScreen> createState() =>
//       _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   bool isEmailVerified = false;
//   Timer? timer;

//   final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   @override
//   void initState() {
//     super.initState();
//     auth.currentUser?.sendEmailVerification();

//     timer =
//         Timer.periodic(const Duration(seconds: 5), (_) => checkEmailVerified());
//   }

//   checkEmailVerified() async {
//     await FirebaseAuth.instance.currentUser?.reload();

//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });

//     if (isEmailVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Email Successfully Verified")));
//       // Create a list of emails to be added to the Admin collection

//       // Add data to the Admin collection
//       if (auth.currentUser != null) {
//         await addDataToAdminCollection(
//             auth.currentUser!.uid, [auth.currentUser!.email!]);
//       }

//       // Navigate to the dashboard screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DashBoardScreen(),
//         ),
//       );

//       timer?.cancel();
//     }
//   }



//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: isEmailVerified
//             ? const Center(
//                 child: Text("Email Successfully Verified",
//                     style: TextStyle(fontWeight: FontWeight.w600)),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 35),
//                     const SizedBox(height: 30),
//                     const Center(
//                       child: Text(
//                         'Check your \n Email',
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                       child: Center(
//                         child: Text(
//                           'We have sent you a Email on  ${auth.currentUser?.email}',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Center(child: CircularProgressIndicator()),
//                     const SizedBox(height: 8),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 32.0),
//                       child: Center(
//                         child: Text(
//                           'Verifying email....',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 57),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                       child: ElevatedButton(
//                         child: const Text('Resend'),
//                         onPressed: () {
//                           try {
//                             FirebaseAuth.instance.currentUser
//                                 ?.sendEmailVerification();
//                           } catch (e) {
//                             debugPrint('$e');
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
