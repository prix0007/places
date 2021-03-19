import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-preview';
  final double long;
  final double lat;
  MapScreen({this.lat, this.long, Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng coords;
  MapController controller;

  @override
  void initState() {
    // print(widget.lat);
    if (widget.long == null || widget.lat == null) {
      coords = LatLng(37.422, -122.084);
      controller = MapController(
        location: coords,
        zoom: 12,
        tileSize: 100,
      );
    } else {
      setState(() {
        coords = LatLng(widget.lat, widget.long);
        controller = MapController(
          location: coords,
          zoom: 16,
          tileSize: 160,
        );
      });
    }
    super.initState();
  }

  // void _gotoDefault() {
  //   controller.center = coords;
  // }

  void _onDoubleTap() {
    controller.zoom += 0.5;
  }

  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(LatLng(
                controller.center.latitude,
                controller.center.longitude,
              ));
            },
          ),
        ],
      ),
      body: Hero(
        tag: 'mapPreview',
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: GestureDetector(
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: (details) {
              print(
                  "Location: ${controller.center.latitude}, ${controller.center.longitude}");
            },
            child: Stack(
              children: [
                if (controller != null)
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                Center(
                  child: Icon(Icons.location_on, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
