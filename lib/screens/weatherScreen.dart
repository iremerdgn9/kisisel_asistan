//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:kisisel_asistan/dashboard.dart';
import 'package:kisisel_asistan/services/weather_service.dart';
import 'package:kisisel_asistan/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<WeatherModel> _weathers = [];

  void _getWeatherData() async {
    _weathers = await WeatherService().getWeatherData();
    if(mounted){
    setState(() {

    });
  }}

  @override
  void initState(){
    _getWeatherData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hava Durumu',style: TextStyle(color: Colors.black),),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard(adSoyad: '', email: '',),),
            );
          },
        ),
        //leadingWidth: Text('${pla}'),
      ),
      body: Center(
              child: ListView.builder(
                itemCount: _weathers.length,
                itemBuilder: (context, index){
                  final WeatherModel weather = _weathers[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Image.network(weather.ikon,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('${weather.tarih}  ${weather.gun}\n  ${weather.durum.toUpperCase()}   ${weather.derece}°',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20,color: Colors.black),
                          ),
                        ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Min: ${weather.min}'),
                                  Text('Max: ${weather.max}'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Gece: ${weather.gece}'),
                                  Text('Nem: ${weather.nem}'),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
