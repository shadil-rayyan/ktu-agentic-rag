import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:math'; // For sqrt function

class VectorDB {
  static Database? _db;

  static Future<void> initialize() async {
    if (_db != null) return;
    
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/vector_db.sqlite3';
    
    if (!File(dbPath).existsSync()) {
      await _copyDatabase(dbPath);
    }

    _db = sqlite3.open(dbPath);
  }

  static Future<void> _copyDatabase(String dbPath) async {
    final data = await rootBundle.load('assets/dbs/vector_db.sqlite3');
    await File(dbPath).writeAsBytes(data.buffer.asUint8List());
  }

  static Future<List<String>> getAvailableSubjects() async {
    await initialize();
    final results = _db!.select('SELECT DISTINCT subject FROM embeddings');
    return results.map((row) => row['subject'] as String).toList();
  }

  static Future<List<Map<String, dynamic>>> search(
    String query,
    String subject, {
    int k = 3
  }) async {
    await initialize();
    final results = _db!.select(
      'SELECT text, embedding FROM embeddings WHERE subject = ?',
      [subject]
    );

    final queryVec = _simpleEmbedding(query);
    
    final scoredResults = results.map((row) {
      final text = row['text'] as String;
      final embedding = (row['embedding'] as String)
          .split(',')
          .map(double.parse)
          .toList();
      
      return {
        'text': text,
        'score': _cosineSimilarity(queryVec, embedding)
      };
    }).toList();

    scoredResults.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    return scoredResults.take(k).toList();
  }

  static List<double> _simpleEmbedding(String query) {
    final words = query.toLowerCase().split(RegExp(r'\W+')).where((w) => w.isNotEmpty).toList();
    return List.generate(384, (i) => i < words.length ? 1.0 : 0.0);
  }

  static double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    
    double dotProduct = 0.0;
    double magA = 0.0;
    double magB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      magA += a[i] * a[i];
      magB += b[i] * b[i];
    }

    magA = sqrt(magA);
    magB = sqrt(magB);

    if (magA == 0.0 || magB == 0.0) return 0.0;
    return dotProduct / (magA * magB);
  }
}