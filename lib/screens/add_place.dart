import 'dart:io';
import 'package:favorite_places/models/Place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/lacation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});


  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}


class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if(enteredTitle.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }
     // here we use read to send some data and watch is used to display some changing in UI.
    // else
    ref.read(userPlacesProvider.notifier).addPlace(enteredTitle, _selectedImage!, _selectedLocation!);  // here .notifier class is connected to this provider here because it's then this class that can be used to add a place, so to call this addPlace method
     // In short: Here, userPlacesProvider points to userPlacesProvider variable which is in user_places.dart file and .notifier is connected to UserPlaceNotifier class which is in user_places.dart file and UserPlaceNotifier class is also connected to the userPlacesProvider variable which is also in user_places.dart file and we call addPlace() method by using .add() and in this we pass a argument which is text and the name is is enteredTitle
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // void _addImage(File image) {
  //   _selectedImage = image;
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                    maxLength: 50,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: 'Title',
                    ),
                    controller: _titleController,
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(height: 10,),
              ImageInput(
                  onPickImage:      // or  _addImage,
                  (image){ // Type of image: File
                _selectedImage = image;
                 },
              ),
              const SizedBox(height: 10,),
              LocationInput(onSelectLocation: (location) { _selectedLocation = location; } ),  // PlaceLocation location
              const SizedBox(height: 16,),
              ElevatedButton.icon(onPressed: _savePlace, icon: const Icon(Icons.add), label: const Text('Add Place'), )// center
            ],
          ),
        ),
    );
  }
}
