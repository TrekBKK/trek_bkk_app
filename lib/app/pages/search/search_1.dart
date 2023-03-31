import 'package:flutter/material.dart';

import 'package:trek_bkk_app/app/pages/search/search_2.dart';
import 'package:trek_bkk_app/app/widgets/add_place_dialog.dart';
import 'package:trek_bkk_app/domain/entities/add_place_dialog_input.dart';
import 'package:trek_bkk_app/utils.dart';

class Search1 extends StatefulWidget {
  const Search1({Key? key}) : super(key: key);

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  late TextEditingController _addController;
  late TextEditingController _searchController;
  String prevSearchKey = "";

  @override
  void initState() {
    super.initState();
    _addController = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _addController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  toSearch2(String searchKey) async {
    prevSearchKey = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Search2(
              initialSearchKey: searchKey,
            )));
    _searchController.text = prevSearchKey;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Search by Route name or description"),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: TextFormField(
                controller: _searchController,
                onFieldSubmitted: (value) {
                  toSearch2(value);
                },
                decoration: textFieldDecoration(hintText: "Search routes")),
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
              onPressed: () async {
                AddPlaceDialogInput? a = await showDialog(
                    context: context,
                    builder: (context) => const AddPlaceDialog());

                if (a != null && context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search2(
                                initalPlaceTag: a,
                              )));
                }
              },
              child: const Text("Add place")),
        ],
      ),
    );
  }
}
