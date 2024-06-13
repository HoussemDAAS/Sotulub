import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemandList extends StatelessWidget {
  final List<QueryDocumentSnapshot> data;
  final Function(QueryDocumentSnapshot) onItemTap;

  DemandList({required this.data, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var doc = data[index];
        return ListTile(
          title: Text(doc['responsable']),
          subtitle: Text("Quantity: ${doc['quentity']}L"),
          onTap: () => onItemTap(doc),
        );
      },
    );
  }
}
