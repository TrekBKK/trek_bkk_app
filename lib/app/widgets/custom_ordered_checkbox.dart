import 'package:flutter/material.dart';
import 'package:trek_bkk_app/constants.dart';

class CustomOrderedCheckbox extends StatelessWidget {
  final String title;
  final int index;
  final int order;
  final Function(int) onTap;
  const CustomOrderedCheckbox(
      {super.key,
      required this.title,
      required this.index,
      required this.order,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(
                height: 32,
                child: order != -1
                    ? Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: lightColor,
                            border: Border.all(
                              color: lightColor,
                              width: 4.0,
                              style: BorderStyle.solid,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text((order + 1).toString()),
                        ))
                    : const Icon(Icons.circle_outlined),
              )
            ],
          ),
        ),
      ),
    );
  }
}
