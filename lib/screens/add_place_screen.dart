import 'package:flutter/material.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  AddPlaceScreen({Key key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleControlller = TextEditingController();
  File _pickedImage;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleControlller.text.isEmpty || _pickedImage == null) {
      return;
    }
    Provider.of<GreatPlace>(context, listen: false)
        .addPlace(_titleControlller.text, _pickedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new place')),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleControlller,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(),
                    ImageInput(
                      onSelectImage: _selectImage,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
