import 'package:favorite_places/models/Place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.location = const PlaceLocation(latitude: 37.422,longitude: -122.084,address: '',), this.isSelected = true,});
  final PlaceLocation location;
  final bool isSelected;

  @override
  State<MapScreen> createState() {
    return _MapsScreenState();
  }
}

class _MapsScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelected ? 'Pick your Location' : 'Your Location'),
        actions: [
          if(widget.isSelected)  // isSelected = true
            IconButton(
                onPressed: (){ Navigator.of(context).pop(_pickedLocation); },
                icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(widget.location.latitude, widget.location.longitude), zoom: 16,),
        onTap: !widget.isSelected ? null : (position) {  //  LatLng position
        // or onTap: widget.isSelected == false ? null : (position) {
          setState(() {
            _pickedLocation = position;
          });
        },                // true AND true = true, Otherwise false
        markers: (_pickedLocation == null && widget.isSelected) ? {} : {   // widget.isSelected == true  // markers takes a input of Set // type: Set<Marker>
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation ?? LatLng(widget.location.latitude, widget.location.longitude,),
          // or  position: _pickedLocation != null ? _pickedLocation! : LatLng(widget.location.latitude, widget.location.longitude,),
          ),
        },
      ),
    );
  }

}