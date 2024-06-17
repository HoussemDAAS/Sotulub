import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemandDetailBottomSheet extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final VoidCallback onDeliver;
  final VoidCallback onReject;

  DemandDetailBottomSheet({required this.doc, required this.onDeliver, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDeliver(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Deliver',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onReject(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.close,
              label: 'Reject',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: doc['delivred']
                ? Colors.yellow.withOpacity(0.3)
                : doc['approved']
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Détenteur: ${doc['responsable']}"),
            const   SizedBox(height: 5),
              Text("Numero Demande: ${doc['numeroDemande']}"),
          const     SizedBox(height: 5),
              Row(
                children: [
               const    Icon(Icons.phone),
             const     SizedBox(width: 5),
                  Text("${doc['telephone']}"),
                ],
              ),
            const   SizedBox(height: 5),
              Text("${doc['gouvernorat']}"),
           const   SizedBox(height: 5),
              Row(
                children: [
               const    Text("Mois: "),
                  Text("${doc['month']}"),
                ],
              ),
             const  SizedBox(height: 5),
              Row(
                children: [
            const       Text("Quantité: "),
                  Text("${doc['quentity']}L"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
