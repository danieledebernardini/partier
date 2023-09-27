import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:partier/routing/app_router.dart';
import '../event_widget/container/my_fancy_container.dart';
import '../../services/auth_service.dart';


/// Home page of the application.
/// This widget will contain an upper bar and an istance of page widget. In
/// particular, through a button will get access to the user's options.
class DiscoverPage  extends StatelessWidget {
  final String title = 'Partier';

  DiscoverPage({super.key});

  final formatter = DateFormat('d/M/y');

  /// TODO: Not saving login info
  //var api = Api();
  final logInfo = LoginInfo();
  final String path = DiscoveryRoute().location;

  final Stream<QuerySnapshot> _eventsStream =
    FirebaseFirestore.instance.collection('events')
    .where("public", isEqualTo: true)
    .where("event_date", isGreaterThan: DateTime.now())
    .snapshots();

  /// Given a query snapshot, creates a list of widgets representing events
  /// retrieved by the stream.
  List<Widget> createEventContainers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      DateTime date = data['event_date'].toDate();

      return Container(
        alignment: Alignment.center,
        //width: MediaQuery.of(this).size.width,
        //height: MediaQuery.of(context).size.height*0.25,
        child: MyFancyContainer(
          id: doc.id,
          title: data['name_event'],
          date: //"${date.day}-${date.month}-${date.year}",
            formatter.format(date),
        )
      );
    })
    .toList()
    .cast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () async {
              await logInfo.signOut();
              LoginRoute(from: path).go(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget disc;

          if (snapshot.hasError) {
            disc = const Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            disc = const CircularProgressIndicator();
          } else {
            disc = ListView(
              children: createEventContainers(snapshot),
            );
          }

          return disc;
        },
      )
    );
  }
}