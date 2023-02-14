import 'package:flutter/material.dart';

class Search2 extends StatefulWidget {
  final String initialSearchKey;

  const Search2({super.key, required this.initialSearchKey});

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  @override
  Widget build(BuildContext context) {
    String searchKey = widget.initialSearchKey;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFEFEFEF),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFFFAE1A6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          shape: const StadiumBorder()),
                      child: const Text("BACK")),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      initialValue: searchKey,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Search routes",
                          fillColor: Colors.white,
                          filled: true),
                    )),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      const Align(
                                          alignment: Alignment.topRight,
                                          child: CloseButton()),
                                      ElevatedButton(
                                        child: const Text("APPLY FILTER"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                      child: const Icon(Icons.filter_alt),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
