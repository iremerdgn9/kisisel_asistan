import 'source_model.dart';
class NewsModel {
  Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsModel(this.source,this.author,this.title,this.description,this.url,this.urlToImage,this.publishedAt,this.content);

   NewsModel.fromJson(Map<String,dynamic> json)
     :
     source =json['source'] != null ? new Source.fromJson(json['source']): null,
     author = json['author'],
     title = json['title'],
     description = json['description'],
     url = json['url'],
     urlToImage = json['urlToImage'],
     publishedAt = json['publishedAt'],
     content = json['content'];
   }

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (Source != null) {
    data['source'] = Source;
  }
  data['author'] ;
  data['title'];
  data['description'];
  data['url'] ;
  data['urlToImage'];
  data['publishedAt'] ;
  data['content'];
  return data;
}


      //source: Source.fromJson(json['source']),
      //author: json['author'] as String,
      //title: json['title'] as String,
      //description: json['description'] as String,
      //url: json['url'] as String,
      //urlToImage: json['urlToImage'] as String,
      //publishedAt: json['publishedAt'] as String,
      //content: json['content'] as String,


    //);
  //}
//}







