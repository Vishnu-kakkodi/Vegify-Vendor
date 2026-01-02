


import 'package:flutter/material.dart';

class DocumentPreviewScreen extends StatelessWidget {
  final String url;
  const DocumentPreviewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document")),
      body: Center(
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}
