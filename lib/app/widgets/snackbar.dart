import 'package:flutter/material.dart';

warningSnackbar(String content) {
  return SnackBar(
    content: Text(content),
    backgroundColor: const Color(0xFFed6c02),
    margin: const EdgeInsets.only(bottom: 20),
    behavior: SnackBarBehavior.floating,
  );
}

errorSnackbar(String content) {
  return SnackBar(
    content: Text(content),
    backgroundColor: Colors.red,
    margin: const EdgeInsets.only(bottom: 20),
    behavior: SnackBarBehavior.floating,
  );
}
