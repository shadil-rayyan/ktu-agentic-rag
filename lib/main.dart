import 'package:flutter/material.dart';
import 'package:kturag/app/app.dart';
import 'package:kturag/database/vector_db.dart';

void main() async {  // Make main async
  // Initialize Flutter engine binding FIRST
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await VectorDB.initialize();

  // Start the app
  runApp(const MyApp());
}
