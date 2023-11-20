import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DBProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
}
