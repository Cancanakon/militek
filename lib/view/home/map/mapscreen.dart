import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import '../../../product/constans/project_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class Maps extends StatefulWidget {
  static const String route = 'Harita';

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> with TickerProviderStateMixin {
  late final MapController mapController;

  late double lat = 0.0;
  late double long = 0.0;
  late double spd = 0.0;
  late double acrcy = 0.0;
  late double spdacrcy = 0.0;
  late int satnum = 0;
  late double gpst = 0.0;


  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  static LatLng ahlat = LatLng(38.740450, 42.458626);
  static LatLng fatih = LatLng(41.019303, 28.950296);

  @override
  void initState() {
    super.initState();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    mapController = MapController();
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(lat,long),
        builder: (ctx) => Container(
          key: const Key('blue'),
          child: const FlutterLogo(),
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: ahlat,
        builder: (ctx) => const FlutterLogo(
          key: Key('green'),
          textColor: Colors.green,
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: fatih,
        builder: (ctx) => Container(
          key: const Key('purple'),
          child: const FlutterLogo(textColor: Colors.purple),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Animasyonlu Harita')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(LatLng(lat,long), 10);
                    },
                    child: const Text('Ben'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(ahlat, 10);
                    },
                    child: const Text('SELÇUKLU AHLAT'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(fatih, 10);
                    },
                    child: const Text('FATİH'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      final bounds = LatLngBounds();
                      bounds.extend(LatLng(lat,long));
                      bounds.extend(ahlat);
                      bounds.extend(fatih);
                      mapController.fitBounds(
                        bounds,
                        options: const FitBoundsOptions(
                          padding: EdgeInsets.only(left: 15, right: 15),
                        ),
                      );
                    },
                    child: const Text('Fit Bounds'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      final bounds = LatLngBounds();
                      bounds.extend(LatLng(lat,long));
                      bounds.extend(ahlat);
                      bounds.extend(fatih);

                      final centerZoom =
                          mapController.centerZoomFitBounds(bounds);
                      _animatedMapMove(centerZoom.center, centerZoom.zoom);
                    },
                    child: const Text('Fit Bounds animated'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    center: LatLng(lat, long),
                    zoom: 5,
                    maxZoom: 16,
                    minZoom: 3),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _getLocation() async* {
    final loc.LocationData _locationResult = await location.getLocation();
    setState(() async* {
      spd = _locationResult.speed!;
      long = _locationResult.longitude!;
      lat = _locationResult.latitude!;
      acrcy = _locationResult.accuracy!;
      spdacrcy = _locationResult.speedAccuracy!;
      satnum = _locationResult.satelliteNumber!;
      gpst = _locationResult.time!;
    });
    print("$spd hızınız");
    print("$gpst 'da güncellendi.");
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
        spd = currentlocation.speed!;
        long = currentlocation.longitude!;
        lat = currentlocation.latitude!;
        acrcy = currentlocation.accuracy!;
        spdacrcy = currentlocation.speedAccuracy!;
        satnum = currentlocation.satelliteNumber!;
        gpst = currentlocation.time!;
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
