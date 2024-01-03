import 'dart:convert';
import 'dart:io';

import 'package:favorite_places/models/Place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if(_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude; // here the _pickedLocation is not null because I'll only use this URL if we are showing a preview, which we wll only  do down there at least soon if we have a picked place
    final lng = _pickedLocation!.longitude;
  //  return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=YOUR_API_KEY&signature=YOUR_SIGNATURE';  //  This url is taken from google maps static api to show the preview of the map
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap &markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  }

  Future<void> _savePlace(double latitude, double longitude) async{

    // final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY');  // this url is taken from google maps geocoding api
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDLcwxUgqpPZo81cbH0TB4Crq5SJjtj4ag');  // AIzaSyDLcwxUgqpPZo81cbH0TB4Crq5SJjtj4ag this is taken from google maps api
    // Here, we can take http method but we take parse method because parse method takes full URL, A full URL string to be precise and then converts it into  such a Uri object.
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(latitude: latitude, longitude: longitude, address: address);
      _isGettingLocation = false;
    });
    // print(locationData.latitude);
    // print(locationData.longitude);

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
             // service enabling logic
    serviceEnabled = await location.serviceEnabled();   // Future<bool> serviceEnabled( // checking the service is enabled?
    if (!serviceEnabled) {   // if service is not enabled then request to ask the permission for enable the service
      serviceEnabled = await location.requestService();  // Future<bool> requestService() // requestService Containing class: Location
      if (!serviceEnabled) {  // if request is not accept the we return
        return;
      }
    }
                 // logic of if permission is accepted
    permissionGranted = await location.hasPermission();  // Future<PermissionStatus> hasPermission()
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();  // Future<PermissionStatus> requestPermission()
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if(lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  @override
  Widget build (BuildContext context) {

    void _selectOnMap () async{
      final pickedLocation = await Navigator.of(context).push<LatLng>(MaterialPageRoute(builder: (ctx) => const MapScreen() ));
      if(pickedLocation == null) {
        return;
      }

      _savePlace(pickedLocation.latitude, pickedLocation.longitude);
    }

    Widget previewContent = Text('No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if(_pickedLocation != null) {
      previewContent = Image.network(locationImage, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
    }

    if(_isGettingLocation) {  // _isGettingLocation = true
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withOpacity(0.2), ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
         TextButton.icon(
           onPressed: _getCurrentLocation,
           icon: const Icon(Icons.location_on),
           label:  const Text('Get Current Location'),
            ),
          TextButton.icon(
            onPressed: _selectOnMap,
            icon: const Icon(Icons.map),
            label:  const Text('Select on Map'),
          ),
          ],
        ),
      ],
    );
  }
}