import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:kisisel_asistan/models/news_model.dart';
import 'package:kisisel_asistan/services/news_service.dart';
import 'package:kisisel_asistan/models//source_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsModel> articles = [];
  NewsApiService client = NewsApiService();

  void _getNewsModel() async {

    NewsApiService().getNewsModel().then((value){
      setState(() {
        articles = value!;
      });
    });
    if(mounted){
      setState(() {
      });
    }}

  @override
  void initState(){
    _getNewsModel();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Haberler'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                const Dashboard(
                  adSoyad: '', email: '',),),
              );
            },
          ),
        ),
        body: FutureBuilder(
        future: client.getNewsModel(),
          builder: (BuildContext context,AsyncSnapshot<List<NewsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Veri henüz yüklenmediyse, bir yükleme göstergesi gösterin
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Hata oluştuğunda hata mesajını gösterin
              return Center(child: Text('Hata: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<NewsModel>? articles = snapshot.data;
              return Center(
                child: ListView.builder(
                    itemCount: articles?.length,
                    itemBuilder: (context, index) {
                      final NewsModel article = articles![index];
                if (article.urlToImage != null) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          articles[index].urlToImage.toString(),
                        ),
                        const SizedBox(height: 10,),
                        ListTile(
                          leading: Icon(Icons.favorite_border),
                          minLeadingWidth: 3,
                          title: Text(articles[index].title.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          subtitle: Text(articles[index].author.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            articles[index].description.toString(),
                            style: TextStyle(fontSize: 15),),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                String? url = articles[index].url?.toString();
                                print(
                                    'URL: $url'); // URL'nin doğru olduğunu kontrol etmek için
                                if (url != null && url.isNotEmpty) {
                                  print('URL açılıyor...');
                                  await launch(url);
                                }
                              },
                              child: Text(
                                'Habere Git',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }else{
                  return SizedBox();
                }
                    }),
              );
            } else {
              return const SizedBox();
    }
          },
    ),
    );
    }
  }

