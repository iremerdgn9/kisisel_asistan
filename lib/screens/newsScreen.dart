import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:kisisel_asistan/models/news_model.dart';
import 'package:kisisel_asistan/services/news_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsModel> allArticles = [];
  List<NewsModel> filteredArticles = [];
  String selectedCategory = 'business';
  NewsApiService client = NewsApiService();

  void _getNewsModel() async {
    try {
      List<NewsModel>? articles = await NewsApiService().getNewsModel();
        setState(() {
          allArticles = articles!;
          filteredArticles = allArticles;
        });
      }catch(error) {
        // Handle API errors here
        print("Error fetching news: $error");
      }
    }

  void _filterNewsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredArticles = allArticles.where((article) => article.category == category).toList();
    });
  }


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
              List<NewsModel>? filteredArticles = snapshot.data;
              return Column(
                children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterChip(label: Text('Business'),
                        selected: selectedCategory=='Business',
                        onSelected: (value)=> _filterNewsByCategory('business'),),
                      FilterChip(label: Text('Entertainment'),
                        selected: selectedCategory=='Entertainment',
                        onSelected: (value)=> _filterNewsByCategory('Entertainment'),),
                      FilterChip(label: Text('General'),
                        selected: selectedCategory=='General',
                        onSelected: (value)=> _filterNewsByCategory('General'),),
                      FilterChip(label: Text('Technology'),
                        selected: selectedCategory=='technology',
                        onSelected: (value)=> _filterNewsByCategory('technology'),),
                      FilterChip(label: Text('Science'),
                        selected: selectedCategory=='science',
                        onSelected: (value)=> _filterNewsByCategory('science'),),
                      FilterChip(label: Text('Health'),
                        selected: selectedCategory=='health',
                        onSelected: (value)=> _filterNewsByCategory('health'),),
                      FilterChip(label: Text('Sports'),
                        selected: selectedCategory=='sports',
                        onSelected: (value)=> _filterNewsByCategory('sports'),),
                    ],

                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredArticles!.length,
                      itemBuilder: (context, index) {
                        final NewsModel article = filteredArticles[index];
                  if (article.urlToImage != null) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            filteredArticles[index].urlToImage.toString(),
                          ),
                           SizedBox(height: 10,),
                          ListTile(
                            leading: Icon(Icons.favorite_border),
                            minLeadingWidth: 3,
                            title: Text(filteredArticles[index].title.toString(),
                              style:const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),),
                            subtitle: Text(filteredArticles[index].author.toString()),
                          ),
                          Padding(
                            padding:const EdgeInsets.all(1.0),
                            child: Text(
                              filteredArticles[index].description.toString(),
                              style: TextStyle(fontSize: 15),),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  String? url = filteredArticles[index].url?.toString();
                                  print(
                                      'URL: $url'); // URL'nin doğru olduğunu kontrol etmek için
                                  if (url != null && url.isNotEmpty) {
                                    print('URL açılıyor...');
                                    await launch(url);
                                  }
                                },
                                child: const Text(
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
                ),
                ],
              );
            } else {
              return SizedBox();
    }
          },
    ),
    );
    }
  }

