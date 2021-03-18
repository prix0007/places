import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:places/helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  LocationInput({Key key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  double long;
  double lat;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    // print(locData.latitude);
    // print(locData.longitude);
    setState(() {
      _previewImageUrl = "true";
      long = locData.longitude;
      lat = locData.latitude;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(long: long, lat: lat),
    ));
    if (selectedLocation == null) {
      return;
    }
    setState(() {
      _previewImageUrl = "true";
      long = selectedLocation.longitude;
      lat = selectedLocation.latitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'mapPreview',
          child: Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: _previewImageUrl == null
                ? Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : LocationPreview(
                    lat: lat,
                    long: long,
                  ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_city),
              label: Text(
                'Current Location',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text(
                'Open Map Preview',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
      ],
    );
  }
}
