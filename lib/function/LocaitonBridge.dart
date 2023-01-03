class Loca{
  late String location_name;
  late String location_id;
  late String latitude;
  late String longitude;
  late String speed;
  late String accuracy;
  late String speed_accuracy;
  late String satellite_number;
  late String gps_time;


  Loca(
      this.location_name,
      this.location_id,
      this.latitude,
      this.longitude,
      this.speed,
      this.accuracy,
      this.speed_accuracy,
      this.satellite_number,
      this.gps_time);

  factory Loca.fromJson(String key,Map<dynamic,dynamic> json){
    return Loca(json["location_name"],key,json["latitude"] as String,json["longitude"] as String,json["speed"] as String,
        json["accuracy"] as String,json["speed_accuracy"] as String,json["satellite_number"] as String,json["gps_time"] as String);
  }
}

