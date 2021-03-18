import 'package:flutter/foundation.dart';

import '../models/place.dart';
import 'dart:io';
import '../helpers/db_helper.dart';

class GreatPlace with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String title,
    File image,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      location: null,
      title: title,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              image: File(item['image']),
              title: item['title'],
              location: null,
            ))
        .toList();
    notifyListeners();
  }
}
