import 'package:kturag/database/vector_db.dart';

class RagService {
  static Future<String> getContext(String query, String subject) async {
    final results = await VectorDB.search(query, subject);
    return results.map((r) => r['text'] as String).join('\n\n');
  }
}