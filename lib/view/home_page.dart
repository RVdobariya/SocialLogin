import 'package:demotask/controller/auth_controller.dart';
import 'package:demotask/main.dart';
import 'package:demotask/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${FirebaseAuth.instance.currentUser!.email} logged in",
            style: const TextStyle(fontSize: 20),
          ),
          ElevatedButton(
              onPressed: () {
                FireBaseAuth.logOut();
                sharedPreferences!.clear();
                Get.offAll(() => const LoginScreen());
              },
              child: const Text("Logout"))
        ],
      )),
    );
  }
}
