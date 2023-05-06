import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/widgets/google_map/propose_route.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';

import 'package:trek_bkk_app/domain/usecases/get_routes.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'package:trek_bkk_app/utils.dart';

class ProposeTab extends StatefulWidget {
  const ProposeTab({super.key});

  @override
  State<ProposeTab> createState() => _ProposeTabState();
}

class _ProposeTabState extends State<ProposeTab> {
  List<ProposeModel> _route = [];
  bool _dataIsFetched = false;

  @override
  void initState() {
    super.initState();

    if (context.mounted) {
      _fetchProposedRoutes();
    }
  }

  void _fetchProposedRoutes() async {
    _route = await getProposedRoutes(
        Provider.of<UserData>(context, listen: false).user!.id);
    setState(() {
      _dataIsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProposeRoutePage(),
                      ));
                },
                style: primaryButtonStyles(),
                child: const Text("start"),
              ),
            ),
          ),
          _dataIsFetched
              ? _route.isEmpty
                  ? Text("no data")
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _route.length,
                          itemBuilder: (context, index) => Card(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _route[index].name,
                                              style: headline20,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            SizedBox(
                                              height: 56,
                                              child: Text(
                                                _route[index].description,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Pending",
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )))
              : const CircularProgressIndicator()
        ],
      ),
    );
  }
}
