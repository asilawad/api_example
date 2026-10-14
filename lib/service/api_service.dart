import 'dart:convert';
import 'package:api_example/service/post_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  final headers = {'Content-Type': 'application/json; charset=UTF-8'};

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('فشل جلب البيانات');
    }
  }

  Future<Post> addPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشلت الإضافة');
    }
  }

  Future<Post> updatePost(int id, Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشل التعديل');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('انحذف بنجاح ✅');
    } else {
      throw Exception('فشل الحذف');
    }
  }
}
