import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/Place.dart';

Future<Database> _getDatabase() async{
  final dbPath = await sql.getDatabasesPath();  // here we get the database path
  final db = await sql.openDatabase(  // here we open the database and do something inside the database
    path.join(dbPath, 'places.db'), // it creates a file inside dbPath's path and the name of file is 'places.db'
    onCreate: (db, version) {  // it creates a a table inside the db(places.db file) and we give the number of table by using version and the name of table is user_places
      return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'); },
    version: 1,  // it is the number of table: table no. 1
  );
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  Future<void> loadPlaces() async{
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map( (row) => Place(id: row['id'] as String, title: row['title'] as String, image: File(row['image'] as String), location: PlaceLocation(latitude: row['lat'] as double, longitude: row['lng'] as double, address: row['address'] as String,),  ) ).toList();
  state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async{                                                                 // or   void addPlace(Place place) {
    final appDir = await syspaths.getApplicationDocumentsDirectory();   // Type: Future<Directory> getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');   // Type: Future<File> copy(String newPath);

    final newPlace = Place(title: title, image: copiedImage, location: location);  // or Place newPlace =                                //       final newPlace = Place(title: place.title);

    final db = await _getDatabase();
    db.insert('user_places', {   // Future<int> insert( String table, Map<String, Object?> values, {   String? nullColumnHack,   ConflictAlgorithm? conflictAlgorithm, })  // insert(table, values)
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    } );
    state = [newPlace, ...state]; // or state.add(newPlace);                                                                             //       state = [newPlace, ...state];   // or [...state, newPlace];
  }                                                                                                                                      //       }

}

final userPlacesProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>((ref) => UserPlaceNotifier() );
// Here, StateNotifierProvider will use the UserPlaceNotifier and it will then actually yield a list of places because that is the managed by UserPlaceNotifier.

// * By the using of getApplicationDocumentsDirectory: it creates/generates a path for the app in our file manager and in this pat we can storing user data, such as databases, files or any other data in the path locally
// foe e.g., like Whatsapp has a path in file manager in this path it stores our data locally and this path is created by Whatsapp.

// image.path: This is a property of the File class in Dart, and it returns a string representing the full path to the file. In your context, it would be the full path to an image file.
// * By the using of path.basename(image.path): It takes a full path as input and returns the last part of that path, which is typically the filename. For example, if 'image.path' is "/DCIM/Camera/images/example.jpg", then 'path.basename(image.path)' would return 'example.jpg'.

// * By the using of image.copy('${appDir.path}/$filename'):
// 1. image.copy(...): Assuming image is a File object, the copy method is used to duplicate the file. It creates a new file with the same content as the original.
// 2. await: The 'await' keyword is used because the copy method is asynchronous. It means that copying a file could take some time, and 'await' ensures that the program waits for the operation to complete before moving on to the next line.
// 3. 'final copiedImage = ...': This line assigns the result of the copy operation (which is a Future<File>) to the variable copiedImage. The await keyword ensures that the program waits for the copying to be completed before assigning the result to copiedImage.
// 4. ${appDir.path}: This is the path to the application's documents directory, where the original image was copied to.
// 5. /$filename: This is the filename getting from the original image file path. It's essentially the name of the image file you want to display.
// So, if we click a photo from app's camera it takes image file name and store our image to appDir's path and if we display our image in app we give a path of this image file like this '${appDir.path}/$filename' this is the storing path of our image.
// So, in summary, this line is copying the original image file to a new location within the application's documents directory and getting a reference to the copied image file, stored in the variable 'copiedImage'.
// So, if appDir.path is '/Internal Storage/data/com.example.myapp/favorite_places' and filename is 'example.jpg', then ${appDir.path}/$filename would be '/Internal Storage/data/com.example.myapp/favorite_places/example.jpg'.
