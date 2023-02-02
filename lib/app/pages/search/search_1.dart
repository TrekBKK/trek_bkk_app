import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/search/search_2.dart';

class Search1 extends StatefulWidget {
  const Search1({Key? key}) : super(key: key);

  @override
  State<Search1> createState() => _Search1State();
}

class _Search1State extends State<Search1> {
  late TextEditingController _controller;
  var searchKey = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = searchKey;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  next(String searchKey) {
    searchKey = searchKey;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Search2(
              initialSearchKey: searchKey,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Search by Route name or description"),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: TextField(
            controller: _controller,
            onSubmitted: (value) {
              next(value);
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search routes",
                fillColor: Colors.white,
                filled: true),
          ),
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
        TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFFAE1A6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: const StadiumBorder()),
            child: const Text('button'))
      ],
    );
  }
}
