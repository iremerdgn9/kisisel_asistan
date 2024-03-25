import 'package:flutter/material.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:kisisel_asistan/models/news_model.dart';
import 'package:kisisel_asistan/services/news_service.dart';
import 'package:kisisel_asistan/models//source_model.dart';

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

                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FavoriteButton(
                              isFavorite: false, valueChanged: (_isFavorite) {  },

                            ),
                                    Image.network(articles[index].urlToImage.toString()),
                            
                            const SizedBox(height: 10,),
                            ListTile(
                              leading: Icon(Icons.arrow_circle_down),
                              minLeadingWidth: 3,
                              title: Text(articles[index].title.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                              subtitle: Text(articles[index].author.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                articles[index].description.toString(),
                                style: TextStyle(fontSize: 15),),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: <Widget>[
                                FlatButton(
                                  color: Colors.white30,
                                  textColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () async {
                                    await (articles[index].url.toString());
                                  },
                                  child: Text(
                                    'Habere Git',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                StarButton(
                                  isStarred: true,
                                  iconSize: 50,
                                  iconColor: Colors.yellowAccent,
                                  iconDisabledColor: Colors.deepOrangeAccent,
                                  valueChanged: (_isStarred) {
                                    print('Is Starred : $_isStarred');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            } else {
              return const SizedBox();
    }
          },
    ),
    );
    }

  FavoriteButton({required bool isFavorite, required Null Function(dynamic _isFavorite) valueChanged}) {}

  FlatButton({required Color color, required MaterialColor textColor, required RoundedRectangleBorder shape, required Future<Null> Function() onPressed, required Text child}) {}

  StarButton({required bool isStarred, required int iconSize, required MaterialAccentColor iconColor, required MaterialAccentColor iconDisabledColor, required Null Function(dynamic _isStarred) valueChanged}) {}

  }
