import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/search/search_2.dart';

import 'package:trek_bkk_app/constants.dart';

import 'package:trek_bkk_app/utils.dart';

class Search1 extends StatefulWidget {
  const Search1({Key? key}) : super(key: key);

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  late TextEditingController _searchController;
  late TextEditingController _addController;
  var searchKey = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _addController = TextEditingController();
    _searchController.text = searchKey;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addController.dispose();
    super.dispose();
  }

  next(String searchKey) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Search2(
              initialSearchKey: searchKey,
            )));
  }

  @override
  Widget build(BuildContext context) {
    var addPlaceDialog = Dialog(
      backgroundColor: const Color(lightColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 304,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("Adding stop"), Icon(Icons.close)],
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
                controller: _addController,
                onSubmitted: (value) {
                  print(value);
                },
                decoration: textFieldDecoration),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: ElevatedButton(
                style: primaryButtonStyles(),
                onPressed: () {},
                child: const Text("ADD"),
              ),
            )
          ]),
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Search by Route name or description"),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                next(value);
              },
              decoration: textFieldDecoration),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: const [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              )),
              Text("OR"),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text("Have some places in mind?"),
        const SizedBox(height: 32),
        ElevatedButton(
            style: primaryButtonStyles(px: 32),
            onPressed: () => showDialog(
                context: context, builder: (context) => addPlaceDialog),
            child: const Text("Add place")),
      ],
    );
  }
}
