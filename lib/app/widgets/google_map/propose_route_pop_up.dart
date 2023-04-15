import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PRpopup extends StatefulWidget {
  final Future<List<dynamic>> places;
  final List<dynamic> markedPlaces;
  final void Function(String) onAddCurrentLoc;
  final void Function(dynamic) onClick;
  const PRpopup({
    super.key,
    required this.places,
    required this.markedPlaces,
    required this.onClick,
    required this.onAddCurrentLoc,
  });

  @override
  State<PRpopup> createState() => _PRpopupState();
}

class _PRpopupState extends State<PRpopup> {
  late Future<List<dynamic>> _places;
  late List<dynamic> _markedPlaces;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _places = widget.places;
    _markedPlaces = widget.markedPlaces;
  }

  void _onClickHandler(dynamic place) {
    final temp = {
      'name': place['name'],
      'latitude': place['geometry']['location']['lat'],
      'longitude': place['geometry']['location']['lng'],
    };

    widget.onClick(place);
    setState(() {
      _markedPlaces.add(temp);
    });
  }

  void _onClickCustomPlaceHandler() {
    final String text = _textController.text.trim();
    final temp = {
      'name': text,
    };
    widget.onAddCurrentLoc(text);
    setState(() {
      _markedPlaces.add(temp);
    });

    Fluttertoast.showToast(
      msg: "added your custom place",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool _checkClicked(String place) {
    for (var i = 0; i < _markedPlaces.length; i++) {
      if (_markedPlaces[i]['name'] == place) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _places,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //while waiting for the API response.
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors while fetching.
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> places = snapshot.data!;
            return ListView.builder(
              itemCount: places.length + 1,
              itemBuilder: (BuildContext context, int index) {
                // we want to have another item in this builder and dont want to access over index
                index -= 1;
                if (index == -1) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(),
                            labelText: 'Enter a custom place',
                            hintText: 'Enter a custom place',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _onClickCustomPlaceHandler,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.place),
                        ),
                      )
                    ],
                  );
                }
                dynamic place = places[index];
                String name = place['name'];
                double rating = (place['rating'] != null
                    ? (place['rating'] as num).toDouble()
                    : 0.0);
                String address = place['vicinity'];
                bool check = _checkClicked(name);

                return Container(
                  color: check ? Colors.grey : null,
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(address),
                    trailing: Text(rating.toString()),
                    onTap: () {
                      check ? null : _onClickHandler(place);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}