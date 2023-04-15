import 'package:flutter/material.dart';

class ProposePage extends StatefulWidget {
  final String polyline;
  final dynamic places;
  const ProposePage({super.key, required this.polyline, this.places});

  @override
  State<ProposePage> createState() => _ProposePageState();
}

class _ProposePageState extends State<ProposePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _polyline;
  late dynamic _places;

  @override
  void initState() {
    _polyline = widget.polyline;
    _places = widget.places;
    super.initState();
  }

  void _onSubmitHandler(String name, String des) {
    print("asd");
    print(name + des);
    print(_polyline);
    print(_places);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
                hintText: 'Enter a message',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter your description',
                border: OutlineInputBorder(),
                hintText: 'Enter a message',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                final String text = _nameController.text.trim();
                final String des = _descriptionController.text.trim();
                // if (text.isNotEmpty) {
                _onSubmitHandler(text, des);
                _nameController.clear();
                _descriptionController.clear();
                // }
              },
            ),
          ],
        ));
  }
}
