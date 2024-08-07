import 'dart:convert';
import 'package:http/http.dart';
import 'package:kisisel_asistan/models/news_model.dart';

class NewsApiService {
  static const String _apiKey = "eb9dee953a784f848a327036dee9153d";

Future<List<NewsModel>> getNewsModel(String category) async{
    final endPointUrl  = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$_apiKey");
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