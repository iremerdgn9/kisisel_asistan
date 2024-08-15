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
  String selectedCategory = 'General';
  NewsApiService client = NewsApiService();

  @override
  void initState(){
    _getNewsModel(selectedCategory);
    super.initState();
  }

  void _getNewsModel(String category) async {
    try {
      List<NewsModel>? articles = await client.getNewsModel(category);
        setState(() {
          allArticles = articles;
          _filterNewsByCategory(selectedCategory);
        });
      }catch(error) {
        print("Error fetching news: $error");
      }
    }

  void _filterNewsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredArticles = (category.isEmpty || category.toLowerCase() == 'all')
          ? allArticles
          : allArticles
          .where((article) =>
      article.category?.toLowerCase() == category.toLowerCase())
          .toList();
    });
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
        future: client.getNewsModel(selectedCategory),
          builder: (BuildContext context,AsyncSnapshot<List<NewsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
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
                      _buildCategoryChip('Business'),
                      _buildCategoryChip('Entertainment'),
                      _buildCategoryChip('General'),
                      _buildCategoryChip('Technology'),
                      _buildCategoryChip('Science'),
                      _buildCategoryChip('Health'),
                      _buildCategoryChip('Sports'),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredArticles!.isNotEmpty
                ?  ListView.builder(
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        final NewsModel article = filteredArticles[index];
                  if (article.urlToImage != null) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            article.urlToImage.toString(),
                          ),
                           SizedBox(height: 10,),
                          ListTile(
                            leading: Icon(Icons.favorite_border),
                            minLeadingWidth: 3,
                            title: Text(article.title.toString(),
                              style:const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),),
                            subtitle: Text(article.author.toString() ?? 'author'),
                          ),
                          Padding(
                            padding:const EdgeInsets.all(1.0),
                            child: Text(
                              article.description.toString(),
                              style: TextStyle(fontSize: 15),),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  String? url = article.url?.toString();
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
                    return const SizedBox();
                  }
                      },
                      )
                          : const Center(child: Text('No news available for the selected category'),
            ),
                ),
                ],
              );
            } else {
              return const SizedBox();
    }
          },
    ),
    );
    }
  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
        label: Text(category),
        selected: selectedCategory.toLowerCase() == category.toLowerCase(),
        onSelected: (value) => _filterNewsByCategory(category),
      ),
    );
  }
  }



