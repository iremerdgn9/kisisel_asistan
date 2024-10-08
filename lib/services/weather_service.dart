import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kisisel_asistan/models/weather_model.dart';
import 'package:kisisel_asistan/screens/weatherScreen.dart';

class WeatherService {
  Future<String> _getLocation() async {

      //kullanıcının konumu açık mı diye kontrol ettik.
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Future.error('konum servisiniz kapalı.');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error('konum izni vermelisiniz!');
        }
      }

      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //kullanıcının pozisyonundan yerleşim noktasını bulduk.
      final List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      print(placemark);
      //şehri yerleşim noktasından kaydettik.
      final String? city = placemark[0].administrativeArea;

      if (city == null) Future.error('bir sorun oluştu');
      return city!;
    }

    Future<List<WeatherModel>> getWeatherData() async {
      final String city = await _getLocation();
      final weatherUrl = dotenv.env['WEATHER_URL'];
      final String url = '$weatherUrl?data.lang=tr&data.city=$city';
      final Map<String, dynamic> headers = {
        'authorization': '${dotenv.env["AUTHORIZATION"]}',
        'content-type': '${dotenv.env["CONTENT_TYPE"]}'
      };

      final dio = Dio();

      final response = await dio.get(url, options: Options(headers: headers));
      if (response.statusCode != 200) {
        return Future.error('bir sorun oluştu');
      }
      final List list = response.data['result'];
      final List<WeatherModel> weatherList = list.map((e) =>
          WeatherModel.fromJson(e)).toList();

      return weatherList;
    }
  }


