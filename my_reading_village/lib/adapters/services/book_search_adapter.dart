import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_reading_village/domain/entities/book_search_result.dart';
import 'package:my_reading_village/domain/ports/book_search_port.dart';

class BookSearchAdapter implements BookSearchPort {
  static const _baseUrl = 'https://openlibrary.org/search.json';
  static const _maxRetries = 3;
  static const _baseDelayMs = 200;

  @override
  Future<List<BookSearchResult>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
        '$_baseUrl?q=${Uri.encodeQueryComponent(query)}&limit=15&fields=title,author_name,number_of_pages_median,cover_i,subject');

    http.Response? response;
    Object? lastError;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      if (attempt > 0) {
        await Future.delayed(Duration(milliseconds: _baseDelayMs * (1 << (attempt - 1))));
      }
      try {
        response = await http.get(uri).timeout(Duration(seconds: 10));
        if (response.statusCode < 500) break;
        lastError = BookSearchException('API error (${response.statusCode})');
      } catch (e) {
        lastError = e;
        response = null;
      }
    }

    if (response == null) {
      throw BookSearchException('Network error: $lastError');
    }

    if (response.statusCode >= 400) {
      throw BookSearchException('API error (${response.statusCode})');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? [];

    return docs.map((doc) {
      final map = doc as Map<String, dynamic>;
      final authors = map['author_name'] as List<dynamic>?;
      final coverId = map['cover_i'] as int?;
      final thumbnailUrl = coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : null;
      final subjects = map['subject'] as List<dynamic>?;

      return BookSearchResult(
        title: map['title'] as String? ?? 'Unknown',
        author: authors?.isNotEmpty == true ? authors!.join(', ') : null,
        pageCount: map['number_of_pages_median'] as int?,
        thumbnailUrl: thumbnailUrl,
        categories: subjects?.take(3).map((s) => s.toString()).toList() ?? [],
      );
    }).toList();
  }
}

class BookSearchException implements Exception {
  final String message;
  BookSearchException(this.message);
  @override
  String toString() => message;
}
