import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:kisisel_asistan/models/news_model.dart';

class NewsApiService {
  final String _apiKey = "${dotenv.env["NEWS_API_KEY"]}";
  final baseUrl= dotenv.env['BASE_URL'];

Future<List<NewsModel>> getNewsModel(String category) async{
    final endPointUrl  = Uri.parse("$baseUrl?country=us&category=$category&apiKey=$_apiKey");
    final Response res = await get(endPointUrl);

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<NewsModel> articles =
      body.map((dynamic item) => NewsModel.fromJson(item)).toList();

      return articles;
    } else {
      throw Exception("Can't get the Articles");
    }
}
}