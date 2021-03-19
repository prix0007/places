import 'package:flutter/material.dart';
import 'add_place_screen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import 'place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<GreatPlace>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => Consumer<GreatPlace>(
          builder: (ctx, greatPlaces, ch) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : greatPlaces.items.length > 0
                  ? ListView.builder(
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[i].image),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          subtitle: Text(
                            'lat: ' +
                                greatPlaces.items[i].location.lat.toString(),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlaces.items[i].id,
                            );
                          },
                        );
                      },
                      itemCount: greatPlaces.items.length)
                  : ch,
          child: Center(child: Text('Got no places yet, start adding some!')),
        ),
      ),
    );
  }
}
