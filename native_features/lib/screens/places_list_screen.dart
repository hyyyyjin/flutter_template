import 'package:flutter/material.dart';
import 'package:native_features/providers/great_places.dart';
import 'package:native_features/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child: Center(
                    child: const Text('Got no places yet, start adding Some!'),
                  ),
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.items.length <= 0
                          ? ch
                          // ch: child const text의 내용 노출
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (ctx, i) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      FileImage(greatPlaces.items[i].image),
                                ),
                                title: Text(greatPlaces.items[i].title),
                                onTap: () {
                                  // Go to detail pages...
                                },
                              ),
                            ),
                ),
        ));
  }
}
