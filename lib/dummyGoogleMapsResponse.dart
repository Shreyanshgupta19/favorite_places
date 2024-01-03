// import 'dart:convert';
//
// // This request demonstrates using the JSON output flag:
// //  https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJeRpOeF67j4AR9ydy_PIzPuM&key=YOUR_API_KEY
//
// // this is the response in json format by using google maps geocoding api URL
// final Map<String, Object> _geocodingResponse = {   // it represents Welcome class
//     "results": [   // it represents results variable inside the Welcome class      // ['result']  // here result key is a list of maps
//         {      // it represents Result class                                       // [0]         // the index of first map is [0]
//             "address_components": [
//                 {     // it represents AddressComponent class
//                     "long_name": "1600",
//                     "short_name": "1600",
//                     "types": [
//                         "street_number"
//                     ]
//                 },
//               {
//                     "long_name": "Amphitheatre Parkway",
//                     "short_name": "Amphitheatre Pkwy",
//                     "types": [
//                         "route"
//                     ]
//                 },
//                 {
//                     "long_name": "Mountain View",
//                     "short_name": "Mountain View",
//                     "types": [
//                         "locality",
//                         "political"
//                     ]
//                 },
//                 {
//                     "long_name": "Santa Clara County",
//                     "short_name": "Santa Clara County",
//                     "types": [
//                         "administrative_area_level_2",
//                         "political"
//                     ]
//                 },
//                 {
//                     "long_name": "California",
//                     "short_name": "CA",
//                     "types": [
//                         "administrative_area_level_1",
//                         "political"
//                     ]
//                 },
//                 {
//                     "long_name": "United States",
//                     "short_name": "US",
//                     "types": [
//                         "country",
//                         "political"
//                     ]
//                 },
//                 {
//                     "long_name": "94043",
//                     "short_name": "94043",
//                     "types": [
//                         "postal_code"
//                     ]
//                 }
//             ],
//             "formatted_address": "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",  // it represents formattedAddress variable inside the Result class  // ['formatted_address'] // formatted_address is a key of 0th index map
//             "geometry": {      // it represents Geometry class
//                 "location": {   // it represents Location class
//                     "lat": 37.4224428,
//                     "lng": -122.0842467
//                 },
//                 "location_type": "ROOFTOP",
//                 "viewport": {    // it represents Viewport class
//                     "northeast": {
//                         "lat": 37.4239627802915,
//                         "lng": -122.0829089197085
//                     },
//                     "southwest": {
//                         "lat": 37.4212648197085,
//                         "lng": -122.0856068802915
//                     }
//                 }
//             },
//             "place_id": "ChIJeRpOeF67j4AR9ydy_PIzPuM",   // it represents placeId variable inside the Result class
//             "plus_code": {     // it represents PlusCode class
//                 "compound_code": "CWC8+X8 Mountain View, CA",
//                 "global_code": "849VCWC8+X8"
//             },
//             "types": [  // it represents types variable inside the Result class
//                 "street_address"
//             ]
//         }
//     ],
//     "status": "OK"   // it represents status variable inside the Welcome class
// };
//
//
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());
//
//
// class Welcome {
//     Welcome({required this.results, required this.status, });
//     List<Result> results;
//     String status;
//
//     factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//         results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
//         status: json["status"],
//     );
//
//     Map<String, dynamic> toJson() => {
//         "results": List<dynamic>.from(results.map((x) => x.toJson())),
//         "status": status,
//     };
// }
//
// class Result {
//     Result({ required this.addressComponents, required this.formattedAddress, required this.geometry, required this.placeId, required this.plusCode, required this.types, });
//     final List<AddressComponent> addressComponents;   // it calls AddressComponent class
//     final String formattedAddress;
//     final Geometry geometry;     // it calls Geometry class
//     final String placeId;
//     final PlusCode plusCode;    // it calls PlusCode class
//     final List<String> types;
//
//     factory Result.fromJson(Map<String, dynamic> json) {    // The name of Map<String, dynamic> is json
//         return Result(
//             addressComponents: (json['results'][0]['address_components'] as List)
//                 .map((item) => AddressComponent.fromJson(item))
//                 .toList(),
//             formattedAddress: json['results'][0]['formatted_address'],
//             geometry: Geometry.fromJson(json['results'][0]['geometry']),
//             placeId: json['results'][0]['place_id'],
//             plusCode: PlusCode.fromJson(json['results'][0]['plus_code']),
//             types: List<String>.from(json['results'][0]['types']),
//         );
//     }
//
//
// }
//
// class AddressComponent {
//     AddressComponent({ required this.longName, required this.shortName, required this.types, });
//     final String longName;
//     final String shortName;
//     final List<String> types;
//
//     factory AddressComponent.fromJson(Map<String, dynamic> json) {
//         return AddressComponent(
//             longName: json['long_name'],
//             shortName: json['short_name'],
//             types: List<String>.from(json['types']),
//         );
//     }
//
// }
//
// class Geometry {
//     Geometry({ required this.location, required this.locationType, required this.viewport, });
//     final Location location;   // it calls Location class
//     final String locationType;
//     final Viewport viewport;   // // it calls Viewport class
//
//     factory Geometry.fromJson(Map<String, dynamic> json) {
//         return Geometry(
//             location: Location.fromJson(json['location']),
//             locationType: json['location_type'],
//             viewport: Viewport.fromJson(json['viewport']),
//         );
//     }
//
// }
//
// class Location {
//     Location({required this.lat, required this.lng});
//     final double lat;
//     final double lng;
//
//     factory Location.fromJson(Map<String, dynamic> json) {
//         return Location(
//             lat: json['lat'],
//             lng: json['lng'],
//         );
//     }
//
// }
//
// class Viewport {
//     Viewport({required this.northeast, required this.southwest});
//     final Location northeast;  // it calls Location class
//     final Location southwest;  // it calls Location class
//
//     factory Viewport.fromJson(Map<String, dynamic> json) {
//         return Viewport(
//             northeast: Location.fromJson(json['northeast']),
//             southwest: Location.fromJson(json['southwest']),
//         );
//     }
//
// }
//
// class PlusCode {
//     PlusCode({required this.compoundCode, required this.globalCode});
//     final String compoundCode;
//     final String globalCode;
//
//     factory PlusCode.fromJson(Map<String, dynamic> json) {  // In dart the '.fromJson' method is commonly used when the JSON serialization/deserialization. it is part of the 'dart:convert' library and you typically implement it in your class to convert a JSON object into an instance of that class
//         return PlusCode(
//             compoundCode: json['compound_code'],
//             globalCode: json['global_code'],
//         );
//     }
//
// }

