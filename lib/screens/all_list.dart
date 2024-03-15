import 'package:flutter/material.dart';

class AllList extends StatefulWidget {
  const AllList({super.key});

  @override
  State<AllList> createState() => _AllListState();
}

class _AllListState extends State<AllList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All List"),
      ),
      body: Center(
        child: Text("All List Page"),
      ),
    );
  }
}
