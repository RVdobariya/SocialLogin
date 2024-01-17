import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

// Package imports:
