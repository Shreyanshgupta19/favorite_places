import 'package:favorite_places/models/Place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place,});
  final Place place;

  String get locationImage {
    final lat = place.location.latitude; // here the _pickedLocation is not null because I'll only use this URL if we are showing a preview, which we wll only  do down there at least soon if we have a picked place
    final lng = place.location.longitude;
    //  return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap &markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=YOUR_API_KEY&signature=YOUR_SIGNATURE';  //  This url is taken from google maps static api to show the preview of the map
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap &markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(place.title.toString() ),
     ),
     body: Stack(
       children: [
         InteractiveViewer(  // image zoom widget
           maxScale: 5.0,  // Maximum zoom
           minScale: 0.01,  // Minimum zoom
           // boundaryMargin: const EdgeInsets.all(20),// const EdgeInsets.all(double.infinity),
           child: Image.file(
             place.image,
             fit: BoxFit.cover,
             width: double.infinity,
             height: double.infinity,
           ),
         ),
         Positioned(
           bottom: 0,
             left: 0,
             right: 0,
             child: Column(
               children: [
                 GestureDetector(
                   onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MapScreen(location: place.location, isSelected: false,),),);
                   },
                   child: CircleAvatar(
                     radius: 70,
                     backgroundImage: NetworkImage(locationImage),
                   ),
                 ),
                 Container(
                   alignment: Alignment.center,
                   padding: const EdgeInsets.symmetric(
                     horizontal: 24,
                     vertical: 16,
                   ),
                   decoration: const BoxDecoration(
                     gradient: LinearGradient(colors: [
                       Colors.transparent,
                       Colors.black54,
                     ],
                     begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                     ),
                   ),
                   child: Text(place.location.address, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground,),),
                 ),
               ],
             )
         ),
       ],
     ),
   );
  }

}
