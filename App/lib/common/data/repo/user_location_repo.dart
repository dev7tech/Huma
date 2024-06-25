import 'dart:convert';

import 'package:location/location.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../config/app_config.dart';
import '../../../models/reverse_geocode.dart';

abstract class UserLocationReporistory {
  const UserLocationReporistory._();
  Future<Map?> getLocationCoordinates() async {
    return null;
  }
}

class UserLocationReporistoryImpl implements UserLocationReporistory {
  @override
  Future<Map?> getLocationCoordinates() async {
    loc.Location location = loc.Location();
    try {
      await location.serviceEnabled().then((value) async {
        if (!value) {
          await location.requestService();
        }
      });

      final coordinates = await location.getLocation();

      // if (Platform.isAndroid) {
      //   return await coordinatesToAddress(
      //     latitude: coordinates.latitude,
      //     longitude: coordinates.longitude,
      //   );
      // } else {
      final reverseGeocode = await getReverseGeocodingData(
          lat: coordinates.latitude!, lng: coordinates.longitude!);

      return reverseGeocode;
      // }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Future coordinatesToAddress({latitude, longitude}) async {
  //   try {
  //     Map<String, dynamic> obj = {};
  //     final coordinates = Coordinates(latitude, longitude);

  //     List<dynamic> result =
  //         await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //     String currentAddress =
  //         "${result.first.locality ?? ''} ${result.first.subLocality ?? ''} ${result.first.subAdminArea ?? ''} ${result.first.countryName ?? ''}, ${result.first.postalCode ?? ''}";

  //     debugPrint('-------------======$currentAddress');
  //     debugPrint('--------res-----======$result');
  //     obj['PlaceName'] = currentAddress;
  //     obj['countryName'] = result.first.countryName;
  //     obj['subLocality'] = result.first.subLocality;
  //     obj['latitude'] = latitude;
  //     obj['longitude'] = longitude;

  //     return obj;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  Future<ReverseGeocode> getReverseGeoding(
      {required double lat, required double lng}) async {
    const geocodeURL = "https://maps.googleapis.com/maps/api/geocode";
    final url =
        Uri.parse("$geocodeURL/json?latlng=$lat,$lng&key=$googleMapsKey");

    final response = await http.get(url);

    debugPrint("REVERSE ${response.body}");

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.containsKey("results")) {
        final addressDetails = extractedData["results"][0];
        return ReverseGeocode.fromJson(addressDetails);
      } else {
        throw "Couldn't get the address";
      }
    } else {
      throw "Network Error!";
    }
  }

  Future<Map<String, dynamic>> getReverseGeocodingData(
      {required double lat, required double lng}) async {
    const geocodeURL = "https://maps.googleapis.com/maps/api/geocode";
    final url =
        Uri.parse("$geocodeURL/json?latlng=$lat,$lng&key=$googleMapsKey");

    final response = await http.get(url);

    debugPrint("REVERSE ${response.body}");

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.containsKey("results")) {
        final addressDetails = extractedData["results"][0];
        final List<dynamic> addressComponents =
            addressDetails["address_components"];
        String countryName = "";
        double latitude = lat;
        double longitude = lng;
        String subLocality = '';

        for (var component in addressComponents) {
          final List<String> types = List<String>.from(component["types"]);
          if (types.contains("country")) {
            countryName = component["long_name"];
          }
          if (types.contains("sublocality")) {
            subLocality = component["long_name"];
          }
        }

        Map<String, dynamic> obj = {
          'PlaceName': addressDetails["formatted_address"],
          'countryName': countryName,
          'subLocality': subLocality,
          'latitude': latitude,
          'longitude': longitude,
        };

        return obj;
      } else {
        throw "Couldn't get the address";
      }
    } else {
      throw "Network Error!";
    }
  }
}
