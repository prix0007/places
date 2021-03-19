import 'package:flutter/foundation.dart';

import '../models/place.dart';
import 'dart:io';
import '../helpers/db_helper.dart';

class GreatPlace with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image, PlaceLocation pickedLocation) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      location: pickedLocation,
      title: title,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.lat,
      'loc_lng': newPlace.location.lon,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              image: File(item['image']),
              title: item['title'],
              location: PlaceLocation(
                lat: item['loc_lat'],
                lon: item['loc_lng'],
              ),
            ))
        .toList();
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }
}
