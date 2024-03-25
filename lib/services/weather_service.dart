import 'package:dio/dio.dart';
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
      //kullanıcı konum izni verdi mi diye kontrol ettik.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        //konum izni vermemişse tekrar izin istedik.
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          //yine izin vermemişse hata döndürdük.
          Future.error('konum izni vermelisiniz!');
        }
      }
      //high kesin konum, low yaklaşık konumu verir.
      //kullanıcının pozisyonunu aldık.
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //kullanıcının pozisyonundan yerleşim noktasını bulduk.
      final List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      //print(placemark);
      //şehri yerleşim noktasından kaydettik.
      final String? city = placemark[0].administrativeArea;
      if (city == null) Future.error('bir sorun oluştu');
      return city!;
    }

    Future<List<WeatherModel>> getWeatherData() async {
      final String city = await _getLocation();
      final String url = 'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city';
      const Map<String, dynamic> headers = {
        'authorization': 'apikey 6vpYvE5pG41hMVThvhB5xJ:4xlQdRoGTtpb9IjoPoXBdv',
        'content-type': 'application/json'
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


