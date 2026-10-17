import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'post.dart';

class PostsService {
  final http.Client _client;

  PostsService(this._client);

  Future<List<Post>> getPosts({required int page, int limit = 15}) async {
    try {
      final response = await _client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=\$page&_limit=\$limit'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((e) => Post.fromJson(e)).toList();
      } else {
        throw 'Error en el servidor (\${response.statusCode}). Intente más tarde.';
      }
    } on SocketException {
      throw 'Sin conexión a internet. Verifique su red y vuelva a intentarlo.';
    } on TimeoutException {
      throw 'La conexión ha tardado demasiado. Verifique su red.';
    } catch (e) {
      throw 'Ocurrió un error inesperado al cargar las publicaciones.';
    }
  }
}
