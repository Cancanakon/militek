import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import '../../../product/constans/project_texts.dart';
import '../map/mapscreen.dart';


class Track extends StatefulWidget {
  bool intChck = false;
  @override
  State<Track> createState() => TrackState();
}

class TrackState extends State<Track> {

  late double latitude = 0.0;
  late double longitude = 0.0;
  late double speed = 0.0;
  late double accuracy = 0.0;
  late double speed_accuracy = 0.0;
  late int satellite_number = 0;
  late double gps_time = 0.0;


  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  Future<bool> closeApp() async {
    await exit(0);
  }

  Future<void> uyar() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Üzgünüm!"),
              actionsAlignment: MainAxisAlignment.center,
              content: Text(ProjectTexts.errorInternet),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      closeApp();
                    },
                    child: Text("Çıkış")),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SAFEWAY BETA"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                _getLocation();
              },
              child: Text('Konumumu Ekle')),
          TextButton(
              onPressed: () {
                _listenLocation();
              },
              child: Text('Canlı Konum Aç')),
          TextButton(
              onPressed: () {
                _stopListening();
              },
              child: Text('Canlı Konum Durdur')),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Maps()));
              },
              child: Text('Map')),
          Text("Hızımız: ${speed}"),
          Text("Lat:: ${latitude}"),
          Text("Lon: ${longitude}"),
          Text("Uydu Sayısı: ${satellite_number}"),
          Text("GPS Saati: ${gps_time}"),
          Text("Doğruluk: ${accuracy}"),
          Text("Hız Doğruluğu: ${speed_accuracy}"),
        ],
      ),
    );
  }

  _getLocation() async* {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() async* {
      speed = _locationResult.speed!;
      longitude = _locationResult.longitude!;
      latitude = _locationResult.latitude!;
      accuracy = _locationResult.accuracy!;
      speed_accuracy = _locationResult.speedAccuracy!;
      satellite_number = _locationResult.satelliteNumber!;
      gps_time = _locationResult.time!;
    });
    print("$speed hızınız");
    print("$gps_time 'da güncellendi.");
  }

  Stream<Future<void>> _listenLocation() async* {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async* {
      setState(() async* {
        speed = currentlocation.speed!;
        longitude = currentlocation.longitude!;
        latitude = currentlocation.latitude!;
        accuracy = currentlocation.accuracy!;
        speed_accuracy = currentlocation.speedAccuracy!;
        satellite_number = currentlocation.satelliteNumber!;
        gps_time = currentlocation.time!;
      });
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}
